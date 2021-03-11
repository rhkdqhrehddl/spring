<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String sessionid = request.getSession().getId();
	
	response.setHeader("SET-COOKIE", "JSESSIONID=" + sessionid +"; Path=/; Secure; SameSite=None");
    /*
     * [결제 인증요청 페이지(STEP2-1)]
     *
     * 샘플페이지에서는 기본 파라미터만 예시되어 있으며, 별도로 필요하신 파라미터는 연동메뉴얼을 참고하시어 추가 하시기 바랍니다.
     */

    /*
     * 1. 기본결제 인증요청 정보 변경
     *
     * 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
     */

 	String serverName = request.getServerName();
    String protocol = request.isSecure() ? "https://" : "http://";
	String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                 //LG유플러스 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID              = request.getParameter("CST_MID");                      //LG유플러스으로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
                                                                                        //상점아이디(자동생성)
    String LGD_BUYERSSN         = request.getParameter("LGD_BUYERSSN");                 //인증요청자 생년월일 6자리 (YYMMDD) or 사업자번호 10자리
    String LGD_CHECKSSNYN       = request.getParameter("LGD_CHECKSSNYN");               //인증요청자 생년월일,사업자번호 일치 여부 확인 플래그 ( 'Y'이면 인증창에서 고객이 입력한 생년월일,사업자번호 일치여부를 확인합니다.)
    String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO").trim();       //상품명(페이나우 빌링 사용시 페이나우 뷰를 호출하기 위한 필수 파라미터)
    String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT").trim();            //금액(페이나우 빌링 사용시 페이나우 뷰를 호출하기 위한 필수 파라미터
	String LGD_EASYPAY_ONLY		= request.getParameter("LGD_EASYPAY_ONLY").trim();		//페이나우사용여부(값: PAYNOW, 페이나우 빌링 사용시 페이나우 뷰를 호출하기 위한 필수 파라미터)
   
    /*
     * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
     */    
    String LGD_RETURNURL			= protocol + serverName + "/PG/SmartXPayBilling/returnurl.do";
	
	String LGD_PAYWINDOWTYPE    = "CardBillingAuth_smartphone";
	String LGD_VERSION			= "JSP_SmartXPay_CardBilling";

	String CST_WINDOW_TYPE = "submit";//수정불가
    HashMap payReqMap = new HashMap();
    payReqMap.put("CST_PLATFORM"                , CST_PLATFORM);                    // 테스트, 서비스 구분
    payReqMap.put("CST_MID"                     , CST_MID );                        // 상점아이디
    payReqMap.put("CST_WINDOW_TYPE"             , CST_WINDOW_TYPE );                   
    payReqMap.put("LGD_MID"                     , LGD_MID );                        // 상점아이디
    payReqMap.put("LGD_BUYERSSN"                , LGD_BUYERSSN );                   // 요청자 생년월일 / 사업자번호   
    payReqMap.put("LGD_CHECKSSNYN"              , LGD_CHECKSSNYN );                 // 요청자 정보 일치여부 확인값
    payReqMap.put("LGD_PRODUCTINFO"             , LGD_PRODUCTINFO );                // 상품명(페이나우 빌링 사용시 필수)
    payReqMap.put("LGD_AMOUNT"                  , LGD_AMOUNT );                     // 금액(페이나우 빌링 사용시 필수)
	payReqMap.put("LGD_EASYPAY_ONLY"            , LGD_EASYPAY_ONLY );               // 페이나우사용여부(페이나우 빌링 사용시 필수)
    payReqMap.put("LGD_RETURNURL"               , LGD_RETURNURL );  
    payReqMap.put("LGD_PAYWINDOWTYPE"           , LGD_PAYWINDOWTYPE );
    payReqMap.put("LGD_VERSION"                 , LGD_VERSION );
	payReqMap.put("LGD_DOMAIN_URL"				, "xpayvvip" );	
	payReqMap.put("LGD_ENCODING"          			, "UTF-8" );
    payReqMap.put("LGD_ENCODING_RETURNURL"         , "UTF-8" );
	
    session.setAttribute("PAYREQ_MAP", payReqMap);
 %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>LG유플러스 전자결서비스 결제테스트</title>
<!-- test -->
<script language="javascript" src="https://pretest.uplus.co.kr:9443/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<!-- 
  service  
<script language="javascript" src="https://xpayvvip.uplus.co.kr/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
 -->

<script type="text/javascript">

/*
* iframe으로 결제창을 호출하시기를 원하시면 iframe으로 설정 (변수명 수정 불가)
*/
	var LGD_window_type = '<%=CST_WINDOW_TYPE%>';
/*
* 수정불가
*/
function launchCrossPlatform(){
      lgdwin = open_paymentwindow(document.getElementById('LGD_PAYINFO'), '<%= CST_PLATFORM %>', LGD_window_type);
}
/*
* FORM 명만  수정 가능
*/
function getFormObject() {
        return document.getElementById("LGD_PAYINFO");
}
</script>
</head>

<body>
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" action="">


<table>
    <tr>
        <td>인증요청 주민등록번호</td>
        <td><%= LGD_BUYERSSN %></td>
    </tr>
    <tr>
        <td>인증요청 주민등록번호 일치여부 확인 플래그 </td>
        <td><%= LGD_CHECKSSNYN %></td>
    </tr>
    <tr>
        <td colspan="2">* 추가 상세 인증요청 파라미터는 메뉴얼을 참조하세요.</td>
    </tr>
    <tr>
        <td>
		<input type="button" value="인증요청" onclick="launchCrossPlatform();"/>        
        </td>
    </tr>
</table>
<%
	for(Iterator i = payReqMap.keySet().iterator(); i.hasNext();){
		Object key = i.next();
		out.println("<input type='hidden' name='" + key + "' id='"+key+"' value='" + payReqMap.get(key) + "'>" );
	}
%>
</form>
</body>

</html>
