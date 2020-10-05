<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>result</title>
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
			default:
				out.println("\t 결제실패 <br>");
				break;
		}
		out.println("\t error MSG = " + request.getAttribute("err_msg").toString() + "<br>");
	%>
</body>
</html>