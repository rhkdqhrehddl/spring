<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.security.MessageDigest" %>

<%
	request.setCharacterEncoding("utf-8");
    /*
     * [상점 결제결과처리(DB) 페이지]
     *
     * 1) 위변조 방지를 위한 hashdata값 검증은 반드시 적용하셔야 합니다.
     *
     */

    /*
     * 공통결제결과 정보 
     */
    String LGD_RESPCODE = "";           // 응답코드: 0000(성공) 그외 실패
    String LGD_RESPMSG = "";            // 응답메세지
    String LGD_MID = "";                // 상점아이디 
    String LGD_OID = "";                // 주문번호
    String LGD_AMOUNT = "";             // 거래금액
    String LGD_TID = "";                // 토스페이먼츠 부여한 거래번호
    String LGD_PAYTYPE = "";            // 결제수단코드
    String LGD_PAYDATE = "";            // 거래일시(승인일시/이체일시)
    String LGD_HASHDATA = "";           // 해쉬값
    String LGD_FINANCECODE = "";        // 결제기관코드(카드종류/은행코드/이통사코드)
    String LGD_FINANCENAME = "";        // 결제기관이름(카드이름/은행이름/이통사이름)
    String LGD_ESCROWYN = "";           // 에스크로 적용여부
    String LGD_TIMESTAMP = "";          // 타임스탬프
    String LGD_FINANCEAUTHNUM = "";     // 결제기관 승인번호(신용카드, 계좌이체, 상품권)
    String LGD_TAXFREEAMOUNT = "";      // 면세금액
    
    /*
     * 신용카드 결제결과 정보
     */
    String LGD_CARDNUM = "";            // 카드번호(신용카드)
    String LGD_CARDINSTALLMONTH = "";   // 할부개월수(신용카드) 
    String LGD_CARDNOINTYN = "";        // 무이자할부여부(신용카드) - '1'이면 무이자할부 '0'이면 일반할부
    String LGD_TRANSAMOUNT = "";        // 환율적용금액(신용카드)
    String LGD_EXCHANGERATE = "";       // 환율(신용카드)

    /*
     * 휴대폰
     */
    String LGD_PAYTELNUM = "";          // 결제에 이용된전화번호

    /*
     * 계좌이체, 무통장
     */
    String LGD_ACCOUNTNUM = "";         // 계좌번호(계좌이체, 무통장입금) 
    String LGD_CASTAMOUNT = "";         // 입금총액(무통장입금)
    String LGD_CASCAMOUNT = "";         // 현입금액(무통장입금)
    String LGD_CASFLAG = "";            // 무통장입금 플래그(무통장입금) - 'R':계좌할당, 'I':입금, 'C':입금취소 
    String LGD_CASSEQNO = "";           // 입금순서(무통장입금)
    String LGD_CASHRECEIPTNUM = "";     // 현금영수증 승인번호
    String LGD_CASHRECEIPTSELFYN = "";  // 현금영수증자진발급제유무 Y: 자진발급제 적용, 그외 : 미적용
    String LGD_CASHRECEIPTKIND = "";    // 현금영수증 종류 0: 소득공제용 , 1: 지출증빙용

    /*
     * OK캐쉬백
     */
    String LGD_OCBSAVEPOINT = "";       // OK캐쉬백 적립포인트
    String LGD_OCBTOTALPOINT = "";      // OK캐쉬백 누적포인트
    String LGD_OCBUSABLEPOINT = "";     // OK캐쉬백 사용가능 포인트

    /*
     * 구매정보
     */
    String LGD_BUYER = "";              // 구매자
    String LGD_PRODUCTINFO = "";        // 상품명
    String LGD_BUYERID = "";            // 구매자 ID
    String LGD_BUYERADDRESS = "";       // 구매자 주소
    String LGD_BUYERPHONE = "";         // 구매자 전화번호
    String LGD_BUYEREMAIL = "";         // 구매자 이메일
    String LGD_BUYERSSN = "";           // 구매자 주민번호
    String LGD_PRODUCTCODE = "";        // 상품코드
    String LGD_RECEIVER = "";           // 수취인
    String LGD_RECEIVERPHONE = "";      // 수취인 전화번호
    String LGD_DELIVERYINFO = "";       // 배송지

    LGD_RESPCODE            = request.getParameter("LGD_RESPCODE");
    LGD_RESPMSG             = request.getParameter("LGD_RESPMSG");
    LGD_MID                 = request.getParameter("LGD_MID");
    LGD_OID                 = request.getParameter("LGD_OID");
    LGD_AMOUNT              = request.getParameter("LGD_AMOUNT");
    LGD_TID                 = request.getParameter("LGD_TID");
    LGD_PAYTYPE             = request.getParameter("LGD_PAYTYPE");
    LGD_PAYDATE             = request.getParameter("LGD_PAYDATE");
    LGD_HASHDATA            = request.getParameter("LGD_HASHDATA");
    LGD_FINANCECODE         = request.getParameter("LGD_FINANCECODE");
    LGD_FINANCENAME         = request.getParameter("LGD_FINANCENAME");
    LGD_ESCROWYN            = request.getParameter("LGD_ESCROWYN");
    LGD_TRANSAMOUNT         = request.getParameter("LGD_TRANSAMOUNT");
    LGD_EXCHANGERATE        = request.getParameter("LGD_EXCHANGERATE");
    LGD_CARDNUM             = request.getParameter("LGD_CARDNUM");
    LGD_CARDINSTALLMONTH    = request.getParameter("LGD_CARDINSTALLMONTH");
    LGD_CARDNOINTYN         = request.getParameter("LGD_CARDNOINTYN");
    LGD_TIMESTAMP           = request.getParameter("LGD_TIMESTAMP");
    LGD_FINANCEAUTHNUM      = request.getParameter("LGD_FINANCEAUTHNUM");
    LGD_PAYTELNUM           = request.getParameter("LGD_PAYTELNUM");
    LGD_ACCOUNTNUM          = request.getParameter("LGD_ACCOUNTNUM");
    LGD_CASTAMOUNT          = request.getParameter("LGD_CASTAMOUNT");
    LGD_CASCAMOUNT          = request.getParameter("LGD_CASCAMOUNT");
    LGD_CASFLAG             = request.getParameter("LGD_CASFLAG");
    LGD_CASSEQNO            = request.getParameter("LGD_CASSEQNO");
    LGD_CASHRECEIPTNUM      = request.getParameter("LGD_CASHRECEIPTNUM");
    LGD_CASHRECEIPTSELFYN   = request.getParameter("LGD_CASHRECEIPTSELFYN");
    LGD_CASHRECEIPTKIND     = request.getParameter("LGD_CASHRECEIPTKIND");
    LGD_OCBSAVEPOINT        = request.getParameter("LGD_OCBSAVEPOINT");
    LGD_OCBTOTALPOINT       = request.getParameter("LGD_OCBTOTALPOINT");
    LGD_OCBUSABLEPOINT      = request.getParameter("LGD_OCBUSABLEPOINT");
    LGD_TAXFREEAMOUNT       = request.getParameter("LGD_TAXFREEAMOUNT");
    
    LGD_BUYER               = request.getParameter("LGD_BUYER");
    LGD_PRODUCTINFO         = request.getParameter("LGD_PRODUCTINFO");
    LGD_BUYERID             = request.getParameter("LGD_BUYERID");
    LGD_BUYERADDRESS        = request.getParameter("LGD_BUYERADDRESS");
    LGD_BUYERPHONE          = request.getParameter("LGD_BUYERPHONE");
    LGD_BUYEREMAIL          = request.getParameter("LGD_BUYEREMAIL");
    LGD_BUYERSSN            = request.getParameter("LGD_BUYERSSN");
    LGD_PRODUCTCODE         = request.getParameter("LGD_PRODUCTCODE");
    LGD_RECEIVER            = request.getParameter("LGD_RECEIVER");
    LGD_RECEIVERPHONE       = request.getParameter("LGD_RECEIVERPHONE");
    LGD_DELIVERYINFO        = request.getParameter("LGD_DELIVERYINFO");

    /*
     * hashdata 검증을 위한 mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다. 
     * 토스페이먼츠에서 발급한 상점키로 반드시변경해 주시기 바랍니다.
     */  
    String LGD_MERTKEY = ""; //mertkey

    StringBuffer sb = new StringBuffer();
    sb.append(LGD_MID);
    sb.append(LGD_OID);
    sb.append(LGD_AMOUNT);
    sb.append(LGD_RESPCODE);
    sb.append(LGD_TIMESTAMP);
    sb.append(LGD_MERTKEY);

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

    String LGD_HASHDATA2 = strBuf.toString();  //상점검증 해쉬값  
    
    /*
     * 상점 처리결과 리턴메세지
     *
     * OK   : 상점 처리결과 성공
     * 그외 : 상점 처리결과 실패
     *
     * ※ 주의사항 : 성공시 'OK' 문자이외의 다른문자열이 포함되면 실패처리 되오니 주의하시기 바랍니다.
     */    
    String resultMSG = "결제결과 상점 DB처리(NOTE_URL) 결과값을 입력해 주시기 바랍니다.";  
    
    if (LGD_HASHDATA2.trim().equals(LGD_HASHDATA)) { //해쉬값 검증이 성공이면
        if (LGD_RESPCODE.trim().equals("0000")){ //결제가 성공이면
            /*
             * 거래성공 결과 상점 처리(DB) 부분
             * 상점 결과 처리가 정상이면 "OK"
             */    
            //if( 결제성공 상점처리결과 성공 ) resultMSG = "OK";   
        } else { //결제가 실패이면
            /*
             * 거래실패 결과 상점 처리(DB) 부분
             * 상점결과 처리가 정상이면 "OK"
             */  
           //if( 결제실패 상점처리결과 성공 ) resultMSG = "OK";     
        }
    } else { //해쉬값이 검증이 실패이면
        /*
         * hashdata검증 실패 로그를 처리하시기 바랍니다. 
         */      
        resultMSG = "결제결과 상점 DB처리(NOTE_URL) 해쉬값 검증이 실패하였습니다.";     
    }
    
    out.println(resultMSG.toString());                       
%>
 
