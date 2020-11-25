<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>

<%
	request.setCharacterEncoding("utf-8");
    /*
     * [문화상품권 인증번호 SMS 발송 페이지]
     *
     * 파라미터 전달시 POST를 사용하세요
     */
    String CST_PLATFORM         = request.getParameter("CST_PLATFORM");                 //토스페이먼츠 결제서비스 선택(test:테스트, service:서비스)
    String CST_MID              = request.getParameter("CST_MID");                      //토스페이먼츠으로 부터 발급받으신 상점아이디를 입력하세요.
    String LGD_MID              = ("test".equals(CST_PLATFORM.trim())?"t":"")+CST_MID;  //테스트 아이디는 't'를 제외하고 입력하세요.
                                                                                        //상점아이디(자동생성)
    String LGD_TID			= request.getParameter("LGD_TID");							//토스페이먼츠 거래번호
    String LGD_CULTID     	= request.getParameter("LGD_CULTID");             			//컬쳐랜드 아이디
    
    String configPath 			= "C:/lgdacom";  										//토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf") 위치 지정.
    
	if(System.getProperty("os.name").equals("Linux")){
		configPath = "/lgdacom";
 	}
    
    LGD_TID     			= ( LGD_TID == null )?"":LGD_TID; 
    LGD_CULTID       		= ( LGD_CULTID == null )?"":LGD_CULTID;
    
    XPayClient xpay = new XPayClient();
    xpay.Init(configPath, CST_PLATFORM);
    xpay.Init_TX(LGD_MID);
    xpay.Set("LGD_TXNAME", "GiftCulture");
    xpay.Set("LGD_METHOD", "SMS");
    xpay.Set("LGD_TID", LGD_TID);
    xpay.Set("LGD_CULTID", LGD_CULTID);
 
    /*
     * SMS 발송요청 결과      
     */
    if (xpay.TX()) {
        out.println("인증번호 발송요청 성공 <br>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
    }else {
        out.println("인증번호 발송요청 실패  <br>");
        out.println( "TX Response_code = " + xpay.m_szResCode + "<br>");
        out.println( "TX Response_msg = " + xpay.m_szResMsg + "<p>");
    }
    
    if ("0000".equals( xpay.m_szResCode )) {
%>    	
 		<script type="text/javascript">
			alert("인증번호 SMS 발송 성공");
		</script>
 	   	
<%  
	}
%>
