<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.security.MessageDigest, java.util.*" %>>
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
	
	/*
	* 1. 기본결제 인증요청 정보 변경
	*
	* 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
	*/
	
	
	String CST_PLATFORM                 = request.getParameter("CST_PLATFORM");                     // 토스페이먼츠 결제 서비스 선택(test:테스트, service:서비스)
    String CST_MID                      = request.getParameter("CST_MID");                          // 상점아이디(토스페이먼츠으로 부터 발급받으신 상점아이디를 입력하세요)
                                                                                                    // 테스트 아이디는 't'를 반드시 제외하고 입력하세요.
    String LGD_MID                      = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;      // 상점아이디(자동생성)
    String LGD_OID                      = request.getParameter("LGD_OID");                          // 주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_BUYER                    = request.getParameter("LGD_BUYER");                        // 구매자명
    String LGD_PRODUCTINFO              = request.getParameter("LGD_PRODUCTINFO");                  // 상품명
    String LGD_AMOUNT                   = request.getParameter("LGD_AMOUNT");                       // 결제금액("," 를 제외한 결제금액을 입력하세요)
	String LGD_BUYEREMAIL               = request.getParameter("LGD_BUYEREMAIL");                   // 구매자 이메일
    String LGD_TIMESTAMP                = request.getParameter("LGD_TIMESTAMP");                    // 타임스탬프
    String LGD_CUSTOM_SKIN              = "red";                                                    // 상점정의 결제창 스킨 (red, purple, yellow)
    String LGD_CUSTOM_USABLEPAY         = request.getParameter("LGD_CUSTOM_USABLEPAY");             // 상점정의 초기 결제 수단.
	String LGD_CUSTOM_PROCESSTYPE		= request.getParameter("LGD_CUSTOM_PROCESSTYPE");           // 결제유형
	String LGD_WINDOW_TYPE			    = request.getParameter("LGD_WINDOW_TYPE");                  // 결제창 호출 방식
    String LGD_WINDOW_VER               = "2.5";                                                    // 결제창 버젼정보
    String LGD_BUYERID                  = request.getParameter("LGD_BUYERID");                      // 구매자 아이디
    String LGD_BUYERIP                  = request.getParameter("LGD_BUYERIP");                      // 구매자IP
	String LGD_CUSTOM_SWITCHINGTYPE	    = request.getParameter("LGD_CUSTOM_SWITCHINGTYPE");         // 카드사 호출 방식 (수정불가)
	String LGD_SELF_CUSTOM			    = request.getParameter("LGD_SELF_CUSTOM");                  // 자체창 사용여부  (자체창 사용시에는 수정불가)
	String LGD_CARDTYPE				    = request.getParameter("LGD_CARDTYPE");                     // 카드사 코드
	
	String LGD_INSTALL				    = request.getParameter("LGD_INSTALL");                      // 할부개월
	String LGD_NOINT					= request.getParameter("LGD_NOINT");                        // 상점부담무이자할부 적용여부 (상점부담무이자할부 적용여부)
	String LGD_SP_CHAIN_CODE			= request.getParameter("LGD_SP_CHAIN_CODE");                // 간편결제사용여부
	String LGD_SP_ORDER_USER_ID		    = request.getParameter("LGD_SP_ORDER_USER_ID");             // 삼성카드 간편결제 쇼핑몰 ID (삼성카드 간편결제는 사전 협의된 가맹점만 사용 가능합니다)
	String LGD_POINTUSE				    = request.getParameter("LGD_POINTUSE");                     // 포인트 사용여부 (값 Y: 사용, N: 미사용)
	String LGD_RETURNURL                = request.getParameter("LGD_RETURNURL");                    // 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다.

