<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("utf-8");

String LGD_RESPCODE		= request.getParameter("LGD_RESPCODE");		//결과코드
String LGD_RESPMSG 		= request.getParameter("LGD_RESPMSG");		//결과메세지

String LGD_BILLKEY 		= request.getParameter("LGD_BILLKEY");		//추후 빌링시 카드번호 대신 입력할 값입니다.
String LGD_PAYTYPE 		= request.getParameter("LGD_PAYTYPE");		//인증수단
String LGD_PAYDATE 		= request.getParameter("LGD_PAYDATE");		//인증일시
String LGD_FINANCECODE 	= request.getParameter("LGD_FINANCECODE");	//인증기관코드
String LGD_FINANCENAME 	= request.getParameter("LGD_FINANCENAME");	//인증기관이름 
String LGD_CARDNUM 	= request.getParameter("LGD_CARDNUM");	//인증기관이름 


out.println("LGD_CARDNUM:" + LGD_CARDNUM);

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
<form method="post" name="LGD_RETURNINFO" id="LGD_RETURNINFO">
<%
	if( LGD_RESPCODE.equals("0000") ){
		
		payReqMap.put("LGD_RESPCODE"	, LGD_RESPCODE);
		payReqMap.put("LGD_RESPMSG"		, LGD_RESPMSG);
		payReqMap.put("LGD_BILLKEY"		, LGD_BILLKEY);
		payReqMap.put("LGD_PAYTYPE"		, LGD_PAYTYPE);
		payReqMap.put("LGD_PAYDATE"		, LGD_PAYDATE);
		payReqMap.put("LGD_FINANCECODE"	, LGD_FINANCECODE);
		payReqMap.put("LGD_FINANCENAME"	, LGD_FINANCENAME);
		payReqMap.put("LGD_CARDNUM"	, LGD_CARDNUM);
		
		for (Iterator i = payReqMap.keySet().iterator(); i.hasNext();) {
			Object key = i.next();

			if (payReqMap.get(key) instanceof String[]) {
				String[] valueArr = (String[])payReqMap.get(key);
				for(int k = 0; k < valueArr.length; k++)
					out.println("<input type='hidden' name='" + key + "' id='"+key+"'value='" + valueArr[k] + "'/>");
			} else {
				String value = payReqMap.get(key) == null ? "" : (String) payReqMap.get(key);
				out.println("<input type='hidden' name='" + key + "' id='"+key+"'value='" + value + "'/>");
			}
		}
	}else{
		out.println("LGD_RESPCODE:" + LGD_RESPCODE + " ,LGD_RESPMSG:" + LGD_RESPMSG);
		out.println("<input type='hidden' name='LGD_RESPCODE' id='LGD_RESPCODE' value='" + LGD_RESPCODE + "'/>");
		out.println("<input type='hidden' name='LGD_RESPMSG' id='LGD_RESPMSG' value='" + LGD_RESPMSG + "'/>");
	}
	
%>
</form>
</body>
</html>