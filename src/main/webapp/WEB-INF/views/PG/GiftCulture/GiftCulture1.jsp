<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lgdacom.XPayClient.XPayClient"%>

<%
    String configPath = "C:/lgdacom";  //토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf") 위치 지정.
    
    if(System.getProperty("os.name").equals("Linux")){
		configPath = "/lgdacom";
 	}
    
    request.setCharacterEncoding("UTF-8");
    String CST_PLATFORM                 = request.getParameter("CST_PLATFORM");		//토스페이먼츠 결제 서비스 선택(test:테스트, service:서비스)	
    String CST_MID                      = request.getParameter("CST_MID");			//상점아이디(토스페이먼츠로 부터 발급받으신 상점아이디를 입력하세요)
    String LGD_MID                      = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;	//테스트 아이디는 't'를 제외하고 입력하세요.
    																				//상점아이디(자동생성) 
    String LGD_OID                  	= request.getParameter("LGD_OID");			//주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT                  	= request.getParameter("LGD_AMOUNT");		//결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_CULTID    				= request.getParameter("LGD_CULTID");		//컬쳐랜드 아이디
    String LGD_CULTPASSWD    			= request.getParameter("LGD_CULTPASSWD");	//컬쳐랜드 비밀번호
    String LGD_METHOD					= "AUTH";									//메소드 (인증요청)
    String LGD_BUYER    				= request.getParameter("LGD_BUYER");		//구매자
    String LGD_BUYEREMAIL    			= request.getParameter("LGD_BUYEREMAIL");	//구매자 이메일
    String LGD_PRODUCTINFO    			= request.getParameter("LGD_PRODUCTINFO");	//상품명
    String LGD_BUYERID    				= request.getParameter("LGD_BUYERID");		//구매자 아이디
    String LGD_BUYERIP    				= request.getParameter("LGD_BUYERIP");		//구매자 IP
