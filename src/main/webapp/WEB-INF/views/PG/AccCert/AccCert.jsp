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
	 * [본인인증 요청 페이지]
	 *
	 * 파라미터 전달시 POST를 사용하세요.
	 */

    String CST_PLATFORM        = nvl(request.getParameter("CST_PLATFORM"));     	//LG유플러스 결제 서비스 선택(test:테스트, service:서비스)
    String CST_MID             = nvl(request.getParameter("CST_MID"));           	//상점아이디(LG유플러스으로 부터 발급받으신 상점아이디를 입력하세요)
    String LGD_MID             = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
	 																				//상점아이디(자동생성)    
    String LGD_GUBUN           = nvl(request.getParameter("LGD_GUBUN"));           	//거래구분    
    String LGD_BANKCODE        = nvl(request.getParameter("LGD_BANKCODE"));       	//은행코드
    String LGD_ACCOUNTNO       = nvl(request.getParameter("LGD_ACCOUNTNO"));      	//계좌번호    
    String LGD_NAME  		   = nvl(request.getParameter("LGD_NAME"));   			//성명
    String LGD_PRIVATENO       = nvl(request.getParameter("LGD_PRIVATENO"));     	//생년월일 6자리 (YYMMDD) or 사업자번호 10자리
    String LGD_BUYERIP		   = request.getRemoteAddr();
    
    String configPath		   = "C:/lgdacom";						 				//LG유플러스에서 제공한 환경파일(/conf/lgdacom.conf, /conf/mall.conf)이 위치한 디렉토리 지정 

    if(System.getProperty("os.name").equals("Linux")){
		configPath = "/lgdacom";
 	}
    
    XPayClient xpay = new XPayClient();
   	boolean isInitOK = xpay.Init(configPath, CST_PLATFORM);
   	
    if( !isInitOK ) {
    	//API 초기화 실패 화면처리
        out.println( "인증요청을 초기화 하는데 실패하였습니다.<br>");
        out.println( "LG유플러스에서 제공한 환경파일이 정상적으로 설치 되었는지 확인하시기 바랍니다.<br>");        
        out.println( "mall.conf에는 Mert ID = Mert Key 가 반드시 등록되어 있어야 합니다.<br><br>");
        out.println( "문의전화 LG유플러스 1544-7772<br>");
        return;
    }        	
    
   	xpay.Init_TX(LGD_MID);
   
   	//xpay.Log("인증요청을 시작합니다.");

    xpay.Set("LGD_TXNAME", "AccCert");
	xpay.Set("LGD_GUBUN", LGD_GUBUN);
	xpay.Set("LGD_BANKCODE", LGD_BANKCODE); 
	xpay.Set("LGD_ACCOUNTNO", LGD_ACCOUNTNO);
	xpay.Set("LGD_NAME", LGD_NAME);
	xpay.Set("LGD_PRIVATENO", LGD_PRIVATENO);
	xpay.Set("LGD_BUYERIP", LGD_BUYERIP);
	xpay.Set("LGD_CHECKNHYN", "Y");
	
    if ( xpay.TX() ) {
        //1)인증결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
        out.println( "인증요청이 완료되었습니다.  <br>");
        out.println( "TX 인증요청 Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX 인증요청 Response_msg = " + xpay.m_szResMsg + "<p>");
        
        //아래는 인증 결과 파라미터를 모두 찍어 줍니다.
        for (int i = 0; i < xpay.ResponseNameCount(); i++)
        {
            out.println(xpay.ResponseName(i) + " = ");
            for (int j = 0; j < xpay.ResponseCount(); j++)
            {
                out.println("\t" + xpay.Response(xpay.ResponseName(i), j) + "<br>");
            }
        }
        out.println("<p>");
        
    }else {
        //2)API 요청실패 화면처리
        out.println( "인증요청이 실패하였습니다.  <br>");
        out.println( "TX 인증요청 Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX 인증요청 Response_msg = " + xpay.m_szResMsg + "<p>");
        
    	//인증요청 결과 실패 DB처리
    	out.println("인증요청 결과 실패 DB처리하시기 바랍니다.<br>");            	            
    }   
    //xpay.Log("인증요청을 종료합니다.");
%>
 
