<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.security.MessageDigest, java.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
	String sessionid = request.getSession().getId();
	
	response.setHeader("SET-COOKIE", "JSESSIONID=" + sessionid +"; Path=/; Secure; SameSite=None");
	/*
     * 
     *     
     * 기본 파라미터만 예시되어 있으며, 별도로 필요하신 파라미터는 연동메뉴얼을 참고하시어 추가하시기 바랍니다. 
     *
     */

     
    /*
	 * [상점인증요청 페이지]
     * 1. 기본인증정보 변경
     *
     * 인증기본정보를 변경하여 주시기 바랍니다. 
     */
    String CST_PLATFORM			= request.getParameter("CST_PLATFORM").trim();     			//LG유플러스 인증서비스 선택(test:테스트, service:서비스)                                              
    String CST_MID				= request.getParameter("CST_MID").trim();          			//LG유플러스으로 부터 발급받으신 상점아이디를 입력하세요. 
                                                                                            //테스트 아이디는 't'를 제외하고 입력하세요.
    String LGD_MID				= ("test".equals(CST_PLATFORM)?"t":"")+CST_MID;             //상점아이디(자동생성)   
    String LGD_BUYERSSN			= request.getParameter("LGD_BUYERSSN").trim();				//인증요청자 생년월일 6자리 (YYMMDD) or 사업자번호 10자리
    String LGD_CHECKSSNYN		= request.getParameter("LGD_CHECKSSNYN").trim();			//인증요청자 생년월일,사업자번호 일치 여부 확인 플래그 ( 'Y'이면 인증창에서 고객이 입력한 생년월일,사업자번호 일치여부를 확인합니다.)
    String LGD_DISABLE_AGREE	= request.getParameter("LGD_DISABLE_AGREE").trim();
	String LGD_PRODUCTINFO		= request.getParameter("LGD_PRODUCTINFO").trim();			//상품명(페이나우 빌링 사용시 페이나우 뷰를 호출하기 위한 필수 파라미터)
	String LGD_AMOUNT			= request.getParameter("LGD_AMOUNT").trim();				//금액(페이나우 빌링 사용시 페이나우 뷰를 호출하기 위한 필수 파라미터)
    String LGD_EASYPAY_ONLY		= request.getParameter("LGD_EASYPAY_ONLY").trim();			//페이나우사용여부(값:PAYNOW, 페이나우 빌링 사용시 페이나우 뷰를 호출하기 위한 필수 파라미터)
	String LGD_WINDOW_TYPE		= "iframe";													//인증창 호출 방식 (수정불가)   

    /*
     * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
     */
 	String LGD_RETURNURL			= "https://rhkdqhrehddl.tk/PG/CardBilling/returnurl.do";		// FOR MANUAL

	Map payReqMap = new HashMap();
		 
	payReqMap.put("CST_PLATFORM"			, CST_PLATFORM);					// 테스트, 서비스 구분
	payReqMap.put("CST_MID"					, CST_MID );						// 상점아이디
	payReqMap.put("LGD_WINDOW_TYPE"			, LGD_WINDOW_TYPE );				// 호출방식
	payReqMap.put("LGD_MID"					, LGD_MID );						// 상점아이디
	payReqMap.put("LGD_BUYERSSN"			, LGD_BUYERSSN );					// 요청자 생년월일 / 사업자번호
	payReqMap.put("LGD_CHECKSSNYN"			, LGD_CHECKSSNYN );					// 요청자 정보 일치여부 확인값
	payReqMap.put("LGD_PRODUCTINFO"			, LGD_PRODUCTINFO );				// 상품명(페이나우 빌링 사용시 필수)
	payReqMap.put("LGD_AMOUNT"				, LGD_AMOUNT );						// 금액(페이나우 빌링 사용시 필수)
	payReqMap.put("LGD_EASYPAY_ONLY"		, LGD_EASYPAY_ONLY );				// 페이나우사용여부(페이나우 빌링 사용시 필수)
	payReqMap.put("LGD_RETURNURL"			, LGD_RETURNURL );					// 리턴URL
	payReqMap.put("LGD_PAYWINDOWTYPE"		, "CardBillingAuth");				// 인증요청구분 (수정불가)
	payReqMap.put("LGD_VERSION"				, "JSP_Non-ActiveX_CardBilling");	// 사용타입 정보(수정 및 삭제 금지): 이 정보를 근거로 어떤 서비스를 사용하는지 판단할 수 있습니다.
	payReqMap.put("LGD_DOMAIN_URL"			, "xpayvvip" );	//<= 주석 처리 후 IE에서 정상동작 (추후에 추가된 파라미터)		
	
	/*Return URL에서 인증 결과 수신 시 셋팅될 파라미터 입니다.*/
	payReqMap.put("LGD_RESPCODE"			, "");
	payReqMap.put("LGD_RESPMSG"				, "");
	payReqMap.put("LGD_BILLKEY"				, "");			   	  
	payReqMap.put("LGD_PAYTYPE"				, "");			   	   
	payReqMap.put("LGD_PAYDATE"				, "");			   	   	
	payReqMap.put("LGD_FINANCECODE"			, "");			   	   	
	payReqMap.put("LGD_FINANCENAME"			, "");
	//payReqMap.put("LGD_ACTIVEXYN"			, "N");
    payReqMap.put("LGD_ENCODING"          			, "UTF-8" );
    payReqMap.put("LGD_ENCODING_RETURNURL"         , "UTF-8" );
    payReqMap.put("LGD_RETURN_MERT_CUSTOM_PARAM"	, "Y");
	payReqMap.put("LGD_DISABLE_AGREE"			, LGD_DISABLE_AGREE);
    
	session.setAttribute("PAYREQ_MAP", payReqMap);

