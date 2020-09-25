<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>result</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
	
		if(request.getAttribute("resp_code").toString().equals("200")){
			out.println("\t 결제성공 <br>");	
			
			Map resultMap = (Map)request.getAttribute("result");
			for (Iterator i = resultMap.keySet().iterator(); i.hasNext();) {
				Object key = i.next();
				out.println("\t" + key + " = " + resultMap.get(key) + "<br>");
			}
		} else {
			out.println("\t 결제실패 <br>");
			out.println("\t response code = " + request.getAttribute("resp_code").toString() + "<br>");
			out.println("\t error MSG = " + request.getAttribute("err_msg").toString() + "<br>");
		}
	%>
</body>
</html>