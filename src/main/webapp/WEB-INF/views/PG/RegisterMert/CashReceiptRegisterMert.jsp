<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>

<%
	request.setCharacterEncoding("utf-8");
    /*
     * [현금영수증 사용 가맹 등록/조회 요청 페이지]
     *
     */
    String CST_PLATFORM           = request.getParameter("CST_PLATFORM");                 	//토스페이먼츠 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID                = request.getParameter("CST_MID");                      	//토스페이먼츠으로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID                = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  	//테스트 아이디는 't'를 제외하고 입력하세요.
                                                                                          	//상점아이디(자동생성)
    String LGD_METHOD   		  = request.getParameter("LGD_METHOD");						//메소드('REG_REQUEST':등록요청, 'REG_RESULT' 등록결과확인)
    String LGD_REG_BUSINESSNUM    = request.getParameter("LGD_REG_BUSINESSNUM");			//현금영수증 가맹 사업자 등록번호
    String LGD_REG_MERTNAME       = request.getParameter("LGD_REG_MERTNAME");				//현금영수증 가맹 사업자명
    String LGD_REG_MERTPHONE      = request.getParameter("LGD_REG_MERTPHONE");				//현금영수증 가맹 사업자 전화번호
    String LGD_REG_CEONAME 		  = request.getParameter("LGD_REG_CEONAME");				//현금영수증 가맹 사업자 대표자명
    String LGD_REG_MERTADDRESS	  = request.getParameter("LGD_REG_MERTADDRESS");			//현금영수증 가맹 사업장주소

    String configPath 			  = "C:/lgdacom";  										    //토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf") 위치 지정.
        
    if(System.getProperty("os.name").equals("Linux")){
		configPath = "/lgdacom";
 	}
    
    LGD_METHOD       		= ( LGD_METHOD == null )?"":LGD_METHOD;
    LGD_REG_BUSINESSNUM		= ( LGD_REG_BUSINESSNUM == null )?"":LGD_REG_BUSINESSNUM;
    LGD_REG_MERTNAME		= ( LGD_REG_MERTNAME == null )?"":LGD_REG_MERTNAME;
    LGD_REG_MERTPHONE		= ( LGD_REG_MERTPHONE == null )?"":LGD_REG_MERTPHONE;
    LGD_REG_CEONAME			= ( LGD_REG_CEONAME == null )?"":LGD_REG_CEONAME;
    LGD_REG_MERTADDRESS		= ( LGD_REG_MERTADDRESS == null )?"":LGD_REG_MERTADDRESS;
    
    XPayClient xpay = new XPayClient();
    xpay.Init(configPath, CST_PLATFORM);
    xpay.Init_TX(LGD_MID);
    xpay.Set("LGD_TXNAME", "CashReceipt");
    xpay.Set("LGD_METHOD", LGD_METHOD);
    xpay.Set("LGD_ENCODING", "UTF-8");
  
   	xpay.Set("LGD_REG_BUSINESSNUM", LGD_REG_BUSINESSNUM);
    xpay.Set("LGD_REG_MERTNAME", LGD_REG_MERTNAME);
    xpay.Set("LGD_REG_MERTPHONE", LGD_REG_MERTPHONE);
    xpay.Set("LGD_REG_CEONAME", LGD_REG_CEONAME);
    xpay.Set("LGD_REG_MERTADDRESS", LGD_REG_MERTADDRESS);
    
    /*
     * 1. 현금영수증 사용 가맹 등록/조회 요청 결과처리
     *
     * 결과 리턴 파라미터는 연동메뉴얼을 참고하시기 바랍니다.
     */
    if (xpay.TX()) {
        //1)현금영수증 사용 가맹 등록/조회 확인  화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
        out.println("현금영수증 가맹 사업자 등록요청/결과확인 요청처리가 완료되었습니다.  <br>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
        
        out.println("결과코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
        out.println("결과메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<br>");
        out.println("사업자 번호: " + xpay.Response("LGD_REG_BUSINESSNUM",0) + "<br>");
        out.println("사업자명 : " + xpay.Response("LGD_REG_MERTNAME",0) + "<br>");
        out.println("사업자전화번호 : " + xpay.Response("LGD_REG_MERTPHONE",0) + "<br>");
        out.println("대표자명 : " + xpay.Response("LGD_REG_CEONAME",0) + "<br>");
        out.println("사업장 주소: " + xpay.Response("LGD_REG_MERTADDRESS",0) + "<br>");
        out.println("등록요청일자 : " + xpay.Response("LGD_REG_REQDATE",0) + "<p>");
               
    }else {
        //2)API 요청 실패 화면처리
        out.println("현금영수증 가맹 사업자 등록요청/결과확인 요청처리가 실패되었습니다.  <br>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
    }
%>
