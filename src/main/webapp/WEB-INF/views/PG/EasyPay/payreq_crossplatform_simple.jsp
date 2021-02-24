<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.security.MessageDigest, java.util.*" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>

<%
	request.setCharacterEncoding("utf-8");
    /*
     * [결제 인증요청 페이지(STEP2-1)]
     *
     * 샘플페이지에서는 기본 파라미터만 예시되어 있으며, 별도로 필요하신 파라미터는 연동메뉴얼을 참고하시어 추가 하시기 바랍니다.
     */

     /* ※ 중요
 	* 환경설정 파일의 경우 반드시 외부에서 접근이 가능한 경로에 두시면 안됩니다.
 	* 해당 환경파일이 외부에 노출이 되는 경우 해킹의 위험이 존재하므로 반드시 외부에서 접근이 불가능한 경로에 두시기 바랍니다. 
 	* 예) [Window 계열] C:\inetpub\wwwroot\lgdacom ==> 절대불가(웹 디렉토리)
 	*/
 	String configPath = "C:/lgdacom";  //토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
    
 	if(System.getProperty("os.name").equals("Linux")){
		configPath = "/lgdacom";
 	}
 	
 	String sessionid = request.getSession().getId();
 	response.setHeader("SET-COOKIE", "JSESSIONID=" + sessionid + "; Path=/; Secure; SameSite=None");
 	
    /*
     * 1. 기본결제 인증요청 정보 변경
     *
     * 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
     */
  	String serverName = request.getServerName();
    String protocol = request.isSecure() ? "https://" : "http://";
    String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                 //토스페이먼츠 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID              = request.getParameter("CST_MID");                      //토스페이먼츠으로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
                                                                                        //상점아이디(자동생성)
    String LGD_OID              = request.getParameter("LGD_OID");                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT");                   //결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_BUYER            = request.getParameter("LGD_BUYER");                    //구매자명
    String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO");              //상품명
    String LGD_BUYEREMAIL       = request.getParameter("LGD_BUYEREMAIL");               //구매자 이메일
    String LGD_TIMESTAMP        = request.getParameter("LGD_TIMESTAMP");                //타임스탬프
	String LGD_BUYERPHONE       = request.getParameter("LGD_BUYERPHONE"); 
    String LGD_CUSTOM_SKIN      = "red";                                                //상점정의 결제창 스킨(red, blue, cyan, green, yellow)
    String LGD_BUYERID          = request.getParameter("LGD_BUYERID");       			//구매자 아이디
    String LGD_BUYERIP          = request.getParameter("LGD_BUYERIP");       			//구매자IP
	String LGD_DISPLAY_BUYEREMAIL   = request.getParameter("LGD_DISPLAY_BUYEREMAIL");	//구매자이메일
	String LGD_EASYPAY_ONLY		= request.getParameter("LGD_EASYPAY_ONLY");												//페이나우사용여부(값:PAYNOW, 수정불가)
	String LGD_ONEPAY_VIEW_VERSION  = "02";												//페이나우 창 크기 설정
	String LGD_CUSTOM_USABLEPAY	= request.getParameter("LGD_CUSTOM_USABLEPAY");			//상점정의 결제가능 수단
	String LGD_USABLECARD		= request.getParameter("LGD_USABLECARD");				//사용을 원하는 카드사만 표시
	String LGD_CASHRECEIPTYN	= request.getParameter("LGD_CASHRECEIPTYN");			//현금영수증발급 사용여부
	String LGD_WINDOW_VER       = "2.5";                                                //결제창 버젼정보
	String CST_WINDOW_TYPE      = request.getParameter("LGD_WINDOW_TYPE");				//결제창 호출 방식 (수정불가)
	String LGD_CUSTOM_SWITCHINGTYPE = request.getParameter("LGD_CUSTOM_SWITCHINGTYPE"); //수정불가
    /*
     * 가상계좌(무통장) 결제 연동을 하시는 경우 아래 LGD_CASNOTEURL 을 설정하여 주시기 바랍니다. 
     */    
	
    /*
     * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
     */
    String LGD_RETURNURL		= protocol + serverName + "/PG/EasyPay/returnurl.do";

    /*
     *************************************************
     * 2. MD5 해쉬암호화 (수정하지 마세요) - BEGIN
     *
     * MD5 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
     *************************************************
     *
     * 해쉬 암호화 생성( LGD_MID + LGD_OID + LGD_AMOUNT + LGD_TIMESTAMP )
     * LGD_MID          : 상점아이디
     * LGD_OID          : 주문번호
     * LGD_AMOUNT       : 금액
     * LGD_TIMESTAMP    : 타임스탬프
     *
     * MD5 해쉬데이터 암호화 검증을 위해
     * 토스페이먼츠에서 발급한 상점키(MertKey)를 환경설정 파일(lgdacom/conf/mall.conf)에 반드시 입력하여 주시기 바랍니다.
     */
     String LGD_HASHDATA = "";
     XPayClient xpay = null;
     try {
    	 
    	 xpay = new XPayClient();
    	 xpay.Init(configPath, CST_PLATFORM);
    	 
    	 if(LGD_TIMESTAMP == null || "".equals(LGD_TIMESTAMP)) {
    		 LGD_TIMESTAMP = xpay.GetTimeStamp();
    	 }
    	 LGD_HASHDATA = xpay.GetHashData(LGD_MID, LGD_OID, LGD_AMOUNT, LGD_TIMESTAMP);
    	 
     } catch(Exception e) {
    	 e.printStackTrace();
    	out.println("토스페이먼츠 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다. ");
 		out.println(""+e.getMessage());    	
 		return;
     } finally {
    	 xpay = null;
     }
    String LGD_HASHDATA = strBuf.toString();
    String LGD_CUSTOM_PROCESSTYPE = "TWOTR";
    /*
     *************************************************
     * 2. MD5 해쉬암호화 (수정하지 마세요) - END
     *************************************************
     */
	Map payReqMap = new HashMap();
     
	payReqMap.put("CST_PLATFORM"                , CST_PLATFORM);                   		// 테스트, 서비스 구분
	payReqMap.put("CST_MID"                     , CST_MID );                        	// 상점아이디
	payReqMap.put("CST_WINDOW_TYPE"             , CST_WINDOW_TYPE );                    // 결제창 호출 방식 (수정불가)
	payReqMap.put("LGD_MID"                     , LGD_MID );                        	// 상점아이디
	payReqMap.put("LGD_OID"                     , LGD_OID );                        	// 주문번호
	payReqMap.put("LGD_BUYER"                   , LGD_BUYER );                      	// 구매자
	payReqMap.put("LGD_PRODUCTINFO"             , LGD_PRODUCTINFO );                	// 상품정보
	payReqMap.put("LGD_AMOUNT"                  , LGD_AMOUNT );                     	// 결제금액
	payReqMap.put("LGD_BUYEREMAIL"              , LGD_BUYEREMAIL );                 	// 구매자 이메일
	payReqMap.put("LGD_BUYERPHONE"              , LGD_BUYERPHONE );                 	// 구매자 휴대폰
	payReqMap.put("LGD_CUSTOM_SKIN"             , LGD_CUSTOM_SKIN );                	// 결제창 SKIN
	payReqMap.put("LGD_WINDOW_VER"              , LGD_WINDOW_VER );                		// 결제창 버젼정보
	payReqMap.put("LGD_CUSTOM_PROCESSTYPE"      , LGD_CUSTOM_PROCESSTYPE );         	// 트랜잭션 처리방식
	payReqMap.put("LGD_TIMESTAMP"               , LGD_TIMESTAMP );                  	// 타임스탬프
	payReqMap.put("LGD_HASHDATA"                , LGD_HASHDATA );      	           		// MD5 해쉬암호값
	payReqMap.put("LGD_RETURNURL"   			, LGD_RETURNURL );      			   	// 응답수신페이지
	payReqMap.put("LGD_CUSTOM_USABLEPAY"  		, LGD_CUSTOM_USABLEPAY );				// 디폴트 결제수단
	payReqMap.put("LGD_CUSTOM_SWITCHINGTYPE"  	, LGD_CUSTOM_SWITCHINGTYPE );			// 신용카드 카드사 인증 페이지 연동 방식, 수정불가
	payReqMap.put("LGD_BUYERID"  				, LGD_BUYERID );						// 구매자 아이디
	payReqMap.put("LGD_BUYERIP"  				, LGD_BUYERIP );						// 구매자 IP
	payReqMap.put("LGD_DISPLAY_BUYEREMAIL"  	, LGD_DISPLAY_BUYEREMAIL );				// 구매자이메일
	
	payReqMap.put("LGD_EASYPAY_ONLY"  			, LGD_EASYPAY_ONLY );					// PAYNOW 사용
	payReqMap.put("LGD_ONEPAY_VIEW_VERSION"		, LGD_ONEPAY_VIEW_VERSION );			// PAYNOW 창 크기 설정
	
	payReqMap.put("LGD_USABLECARD"  			, LGD_USABLECARD );						// 사용을 원하는 카드사만 표시
	payReqMap.put("LGD_CASHRECEIPTYN"  			, LGD_CASHRECEIPTYN );					// 현금영수증발급 사용여부
	payReqMap.put("LGD_VERSION"         		, "JSP_Non-ActiveX_Paynow");			// 사용타입 정보(수정 및 삭제 금지): 이 정보를 근거로 어떤 서비스를 사용하는지 판단할 수 있습니다.
	payReqMap.put("LGD_DOMAIN_URL"				, "xpayvvip" );	
    payReqMap.put("LGD_ENCODING"          			, "UTF-8" );
    payReqMap.put("LGD_ENCODING_RETURNURL"         , "UTF-8" );
   
   	// 가상계좌(무통장) 결제연동을 하시는 경우  할당/입금 결과를 통보받기 위해 반드시 LGD_CASNOTEURL 정보를 토스페이먼츠에 전송해야 합니다 .

  	/*Return URL에서 인증 결과 수신 시 셋팅될 파라미터 입니다.*/
	payReqMap.put("LGD_RESPCODE"  		 , "" );
	payReqMap.put("LGD_RESPMSG"  		 , "" );
	payReqMap.put("LGD_PAYKEY"  		 , "" );
	
	session.setAttribute("PAYREQ_MAP", payReqMap);
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta http-equiv="Pragma" content="no-cache"/>
<title>LG U+ eCredit서비스 결제테스트</title>
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
	var LGD_window_type = '<%=CST_WINDOW_TYPE%>';
	
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
 function payment_return(LGD_RESPCODE, LGD_RESPMSG, LGD_PAYKEY) {
		
		var fDoc;
		
		if (LGD_window_type == "iframe") {
			fDoc = lgdwin.contentWindow || lgdwin.contentDocument;
		} else {
			fDoc = lgdwin;
		}
		
		if (fDoc.document.getElementById('LGD_RESPCODE').value == "0000") {
			if (document.getElementById("LGD_CUSTOM_PROCESSTYPE").value == "TWOTR") {
				document.getElementById("LGD_PAYKEY").value = fDoc.document.getElementById('LGD_PAYKEY').value;
				
				document.getElementById("LGD_PAYINFO").target = "_self";
				document.getElementById("LGD_PAYINFO").action = "payres.jsp"; // 고객사 payres.jsp 호출 주소로 알맞게 수정
				document.getElementById("LGD_PAYINFO").submit();
			} else {
				alert("LGD_RESPCODE (결과코드) : " + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "LGD_RESPMSG (결과메시지): " + fDoc.document.getElementById('LGD_RESPMSG').value);
				closeIframe();
			}
		} else {
			alert("LGD_RESPCODE (결과코드) : " + fDoc.document.getElementById('LGD_RESPCODE').value + "\n" + "LGD_RESPMSG (결과메시지): " + fDoc.document.getElementById('LGD_RESPMSG').value);
			closeIframe();
		}
}

</script>
</head>

<form method="post" name ="LGD_PAYINFO"  id="LGD_PAYINFO" action="payres.do">
<table>
    <tr>
        <td>구매자 이름 </td>
        <td><%= LGD_BUYER %></td>
    </tr>
    <tr>
        <td>구매자 IP </td>
        <td><%= LGD_BUYERIP %></td>
    </tr>
    <tr>
        <td>구매자 ID </td>
        <td><%= LGD_BUYERID %></td>
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
