<%@ page contentType="text/html; charset=UTF-8" %>
<%
	request.setCharacterEncoding("utf-8");
    /*
     * [ 인증결과 화면페이지]
     */

    String LGD_RESPCODE                = request.getParameter("LGD_RESPCODE");			//LG유플러스 응답코드
    String LGD_RESPMSG                 = request.getParameter("LGD_RESPMSG");			//LG유플러스 응답메세지

	String LGD_BILLKEY                 = request.getParameter("LGD_BILLKEY");			//LG유플러스 빌링키
        
    if (("0000".equals(LGD_RESPCODE))) { 	//인증성공시
    	out.println("* SmartXpay-Billing (화면)결과리턴페이지 예제입니다." + "<p>");

    	out.println("결과코드 : " + LGD_RESPCODE + "<br>");
    	out.println("결과메세지 : " + LGD_RESPMSG + "<br>");
    	out.println("빌링키 : " + LGD_BILLKEY + "<br>");
	}
%>
