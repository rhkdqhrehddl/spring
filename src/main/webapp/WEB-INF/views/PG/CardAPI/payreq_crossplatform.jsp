<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.security.MessageDigest, java.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
    /*
     * [결제 인증요청 페이지(STEP2-1)]
     *
     * 샘플페이지에서는 기본 파라미터만 예시되어 있으며, 별도로 필요하신 파라미터는 연동메뉴얼을 참고하시어 추가 하시기 바랍니다.
     */

    String sessionid = request.getSession().getId();

  	response.setHeader("SET-COOKIE", "JSESSIONID=" + sessionid + "; Path=/; Secure; SameSite=None");
 	 
     
    /*
     * 1. 기본결제 인증요청 정보 변경
     *
     * 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
     */
 	

 	String serverName = request.getServerName();
    String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                 //토스페이먼츠 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID              = request.getParameter("CST_MID");                      //토스페이먼츠로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
                                                                                        //상점아이디(자동생성)
    String LGD_OID              = request.getParameter("LGD_OID");                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT");                   //결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_MERTKEY          = "반드시 입력하세요";                  						//상점MertKey(mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
    String LGD_BUYER            = request.getParameter("LGD_BUYER");                    //구매자명
    String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO");              //상품명
    String LGD_BUYEREMAIL       = request.getParameter("LGD_BUYEREMAIL");               //구매자 이메일
    String LGD_TIMESTAMP        = request.getParameter("LGD_TIMESTAMP");                //타임스탬프
    String LGD_CUSTOM_USABLEPAY = request.getParameter("LGD_CUSTOM_USABLEPAY");        	//상점정의 초기결제수단
    String LGD_CUSTOM_SKIN      = "red";                                                //상점정의 결제창 스킨(red)


    String LGD_CUSTOM_SWITCHINGTYPE = request.getParameter("LGD_CUSTOM_SWITCHINGTYPE"); //신용카드 카드사 인증 페이지 연동 방식 (수정불가)
    String LGD_WINDOW_VER		= "2.5";												//결제창 버젼정보
    String LGD_WINDOW_TYPE      = request.getParameter("LGD_WINDOW_TYPE");              //결제창 호출 방식 (수정불가)

	String LGD_OSTYPE_CHECK     = "P";                                                  //값 P: XPay 실행(PC 결제 모듈): PC용과 모바일용 모듈은 파라미터 및 프로세스가 다르므로 PC용은 PC 웹브라우저에서 실행 필요. 
                                                                                        //"P", "M" 외의 문자(Null, "" 포함)는 모바일 또는 PC 여부를 체크하지 않음
	//String LGD_ACTIVEXYN		= "N";													//계좌이체 결제시 사용, ActiveX 사용 여부로 "N" 이외의 값: ActiveX 환경에서 계좌이체 결제 진행(IE)

    
    /*
     * 가상계좌(무통장) 결제 연동을 하시는 경우 아래 LGD_CASNOTEURL 을 설정하여 주시기 바랍니다.
     */
    String LGD_CASNOTEURL		= "https://" + serverName + "/PG/XPayClient/cas_noteurl.do";;

    /*
     * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
     */
    String LGD_RETURNURL		= "https://" + serverName + "/PG/CardAPI/returnurl.do";
	
	
	/*
	 * [ 신용카드 자체창(신용카드 선택창 스킵) 파라미터 ]
	 * 신용카드 자체창 파라미터는 다른 결제수단 연동시 제외해야 합니다. 
	 * 신용카드 결제요청시에만 추가 해 주세요.
	 */
	String LGD_SELF_CUSTOM		= request.getParameter("LGD_SELF_CUSTOM");				//표준창의 신용카드 선택창 스킵
	String LGD_CARDTYPE			= request.getParameter("LGD_CARDTYPE");					//결제진행 신용카드 카드사 코드
	String LGD_INSTALL			= request.getParameter("LGD_INSTALL");					//안심클릭할부개월
	String LGD_NOINT			= request.getParameter("LGD_NOINT");					//무이자적용 여부
	String LGD_SP_CHAIN_CODE	= request.getParameter("LGD_SP_CHAIN_CODE");			//간편결제사용여부
	String LGD_SP_ORDER_USER_ID	= request.getParameter("LGD_SP_ORDER_USER_ID");			//간편결제 쇼핑몰 KEY_ID(계약된 일부 상점만 가능)
	String LGD_POINTUSE			= request.getParameter("LGD_POINTUSE");					//포인트 사용여부
	String LGD_CURRENCY			= request.getParameter("LGD_CURRENCY");					//통화코드(410: 원화)
	//- 끝
	
	

    /*
     *************************************************
     * 2. MD5 해쉬암호화 (수정하지 마세요) - BEGIN
     *
     * MD5 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
     *************************************************
     *
     * 해쉬 암호화 적용( LGD_MID + LGD_OID + LGD_AMOUNT + LGD_TIMESTAMP + LGD_MERTKEY )
     * LGD_MID          : 상점아이디
     * LGD_OID          : 주문번호
     * LGD_AMOUNT       : 금액
     * LGD_TIMESTAMP    : 타임스탬프
     * LGD_MERTKEY      : 상점MertKey (mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
     *
     * MD5 해쉬데이터 암호화 검증을 위해
     * 토스페이먼츠에서 발급한 상점키(MertKey)를 환경설정 파일(lgdacom/conf/mall.conf)에 반드시 입력하여 주시기 바랍니다.
     */
    StringBuffer sb = new StringBuffer();
    sb.append(LGD_MID);
    sb.append(LGD_OID);
    sb.append(LGD_AMOUNT);
    sb.append(LGD_TIMESTAMP);
    sb.append(LGD_MERTKEY);

    byte[] bNoti = sb.toString().getBytes();
    MessageDigest md = MessageDigest.getInstance("MD5");
    byte[] digest = md.digest(bNoti);

    StringBuffer strBuf = new StringBuffer();
    for (int i=0 ; i < digest.length ; i++) {
        int c = digest[i] & 0xff;
        if (c <= 15){
            strBuf.append("0");
        }
        strBuf.append(Integer.toHexString(c));
    }

    String LGD_HASHDATA = strBuf.toString();
    String LGD_CUSTOM_PROCESSTYPE = "TWOTR";
    /*
     *************************************************
     * 2. MD5 해쉬암호화 (수정하지 마세요) - END
     *************************************************
     */
     
     
     
     
  	 Map payReqMap = new HashMap();
     
     payReqMap.put("CST_PLATFORM"                , CST_PLATFORM);                   	// 테스트, 서비스 구분
     payReqMap.put("CST_MID"                     , CST_MID );                        	// 상점아이디
     payReqMap.put("LGD_WINDOW_TYPE"             , LGD_WINDOW_TYPE );                   // 결제창호출 방식(수정불가)
     payReqMap.put("LGD_MID"                     , LGD_MID );                        	// 상점아이디
     payReqMap.put("LGD_OID"                     , LGD_OID );                        	// 주문번호
     payReqMap.put("LGD_BUYER"                   , LGD_BUYER );                      	// 구매자
     payReqMap.put("LGD_PRODUCTINFO"             , LGD_PRODUCTINFO );                	// 상품정보
     payReqMap.put("LGD_AMOUNT"                  , LGD_AMOUNT );                     	// 결제금액
     payReqMap.put("LGD_BUYEREMAIL"              , LGD_BUYEREMAIL );                 	// 구매자 이메일
     payReqMap.put("LGD_CUSTOM_SKIN"             , LGD_CUSTOM_SKIN );                	// 결제창 SKIN
     payReqMap.put("LGD_CUSTOM_PROCESSTYPE"      , LGD_CUSTOM_PROCESSTYPE );         	// 트랜잭션 처리방식
     payReqMap.put("LGD_TIMESTAMP"               , LGD_TIMESTAMP );                  	// 타임스탬프
     payReqMap.put("LGD_HASHDATA"                , LGD_HASHDATA );      	           	// MD5 해쉬암호값
     payReqMap.put("LGD_RETURNURL"   			, LGD_RETURNURL );      			   	// 응답수신페이지
     payReqMap.put("LGD_CUSTOM_USABLEPAY"  		, LGD_CUSTOM_USABLEPAY );				// 디폴트 결제수단 (해당 필드를 보내지 않으면 결제수단 선택 UI 가 보이게 됩니다.)
     payReqMap.put("LGD_CUSTOM_SWITCHINGTYPE"  	, LGD_CUSTOM_SWITCHINGTYPE );			// 신용카드 카드사 인증 페이지 연동 방식
     payReqMap.put("LGD_WINDOW_VER"  			, LGD_WINDOW_VER );						// 결제창 버젼정보 
     payReqMap.put("LGD_OSTYPE_CHECK"           , LGD_OSTYPE_CHECK);                    // 값 P: XPay 실행(PC용 결제 모듈), PC, 모바일 에서 선택적으로 결제가능 
	 //payReqMap.put("LGD_ACTIVEXYN"			, LGD_ACTIVEXYN);						// 계좌이체 결제시 사용, ActiveX 사용 여부
	 payReqMap.put("LGD_VERSION"         		, "JSP_Non-ActiveX_Standard");			// 사용타입 정보(수정 및 삭제 금지): 이 정보를 근거로 어떤 서비스를 사용하는지 판단할 수 있습니다.
	 payReqMap.put("LGD_DOMAIN_URL"				, "xpayvvip" );
	 payReqMap.put("LGD_ENCODING"          			, "UTF-8" );
     payReqMap.put("LGD_ENCODING_RETURNURL"         , "UTF-8" );

     
     // 가상계좌(무통장) 결제연동을 하시는 경우  할당/입금 결과를 통보받기 위해 반드시 LGD_CASNOTEURL 정보를 토스페이먼츠에 전송해야 합니다 .
     payReqMap.put("LGD_CASNOTEURL"          , LGD_CASNOTEURL );               // 가상계좌 NOTEURL

	/*
	 * [ 신용카드 자체창(신용카드 선택창 스킵) 파라미터 ]
	 * 신용카드 자체창 파라미터는 다른 결제수단 연동시 제외해야 합니다. 
	 * 신용카드 결제요청시에만 추가 해 주세요.
	 */
	 payReqMap.put("LGD_SELF_CUSTOM"         , LGD_SELF_CUSTOM );                  
     payReqMap.put("LGD_CARDTYPE"         	 , LGD_CARDTYPE );                  
     payReqMap.put("LGD_INSTALL"           	 , LGD_INSTALL );                     
     payReqMap.put("LGD_NOINT"           	 , LGD_NOINT );                     
     payReqMap.put("LGD_SP_CHAIN_CODE"       , LGD_SP_CHAIN_CODE );                     
     payReqMap.put("LGD_SP_ORDER_USER_ID"    , LGD_SP_ORDER_USER_ID );                     
     payReqMap.put("LGD_POINTUSE"          	 , LGD_POINTUSE );                                        
     payReqMap.put("LGD_CURRENCY"          	 , LGD_CURRENCY );
	//- 끝
	 

    /*Return URL에서 인증 결과 수신 시 셋팅될 파라미터 입니다.*/
	 payReqMap.put("LGD_RESPCODE"  		 , "" );
	 payReqMap.put("LGD_RESPMSG"  		 , "" );
	 payReqMap.put("LGD_PAYKEY"  		 , "" );

	 session.setAttribute("PAYREQ_MAP", payReqMap);

 %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>통합토스페이먼츠 전자결서비스 결제테스트</title>
