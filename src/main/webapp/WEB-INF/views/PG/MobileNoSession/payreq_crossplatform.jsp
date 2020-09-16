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
	
	String configPath = "C:/lgdacom";  //LG유플러스에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
    
 	if(System.getProperty("os.name").equals("Linux")){
		configPath = "/lgdacom";
 	}
	
	/*
	* 1. 기본결제 인증요청 정보 변경
	*
	* 기본정보를 변경하여 주시기 바랍니다.(파라미터 전달시 POST를 사용하세요)
	*/

	//&&&&PARAMETER EDIT START&&&&
	String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                 //토스페이먼츠 결제서비스 선택(test:테스트, service:서비스)
	String CST_MID              = request.getParameter("CST_MID");                      //토스페이먼츠로 부터 발급받으신 상점아이디를 입력하세요.
	String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
	                                                                                    //상점아이디(자동생성)
	String LGD_OID              = request.getParameter("LGD_OID");                      //주문번호(상점정의 유니크한 주문번호를 입력하세요)
	String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT");                   //결제금액("," 를 제외한 결제금액을 입력하세요)
	String LGD_BUYER            = request.getParameter("LGD_BUYER");                    //구매자명
	String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO");              //상품명
	String LGD_BUYEREMAIL       = request.getParameter("LGD_BUYEREMAIL");               //구매자 이메일
	String LGD_TIMESTAMP        = request.getParameter("LGD_TIMESTAMP");                //타임스탬프
	String LGD_CUSTOM_FIRSTPAY  = request.getParameter("LGD_CUSTOM_FIRSTPAY");          //상점정의 초기결제수단
	String LGD_PCVIEWYN			= request.getParameter("LGD_PCVIEWYN");					//페이나우 휴대폰번호 입력 화면 사용 여부(유심칩이 없는 단말기에서 입력-->유심칩이 있는 휴대폰에서 실제 결제)
	String LGD_CUSTOM_SKIN      = "SMART_XPAY2";                                        //상점정의 결제창 스킨
	String LGD_OSTYPE_CHECK		= "M";
	String LGD_CUSTOM_PROCESSTYPE = "TWOTR";
	
	//&&&&PARAMETER EDIT END&&&&
	/*
	* 가상계좌(무통장) 결제 연동을 하시는 경우 아래 LGD_CASNOTEURL 을 설정하여 주시기 바랍니다.
 	*/
	String LGD_CASNOTEURL		= "https://rhkdqhrehddl.tk/PG/MobileNoSession/cas_noteurl.do";

    /*
   	* LGD_RETURNURL 을 설정하여 주시기 바랍니다. 반드시 현재 페이지와 동일한 프로트콜 및  호스트이어야 합니다. 아래 부분을 반드시 수정하십시요.
   	*/
	String LGD_RETURNURL		= "https://rhkdqhrehddl.tk/PG/MobileNoSession/returnurl.do";// FOR MANUAL
	
	/*
	* ISP 카드결제 연동을 위한 파라미터(필수)
	*/
	String LGD_KVPMISPWAPURL		= "";
	String LGD_KVPMISPCANCELURL     = "";
		
	String LGD_MPILOTTEAPPCARDWAPURL = ""; //iOS 연동시 필수
	
	/*
	* 계좌이체 연동을 위한 파라미터(필수)
	*/
	String LGD_MTRANSFERWAPURL 		= "";
	String LGD_MTRANSFERCANCELURL 	= "";   
	   
	
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
	
	String CST_WINDOW_TYPE = "submit";			// 수정불가
	String LGD_CUSTOM_SWITCHINGTYPE = "SUBMIT"; // (수정불가)신용카드 카드사 인증 페이지 연동 방식
	
		
	/*
	****************************************************
	* 모바일 OS별 ISP(국민/비씨), 계좌이체 결제 구분 값
	****************************************************
	1) Web to Web
	- 안드로이드: A (디폴트)
	- iOS: N
	  ** iOS일 경우, 반드시 N으로 값을 수정
	2) App to Web(반드시 SmartXPay_AppToWeb_연동가이드를 참조합니다.)
	- 안드로이드, iOS: A
	*/
	String LGD_KVPMISPAUTOAPPYN		= "A";					// 신용카드 결제 사용시 필수
	String LGD_MTRANSFERAUTOAPPYN	= "A";					// 계좌이체 결제 사용시 필수
	
	
		
 %>

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

