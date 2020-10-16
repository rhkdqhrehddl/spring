<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("utf-8");

String LGD_RESPCODE = request.getParameter("LGD_RESPCODE");
String LGD_RESPMSG 	= request.getParameter("LGD_RESPMSG");
String LGD_PAYKEY 	= request.getParameter("LGD_PAYKEY");


%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<head>
	<script type="text/javascript">

		function setLGDResult() {
			parent.payment_return();
			try {
			} catch (e) {
				alert(e.message);
			}
		}
		
	</script>
</head>
<body onload="setLGDResult()">
<p><h1>RETURN_URL (인증결과)</h1></p>
<div>
<p>LGD_RESPCODE (결과코드) : <%= LGD_RESPCODE %></p>
<p>LGD_RESPMSG (결과메시지): <%= LGD_RESPMSG %></p>

<form method="post" name="LGD_RETURNINFO" id="LGD_RETURNINFO">
	
	<input type="hidden" id="LGD_RESPCODE"	name="LGD_RESPCODE"	value="<%= LGD_RESPCODE %>"/>
	<input type="hidden" id="LGD_RESPMSG"	name="LGD_RESPMSG"	value="<%= LGD_RESPMSG %>"/>
	<input type="hidden" id="LGD_PAYKEY"	name="LGD_PAYKEY"	value="<%= LGD_PAYKEY %>"/>	
	
</form>
</body>
</html>