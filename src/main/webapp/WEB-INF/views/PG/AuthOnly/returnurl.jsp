<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("utf-8");

String LGD_RESPCODE = request.getParameter("LGD_RESPCODE");
String LGD_RESPMSG 	= request.getParameter("LGD_RESPMSG");

HashMap payReqMap = (HashMap)session.getAttribute("PAYREQ_MAP");//결제 요청시, Session에 저장했던 파라미터 MAP 
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

<% 
String LGD_AUTHONLYKEY	= "";
String LGD_PAYTYPE 	= request.getParameter("LGD_PAYTYPE");

LGD_AUTHONLYKEY = request.getParameter("LGD_AUTHONLYKEY");
payReqMap.put("LGD_RESPCODE"	, LGD_RESPCODE);
payReqMap.put("LGD_RESPMSG"		, LGD_RESPMSG);
payReqMap.put("LGD_AUTHONLYKEY"	, LGD_AUTHONLYKEY);
payReqMap.put("LGD_PAYTYPE"		, LGD_PAYTYPE);

%><form method="post" name="LGD_RETURNINFO" id="LGD_RETURNINFO"><%		
	for(Iterator i = payReqMap.keySet().iterator(); i.hasNext();){
		Object key = i.next();
		out.println("<input type='hidden' name='" + key + "' id='" + key + "' value='" + payReqMap.get(key) + "'>" );
	}
%></form>
</div>
</body>
</html>