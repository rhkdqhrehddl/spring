<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.security.MessageDigest, java.util.*" %>

<!-- XpayUtil 라이브러리 사용하여 LGD_HASHDATA 생성 시 -->
<%@ page import="lgdacom.XPayClient.XPayUtil"%>


<%
	request.setCharacterEncoding("utf-8");
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
    String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                // 토스페이먼츠 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID              = request.getParameter("CST_MID");                     // 토스페이먼츠로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID; // 테스트 아이디는 't'를 제외하고 입력하세요.
																						// 상점아이디(자동생성)
    String LGD_OID              = request.getParameter("LGD_OID");                     // 주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT");                  // 결제금액("," 를 제외한 결제금액을 입력하세요)

    String LGD_BUYER            = request.getParameter("LGD_BUYER");                   // 구매자명
    String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO");             // 상품명
    String LGD_BUYEREMAIL       = request.getParameter("LGD_BUYEREMAIL");              // 구매자 이메일
    String LGD_CUSTOM_USABLEPAY = request.getParameter("LGD_CUSTOM_USABLEPAY");        // 상점정의 초기결제수단
    String LGD_CUSTOM_SKIN      = "red";                                               // 상점정의 결제창 스킨(red)
                                                                                           
    String LGD_CUSTOM_SWITCHINGTYPE = request.getParameter("LGD_CUSTOM_SWITCHINGTYPE");// 신용카드 카드사 인증 페이지 연동 방식 (수정불가)
    String LGD_WINDOW_VER		 = "2.5";												// 결제창 버젼정보
    String LGD_WINDOW_TYPE      = request.getParameter("LGD_WINDOW_TYPE");             // 결제창 호출 방식 (수정불가)
	String LGD_OSTYPE_CHECK     = "P";                                                 // 값 P: XPay 실행(PC 결제 모듈): PC용과 모바일용 모듈은 파라미터 및 프로세스가 다르므로 PC용은 PC 웹브라우저에서 실행 필요. 
                                                                                        // "P", "M" 외의 문자(Null, "" 포함)는 모바일 또는 PC 여부를 체크하지 않음
    
	String LGD_INSTALLRANGE			 = request.getParameter("LGD_INSTALLRANGE");		// 표시할부개월수
	String LGD_NOINT			 	 = request.getParameter("LGD_NOINT");				// 무이자할부 적용여부
	//String LGD_NOINTINF			 	 = request.getParameter("LGD_NOINTINF");			// 무이자할부 적용 카드사+할부개월 정보
	//String LGD_USABLEBANK		 	= request.getParameter("LGD_USABLEBANK");			// 사용가능은행 표시
	String LGD_CASHRECEIPTYN		 = request.getParameter("LGD_CASHRECEIPTYN");		// 현금영수증
	String LGD_ESCROW_USEYN			 = request.getParameter("LGD_ESCROW_USEYN");		// 에스크로
    
    String iPopUpWinX			 = "375";												// 오픈페이 PC 팝업 결제창 가로크기(수정불가)
    String iPopUpWinY			 = "667";												// 오픈페이 PC 팝업 결제창 세로크기(수정불가)
    String LGD_OPENPAY_TOKEN	 = request.getParameter("LGD_OPENPAY_TOKEN");			// 오픈페이 결제 고객 로그인 토큰 
    String LGD_OPENPAY_MER_UID	 = request.getParameter("LGD_OPENPAY_MER_UID");			// 오픈페이 결제 고객 가맹점 ID 
	String VIEW_AGREE			 = request.getParameter("VIEW_AGREE");

    /*
     * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
     */
     
    String LGD_RETURNURL		 = "https://" + serverName + "/PG/OpenPay/returnurl.do";// FOR MANUAL

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
     String configPath = "C:/lgdacom";  //LG유플러스에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
     
  	if(System.getProperty("os.name").equals("Linux")){
 		configPath = "/lgdacom";
  	}
     
    XPayUtil xu = new XPayUtil();
   	xu.Init(configPath);
	String LGD_TIMESTAMP	= xu.GetTimeStamp();
  	String LGD_HASHDATA		= xu.GetHashData(LGD_MID,LGD_OID,LGD_AMOUNT,LGD_TIMESTAMP);
    /*
     *************************************************
     * 2. MD5 해쉬암호화 (수정하지 마세요) - END
     *************************************************
     */
     String LGD_CUSTOM_PROCESSTYPE = "TWOTR";
    		
	Map payReqMap = new HashMap();
	
	payReqMap.put("CST_PLATFORM"               	, CST_PLATFORM);                   		// 테스트, 서비스 구분
	payReqMap.put("CST_MID"                    	, CST_MID );                        	// 상점아이디
	payReqMap.put("LGD_WINDOW_TYPE"            	, LGD_WINDOW_TYPE );                   	// 결제창호출 방식(수정불가)
	payReqMap.put("LGD_MID"                    	, LGD_MID );                        	// 상점아이디
	payReqMap.put("LGD_OID"                    	, LGD_OID );                        	// 주문번호
	payReqMap.put("LGD_BUYER"                  	, LGD_BUYER );                      	// 구매자
	payReqMap.put("LGD_PRODUCTINFO"            	, LGD_PRODUCTINFO );                	// 상품정보
	payReqMap.put("LGD_AMOUNT"                 	, LGD_AMOUNT );                     	// 결제금액
	payReqMap.put("LGD_BUYEREMAIL"             	, LGD_BUYEREMAIL );                 	// 구매자 이메일
	payReqMap.put("LGD_CUSTOM_SKIN"            	, LGD_CUSTOM_SKIN );                	// 결제창 SKIN
	payReqMap.put("LGD_CUSTOM_PROCESSTYPE"     	, LGD_CUSTOM_PROCESSTYPE );         	// 트랜잭션 처리방식
	payReqMap.put("LGD_TIMESTAMP"              	, LGD_TIMESTAMP );                  	// 타임스탬프
	payReqMap.put("LGD_HASHDATA"               	, LGD_HASHDATA );      	           		// MD5 해쉬암호값
	payReqMap.put("LGD_RETURNURL"   			, LGD_RETURNURL );      			   	// 응답수신페이지
	payReqMap.put("LGD_CUSTOM_USABLEPAY"  		, LGD_CUSTOM_USABLEPAY );				// 디폴트 결제수단 (해당 필드를 보내지 않으면 결제수단 선택 UI 가 보이게 됩니다.)
	payReqMap.put("LGD_CUSTOM_SWITCHINGTYPE"  	, LGD_CUSTOM_SWITCHINGTYPE );			// 신용카드 카드사 인증 페이지 연동 방식
	payReqMap.put("LGD_WINDOW_VER"  			, LGD_WINDOW_VER );						// 결제창 버젼정보 
	payReqMap.put("LGD_OSTYPE_CHECK"           	, LGD_OSTYPE_CHECK);                    // 값 P: XPay 실행(PC용 결제 모듈), PC, 모바일 에서 선택적으로 결제가능 
	payReqMap.put("LGD_INSTALLRANGE"           	, LGD_INSTALLRANGE);                    // 표시할부개월수 
	payReqMap.put("LGD_NOINT"           		, LGD_NOINT);                    		// 무이자할부 적용여부 
	//payReqMap.put("LGD_NOINTINF"           		, LGD_NOINTINF);                    	// 무이자할부 적용 카드사+할부개월 정보 
	//payReqMap.put("LGD_USABLEBANK"       	    , LGD_USABLEBANK);                   	// 사용가능은행표시
	payReqMap.put("LGD_CASHRECEIPTYN"           , LGD_CASHRECEIPTYN);                   // 현금영수증 
	payReqMap.put("LGD_ESCROW_USEYN"           	, LGD_ESCROW_USEYN);                    // 에스크로 
	payReqMap.put("LGD_VERSION"         		, "JSP_Non-ActiveX_Standard");			// 사용타입 정보(수정 및 삭제 금지): 이 정보를 근거로 어떤 서비스를 사용하는지 판단할 수 있습니다.
	payReqMap.put("LGD_EASYPAY_ONLY"			, "PAYNOW");							// 오픈페이 결제 파라미터(고정)
	payReqMap.put("LGD_OPENPAY_YN"				, "Y");									// 오픈페이 결제 파라미터(고정)
	payReqMap.put("LGD_OPENPAY_TOKEN"			, LGD_OPENPAY_TOKEN);					// 오픈페이 결제 고객 로그인 토큰
	payReqMap.put("LGD_OPENPAY_MER_UID"			, LGD_OPENPAY_MER_UID);					// 오픈페이 결제 고객 가맹점 ID
	payReqMap.put("LGD_DOMAIN_URL"				, "xpayvvip" );	
	
    /*Return URL에서 인증 결과 수신 시 셋팅될 파라미터 입니다.*/
	payReqMap.put("LGD_RESPCODE"  		 		, "" );
	payReqMap.put("LGD_RESPMSG"  		 		, "" );
	payReqMap.put("LGD_PAYKEY"  		 		, "" );
	
	payReqMap.put("LGD_OPENPAY_PAYTYPE"  		, "" );
	
	if(VIEW_AGREE.equals("Y")){
		payReqMap.put("LGD_ONEPAY_VIEW_VERSION", "02");
	}

	session.setAttribute("PAYREQ_MAP", payReqMap);

 %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>토스페이먼츠 전자결제서비스 결제테스트</title>
<!-- test일 경우 -->
<script language="javascript" src="https://pretest.tosspayments.com:9443/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<!-- 
  service일 경우 아래 URL을 사용 
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
	lgdwin = openXpay(document.getElementById('LGD_PAYINFO'), '<%= CST_PLATFORM %>', LGD_window_type, null, '<%=iPopUpWinX%>', '<%=iPopUpWinY%>');
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
			
			document.getElementById("LGD_OPENPAY_PAYTYPE").value = fDoc.document.getElementById('LGD_OPENPAY_PAYTYPE').value;
			document.getElementById("LGD_OPENPAY_TOKEN").value = fDoc.document.getElementById('LGD_OPENPAY_TOKEN').value;
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
