<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>결제 실패 페이지</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
		
		int requestFlag = Integer.parseInt(request.getAttribute("requestFlag").toString());
		
		switch(requestFlag){
			case 1:
				out.println("\t 결제실패 <br>");
				break;
			case 2:
				out.println("\t 취소실패 <br>");
				break;
			case 3:
				out.println("\t 조회실패 <br>");
				break;
			case 4:
				out.println("\t 빌링키 발급실패 <br>");
				break;
			case 5:
				out.println("\t 빌링결제실패 <br>");
				break;
			default:
				out.println("\t 결제실패 <br>");
				break;
		}
		out.println("\t error MSG = " + request.getAttribute("err_msg").toString() + "<br>");
	%>
</body>
</html>