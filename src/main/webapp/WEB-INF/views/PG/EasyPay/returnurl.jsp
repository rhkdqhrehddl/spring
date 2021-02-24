<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("utf-8");

String LGD_RESPCODE = request.getParameter("LGD_RESPCODE");
String LGD_RESPMSG 	= request.getParameter("LGD_RESPMSG");
String LGD_PAYKEY	= request.getParameter("LGD_PAYKEY");
%>
<html>
<head>
<script type="text/javascript">
	function setLGDResult() {
		
		parent.payment_return();
		try {
		} catch (e) {
			alert(e.message);
		}
		
		/* 			
		try {
			var RESP = document.getElementById("LGD_RESPCODE");
			var MSG = document.getElementById("LGD_RESPMSG");
			var LGD_PAYKEY = document.getElementById("LGD_PAYKEY");

			opener.payment_return(RESP.value, MSG.value, LGD_PAYKEY.value);
		} catch (e) {
			alert(e.message);
		}
		window.close();
		
		 */
		
	}
	
</script>
</head>
<body onload="setLGDResult()">
	<form method="post" name="LGD_RETURNINFO" id="LGD_RETURNINFO">
		<input type="hidden" id="LGD_RESPCODE" name="LGD_RESPCODE" value="<%=LGD_RESPCODE %>" />
		<input type="hidden" id="LGD_RESPMSG" name="LGD_RESPMSG" value="<%=LGD_RESPMSG %>" />
		<input type="hidden" id="LGD_PAYKEY" name="LGD_PAYKEY" value="<%=LGD_PAYKEY %>" />
	</form>
</body>
</html>