<!-- test -->
<script language="javascript" src="https://pretest.tosspayments.com:9443/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<!-- 
  service  
<script language="javascript" src="https://xpayvvip.tosspayments.com/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
 -->

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
		
			document.getElementById("LGD_PAYKEY").value = fDoc.document.getElementById('LGD_PAYKEY').value;
			document.getElementById("LGD_PAYINFO").target = "_self";
			document.getElementById("LGD_PAYINFO").action = "payres.do";
			document.getElementById("LGD_PAYINFO").submit();
	} else {
		alert("LGD_RESPCODE (결과코드) : " + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "LGD_RESPMSG (결과메시지): " + fDoc.document.getElementById('LGD_RESPMSG').value);
		closeIframe();
	}
}

</script>
</head>
<body>
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" action="payres.do">
<table>
    <tr>
        <td>구매자 이름 </td>
        <td><%= LGD_BUYER %></td>
    </tr>
    <tr>
        <td>상품정보 </td>
        <td><%= LGD_PRODUCTINFO %></td>
    </tr>
    <tr>
        <td>결제금액 </td>
        <td><%= LGD_AMOUNT %></td>
    </tr>
    <tr>
        <td>구매자 이메일 </td>
        <td><%= LGD_BUYEREMAIL %></td>
    </tr>
    <tr>
        <td>주문번호 </td>
        <td><%= LGD_OID %></td>
    </tr>
    <tr>
        <td colspan="2">* 추가 상세 결제요청 파라미터는 메뉴얼을 참조하시기 바랍니다.</td>
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
</form>

</body>

</html>
