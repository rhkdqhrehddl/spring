<%@ page contentType="text/html;charset=utf-8" %>
<%@ page language="java" import="java.security.MessageDigest" %>
<%@ page language="java" import="java.net.HttpURLConnection" %>
<%@ page language="java" import ="java.net.*" %>
<%@ page language="java" import="java.io.*,java.util.*, java.text.*, java.sql.*" %>

<!-- <SCRIPT language=JavaScript src="https://pgweb.tosspayments.com/js/DACOMEscrow_UTF8.js"></SCRIPT> -->
<!-- TEST --> 
<SCRIPT language=JavaScript src="http://pgweb.tosspayments.com:7085/js/DACOMEscrow_UTF8.js"></SCRIPT>

<SCRIPT language=javascript>
function linkESCROW(mid,oid)
{
	checkDacomESC (mid, oid, '');
	location.reload();
}
</SCRIPT>


<%
	request.setCharacterEncoding("utf-8");
	//**************************//
	//
	// 배송결과 송신 JSP 예제
	//
	//**************************//

	String service_url = "";

	// 테스트용
	service_url = "http://pgweb.tosspayments.com:7085/pg/wmp/mertadmin/jsp/escrow/rcvdlvinfo.jsp"; 

	// 서비스용
	//service_url = "https://pgweb.tosspayments.com/pg/wmp/mertadmin/jsp/escrow/rcvdlvinfo.jsp"; 

	String mid ="tdacomnpg";
	String oid ="test_20201102114120";
	String productid ="";
	String orderdate ="";
	String dlvtype ="01";
	String rcvdate ="202011031020";
	String rcvname ="이원준";
	String rcvrelation ="본인";
	String dlvdate ="202011030940";
	String dlvcompcode ="CJ";
	String dlvcomp ="";
	String dlvno ="12345622798";
	String dlvworker ="";
	String dlvworkertel  ="";
	String hashdata ="";
	String mertkey ="";
	
	
