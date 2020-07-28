<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>
<%@ page import="java.security.MessageDigest" %>

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
 	String configPath = "C:/lgdacom";  //LG유플러스에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
     
    /*
     * 1. 기본결제 인증요청 정보 변경
     *
     * 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
     */
    

    String local_ip = request.getServerName();
    String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                 //LG유플러스 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID              = request.getParameter("CST_MID");                      //LG유플러스로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
                                                                                        //상점아이디(자동생성)
    String LGD_OID              = request.getParameter("LGD_OID");                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT");                   //결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_BUYER            = request.getParameter("LGD_BUYER");                    //구매자명
    String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO");              //상품명
    String LGD_BUYEREMAIL       = request.getParameter("LGD_BUYEREMAIL");               //구매자 이메일
    String LGD_TIMESTAMP        = request.getParameter("LGD_TIMESTAMP");                //타임스탬프
    String LGD_CUSTOM_USABLEPAY = request.getParameter("LGD_CUSTOM_USABLEPAY");        	//상점정의 초기결제수단
    String LGD_CUSTOM_SKIN      = "red";                                                //상점정의 결제창 스킨(red)
    String LGD_CUSTOM_PROCESSTYPE = "TWOTR";
 
    String LGD_CUSTOM_SWITCHINGTYPE = request.getParameter("LGD_CUSTOM_SWITCHINGTYPE"); //신용카드 카드사 인증 페이지 연동 방식 (수정불가)
    String LGD_WINDOW_VER		= "2.5";												//결제창 버젼정보
    String LGD_WINDOW_TYPE      = request.getParameter("LGD_WINDOW_TYPE");              //결제창 호출 방식 (수정불가)

	String LGD_OSTYPE_CHECK     = "P";                                                  //값 P: XPay 실행(PC 결제 모듈): PC용과 모바일용 모듈은 파라미터 및 프로세스가 다르므로 PC용은 PC 웹브라우저에서 실행 필요. 
                                                                                        //"P", "M" 외의 문자(Null, "" 포함)는 모바일 또는 PC 여부를 체크하지 않음
	String LGD_ACTIVEXYN		= "N";													//계좌이체 결제시 사용, ActiveX 사용 여부로 "N" 이외의 값: ActiveX 환경에서 계좌이체 결제 진행(IE)

    /*
     * 가상계좌(무통장) 결제 연동을 하시는 경우 아래 LGD_CASNOTEURL 을 설정하여 주시기 바랍니다.
     */
    String LGD_CASNOTEURL		= "http://" + local_ip + ":8081/PG/XPayClient/cas_noteurl.do";

    /*
     * LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
     */
    String LGD_RETURNURL		= "http://" + local_ip + ":8081/PG/XPayClient/returnurl.do";
    String LGD_TAXFREEAMOUNT = request.getParameter("LGD_TAXFREEAMOUNT");
	String LGD_DIVIDE_INFO 		= "{\"divideinfo\":[{\"sub_merchantid\":\"dacomnpg\",\"amount\":\"20\",\"productinfo\":\"상품1\"},{\"sub_merchantid\":\"dacomst7\",\"amount\":\"80\",\"productinfo\":\"상품2\"}]}";  
    

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
     * LG유플러스에서 발급한 상점키(MertKey)를 환경설정 파일(lgdacom/conf/mall.conf)에 반드시 입력하여 주시기 바랍니다.
     */
   
    /* HASHDATA 확인
    StringBuffer sbuf = new StringBuffer();
     
    sbuf.append(LGD_MID);
    sbuf.append(LGD_OID);
    sbuf.append(LGD_AMOUNT);
    sbuf.append(LGD_TIMESTAMP);
    sbuf.append("116063976f7a62cd9770548377f40901");    
    
    byte[] noti = sbuf.toString().getBytes();
    MessageDigest mDigest = MessageDigest.getInstance("MD5");      
    byte[] msgStr = mDigest.digest(noti);
      
    
    StringBuffer strBuf = new StringBuffer();
	for (int i=0 ; i < msgStr.length ; i++) {
	    int c = msgStr[i] & 0xff;
	    if (c <= 15){
	        strBuf.append("0");
	    }
	    strBuf.append(Integer.toHexString(c));
	}
        
     String real_hashdata = strBuf.toString() ;
     
     System.out.println(real_hashdata);
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
    	out.println("LG유플러스 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다. ");
 		out.println(""+e.getMessage());    	
 		return;
     } finally {
    	 xpay = null;
     }
    /*
     *************************************************
     * 2. MD5 해쉬암호화 (수정하지 마세요) - END
     *************************************************
     */
      
     
  	 Map<String, Object> payReqMap = new HashMap<String, Object>();
     
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
	 payReqMap.put("LGD_ACTIVEXYN"			, LGD_ACTIVEXYN);						// 계좌이체 결제시 사용, ActiveX 사용 여부
	 payReqMap.put("LGD_VERSION"         		, "JSP_Non-ActiveX_Standard");			// 사용타입 정보(수정 및 삭제 금지): 이 정보를 근거로 어떤 서비스를 사용하는지 판단할 수 있습니다.
	 payReqMap.put("LGD_DOMAIN_URL"           , "xpayvvip");							// TLS1.2 고정버전 도메인
	 
     // 가상계좌(무통장) 결제연동을 하시는 경우  할당/입금 결과를 통보받기 위해 반드시 LGD_CASNOTEURL 정보를 LG 유플러스에 전송해야 합니다 .
     payReqMap.put("LGD_CASNOTEURL"          , LGD_CASNOTEURL );               // 가상계좌 NOTEURL
 	//payReqMap.put("LGD_CUSTOM_USABLEPAY"	, "SC0030-SC0040" );
     
     payReqMap.put("LGD_ENCODING"          			, "UTF-8" );
     payReqMap.put("LGD_ENCODING_RETURNURL"         , "UTF-8" );
     payReqMap.put("LGD_ENCODING_NOTEURL"          	, "UTF-8" );
     payReqMap.put("LGD_TAXFREEAMOUNT"				, LGD_TAXFREEAMOUNT );
 	 //payReqMap.put("LGD_DIVIDE_INFO", 				LGD_DIVIDE_INFO );			//분할정산 관련 파라미터
 	 payReqMap.put("LGD_RETURN_MERT_CUSTOM_PARAM"	, "Y");							//임의의 파라미터를 returnurl로 전달 가능
     payReqMap.put("LGD_ENCODING"          			, "UTF-8" );
     //payReqMap.put("LGD_DISABLE_AGREE"				, "Y");
     /* 신용카드 결제 파라미터 */
     
     //payReqMap.put("LGD_USABLECARD"          , "11:51" );
     payReqMap.put("LGD_INSTALLRANGE"          , "0:2:3:6:7:8:9:10:11:12" );
     payReqMap.put("LGD_NOINTINF"          , "21-3:6:7:8:9:12,51-7:8:9:12" );
     //payReqMap.put("LGD_LANGUAGE"          , "EN" );
     payReqMap.put("LGD_PRODUCTCODE"          , "rhkdqhrehddl" );
     