/* 인증 이후 자동 채움 되는 필드입니다. (수정 불가)*/
	String LGD_AUTHTYPE				    = request.getParameter("LGD_AUTHTYPE");                     
	String LGD_CURRENCY				    = request.getParameter("LGD_CURRENCY");                     
	String KVP_CURRENCY				    = request.getParameter("KVP_CURRENCY");                     
	String KVP_OACERT_INF			    = request.getParameter("KVP_OACERT_INF");                  
	String KVP_RESERVED1			    = request.getParameter("KVP_RESERVED1");                 
	String KVP_RESERVED2			    = request.getParameter("KVP_RESERVED2");                    
	String KVP_RESERVED3			    = request.getParameter("KVP_RESERVED3");                    
	String KVP_GOODNAME				    = request.getParameter("KVP_GOODNAME");
	String KVP_CARDCOMPANY			    = request.getParameter("KVP_CARDCOMPANY");
	String KVP_PRICE				    = request.getParameter("KVP_PRICE");
	String KVP_PGID					    = request.getParameter("KVP_PGID");
	String KVP_QUOTA				    = request.getParameter("KVP_QUOTA");
	String KVP_NOINT				    = request.getParameter("KVP_NOINT");
	String KVP_SESSIONKEY			    = request.getParameter("KVP_SESSIONKEY");
	String KVP_ENCDATA				    = request.getParameter("KVP_ENCDATA");
	String KVP_CARDCODE				    = request.getParameter("KVP_CARDCODE");
	String KVP_CONAME				    = request.getParameter("KVP_CONAME");
	String LGD_KVPISP_USER			    = request.getParameter("LGD_KVPISP_USER");
	String LGD_PAN					    = request.getParameter("LGD_PAN");
	String VBV_ECI					    = request.getParameter("VBV_ECI");
	String VBV_CAVV					    = request.getParameter("VBV_CAVV");
	String VBV_XID					    = request.getParameter("VBV_XID");
	String VBV_JOINCODE				    = request.getParameter("VBV_JOINCODE");
	String LGD_EXPYEAR				    = request.getParameter("LGD_EXPYEAR");
	String LGD_EXPMON				    = request.getParameter("LGD_EXPMON");
	String LGD_LANGUAGE				    = request.getParameter("LGD_LANGUAGE");
	String LGD_RESPCODE                 = "";
	String LGD_RESPMSG                  = "";

	
	
   
	
	
   
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
    /*
    *************************************************
    * 2. MD5 해쉬암호화 (수정하지 마세요) - END
    *************************************************
    */
   
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>통합토스페이먼츠 전자결서비스 결제테스트</title>
<!-- test일 경우 -->
<script language="javascript" src="https://pretest.tosspayments.com:9443/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
<!-- 
  service일 경우 아래 URL을 사용 
<script language="javascript" src="https://xpayvvip.tosspayments.com/xpay/js/xpay_crossplatform.js" type="text/javascript"></script>
 -->
<script type="text/javascript">