/* 	mid = request.getParameter("mid");						// 상점ID
	oid = request.getParameter("oid");						// 주문번호
	productid = request.getParameter("productid");			// 상품ID
	orderdate = request.getParameter("orderdate");			// 주문일자
	dlvtype = request.getParameter("dlvtype");				// 등록내용구분
	rcvdate = request.getParameter("rcvdate");				// 실수령일자
	rcvname = request.getParameter("rcvname");				// 실수령인명
	rcvrelation = request.getParameter("rcvrelation");		// 관계
	dlvdate = request.getParameter("dlvdate");				// 발송일자
	dlvcompcode = request.getParameter("dlvcompcode");		// 배송회사코드
	dlvcomp = request.getParameter("dlvcompe");				// 배송회사명
	dlvno = request.getParameter("dlvno");					// 운송장번호
	dlvworker = request.getParameter("dlvworker");			// 배송자명
	dlvworkertel = request.getParameter("dlvworkertel");	// 배송자전화번호 */

    boolean resp = false;
	mertkey = "116063976f7a62cd9770548377f40901"; //토스페이먼츠에서 발급한 상점키로 변경해 주시기 바랍니다.
		
	
	//******************************//
	// 보안용 인증키 생성 - 시작
	//******************************//
    StringBuffer sb = new StringBuffer();
	if("03".equals(dlvtype))
	{
		// 발송정보
		sb.append(mid);
		sb.append(oid);
		sb.append(dlvdate);
		sb.append(dlvcompcode);
		sb.append(dlvno);
		sb.append(mertkey);
		
	}
	else if("01".equals(dlvtype))
	{
		// 수령정보 
		sb.append(mid);
		sb.append(oid);
		sb.append(dlvtype);
		sb.append(rcvdate);		
		sb.append(mertkey);
	}	
    
    byte[] bNoti = sb.toString().getBytes();

    MessageDigest md = MessageDigest.getInstance("MD5");
    byte[] digest = md.digest(bNoti);

    StringBuffer strBuf = new StringBuffer();

    for (int i=0 ; i < digest.length ; i++) 
	{
        int c = digest[i] & 0xff;
        if (c <= 15)
		{
            strBuf.append("0");
        }
        strBuf.append(Integer.toHexString(c));
    }

    hashdata = strBuf.toString();
	//******************************//
	// 보안용 인증키 생성 - 끝
	//******************************//

	//******************************//
	// 전송할 파라미터 문자열 생성 - 시작
	//******************************//
	String sendMsg = "";
	StringBuffer msgBuf = new StringBuffer();
	msgBuf.append("mid=" + mid + "&" );	
	msgBuf.append("oid=" + oid+"&");
	msgBuf.append("productid=" + productid + "&" );
	msgBuf.append("orderdate=" + orderdate + "&" );
	msgBuf.append("dlvtype=" + dlvtype + "&" );			
	msgBuf.append("rcvdate=" + rcvdate + "&" );
	msgBuf.append("rcvname=" + rcvname + "&" );
	msgBuf.append("rcvrelation=" + rcvrelation + "&" );			
	msgBuf.append("dlvdate=" + dlvdate + "&" );
	msgBuf.append("dlvcompcode=" + dlvcompcode + "&" );	
	msgBuf.append("dlvno=" + dlvno + "&" );
	msgBuf.append("dlvworker=" + dlvworker + "&" );
	msgBuf.append("dlvworkertel=" + dlvworkertel + "&" );
	msgBuf.append("hashdata=" + hashdata );

	sendMsg = msgBuf.toString();

	StringBuffer errmsg = new StringBuffer();
	//******************************//
	// 전송할 파라미터 문자열 생성 - 끝
	//******************************//
	
	//*************************************//
	// HTTP로 배송결과 등록
	//*************************************//
	URL url = new URL(service_url + "?" + sendMsg);
	resp = sendRCVInfo(sendMsg,url,errmsg);

    if(resp)
	{                                   //결과연동이 성공이면
        out.println("OK");                      
    } 
	else 
	{                                    //결과 연동이 실패이면
        out.println("FAIL");
    }
%>

<td><a href="javascript: linkESCROW('tdacomnpg', 'test_20201103093947');">구매확인</a></td>
<%!
	//*************************************************
	// 아래부분 절대 수정하지 말것
	//*************************************************
	private boolean sendRCVInfo(String sendMsg, URL url, StringBuffer errmsg) throws Exception{
        OutputStreamWriter wr = null;
        BufferedReader br = null;
        HttpURLConnection conn = null;
        boolean result = false;
		String errormsg = null;

        try {
            conn = (HttpURLConnection)url.openConnection();
            conn.setDoOutput(true);
            wr = new OutputStreamWriter(conn.getOutputStream());
            wr.write(sendMsg);
            wr.flush();
            for (int i=0; ; i++) {
                String headerName = conn.getHeaderFieldKey(i);
                String headerValue = conn.getHeaderField(i);

                if (headerName == null && headerValue == null) {
                    break;
                }
                if (headerName == null) {
                    headerName = "Version";
                }

                errmsg.append(headerName + ":" + headerValue + "\n");
            }


            br = new BufferedReader(new InputStreamReader(conn.getInputStream (), "EUC-KR"));

            String in;
            StringBuffer sb = new StringBuffer();
            while(((in = br.readLine ()) != null )){
                sb.append(in);
            }

            errmsg.append(sb.toString().trim());
            if ( sb.toString().trim().equals("OK")){
                result = true;
            }else{
				errormsg = sb.toString().trim();
				System.out.println(errormsg);
			}

        } catch ( Exception ex ) {
            errmsg.append("EXCEPTION : " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            try {
                if ( wr != null) wr.close();
                if ( br != null) br.close();
            } catch(Exception e){
            }
        }
        return result;

    }
%>