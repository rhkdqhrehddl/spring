<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lgdacom.XPayClient.XPayClient"%>

<%
    String configPath = "C:/lgdacom";  //토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf") 위치 지정.
    
    if(System.getProperty("os.name").equals("Linux")){
		configPath = "/lgdacom";
 	}
    
    request.setCharacterEncoding("UTF-8");
    String CST_PLATFORM                 = request.getParameter("CST_PLATFORM");	//토스페이먼츠 결제 서비스 선택(test:테스트, service:서비스)
    String LGD_MID                      = request.getParameter("LGD_MID");		//상점아이디(토스페이먼츠으로 부터 발급받으신 상점아이디를 입력하세요)
	String LGD_TID                  	= request.getParameter("LGD_TID");		//토스페이먼츠 거래번호
    String LGD_AMOUNT                  	= request.getParameter("LGD_AMOUNT");	//결제금액("," 를 제외한 결제금액을 입력하세요)
    String LGD_CULTPIN                  = request.getParameter("LGD_CULTPIN");	//문화상품권번호	
    String LGD_METHOD					= "APP";								//메소드 (승인요청)
    
    XPayClient xpay = new XPayClient();
   	xpay.Init(configPath, CST_PLATFORM);

    try{
	    xpay.Init_TX(LGD_MID);
	    xpay.Set("LGD_TXNAME", "GiftCulture");
	    xpay.Set("LGD_METHOD", LGD_METHOD);
		xpay.Set("LGD_TID", LGD_TID);
	    xpay.Set("LGD_AMOUNT", LGD_AMOUNT);
	    xpay.Set("LGD_CULTPIN", LGD_CULTPIN);
		xpay.Set("LGD_ENCODING", "UTF-8");
	    
    }catch(Exception e) {
    	out.println("토스페이먼츠 제공 API를 사용할 수 없습니다. 환경파일 설정을 확인해 주시기 바랍니다. ");
    	out.println(""+e.getMessage());    	
    	return;
    }
    
    if ( xpay.TX() ) {
        //1)결제결과 화면처리(성공,실패 결과 처리를 하시기 바랍니다.)
        out.println( "결제요청이  완료되었습니다.  <br>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
        
        out.println("결과코드 : " + xpay.Response("LGD_RESPCODE",0) + "<br>");
        out.println("결과메세지 : " + xpay.Response("LGD_RESPMSG",0) + "<br>");
        
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
        	out.println("결제가  성공하였습니다.<br/>"); 
        }else{
        	//최종결제요청 결과 실패 DB처리
        	out.println("결제가  실패하였습니다.<br/>");            	
        }
    }else {
        //2)API 요청실패 화면처리
        out.println( "결제가  실패하였습니다.<br/>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br/>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
    }
%>