<input type="hidden" id="CST_PLATFORM"				name="CST_PLATFORM"					value="<%=CST_PLATFORM %>"/>
<input type="hidden" id="CST_MID"					name="CST_MID"						value="<%=CST_MID %>"/>
<input type="hidden" id="LGD_WINDOW_TYPE"			name="LGD_WINDOW_TYPE"				value="<%=CST_WINDOW_TYPE %>"/>
<input type="hidden" id="CST_WINDOW_TYPE"           name="CST_WINDOW_TYPE"              value="<%=CST_WINDOW_TYPE %>"/>
<input type="hidden" id="LGD_MID"					name="LGD_MID"						value="<%=LGD_MID %>"/>
<input type="hidden" id="LGD_OID"					name="LGD_OID"						value="<%=LGD_OID %>"/>
<input type="hidden" id="LGD_BUYER"					name="LGD_BUYER"					value="<%=LGD_BUYER %>"/>
<input type="hidden" id="LGD_PRODUCTINFO"			name="LGD_PRODUCTINFO"				value="<%=LGD_PRODUCTINFO %>"/>
<input type="hidden" id="LGD_AMOUNT"				name="LGD_AMOUNT"					value="<%=LGD_AMOUNT %>"/>
<input type="hidden" id="LGD_BUYEREMAIL"			name="LGD_BUYEREMAIL"				value="<%=LGD_BUYEREMAIL %>"/>
<input type="hidden" id="LGD_CUSTOM_SKIN"			name="LGD_CUSTOM_SKIN"				value="<%=LGD_CUSTOM_SKIN %>"/>
<input type="hidden" id="LGD_CUSTOM_PROCESSTYPE"	name="LGD_CUSTOM_PROCESSTYPE"		value="<%=LGD_CUSTOM_PROCESSTYPE %>"/>
<input type="hidden" id="LGD_TIMESTAMP"				name="LGD_TIMESTAMP"				value="<%=LGD_TIMESTAMP %>"/>
<input type="hidden" id="LGD_HASHDATA"				name="LGD_HASHDATA"					value="<%=LGD_HASHDATA %>"/>
<input type="hidden" id="LGD_RETURNURL"				name="LGD_RETURNURL"				value="<%=LGD_RETURNURL %>"/>
<input type="hidden" id="LGD_CUSTOM_FIRSTPAY"		name="LGD_CUSTOM_FIRSTPAY"			value="<%=LGD_CUSTOM_FIRSTPAY %>"/>
<input type="hidden" id="LGD_CUSTOM_SWITCHINGTYPE"	name="LGD_CUSTOM_SWITCHINGTYPE"		value="<%=LGD_CUSTOM_SWITCHINGTYPE %>"/>
<input type="hidden" id="LGD_OSTYPE_CHECK"			name="LGD_OSTYPE_CHECK"				value="<%=LGD_OSTYPE_CHECK %>"/>
<input type="hidden" id="LGD_VERSION"				name="LGD_VERSION"					value="JSP_Non-ActiveX_Standard"/>
<input type="hidden" id="LGD_DOMAIN_URL"			name="LGD_DOMAIN_URL"				value="xpayvvip"/>
<input type="hidden" id="LGD_CASNOTEURL"			name="LGD_CASNOTEURL"				value="<%=LGD_CASNOTEURL %>"/>
<input type="hidden" id="LGD_PCVIEWYN"				name="LGD_PCVIEWYN"					value="<%=LGD_PCVIEWYN %>"/>
<input type="hidden" id="LGD_MPILOTTEAPPCARDWAPURL"	name="LGD_MPILOTTEAPPCARDWAPURL"	value="<%=LGD_MPILOTTEAPPCARDWAPURL %>"/>

<!-- ISP(국민/BC)결제에만 적용 -->
<input type="hidden" id="LGD_KVPMISPWAPURL"			name="LGD_KVPMISPWAPURL"			value="<%=LGD_KVPMISPWAPURL %>"/>
<input type="hidden" id="LGD_KVPMISPCANCELURL"		name="LGD_KVPMISPCANCELURL"			value="<%=LGD_KVPMISPCANCELURL %>"/>

<!-- 계좌이체 결제에만 적용 -->
<input type="hidden" id="LGD_MTRANSFERWAPURL"		name="LGD_MTRANSFERWAPURL"			value="<%=LGD_MTRANSFERWAPURL %>"/>
<input type="hidden" id="LGD_MTRANSFERCANCELURL"	name="LGD_MTRANSFERCANCELURL"		value="<%=LGD_MTRANSFERCANCELURL %>"/>

<!-- 모바일 OS별 ISP(국민/BC)결제/계좌이체 결제 구분 -->
<input type="hidden" id="LGD_KVPMISPAUTOAPPYN"		name="LGD_KVPMISPAUTOAPPYN"			value="<%=LGD_KVPMISPAUTOAPPYN %>"/>
<input type="hidden" id="LGD_MTRANSFERAUTOAPPYN"	name="LGD_MTRANSFERAUTOAPPYN"		value="<%=LGD_MTRANSFERAUTOAPPYN %>"/>


<input type="hidden" id="LGD_RESPCODE"				name="LGD_RESPCODE"					value=""/>
<input type="hidden" id="LGD_RESPMSG"				name="LGD_RESPMSG"					value=""/>
<input type="hidden" id="LGD_PAYKEY"				name="LGD_PAYKEY"					value=""/>

</form>

</body>

</html>
