<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
	/*
	 * [결제승인 요청 페이지]
	 *
	 * 파라미터 전달시 POST를 사용하세요.
	 */
	request.setCharacterEncoding("utf-8");

    String CST_PLATFORM        = nvl(request.getParameter("CST_PLATFORM"));     	//LG유플러스 결제 서비스 선택(test:테스트, service:서비스)
    String CST_MID             = nvl(request.getParameter("CST_MID"));           	//상점아이디(LG유플러스으로 부터 발급받으신 상점아이디를 입력하세요)
    String LGD_MID             = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
    																				//상점아이디(자동생성)    
    String LGD_OID             = nvl(request.getParameter("LGD_OID"));           	//주문번호(상점정의 유니크한 주문번호를 입력하세요)
    String LGD_AMOUNT          = nvl(request.getParameter("LGD_AMOUNT"));        	//결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_PAN             = nvl(request.getParameter("LGD_PAN"));           	//카드번호
  																					//Swipe 방식의 경우 track data 입력하세요. 예)4902000000000000=12000011856549300000
    String LGD_INSTALL         = nvl(request.getParameter("LGD_INSTALL"));       	//할부개월수
    String LGD_EXPYEAR         = nvl(request.getParameter("LGD_EXPYEAR"));       	//유효기간년
    String LGD_EXPMON          = nvl(request.getParameter("LGD_EXPMON"));        	//유효기간월    
    String LGD_PIN             = nvl(request.getParameter("LGD_PIN"));        		//비밀번호 앞2자리(옵션-주민번호를 넘기지 않으면 비밀번호도 체크 안함)
    String LGD_PRIVATENO       = nvl(request.getParameter("LGD_PRIVATENO"));     	//생년월일 6자리 (YYMMDD) or 사업자번호(옵션)
    String LGD_BUYERPHONE      = nvl(request.getParameter("LGD_BUYERPHONE"));    	//고객 휴대폰번호(SMS발송:선택) 
    String VBV_ECI      	   = nvl(request.getParameter("VBV_ECI"));    			//결제방식(KeyIn:010, Swipe:020)
    String LGD_BUYER     	   = nvl(request.getParameter("LGD_BUYER"));			//구매자
    String LGD_BUYERID     	   = nvl(request.getParameter("LGD_BUYERID"));			//구매자ID
    String LGD_PRODUCTINFO     = nvl(request.getParameter("LGD_PRODUCTINFO"));		//상품명
    
    String configPath		   = "C:/lgdacom";						 				//LG유플러스에서 제공한 환경파일(/conf/lgdacom.conf, /conf/mall.conf)이 위치한 디렉토리 지정 
    
    if(System.getProperty("os.name").equals("Linux")){
 		configPath = "/lgdacom";
  	 }

    XPayClient xpay = new XPayClient();
   	boolean isInitOK = xpay.Init(configPath, CST_PLATFORM);
   	
    if( !isInitOK ) {
    	//API 초기화 실패 화면처리
        out.println( "결제요청을 초기화 하는데 실패하였습니다.<br>");
        out.println( "LG유플러스에서 제공한 환경파일이 정상적으로 설치 되었는지 확인하시기 바랍니다.<br>");        
        out.println( "mall.conf에는 Mert ID = Mert Key 가 반드시 등록되어 있어야 합니다.<br><br>");
        out.println( "문의전화 LG유플러스 1544-7772<br>");
        return;
    }        	
    
   	xpay.Init_TX(LGD_MID);
   	
    xpay.Set("LGD_TXNAME", "CardAuth");
    xpay.Set("LGD_OID", LGD_OID );
	xpay.Set("LGD_AMOUNT", LGD_AMOUNT);
	xpay.Set("LGD_PAN", LGD_PAN);
	xpay.Set("LGD_INSTALL", LGD_INSTALL);
	xpay.Set("VBV_ECI", VBV_ECI);
	xpay.Set("LGD_BUYERPHONE", LGD_BUYERPHONE);
	xpay.Set("LGD_BUYER", LGD_BUYER);
	xpay.Set("LGD_BUYERID", LGD_BUYERID);
	xpay.Set("LGD_BUYERIP", request.getRemoteAddr());
	xpay.Set("LGD_PRODUCTINFO", LGD_PRODUCTINFO);
	xpay.Set("LGD_ENCODING", "UTF-8");
	
	
	//xpay.Set("LGD_BUYERADDRESS", "LGD_BUYERADDRESS");
	//xpay.Set("LGD_DELIVERYINFO", "LGD_DELIVERYINFO");
	//xpay.Set("LGD_RECEIVER", "LGD_RECEIVER");
	
	if( VBV_ECI.equals("010") || VBV_ECI.equals("030") ){ //키인방식인 경우에만 해당
		xpay.Set("LGD_EXPYEAR", LGD_EXPYEAR); 
		xpay.Set("LGD_EXPMON", LGD_EXPMON);
		xpay.Set("LGD_PIN", LGD_PIN);
		xpay.Set("LGD_PRIVATENO", LGD_PRIVATENO);
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
 
