<%@ include file = "escrow_write.jsp" %>
<%@ page import="java.security.MessageDigest" %>

<%
//**************************//
//
// 처리결과 수신 JSP 예제
//
//**************************//
	request.setCharacterEncoding("utf-8");
// ## 이 페이지는 수정하지 마십시요. ##

// 수정시 html태그나 자바스크립트가 들어가는 경우 동작을 보장할 수 없습니다

// hash데이타값이 맞는 지 확인 하는 루틴은 토스페이먼츠에서 받은 데이타가 맞는지 확인하는 것이므로 꼭 사용하셔야 합니다
// 정상적인 결제 건임에도 불구하고 노티 페이지의 오류나 네트웍 문제 등으로 인한 hash 값의 오류가 발생할 수도 있습니다.
// 그러므로 hash 오류건에 대해서는 오류 발생시 원인을 파악하여 즉시 수정 및 대처해 주셔야 합니다.
// 그리고 정상적으로 data를 처리한 경우에도 토스페이먼츠에서 응답을 받지 못한 경우는 결제결과가 중복해서 나갈 수 있으므로 관련한 처리도 고려되어야 합니다. 

/*************************    변수선언    ******************************/

	String txtype = "";				// 결과구분(C=수령확인결과, R=구매취소요청, D=구매취소결과, N=NC처리결과 )
	String mid="";					// 상점아이디 
	String tid="";					// 토스페이먼츠에서 부여한 거래번호
	String oid="";					// 상품 거래 번호
	String ssn = "";				// 구매자주민번호	
	String ip = "";					// 구매자IP
	String mac = "";				// 구매자 mac
	String hashdata = "";			// 토스페이먼츠 인증 암호키
	String productid = "";			// 상품정보키
	String resdate = "";			// 구매확인 일시

	txtype = request.getParameter("txtype");
	mid = request.getParameter("mid");
	tid = request.getParameter("tid");
	oid = request.getParameter("oid");
	ssn = request.getParameter("ssn");	
	ip = request.getParameter("ip");
	mac = request.getParameter("mac");
	hashdata = request.getParameter("hashdata");
	productid = request.getParameter("productid");
	resdate = request.getParameter("resdate");

    boolean resp = false;
	String mertkey = "";
		
	mertkey = "116063976f7a62cd9770548377f40901";	// 토스페이먼츠에서 발급한 상점키로 변경해 주시기 바랍니다.
													// 상점관리자 계약정보관리에서 확인 가능

	String hashdata2 = null;
/*************************************/
    StringBuffer sb = new StringBuffer();
    sb.append(mid);
	sb.append(oid);
	sb.append(tid);	
	sb.append(txtype);
	sb.append(productid);
	sb.append(ssn);	
	sb.append(ip);	
	sb.append(mac);
	sb.append(resdate);
	sb.append(mertkey);

    byte[] bNoti = sb.toString().getBytes();

    MessageDigest md = MessageDigest.getInstance("MD5");
    byte[] digest = md.digest(bNoti);

    StringBuffer strBuf = new StringBuffer();

    for (int i=0 ; i < digest.length ; i++) {
        int c = digest[i] & 0xff;
        if (c <= 15){
            strBuf.append("0");
        }
        strBuf.append(Integer.toHexString(c));
    }

    hashdata2 = strBuf.toString();

/************************ 로그데이타 생성 ****************************/

    String[] noti = 
	{ 
		txtype,
		mid,
		tid,
		oid,
		ssn,		
		ip,
		mac,
		resdate,		
		hashdata, 
		productid,
		hashdata2 
	};

    if (hashdata2.trim().equals(hashdata)) 
	{										//해쉬값 검증이 성공이면
        resp = write_success(noti);
    } 
	else 
	{										//해쉬값이 검증이 실패이면
        write_hasherr(noti);
    }

    if(resp)
	{										//결과연동이 성공이면
        out.println("OK");
    }
	else
	{										//결과 연동이 실패이면
        out.println("FAIL"+noti);
    }
%>