/*
* iframe으로 결제창을 호출하시기를 원하시면 iframe으로 설정 (변수명 수정 불가)
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
		
			document.getElementById("LGD_AUTHTYPE").value = fDoc.document.getElementById('LGD_AUTHTYPE').value;
			if (document.getElementById("LGD_AUTHTYPE").value != "ISP") {
				document.getElementById("VBV_XID").value = fDoc.document.getElementById('VBV_XID').value;
				document.getElementById("VBV_ECI").value = fDoc.document.getElementById('VBV_ECI').value;
				document.getElementById("VBV_CAVV").value = fDoc.document.getElementById('VBV_CAVV').value;
				if (document.getElementById("VBV_JOINCODE") != null) {
					document.getElementById("VBV_JOINCODE").value = fDoc.document.getElementById('VBV_JOINCODE').value;
				}
				document.getElementById("LGD_PAN").value = fDoc.document.getElementById('LGD_PAN').value;
				document.getElementById("LGD_EXPYEAR").value = fDoc.document.getElementById('LGD_EXPYEAR').value;
				document.getElementById("LGD_EXPMON").value = fDoc.document.getElementById('LGD_EXPMON').value;
				document.getElementById("LGD_INSTALL").value = fDoc.document.getElementById('LGD_INSTALL').value;
				document.getElementById("LGD_NOINT").value = fDoc.document.getElementById('LGD_NOINT').value;
			} else {
				document.getElementById("KVP_QUOTA").value = fDoc.document.getElementById('KVP_QUOTA').value;
				document.getElementById("KVP_NOINT").value = fDoc.document.getElementById('KVP_NOINT').value;
				document.getElementById("KVP_CARDCODE").value = fDoc.document.getElementById('KVP_CARDCODE').value;
				document.getElementById("KVP_SESSIONKEY").value = fDoc.document.getElementById('KVP_SESSIONKEY').value;
				document.getElementById("KVP_ENCDATA").value = fDoc.document.getElementById('KVP_ENCDATA').value;
				if (fDoc.document.getElementById('LGD_KVPISP_USER') != null) {
					document.getElementById("LGD_KVPISP_USER").value = fDoc.document.getElementById('LGD_KVPISP_USER').value;
				}
			}
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
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" action="payres.jsp">
<table>
    <tr>
        <td>구매자 이름 </td>
        <td><%=request.getParameter("LGD_BUYER") %></td>
    </tr>
    <tr>
        <td>상품정보 </td>
        <td><%=request.getParameter("LGD_PRODUCTINFO") %></td>
    </tr>
    <tr>
        <td>결제금액 </td>
        <td><%=request.getParameter("LGD_AMOUNT") %></td>
    </tr>
    <tr>
        <td>구매자 이메일 </td>
        <td><%=request.getParameter("LGD_BUYEREMAIL") %></td>
    </tr>
    <tr>
        <td>주문번호 </td>
        <td><%=request.getParameter("LGD_OID") %></td>
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
<br>

	<input type="hidden" name="CST_PLATFORM"                id="CST_PLATFORM"		value="<%= CST_PLATFORM %>" />           <!-- 테스트, 서비스 구분 -->
	<input type="hidden" name="CST_MID"                     id="CST_MID"			value="<%=CST_MID %>" />                <!-- 상점아이디 -->
	<input type="hidden" name="LGD_WINDOW_TYPE"             id="LGD_WINDOW_TYPE"	value="<%=LGD_WINDOW_TYPE %>" />        <!-- 윈도우 타입 -->
	<input type="hidden" name="LGD_MID"                     id="LGD_MID"			value="<%=LGD_MID %>" />                <!-- 상점아이디 -->
	<input type="hidden" name="LGD_OID"                     id="LGD_OID"			value="<%=LGD_OID %>" />                <!-- 주문번호 -->
	<input type="hidden" name="LGD_BUYER"                   id="LGD_BUYER"			value="<%=LGD_BUYER %>" />              <!-- 구매자 -->
	<input type="hidden" name="LGD_PRODUCTINFO"             id="LGD_PRODUCTINFO"	value="<%=LGD_PRODUCTINFO %>" />        <!-- 상품정보 -->
	<input type="hidden" name="LGD_AMOUNT"                  id="LGD_AMOUNT"			value="<%=LGD_AMOUNT %>" />             <!-- 결제금액 -->
	<input type="hidden" name="LGD_BUYEREMAIL"              id="LGD_BUYEREMAIL"		value="<%=LGD_BUYEREMAIL %>" />         <!-- 구매자 이메일 -->
	<input type="hidden" name="LGD_CUSTOM_SKIN"             id="LGD_CUSTOM_SKIN"   	value="<%=LGD_CUSTOM_SKIN %>"  />       <!-- 결제창 SKIN -->
	<input type="hidden" name="LGD_WINDOW_VER"         	    id="LGD_WINDOW_VER"	    value="<%=LGD_WINDOW_VER %>"  />        <!-- 결제창버전정보 (삭제하지 마세요) -->
	<input type="hidden" name="LGD_CUSTOM_PROCESSTYPE"      id="LGD_CUSTOM_PROCESSTYPE"		value="<%=LGD_CUSTOM_PROCESSTYPE %>">	<!-- 트랜잭션 처리방식 -->
	<input type="hidden" name="LGD_TIMESTAMP"               id="LGD_TIMESTAMP"		value="<%=LGD_TIMESTAMP %>" />                  <!-- 타임스탬프 -->
	<input type="hidden" name="LGD_HASHDATA"                id="LGD_HASHDATA"		value="<%=LGD_HASHDATA %>" />                   <!-- MD5 해쉬암호값 -->
	<input type="hidden" name="LGD_PAYKEY"                  id="LGD_PAYKEY"	 />														<!-- 토스페이먼츠 PAYKEY(인증후 자동셋팅)-->
	<input type="hidden" name="LGD_VERSION"         		id="LGD_VERSION"		value="JSP_Non-ActiveX_CardApp" />				<!-- 버전정보 (삭제하지 마세요) -->
	<input type="hidden" name="LGD_BUYERIP"                 id="LGD_BUYERIP"		value="<%=LGD_BUYERIP %>" />           			<!-- 구매자IP -->
	<input type="hidden" name="LGD_BUYERID"                 id="LGD_BUYERID"		value="<%=LGD_BUYERID %>" />           			<!-- 구매자ID -->
	<input type="hidden" name="LGD_POINTUSE"				id="LGD_POINTUSE"		value="<%= LGD_POINTUSE %>"/>					<!--포인트 사용여부 -->
	<input type="hidden" name="LGD_DOMAIN_URL"              id="LGD_DOMAIN_URL"		value="xpayvvip" />   
	
	<!--LGD_RETURNURL  => 응답 수신 페이지 . -->
	<input type="hidden" name="LGD_RETURNURL"          	id="LGD_RETURNURL"		        value="<%=LGD_RETURNURL %>">				<!-- 응답 수신 페이지 -->  
	<input type="hidden" name="LGD_CUSTOM_USABLEPAY"    id="LGD_CUSTOM_USABLEPAY"		value="<%=LGD_CUSTOM_USABLEPAY %>">			<!-- 디폴트 결제수단 --> 
	<input type="hidden" name="LGD_CUSTOM_SWITCHINGTYPE" id="LGD_CUSTOM_SWITCHINGTYPE"	value="<%=LGD_CUSTOM_SWITCHINGTYPE %>">		<!-- 신용카드 카드사 인증 페이지 연동 방식 -->  
	<input type="hidden" name="LGD_RESPCODE"          	id="LGD_RESPCODE"		        value="<%=LGD_RESPCODE %>">					<!-- 응답 수신 코드 -->  
	<input type="hidden" name="LGD_RESPMSG"          	id="LGD_RESPMSG"		        value="<%=LGD_RESPMSG %>">					<!-- 응답 수신 메시지 -->
	<input type="hidden" name="LGD_SELF_CUSTOM"			id="LGD_SELF_CUSTOM"			value="<%=LGD_SELF_CUSTOM %>"/>				<!--자체창 사용여부 -->
	
	<input type="hidden" name="LGD_NOINT"				id="LGD_NOINT"					value="<%=LGD_NOINT %>"/>					<!-- 상점부담무이자할부 적용여부 -->
	<input type="hidden" name="LGD_SP_CHAIN_CODE"		id="LGD_SP_CHAIN_CODE"			value="<%= LGD_SP_CHAIN_CODE %>"/>		<!--간편결제사용여부 -->
	<input type="hidden" name="LGD_SP_ORDER_USER_ID"	id="LGD_SP_ORDER_USER_ID"		value="<%= LGD_SP_ORDER_USER_ID %>"/>   <!--삼성카드 간편결제 쇼핑몰 KEY_ID -->
	<input type="hidden" name="LGD_AUTHTYPE"			id="LGD_AUTHTYPE"				value="<%= LGD_AUTHTYPE %>"/>           <!--인증유형 -->
	<input type="hidden" name="LGD_CURRENCY"			id="LGD_CURRENCY"				value="<%= LGD_CURRENCY %>"/>           <!-- -->
	<input type="hidden" name="KVP_CURRENCY"			id="KVP_CURRENCY"				value="<%= KVP_CURRENCY %>"/>           <!--통화코드 (won) -->
	<input type="hidden" name="KVP_OACERT_INF"			id="KVP_OACERT_INF"				value="<%= KVP_OACERT_INF %>"/>			<!-- -->
	<input type="hidden" name="KVP_RESERVED1"			id="KVP_RESERVED1"				value="<%= KVP_RESERVED1 %>"/>          <!-- -->
	<input type="hidden" name="KVP_RESERVED2"			id="KVP_RESERVED2"				value="<%= KVP_RESERVED2 %>"/>          <!-- -->
	<input type="hidden" name="KVP_RESERVED3"			id="KVP_RESERVED3"				value="<%= KVP_RESERVED3 %>"/>          <!-- -->
	<input type="hidden" name="LGD_KVPISP_USER"			id="LGD_KVPISP_USER"			value="<%= LGD_KVPISP_USER %>"/>		<!--Speed ISP USER정보 -->
	<input type="hidden" name="LGD_EXPMON"				id="LGD_EXPMON"					value="<%= LGD_EXPMON %>"/>             <!--카드유효기간 (월) -->
	<%-- <input type="hidden" name="LGD_CARDTYPE"			id="LGD_CARDTYPE"				value="<%= LGD_CARDTYPE %>"/>   --%>         
	<input type="hidden" name="LGD_PAN"					id="LGD_PAN"					value="<%= LGD_PAN %>"/>                <!--신용카드번호 -->
	<input type="hidden" name="LGD_EXPYEAR"				id="LGD_EXPYEAR"				value="<%= LGD_EXPYEAR %>"/>            <!-- 카드유효기간 (년)-->
	<input type="hidden" name="LGD_INSTALL"				id="LGD_INSTALL"				value="<%= LGD_INSTALL %>"/>            <!--안심클릭 할부 개월 -->

	<input type="hidden" name="KVP_QUOTA"				id="KVP_QUOTA"			value="<%= KVP_QUOTA %>"/>                  <!--할부개월 -->
	<input type="hidden" name="KVP_NOINT"				id="KVP_NOINT"			value="<%= KVP_NOINT %>"/>                  <!--상점부담무이자할부 적용여부-->
	<input type="hidden" name="KVP_PRICE"				id="KVP_PRICE"			value="<%= KVP_PRICE %>"/>                  <!--결제금액 -->
	<input type="hidden" name="KVP_CONAME"				id="KVP_CONAME"			value="<%= KVP_CONAME %>"/>                 <!--ISP 서비스명 “안전결제서비스” -->
	<input type="hidden" name="KVP_CARDCODE"			id="KVP_CARDCODE"		value="<%= KVP_CARDCODE %>"/>           <!--ISP 카드코드 -->
	<input type="hidden" name="KVP_SESSIONKEY"			id="KVP_SESSIONKEY"		value="<%= KVP_SESSIONKEY %>"/>         <!--ISP 세션키-->
	<input type="hidden" name="KVP_CARDCOMPANY"			id="KVP_CARDCOMPANY"	value="<%= KVP_CARDCOMPANY %>"/>		<!--카드사 코드 -->
	<input type="hidden" name="KVP_ENCDATA"				id="KVP_ENCDATA"		value="<%= KVP_ENCDATA %>"/>            <!--ISP 암호화데이터  -->
	<input type="hidden" name="KVP_PGID"				id="KVP_PGID"			value="<%= KVP_PGID %>"/>               <!--PG사 ID -->
	<input type="hidden" name="KVP_GOODNAME"			id="KVP_GOODNAME"		value="<%= KVP_GOODNAME %>"/>           <!--상품명 -->
	<input type="hidden" name="VBV_CAVV"				id="VBV_CAVV"			value="<%= VBV_CAVV %>"/>                   <!--안심클릭 CAVV -->
	<input type="hidden" name="VBV_ECI"					id="VBV_ECI"			value="<%= VBV_ECI %>"/>                    <!--안심클릭 ECI  -->
	<input type="hidden" name="VBV_JOINCODE"			id="VBV_JOINCODE"		value="<%= VBV_JOINCODE %>"/>				<!--안심클릭 JOINCODE -->
	<input type="hidden" name="VBV_XID"					id="VBV_XID"			value="<%= VBV_XID %>"/>                    <!--안심클릭 XID  -->
	<input type="hidden" name="LGD_LANGUAGE"			id="LGD_LANGUAGE"		value="<%= LGD_LANGUAGE %>"/>				<!-- 결제창내 표시할 언어     -->
	<input type="hidden" name="LGD_ENCODING"					id="LGD_ENCODING"			value="UTF-8"/>                    <!--안심클릭 XID  -->
	<input type="hidden" name="LGD_ENCODING_RETURNURL"			id="LGD_ENCODING_RETURNURL"		value="UTF-8"/>
	<input type="hidden" name="LGD_ENCODING_NOTEURL"			id="LGD_ENCODING_NOTEURL"		value="UTF-8"/>
</form>

</body>

</html>
