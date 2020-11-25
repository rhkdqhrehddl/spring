<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.*,java.util.*" %>

<%!

boolean write_success(String noti[]) throws IOException
{
    //구매여부에 관한 log남기게 됩니다. log path수정 및 db처리루틴이 추가하여 주십시요.
    write_log("/mplog/MPLOG/ESC/TEST/escrow_write_success.log", noti);
    return true;
}

boolean write_failure(String noti[]) throws IOException
{
    //구매여부에 관한 log남기게 됩니다. log path수정 및 db처리루틴이 추가하여 주십시요.
    write_log("/mplog/MPLOG/ESC/TEST/escrow_write_failure.log", noti);
    return true;
}

boolean write_hasherr(String noti[]) throws IOException
{
    //구매여부에 관한 log남기게 됩니다. log path수정 및 db처리루틴이 추가하여 주십시요.
    write_log("/mplog/MPLOG/ESC/TEST/escrow_write_hasherr.log", noti);
    return true;
}

void write_log(String file, String noti[]) throws IOException
{

    StringBuffer strBuf = new StringBuffer();

	strBuf.append("작성일시 : "				+ getSysDate() +"\r\n");
    strBuf.append("결과구분 : "				+ noti[0] +		"\r\n");
    strBuf.append("상점ID : "				+ noti[1] +		"\r\n");
    strBuf.append("토스페이먼츠 거래번호 : "	+ noti[2] +		"\r\n");
	strBuf.append("상점주문번호 : "			+ noti[3] +		"\r\n");
    strBuf.append("작업자 주민번호 : "		+ noti[4] +		"\r\n");    
    strBuf.append("작업자 PC의 IP주소 : "	+ noti[5] +		"\r\n");
    strBuf.append("작업자 PC의 MAC주소 : "	+ noti[6] +		"\r\n");
	strBuf.append("처리일시 : "				+ noti[7] +		"\r\n");
	strBuf.append("토스페이먼츠 인증키 : "	+ noti[8] +		"\r\n");
	strBuf.append("상품ID : "				+ noti[9] +		"\r\n");
	strBuf.append("자체  인증키 : "			+ noti[10] +	"\r\n");


    byte b[] = strBuf.toString().getBytes("EUC-KR");
    BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(file, true));
    stream.write(b);
    stream.close();
}

    public static String getSysDate(){
        Calendar     m_objCal  = Calendar.getInstance();
        StringBuffer m_objDate = new StringBuffer();

        m_objDate.append(m_objCal.get(m_objCal.YEAR));
        if(m_objCal.get(m_objCal.MONTH)<9)
            m_objDate.append(0);
        m_objDate.append(m_objCal.get(m_objCal.MONTH)+1);
        if(m_objCal.get(m_objCal.DATE)<10)
            m_objDate.append(0);
        m_objDate.append(m_objCal.get(m_objCal.DATE));
        if(m_objCal.get(m_objCal.HOUR)<10)
            m_objDate.append(0);
        m_objDate.append(m_objCal.get(m_objCal.HOUR));
        if(m_objCal.get(m_objCal.MINUTE)<10)
            m_objDate.append(0);
        m_objDate.append(m_objCal.get(m_objCal.MINUTE));
        if(m_objCal.get(m_objCal.SECOND)<10)
            m_objDate.append(0);
        m_objDate.append(m_objCal.get(m_objCal.SECOND));

        return m_objDate.toString();
    }
%>



