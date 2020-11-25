<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="lgdacom.XPayClient.XPayClient"%>
<%
    /*
     * [����������û ������(STEP2-2)]
	 *
     * �Ŵ��� "7.	�������� ��û(API) �� �������ó�� ������ ����(PAYRES)"�� "7.1.	�������ó�� ���üҽ� �����ϱ� " ����
	 *
     * �佺���̸������� ���� �������� LGD_PAYKEY(����Key) �� ������ ���� ������û.(�Ķ���� ���޽� POST�� ����ϼ���)
     */

	/* �� �߿�
	* ȯ�漳�� ������ ��� �ݵ�� �ܺο��� ������ ������ ��ο� �νø� �ȵ˴ϴ�.
	* �ش� ȯ�������� �ܺο� ������ �Ǵ� ��� ��ŷ�� ������ �����ϹǷ� �ݵ�� �ܺο��� ������ �Ұ����� ��ο� �νñ� �ٶ��ϴ�. 
	* ��) [Window �迭] C:\inetpub\wwwroot\lgdacom ==> ����Ұ�(�� ���丮)
	*/
	
    String configPath = "/Volumes/Storage/www/lgdacom";  //�佺���̸������� ������ ȯ������("/conf/lgdacom.conf,/conf/mall.conf") ��ġ ����.
    
    /*
     *************************************************
     * 1.�������� ��û - BEGIN
     *  (��, ���� �ݾ�üũ�� ���Ͻô� ��� �ݾ�üũ �κ� �ּ��� ���� �Ͻø� �˴ϴ�.)
     *************************************************
     */
    
    String CST_PLATFORM				= request.getParameter("CST_PLATFORM");
    String LGD_MID					= request.getParameter("LGD_MID");
    String LGD_TID                  = request.getParameter("LGD_TID");
    String LGD_OID                  = request.getParameter("LGD_OID");
    String LGD_AMOUNT               = request.getParameter("LGD_AMOUNT");
    String LGD_PRODUCTINFO          = request.getParameter("LGD_PRODUCTINFO");
    String LGD_BUYER                = request.getParameter("LGD_BUYER");
    String LGD_BUYEREMAIL           = request.getParameter("LGD_BUYEREMAIL");
    String LGD_BUYERPHONE           = request.getParameter("LGD_BUYERPHONE");
	
	String LGD_OPENPAY_PAYTYPE 		= request.getParameter("LGD_OPENPAY_PAYTYPE"); //�������� ���� ����
	String LGD_BILLKEY              = request.getParameter("LGD_BILLKEY");         //�������� ��Ű
	String LGD_OPENPAY_TOKEN        = request.getParameter("LGD_OPENPAY_TOKEN");   //�α��� ��ū

	if(LGD_BILLKEY != null && LGD_BILLKEY.equals("") == false)
	{
		if(LGD_OPENPAY_PAYTYPE.equals("K")) 
		{
		}
		else 
		{
			//������� ���� ����
			out.println("������� ������ �����Ͽ����ϴ�.<br>");
			out.println("���� û�� ������ �������� Ȯ���ϼ���.<br>");
			return;
		}
	}
	else
	{
		//������� ���� ����
		out.println("������� ������ �����Ͽ����ϴ�.<br>");
		out.println("���� û�� ������ �������� Ȯ���ϼ���.<br>");
		return;
	}

    
    //�ش� API�� ����ϱ� ���� WEB-INF/lib/XPayClient.jar �� Classpath �� ����ϼž� �մϴ�.
	// (1) XpayClient�� ����� ���� xpay ��ü ����
    XPayClient xpay = new XPayClient();

	// (2) Init: XPayClient �ʱ�ȭ(ȯ�漳�� ���� �ε�) 
	// configPath: ��������
	// CST_PLATFORM: - test, service ���� ���� lgdacom.conf�� test_url(test) �Ǵ� url(srvice) ���
	//				- test, service ���� ���� �׽�Ʈ�� �Ǵ� ���񽺿� ���̵� ����
   	boolean isInitOK = xpay.Init(configPath, CST_PLATFORM);   	

   	if( !isInitOK ) 
   	{
    	//API �ʱ�ȭ ���� ȭ��ó��
        out.println( "������û�� �ʱ�ȭ �ϴµ� �����Ͽ����ϴ�.<br>");
        out.println( "�佺���̸������� ������ ȯ�������� ���������� ��ġ �Ǿ����� Ȯ���Ͻñ� �ٶ��ϴ�.<br>");        
        out.println( "mall.conf���� Mert ID = Mert Key �� �ݵ�� ��ϵǾ� �־�� �մϴ�.<br><br>");
        out.println( "������ȭ �佺���̸��� 1544-7772<br>");
        return;
   	
   	}
   	else
   	{      
   		try
   		{
   			// (3) Init_TX: �޸𸮿� mall.conf, lgdacom.conf �Ҵ� �� Ʈ������� ������ Ű TXID ����
	    	xpay.Init_TX(LGD_MID);
			// �������� �¶������� ī����� or ������ü����	
	    	xpay.Set("LGD_TXNAME", "CardAuth");
	    	xpay.Set("LGD_OID", LGD_OID );
	    	xpay.Set("LGD_AMOUNT", LGD_AMOUNT);
	    	xpay.Set("LGD_BUYER", LGD_BUYER);
	    	xpay.Set("LGD_PRODUCTINFO", LGD_PRODUCTINFO);
	    	xpay.Set("LGD_BUYEREMAIL", LGD_BUYEREMAIL);
	    	xpay.Set("LGD_BUYERPHONE", LGD_BUYERPHONE);
	    	xpay.Set("LGD_PAN", LGD_BILLKEY);
	    	xpay.Set("LGD_INSTALL", "00");
	    	xpay.Set("LGD_OPENPAY_YN", "Y");
	    	//�ݾ��� üũ�Ͻñ� ���ϴ� ��� �Ʒ� �ּ��� Ǯ� �̿��Ͻʽÿ�.
	    	//String DB_AMOUNT = "DB�� ���ǿ��� ������ �ݾ�"; //�ݵ�� �������� �Ұ����� ��(DB�� ����)���� �ݾ��� �������ʽÿ�.
	    	//xpay.Set("LGD_AMOUNTCHECKYN", "Y");
	    	//xpay.Set("LGD_AMOUNT", DB_AMOUNT);
	    
    	}
   		catch(Exception e) 
   		{
    		out.println("�佺���̸��� ���� API�� ����� �� �����ϴ�. ȯ������ ������ Ȯ���� �ֽñ� �ٶ��ϴ�. ");
    		out.println(""+e.getMessage());    	
    		return;
    	}
   	}
   	
	/*
	 *************************************************
	 * 1.�������� ��û(�������� ������) - END
	 *************************************************
	 */

    /*
     * 2. �������� ��û ���ó��
     *
     * ���� ������û ��� ���� �Ķ���ʹ� �����޴����� �����Ͻñ� �ٶ��ϴ�.
     */
	 // (4) TX: lgdacom.conf�� ������ URL�� ���� ����Ͽ� ���� ������û, ��������� true, false ����
     if ( xpay.TX() ) 
     {
         //1)������� ȭ��ó��(����,���� ��� ó���� �Ͻñ� �ٶ��ϴ�.)
         out.println( "������û�� �Ϸ�Ǿ����ϴ�.  <br>");
		 out.println( "TX ������û ��� �����ڵ� = " + xpay.m_szResCode + "<br>");					//��� �����ڵ�("0000" �� �� ��� ����)
         out.println( "TX ������û ��� ����޽��� = " + xpay.m_szResMsg + "<p>");					//��� ����޽���
         
         out.println("�ŷ���ȣ : " + xpay.Response("LGD_TID",0) + "<br>");
         out.println("�������̵� : " + xpay.Response("LGD_MID",0) + "<br>");
         out.println("�����ֹ���ȣ : " + xpay.Response("LGD_OID",0) + "<br>");
         out.println("�����ݾ� : " + xpay.Response("LGD_AMOUNT",0) + "<br>");
         out.println("����ڵ� : " + xpay.Response("LGD_RESPCODE",0) + "<br>");					//LGD_RESPCODE �� �ݵ�� "0000" �϶��� ���� ����, �� �ܴ� ��� ����
         out.println("����޼��� : " + xpay.Response("LGD_RESPMSG",0) + "<p>");
         
         for (int i = 0; i < xpay.ResponseNameCount(); i++)
         {
             out.println(xpay.ResponseName(i) + " = ");
             for (int j = 0; j < xpay.ResponseCount(); j++)
             {
                 out.println("\t" + xpay.Response(xpay.ResponseName(i), j) + "<br>");
             }
         }
         out.println("<p>");
         
		 // (5) DB�� ������û ��� ó��
         if( "0000".equals( xpay.m_szResCode ) ) 
         {
         	// ��Ż��� ������ ������
			// ����������û ��� ���� DBó��(LGD_RESPCODE ���� ���� ������ ��������, �������� DBó��)
         	out.println("����������û ����, DBó���Ͻñ� �ٶ��ϴ�.<br>");
			out.println("�α��� ��ū : (" + LGD_OPENPAY_TOKEN + ") DB ���� �ʿ�<br>");
         	            	
         	//����������û ����� DBó���մϴ�. (�������� �Ǵ� ���� ��� DBó�� ����)
			//������ DB�� ��� ������ ó���� ���� ���Ѱ�� false�� ������ �ּ���.
         	boolean isDBOK = true; 
         	if( !isDBOK ) 
         	{
				xpay.Rollback("���� DBó�� ���з� ���Ͽ� Rollback ó�� [TID:" +xpay.Response("LGD_TID",0)+",MID:" + xpay.Response("LGD_MID",0)+",OID:"+xpay.Response("LGD_OID",0)+"]");
         		
				out.println( "TX Rollback Response_code = " + xpay.Response("LGD_RESPCODE",0) + "<br>");
				out.println( "TX Rollback Response_msg = " + xpay.Response("LGD_RESPMSG",0) + "<p>");
         		
				if( "0000".equals( xpay.m_szResCode ) ) 
				{ 
					out.println("�ڵ���Ұ� ���������� �Ϸ� �Ǿ����ϴ�.<br>");
				}
				else
				{
					out.println("�ڵ���Ұ� ���������� ó������ �ʾҽ��ϴ�.<br>");
				}
         	}         	
         }
         else
         {
			//��Ż��� ���� �߻�(����������û ��� ���� DBó��)
			out.println("����������û ��� ����, DBó���Ͻñ� �ٶ��ϴ�.<br>");            	
         }
     }
     else 
     {
         //2)API ��û���� ȭ��ó��
         out.println( "������û�� �����Ͽ����ϴ�.  <br>");
         out.println( "TX ������û Response_code = " + xpay.m_szResCode + "<br>");
         out.println( "TX ������û Response_msg = " + xpay.m_szResMsg + "<p>");
         
     	//����������û ��� ���� DBó��
     	out.println("����������û ��� ���� DBó���Ͻñ� �ٶ��ϴ�.<br>");            	            
     }
%>
<html>
<body>
<div>
<div>CST_PLATFORM : <%=CST_PLATFORM%></div>
<div>LGD_MID : <%=LGD_MID%></div>
<div>LGD_TID : <%=xpay.Response("LGD_TID",0)%></div>
<button onclick="javascript:document.getElementById('cancel').submit();">���</button>
<form action="Cancel.jsp" name="cancel" id="cancel" method="POST">
<input type="hidden" name="CST_PLATFORM" value="<%=CST_PLATFORM%>">
<input type="hidden" name="LGD_MID" value="<%=LGD_MID%>">
<input type="hidden" name="LGD_TID" value="<%=xpay.Response("LGD_TID",0)%>">
<input type="hidden" name="recentamount" value="<%=LGD_AMOUNT%>">
</form>
</div>
</body>
</html>