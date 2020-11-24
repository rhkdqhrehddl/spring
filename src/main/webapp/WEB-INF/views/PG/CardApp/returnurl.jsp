<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("utf-8");

String LGD_RESPCODE         = request.getParameter("LGD_RESPCODE");
String LGD_RESPMSG          = request.getParameter("LGD_RESPMSG");       	                        
String LGD_NOINT	        = request.getParameter("LGD_NOINT");
String LGD_MID              = request.getParameter("LGD_MID");
String VBV_CAVV             = request.getParameter("VBV_CAVV");
String LGD_EXPMON           = request.getParameter("LGD_EXPMON");
String KVP_GOODNAME         = request.getParameter("KVP_GOODNAME");
String LGD_DELIVERYINFO     = request.getParameter("LGD_DELIVERYINFO");
String LGD_BUYER            = request.getParameter("LGD_BUYER");
String LGD_CARDTYPE         = request.getParameter("LGD_CARDTYPE");
String KVP_CARDCOMPANY      = request.getParameter("KVP_CARDCOMPANY");
String LGD_BUYERID          = request.getParameter("LGD_BUYERID");
String LGD_OID              = request.getParameter("LGD_OID");
String LGD_PAN              = request.getParameter("LGD_PAN");
String KVP_SESSIONKEY       = request.getParameter("KVP_SESSIONKEY");
String LGD_EXPYEAR          = request.getParameter("LGD_EXPYEAR");
String LGD_RECEIVERPHONE    = request.getParameter("LGD_RECEIVERPHONE");
String KVP_QUOTA            = request.getParameter("KVP_QUOTA");
String LGD_CLOSEDATE        = request.getParameter("LGD_CLOSEDATE");
String LGD_TIMESTAMP        = request.getParameter("LGD_TIMESTAMP");
String KVP_NOINT            = request.getParameter("KVP_NOINT");
String LGD_BUYERPHONE       = request.getParameter("LGD_BUYERPHONE");
String LGD_INSTALL          = request.getParameter("LGD_INSTALL");
String LGD_ESCROWYN         = request.getParameter("LGD_ESCROWYN");
String LGD_RETURNURL        = request.getParameter("LGD_RETURNURL");
String KVP_PRICE            = request.getParameter("KVP_PRICE");
String LGD_PAYTYPE          = request.getParameter("LGD_PAYTYPE");
String LGD_AMOUNT           = request.getParameter("LGD_AMOUNT");
String KVP_CONAME           = request.getParameter("KVP_CONAME");
String LGD_BUYERSSN         = request.getParameter("LGD_BUYERSSN");
String LGD_RES_CARDPOINTYN  = request.getParameter("LGD_RES_CARDPOINTYN");
String LGD_CURRENCY         = request.getParameter("LGD_CURRENCY");
String KVP_CARDCODE         = request.getParameter("KVP_CARDCODE");
String LGD_PRODUCTINFO      = request.getParameter("LGD_PRODUCTINFO");
String VBV_JOINCODE         = request.getParameter("VBV_JOINCODE");
String LGD_PRODUCTCODE      = request.getParameter("LGD_PRODUCTCODE");
String VBV_XID              = request.getParameter("VBV_XID");
String LGD_HASHDATA         = request.getParameter("LGD_HASHDATA");
String VBV_ECI              = request.getParameter("VBV_ECI");
String LGD_BUYERADDRESS     = request.getParameter("LGD_BUYERADDRESS");
String LGD_BUYERIP          = request.getParameter("LGD_BUYERIP");
String LGD_RECEIVER         = request.getParameter("LGD_RECEIVER");
String KVP_ENCDATA          = request.getParameter("KVP_ENCDATA");
String KVP_PGID             = request.getParameter("KVP_PGID");
String LGD_BUYEREMAIL       = request.getParameter("LGD_BUYEREMAIL");
String LGD_AUTHTYPE         = request.getParameter("LGD_AUTHTYPE");
String KVP_CURRENCY         = request.getParameter("KVP_CURRENCY");
String LGD_KVPISP_USER		= request.getParameter("LGD_KVPISP_USER");
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
		<input type="hidden" name="LGD_RESPCODE" id="LGD_RESPCODE" value='<%= LGD_RESPCODE %>' />
		<input type="hidden" name="LGD_RESPMSG" id="LGD_RESPMSG" value='<%= LGD_RESPMSG %>' />
		<input type='hidden' name='LGD_NOINT' id='LGD_NOINT'value='<%= LGD_NOINT %>'/>
		<input type='hidden' name='LGD_MID' id='LGD_MID' value='<%= LGD_MID %>'/>
		<input type='hidden' name='LGD_BUYERADDRESS' id='LGD_BUYERADDRESS' value='<%= LGD_BUYERADDRESS %>'/>
		<input type='hidden' name='LGD_BUYERIP' id='LGD_BUYERIP' value='<%= LGD_BUYERIP %>'/>
		<input type='hidden' name='LGD_RECEIVER' id='LGD_RECEIVER' value='<%= LGD_RECEIVER %>'/>
		<input type='hidden' name='LGD_EXPMON' id='LGD_EXPMON' value='<%= LGD_EXPMON %>'/>
		<input type='hidden' name='LGD_DELIVERYINFO' id='LGD_DELIVERYINFO' value='<%= LGD_DELIVERYINFO %>'/>
		<input type='hidden' name='LGD_BUYER' id='LGD_BUYER' value='<%= LGD_BUYER %>'/>
		<input type='hidden' name='LGD_CARDTYPE' id='LGD_CARDTYPE' value='<%= LGD_CARDTYPE %>'/>
		<input type='hidden' name='LGD_BUYERID' id='LGD_BUYERID' value='<%= LGD_BUYERID %>'/>
		<input type='hidden' name='LGD_OID' id='LGD_OID' value='<%= LGD_OID %>'/>
		<input type='hidden' name='LGD_PAN' id='LGD_PAN' value='<%= LGD_PAN %>'/>
		<input type='hidden' name='LGD_EXPYEAR' id='LGD_EXPYEAR' value='<%= LGD_EXPYEAR %>'/>
		<input type='hidden' name='LGD_RECEIVERPHONE' id='LGD_RECEIVERPHONE' value='<%= LGD_RECEIVERPHONE %>'/>
		<input type='hidden' name='LGD_CLOSEDATE' id='LGD_CLOSEDATE' value='<%= LGD_CLOSEDATE %>'/>
		<input type='hidden' name='LGD_TIMESTAMP' id='LGD_TIMESTAMP' value='<%= LGD_TIMESTAMP %>'/>
		<input type='hidden' name='LGD_BUYERPHONE' id='LGD_BUYERPHONE' value='<%= LGD_BUYERPHONE %>'/>
		<input type='hidden' name='LGD_INSTALL' id='LGD_INSTALL' value='<%= LGD_INSTALL %>'/>
		<input type='hidden' name='LGD_ESCROWYN' id='LGD_ESCROWYN' value='<%= LGD_ESCROWYN %>'/>
		<input type='hidden' name='LGD_RETURNURL' id='LGD_RETURNURL' value='<%= LGD_RETURNURL %>'/>
		<input type='hidden' name='LGD_PAYTYPE' id='LGD_PAYTYPE' value='<%= LGD_PAYTYPE %>'/>
		<input type='hidden' name='LGD_AMOUNT' id='LGD_AMOUNT' value='<%= LGD_AMOUNT %>'/>
		<input type='hidden' name='LGD_BUYERSSN' id='LGD_BUYERSSN' value='<%= LGD_BUYERSSN %>'/>
		<input type='hidden' name='LGD_RES_CARDPOINTYN' id='LGD_RES_CARDPOINTYN' value='<%= LGD_RES_CARDPOINTYN %>'/>
		<input type='hidden' name='LGD_CURRENCY' id='LGD_CURRENCY' value='<%= LGD_CURRENCY %>'/>
		<input type='hidden' name='LGD_PRODUCTINFO' id='LGD_PRODUCTINFO' value='<%= LGD_PRODUCTINFO %>'/>
		<input type='hidden' name='LGD_PRODUCTCODE' id='LGD_PRODUCTCODE' value='<%= LGD_PRODUCTCODE %>'/>
		<input type='hidden' name='LGD_BUYEREMAIL' id='LGD_BUYEREMAIL' value='<%= LGD_BUYEREMAIL %>'/>
		<input type='hidden' name='LGD_AUTHTYPE' id='LGD_AUTHTYPE' value='<%= LGD_AUTHTYPE %>'/>
		<input type='hidden' name='LGD_HASHDATA' id='LGD_HASHDATA' value='<%= LGD_HASHDATA %>'/>
		<input type='hidden' name='KVP_QUOTA' id='KVP_QUOTA' value='<%= KVP_QUOTA %>'/>
		<input type='hidden' name='KVP_NOINT' id='KVP_NOINT' value='<%= KVP_NOINT %>'/>
		<input type='hidden' name='KVP_PRICE' id='KVP_PRICE' value='<%= KVP_PRICE %>'/>
		<input type='hidden' name='KVP_CONAME' id='KVP_CONAME' value='<%= KVP_CONAME %>'/>
		<input type='hidden' name='KVP_CARDCODE' id='KVP_CARDCODE' value='<%= KVP_CARDCODE %>'/>
		<input type='hidden' name='KVP_SESSIONKEY' id='KVP_SESSIONKEY' value='<%= KVP_SESSIONKEY %>'/>
		<input type='hidden' name='KVP_CARDCOMPANY' id='KVP_CARDCOMPANY' value='<%= KVP_CARDCOMPANY %>'/>
		<input type='hidden' name='KVP_ENCDATA' id='KVP_ENCDATA' value='<%= KVP_ENCDATA %>'/>
		<input type='hidden' name='KVP_PGID' id='KVP_PGID' value='<%= KVP_PGID %>'/>
		<input type='hidden' name='KVP_CURRENCY' id='KVP_CURRENCY' value='<%= KVP_CURRENCY %>'/>
		<input type='hidden' name='KVP_GOODNAME' id='KVP_GOODNAME' value='<%= KVP_GOODNAME %>'/>
		<input type='hidden' name='VBV_CAVV' id='VBV_CAVV' value='<%= VBV_CAVV %>'/>
		<input type='hidden' name='VBV_ECI' id='VBV_ECI' value='<%= VBV_ECI %>'/>
		<input type='hidden' name='VBV_JOINCODE' id='VBV_JOINCODE' value='<%= VBV_JOINCODE %>'/>
		<input type='hidden' name='VBV_XID' id='VBV_XID' value='<%= VBV_XID %>'/>
		<input type='hidden' name='LGD_KVPISP_USER' id='LGD_KVPISP_USER' value='<%= LGD_KVPISP_USER  %>'/>
	</form>

</body>
</html>