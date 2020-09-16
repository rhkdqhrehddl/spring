<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<html>
<head>
	<script type="text/javascript">
		function setLGDResult() {
			document.getElementById('LGD_PAYINFO').submit();
		}
		
	</script>
</head>
<body onload="setLGDResult()">
<% 
request.setCharacterEncoding("utf-8");
String LGD_RESPCODE = request.getParameter("LGD_RESPCODE");
String LGD_RESPMSG 	= request.getParameter("LGD_RESPMSG");
String LGD_PAYKEY	= "";

if("0000".equals(LGD_RESPCODE)){
	LGD_PAYKEY = request.getParameter("LGD_PAYKEY");


%>
<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO" action="payres.do">
	
	<input type="hidden" id="LGD_RESPCODE"	name="LGD_RESPCODE"	value="<%= LGD_RESPCODE %>"/>
	<input type="hidden" id="LGD_RESPMSG"	name="LGD_RESPMSG"	value="<%= LGD_RESPMSG %>"/>
	<input type="hidden" id="LGD_PAYKEY"	name="LGD_PAYKEY"	value="<%= LGD_PAYKEY %>"/>	

</form>
<%
}
else{
	out.println("LGD_RESPCODE:" + LGD_RESPCODE + " ,LGD_RESPMSG:" + LGD_RESPMSG); //인증 실패에 대한 처리 로직 추가
}
%>
</body>
</html>