/* 	 payReqMap.put("LGD_SELF_CUSTOM"         , "Y" );                  
     payReqMap.put("LGD_CARDTYPE"         	 , "21" );    */
     
    /* 공통 파라미터 */
     
     //payReqMap.put("LGD_BUYERID"          , "rhkdqhrehddl" );
     //payReqMap.put("LGD_BUYERIP"          , "172.26.103.151" );
     //payReqMap.put("LGD_ESCROW_USEYN"          , "N" );
     //payReqMap.put("LGD_CLOSEDATE"          , "20200428111111" );
     //payReqMap.put("LGD_BACKBTN_YN"          , "Y" );
     
     
     
     /* 가상계좌/계좌이체 공통 파라미터*/
     //payReqMap.put("LGD_CASHRECEIPTYN"          , "Y" );
     payReqMap.put("LGD_DEFAULTCASHRECEIPTUSE", "2");
     payReqMap.put("LGD_BUYERPHONE", "01020202020");
    // payReqMap.put("LGD_AUTOCOPYYN_CASHCARDNUM", )
     
     /* 계좌이체 파라미터 */    
     //payReqMap.put("LGD_USABLEBANK"          , "" );
     
     /* 가상계좌 파라미터 */
     //payReqMap.put("LGD_USABLECASBANK"          , "003" );		(미구현)
     //payReqMap.put("LGD_CUSTOM_CASSMSMSG", "[LGD_BUYER]께서는 [LGD_FINANCENAME] [LGD_SA] (예금주:[LGD_COMPANYNAME])에 [LGD_AMOUNT]원 입금해주시면 됩니다.");
     
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
<title>통합LG유플러스 전자결서비스 결제테스트</title>
<!-- test일 경우 -->
<script language="javascript" src="https://pretest.uplus.co.kr:9443/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<script language="JavaScript" src="http://pgweb.uplus.co.kr:7085/WEB_SERVER/js/receipt_link.js"></script>
<!-- 
  service일 경우 아래 URL을 사용 
<script language="javascript" src="https://xpayvvip.uplus.co.kr/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
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
		console.dir(lgdwin);
	
		
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
    	<td>IP</td>
    	<td><%= request.getServerName() %> </td>
   </tr>
   <tr>
    	<td>OS</td>
    	<td><%= System.getProperty("os.name") %> </td>
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
	for(Iterator<?> i = payReqMap.keySet().iterator(); i.hasNext();){
		Object key = i.next();
		out.println("<input type='hidden' name='" + key + "' id='"+key+"' value='" + payReqMap.get(key) + "'>" );
	}
%>
<input type="hidden" name="aaa" id="aaa" value="aaa">
<input type="hidden" name="vvv" id="vvv" value="vvv">
</form>

</body>

</html>