%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>인증 요청</title>
<!-- test -->
<script language="javascript" src="https://pretest.uplus.co.kr:9443/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>

<script language="javascript" src="https://xpayvvip.uplus.co.kr/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>


<script type="text/javascript">

/*
* 수정불가.
*/
	var LGD_window_type = '<%=LGD_WINDOW_TYPE%>';
	
/*
* 수정불가
*/
function launchCrossPlatform(){
	lgdwin = openXpay(document.getElementById('LGD_PAYINFO'), '<%= CST_PLATFORM %>', LGD_window_type, null, "", "");
}
/*
* FORM 명만  수정 가능
*/
function getFormObject() {
        return document.getElementById("LGD_PAYINFO");
}

/*
 * 인증결과 처리
 */
function payment_return() {
	var fDoc;
	
	fDoc = lgdwin.contentWindow || lgdwin.contentDocument;	
		
	if (fDoc.document.getElementById('LGD_RESPCODE').value == "0000") {
			
			document.getElementById("LGD_RESPCODE").value = fDoc.document.getElementById('LGD_RESPCODE').value;
			document.getElementById("LGD_RESPMSG").value = fDoc.document.getElementById('LGD_RESPMSG').value;
			document.getElementById("LGD_BILLKEY").value = fDoc.document.getElementById('LGD_BILLKEY').value;
			document.getElementById("LGD_PAYTYPE").value = fDoc.document.getElementById('LGD_PAYTYPE').value;
			document.getElementById("LGD_PAYDATE").value = fDoc.document.getElementById('LGD_PAYDATE').value;
			document.getElementById("LGD_FINANCECODE").value = fDoc.document.getElementById('LGD_FINANCECODE').value;
			document.getElementById("LGD_FINANCENAME").value = fDoc.document.getElementById('LGD_FINANCENAME').value;

			document.getElementById("LGD_PAYINFO").target = "_self";
			document.getElementById("LGD_PAYINFO").action = "CardBillingAuth_Res.do";
			document.getElementById("LGD_PAYINFO").submit();
	} else {
		alert("LGD_RESPCODE (결과코드) : " + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "LGD_RESPMSG (결과메시지): " + fDoc.document.getElementById('LGD_RESPMSG').value);
		closeIframe();
	}
}

</script>
</head>
<body>
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" >
<table>
    <tr>
        <td>인증요청 생년월일,사업자번호</td>
        <td><%= LGD_BUYERSSN %></td>
    </tr>
    <tr>
        <td>인증요청 생년월일,사업자번호 일치여부 확인 플래그</td>
        <td><%= LGD_CHECKSSNYN %></td>
    </tr>
    <tr>
        <td colspan="2">* 추가 상세 인증요청 파라미터는 메뉴얼을 참조하세요.</td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>
    <tr>
        <td colspan="2">
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
<input type="hidden" name="aaa" id="aaa" value="aaa">
<input type="hidden" name="vvv" id="vvv" value="vvv">
</form>

</body>

</html>
