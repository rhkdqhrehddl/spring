<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>결제 성공 페이지</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
			
		out.println("\t response code = " + request.getParameter("code").toString() + "<br>");
		out.println("\t error MSG = " + request.getParameter("message").toString() + "<br>");	
	%>
</body>
</html>