//    String LGD_BUYERIP					= request.getRemoteAddr();
    String LGD_CULTAUTHTYPE				="";										//인증타입
    
    XPayClient xpay = new XPayClient();
   	xpay.Init(configPath, CST_PLATFORM);

    try{
	    xpay.Init_TX(LGD_MID);
	    xpay.Set("LGD_TXNAME", "GiftCulture");
	    xpay.Set("LGD_METHOD", LGD_METHOD);
	    xpay.Set("LGD_OID", LGD_OID);
	    xpay.Set("LGD_AMOUNT", LGD_AMOUNT);
	    xpay.Set("LGD_CULTID", LGD_CULTID);
	    xpay.Set("LGD_CULTPASSWD", LGD_CULTPASSWD);
	    xpay.Set("LGD_CULTVERSION", "2");     //삭제하지 마세요 (컬쳐랜드 신규변경전문적용, 2012-6-1)
	    xpay.Set("LGD_BUYER", LGD_BUYER);
	    xpay.Set("LGD_BUYEREMAIL", LGD_BUYEREMAIL);
	    xpay.Set("LGD_BUYERID", LGD_BUYERID);
	    xpay.Set("LGD_BUYERIP", LGD_BUYERIP);
	    xpay.Set("LGD_PRODUCTINFO", LGD_PRODUCTINFO);
		xpay.Set("LGD_ENCODING", "UTF-8");
	    
	    
    }catch(Exception e) {
    	out.println("토스페이먼츠 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다.");
    	out.println(""+e.getMessage());    	
    	return;
    }
    
    if ( xpay.TX() ) {
        //1)결제결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
        out.println( "인증요청이  완료되었습니다.  <br>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
        
        out.println("결과코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
        out.println("결과메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<br>");
        out.println("잔액 : " + xpay.Response("LGD_CULTBALANCE",0) + "<p>");
        
        LGD_CULTAUTHTYPE = xpay.Response("LGD_CULTAUTHTYPE",0);
        
        for (int i = 0; i < xpay.ResponseNameCount(); i++)
        {
            out.println(xpay.ResponseName(i) + " = ");
            for (int j = 0; j < xpay.ResponseCount(); j++)
            {
                out.println("\t" + xpay.Response(xpay.ResponseName(i), j) + "<br>");
            }
        }
        out.println("<p>");
        
        if( "0000".equals( xpay.m_szResCode ) ) {
        	out.println("인증이 성공하였습니다.<br/>"); 
        }else{
        	//최종결제요청 결과 실패 DB처리
        	out.println("인증이 실패하였습니다.<br/>");            	
        }
    }else {
        //2)API 요청실패 화면처리
        out.println( "인증이 실패하였습니다.<br/>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br/>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>문화상품권 결제요청</title>
<script type="text/javascript">
<!--
function goCultureland(){
	
	//서비스계
	popupWin = window.open("http://bill.cultureland.co.kr/mcash/custom/authFind.asp","popWinName","menubar=no,toolbar=0,scrollbars=no,width=500,height=520,resize=1,left=100,top=200")
	
	//테스트계
	//popupWin = window.open("http://testserver.cultureland.co.kr:82/mcash/custom/authFind.asp","popWinName","menubar=no,toolbar=0,scrollbars=no,width=500,height=520,resize=1,left=100,top=200")

}

function goCultureHome(){
	
	popupWin = window.open("http://www.cultureland.co.kr/mypage/SecurityCenter/PayCertification_creat_user.asp","popWinName","menubar=no,toolbar=0,scrollbars=no,width=1024,height=800,resize=1,left=100,top=200")

}

function sendSMS(){
	document.sendSMSForm.target = "hiddenFrame";
	document.sendSMSForm.submit();
}
-->
</script>
</head>
<body>
		<form method="post" action="GiftCulture2.do">
			<input type="hidden" name="CST_PLATFORM" value="<%=CST_PLATFORM %>">
			<input type="hidden" name="LGD_MID" value="<%= LGD_MID %>">
			<input type="hidden" name="LGD_TID" value="<%=xpay.Response("LGD_TID", 0) %>">
			<input type="hidden" name="LGD_AMOUNT" value="<%= LGD_AMOUNT %>">
			<input type="hidden" name="LGD_CULTAUTHTYPE" value="<%=LGD_CULTAUTHTYPE %>"/>
			<table>
			<tr>
                <td>인증타입명</td>
                <td><%=xpay.Response("LGD_CULTAUTHNAME", 0) %></td>
            </tr>
            <%if (!"P".equals(LGD_CULTAUTHTYPE)){%>
            <tr>
                <td>인증번호</td>
                <td><input type="text" name="LGD_CULTAUTHNO" value=""/></td>
            </tr>
            <% if ("0".equals(LGD_CULTAUTHTYPE)){ %>     
        	<tr>
                <td>인증번호 생성 </td>
                <td><input type="button" value="인증번호 생성" onclick="javascript:goCultureland();"/></td>
            </tr>
	    	<% } else if ("1".equals(LGD_CULTAUTHTYPE)){%>
        	<tr>
                <td>인증번호  찾기</td>
                <td><input type="button" value="인증번호 찾기" onclick="javascript:goCultureHome();"/></td>
            </tr>
	    	<% } else if ("2".equals(LGD_CULTAUTHTYPE)){%>
			<tr>
                <td>인증번호 발송</td>
                <td><input type="button" value="인증번호 발송" onclick="javascript:sendSMS();"/></td>
            </tr>
	    	<% }
	    	}
	    	%>
			<tr>
				<td>문화상품권번호</td>
				<td><input type="text" name="LGD_CULTPIN" value=""></td>
			</tr>
			</table>	
			
			<input type="submit" value="결제하기">
		</form>
		
		<!--###### 인증번호 SMS 발송 요청 (시작) #####-->
	<form name="sendSMSForm" method="POST" action="SendSMS.do">
	<input type="hidden" name="CST_PLATFORM" value="<%=CST_PLATFORM%>">
	<input type="hidden" name="CST_MID" value="<%=CST_MID%>">
	<input type="hidden" name="LGD_MID" value="<%=LGD_MID%>">
	<input type="hidden" name="LGD_TID" value="<%=xpay.Response("LGD_TID", 0) %>">
	<input type="hidden" name="LGD_CULTID" value="<%=LGD_CULTID%>">
	</form>						
	<iframe name="hiddenFrame" style="display:none;width:0;height:0" ></iframe>
	<!--###### 인증번호 SMS 발송 요청 (끝) #####-->
</body>
</html>