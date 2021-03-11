<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>

<%! 
	/**
	 * Null 문자 체크
	 * @param str
	 * @return
	 */
	public static String nvl(String str) {
		return nvl(str, "");
	}

	/**
	 * Null 문자 체크
	 * @param str
	 * @param replacer
	 * @return
	 */
	public static String nvl(String str, String replacer) {
		if (str == null || "".equals(str))
			return replacer;
		else
			return str;
	}
%>	

<%
	request.setCharacterEncoding("utf-8");
	/*
	 * [결제승인 요청 페이지]
	 *
	 * 파라미터 전달시 POST를 사용하세요.
	 */

    String CST_PLATFORM        = nvl(request.getParameter("CST_PLATFORM"));     		//토스페이먼츠 결제 서비스 선택(test:테스트, service:서비스)
    String CST_MID             = nvl(request.getParameter("CST_MID"));           		//상점아이디(토스페이먼츠으로 부터 발급받으신 상점아이디를 입력하세요) 테스트 아이디는 't'를 제외하고 입력하세요.
    String LGD_MID             = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  	//상점아이디(자동생성)    
    String LGD_OID             = nvl(request.getParameter("LGD_OID"));           		//주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT          = nvl(request.getParameter("LGD_AMOUNT"));        		//결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_BUYER     	   = nvl(request.getParameter("LGD_BUYER"));				//구매자명
    String LGD_BUYEREMAIL      = nvl(request.getParameter("LGD_BUYEREMAIL"));			//구매자 이메일
    String LGD_PRODUCTINFO     = nvl(request.getParameter("LGD_PRODUCTINFO"));			//상품명
    String LGD_AUTHTYPE        = nvl(request.getParameter("LGD_AUTHTYPE"));        		//인증유형(ISP인경우만  'ISP')
    String LGD_CARDTYPE        = nvl(request.getParameter("LGD_CARDTYPE"));        		//카드사코드
    String LGD_CURRENCY        = nvl(request.getParameter("LGD_CURRENCY"));        		//통화코드
	String LGD_POINTUSE        = nvl(request.getParameter("LGD_POINTUSE"));        		//카드사 포인트 사용여부
    
    //안심클릭 또는 해외카드
    String LGD_PAN				= nvl(request.getParameter("LGD_PAN"));           	//카드번호    
    String LGD_INSTALL			= nvl(request.getParameter("LGD_INSTALL"));       	//할부개월수
    String LGD_NOINT			= nvl(request.getParameter("LGD_NOINT"));        	//무이자할부여부('1':상점부담무이자할부,'0':일반할부)    
    String LGD_EXPYEAR			= nvl(request.getParameter("LGD_EXPYEAR"));       	//유효기간년(YY)
    String LGD_EXPMON          	= nvl(request.getParameter("LGD_EXPMON"));        	//유효기간월 (MM)
    String VBV_ECI				= nvl(request.getParameter("VBV_ECI"));    			//안심클릭ECI
    String VBV_CAVV				= nvl(request.getParameter("VBV_CAVV"));    		//안심클릭CAVV
    String VBV_XID				= nvl(request.getParameter("VBV_XID"));    			//안심클릭XID
    String VBV_JOINCODE			= nvl(request.getParameter("VBV_JOINCODE"));    	//안심클릭JOINCODE
    
    
    //ISP
	String KVP_QUOTA			= nvl(request.getParameter("KVP_QUOTA"));			//할부개월수
	String KVP_NOINT			= nvl(request.getParameter("KVP_NOINT"));			//무이자할부여부('1':상점부담무이자할부,'0':일반할부)
	String KVP_CARDCODE			= nvl(request.getParameter("KVP_CARDCODE"));		//ISP카드코드
	String KVP_SESSIONKEY		= nvl(request.getParameter("KVP_SESSIONKEY"));		//ISP세션키
	String KVP_ENCDATA			= nvl(request.getParameter("KVP_ENCDATA"))	;	 	//ISP암호화데이터

	
	String configPath		   = "C:/lgdacom";						 				//토스페이먼츠에서 제공한 환경파일(/conf/lgdacom.conf, /conf/mall.conf)이 위치한 디렉토리 지정 

    XPayClient xpay = new XPayClient();
   	boolean isInitOK = xpay.Init(configPath, CST_PLATFORM);
   	
    if( !isInitOK ) {
    	//API 초기화 실패 화면처리
        out.println( "결제요청을 초기화 하는데 실패하였습니다.<br>");
        out.println( "토스페이먼츠에서 제공한 환경파일이 정상적으로 설치 되었는지 확인하시기 바랍니다.<br>");        
        out.println( "mall.conf에는 Mert ID = Mert Key 가 반드시 등록되어 있어야 합니다.<br><br>");
        out.println( "문의전화 토스페이먼츠 1544-7772<br>");
        return;
    }        	
    
   	xpay.Init_TX(LGD_MID);
   	

    xpay.Set("LGD_TXNAME", "CardAuth");
    xpay.Set("LGD_OID", LGD_OID );
	xpay.Set("LGD_AMOUNT", LGD_AMOUNT);
	xpay.Set("LGD_BUYER", LGD_BUYER);
	xpay.Set("LGD_PRODUCTINFO", LGD_PRODUCTINFO);
	xpay.Set("LGD_BUYEREMAIL", LGD_BUYEREMAIL);
	xpay.Set("LGD_BUYERIP", request.getRemoteAddr());
	xpay.Set("LGD_AUTHTYPE", LGD_AUTHTYPE);
	xpay.Set("LGD_CARDTYPE", LGD_CARDTYPE);
	xpay.Set("LGD_CURRENCY", LGD_CURRENCY);
	xpay.Set("LGD_POINTUSE", LGD_POINTUSE);
	xpay.Set("LGD_ENCODING", "UTF-8");
	
	if (LGD_AUTHTYPE.equals("ISP")){
		xpay.Set("KVP_QUOTA", KVP_QUOTA);
		xpay.Set("KVP_NOINT", KVP_NOINT);
		xpay.Set("KVP_CARDCODE", KVP_CARDCODE);
		xpay.Set("KVP_SESSIONKEY", KVP_SESSIONKEY);
		xpay.Set("KVP_ENCDATA", KVP_ENCDATA);
	} else {
		xpay.Set("LGD_PAN", LGD_PAN);
		xpay.Set("LGD_INSTALL", LGD_INSTALL);
		xpay.Set("LGD_NOINT", LGD_NOINT);
		xpay.Set("LGD_EXPYEAR", LGD_EXPYEAR);
		xpay.Set("LGD_EXPMON", LGD_EXPMON);
		xpay.Set("VBV_ECI", VBV_ECI);
		xpay.Set("VBV_CAVV", VBV_CAVV);
		xpay.Set("VBV_XID", VBV_XID);
		xpay.Set("VBV_JOINCODE", VBV_JOINCODE);
	}

    if ( xpay.TX() ) {
        //1)결제결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
        out.println( "결제요청이 완료되었습니다.  <br>");
        out.println( "TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
        
        out.println("거래번호 : " + xpay.Response("LGD_TID", 0) + "<br>");
        out.println("상점아이디 : " + xpay.Response("LGD_MID", 0) + "<br>");
        out.println("상점주문번호 : " + xpay.Response("LGD_OID", 0) + "<br>");
        out.println("결제금액 : " + xpay.Response("LGD_AMOUNT", 0) + "<br>");
        out.println("결과코드 : " + xpay.Response("LGD_RESPCODE", 0) + "<br>");
        out.println("결과메세지 : " + xpay.Response("LGD_RESPMSG", 0) + "<p>");
        
        //아래는 결제요청 결과 파라미터를 모두 찍어 줍니다.
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
        	//최종결제요청 결과 성공 DB처리
        	out.println("최종결제요청 결과 성공 DB처리하시기 바랍니다.<br>");
        	            	
        	//최종결제요청 결과 성공 DB처리 실패시 Rollback 처리
        	boolean isDBOK = true; //DB처리 실패시 false로 변경해 주세요.
        	if( !isDBOK ) {
        		xpay.Rollback("상점 DB처리 실패로 인하여 Rollback 처리 [TID:" +xpay.Response("LGD_TID",0)+",MID:" + xpay.Response("LGD_MID",0)+",OID:"+xpay.Response("LGD_OID",0)+"]");
        		
                out.println( "TX Rollback Response_code = " + xpay.Response("LGD_RESPCODE",0) + "<br>");
                out.println( "TX Rollback Response_msg = " + xpay.Response("LGD_RESPMSG",0) + "<p>");
        		
                if( "0000".equals( xpay.m_szResCode ) ) {
                	out.println("자동취소가 정상적으로 완료 되었습니다.<br>");
                }else{
        			out.println("자동취소가 정상적으로 처리되지 않았습니다.<br>");
                }
        	}
        	
        }else{
        	//최종결제요청 결과 실패 DB처리
        	out.println("최종결제요청 결과 실패 DB처리하시기 바랍니다.<br>");            	
        }
    }else {
        //2)API 요청실패 화면처리
        out.println( "결제요청이 실패하였습니다.  <br>");
        out.println( "TX 결제요청 Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX 결제요청 Response_msg = " + xpay.m_szResMsg + "<p>");
        
    	//최종결제요청 결과 실패 DB처리
    	out.println("최종결제요청 결과 실패 DB처리하시기 바랍니다.<br>");            	            
    }   
    
%>
 
