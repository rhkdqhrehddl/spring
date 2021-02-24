<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%
    /*
     * 1. 기본결제정보 변경
     *     
     *
     * 결제기본정보를 변경하여 주시기 바랍니다. 
     */
    
    String serverName = request.getServerName();
    String protocol = request.isSecure() ? "https://" : "http://";
	String LGD_OID              = "test_0001";                      					//주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT           = "1004";                       							//결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_BUYER            = "홍길동";                        						//구매자명
    String LGD_PRODUCTINFO      = "테스트상품";                  						//상품명
    String LGD_NOTEURL      	= protocol + serverName + "/PG/AnsimKeyin/note_url.do";  				//상점결제결과 처리(DB) 페이지 URL (URL을 입력해 주세요. 예: http://pgweb.tosspayments.com/note_url.jsp)
    String LGD_TAXFREEAMOUNT	= "";													//면세금액 (면세상품취급 상점의 경우 사용 - 사용전 "부분면세" 계약을 확인하세요)  	
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>결제요청</title>
<script type="text/javascript">

/*
 * 결제요청 및 결과화면 처리 
 */

function doAnsimKeyin(){
//CST_PLATFORM은 test(테스트) 또는 service(서비스)를 넘겨주시면 됩니다.
	document.getElementById('LGD_MID').value = document.getElementById('CST_PLATFORM').value === 'test' ?
		't' + document.getElementById('CST_MID').value : document.getElementById('CST_MID').value;	
	
    ret = ansimkeyin_check(document.getElementById('LGD_PAYINFO'), document.getElementById('CST_PLATFORM').value); 

    if (ret=="00"){ //plug-in 정상 로딩
        var LGD_RESPCODE       = dpop.getData('LGD_RESPCODE');       //결과코드
        var LGD_RESPMSG        = dpop.getData('LGD_RESPMSG');        //결과메세지
	      if( "0000" == LGD_RESPCODE ) { //결제성공 
            var LGD_TID            = dpop.getData('LGD_TID');            //토스페이먼츠 거래KEY
	        var LGD_PAYDATE        = dpop.getData('LGD_PAYDATE');        //결제일자
            var LGD_FINANCECODE    = dpop.getData('LGD_FINANCECODE');    //결제기관코드
            var LGD_FINANCENAME    = dpop.getData('LGD_FINANCENAME');    //결제기관이름
            var LGD_NOTEURL_RESULT = dpop.getData('LGD_NOTEURL_RESULT'); //상점DB처리결과

            alert("결제가 성공하였습니다. 토스페이먼츠 거래ID : " + LGD_TID);
            /*
             * 결제성공 화면 처리
             */        
       
        } else { //결제실패
             alert("결제가 실패하였습니다. " + LGD_RESPMSG);
            /*
             * 결제실패 화면 처리
             */        
        }
    } else {
        alert("토스페이먼츠 전자결제를 위한 ActiveX 설치 실패");
    }     
} 
 
</script>
</head>

<body>
<form method="post" id="LGD_PAYINFO">
<input type="hidden" id="LGD_MID" name="LGD_MID" value="">								<!-- 상점아이디 -->
<input type="hidden" id="LGD_NOTEURL" name="LGD_NOTEURL" value="<%= LGD_NOTEURL %>">						<!-- 결제결과처리_URL(LGD_NOTEURL) -->
<table>
    <tr>
        <td>상점아이디 </td>
        <td><input type="text" name="CST_MID" id="CST_MID"     value="">	
    </tr>
    <tr>
        <td>서비스, 테스트 </td>
        <td><input type="text" id="CST_PLATFORM"     value="test">	
    </tr>
    <tr>
        <td>주문번호 </td>
        <td><input type="text" name="LGD_OID"     value="<%= LGD_OID %>">	<!-- 주문번호 --></td>
    </tr>
    <tr>
        <td>상품정보 </td>
        <td><input type="text" name="LGD_PRODUCTINFO"     value="<%= LGD_PRODUCTINFO %>">		<!-- 상품정보 --></td>
    </tr>
    <tr>
        <td>결제금액 </td>
        <td><input type="text" name="LGD_AMOUNT"  value="<%= LGD_AMOUNT %>">		<!-- 결제금액 --></td>
    </tr>
    <tr>
        <td>구매자명 </td>
        <td><input type="text" name="LGD_BUYER"   value="<%= LGD_BUYER %>">	<!-- 구매자 --></td>
    </tr>
     <tr>
        <td>
        <input type="button" value="결제요청(ActiveX)" onclick="doAnsimKeyin()"/><br>
        </td>
    </tr>
</table>
</form>

</body>
<!--  xpay.js는 반드시 body 밑에 두시기 바랍니다. -->
<script language="javascript" src="http://xpay.tosspayments.com/ansim-keyin/js/ansim-keyin_utf-8.js" type="text/javascript"></script>
</html>
