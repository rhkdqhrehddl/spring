<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("euc-kr");

String LGD_RESPCODE = request.getParameter("LGD_RESPCODE");
String LGD_RESPMSG 	= request.getParameter("LGD_RESPMSG");

Map payReqMap = request.getParameterMap();
%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<head>
	<script type="text/javascript">

	function setLGDResult() 
	{
	<%
	if(LGD_RESPCODE.equals("0000"))
	{
		Map payReqMapSession = (HashMap)session.getAttribute("PAYREQ_MAP");
		String LGD_WINDOW_TYPE = payReqMapSession.get("LGD_WINDOW_TYPE") == null ? "" : (String) payReqMapSession.get("LGD_WINDOW_TYPE");
		//out.println("LGD_WINDOW_TYPE=["+LGD_WINDOW_TYPE+"]");
		if(LGD_WINDOW_TYPE.equals("submit"))
		{
			out.println("document.LGD_PAYINFO.action='payres.jsp';");
			out.println("document.LGD_PAYINFO.submit();");
		}
		else
		{
			out.println("parent.payment_return();");
		}
	}
	%>	
	}	
		
	</script>
</head>
<body onload="setLGDResult()">
<p><h1>RETURN_URL (인증결과)</h1></p>
<div>
<p>LGD_RESPCODE (결과코드) : <%= LGD_RESPCODE %></p>
<p>LGD_RESPMSG (결과메시지): <%= LGD_RESPMSG %></p>
	<form method="post" name="LGD_PAYINFO" id="LGD_PAYINFO">
	<%
	for (Iterator i = payReqMap.keySet().iterator(); i.hasNext();) {
		Object key = i.next();
		if (payReqMap.get(key) instanceof String[]) {
			String[] valueArr = (String[])payReqMap.get(key);
			for(int k = 0; k < valueArr.length; k++) {
				out.println("<input type='hidden' name='" + key + "' id='"+key+"'value='" + valueArr[k] + "'/>");
				System.out.println("* " + key + " = " + valueArr[k]);
			}
		} else {
			String value = payReqMap.get(key) == null ? "" : (String) payReqMap.get(key);
			out.println("<input type='hidden' name='" + key + "' id='"+key+"'value='" + value + "'/>");
		}
	}
	%>
	</form>
</body>
</html>