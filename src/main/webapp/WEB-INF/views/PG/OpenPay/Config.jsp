<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="lgdacom.XPayClient.*"%>
<%@ page import="lgdacom.XPayClient.XPayUtil"%>
<%
	String LGD_MID              = "paynow_test01";                    // 테스트 아이디는 't'를 제외하고 입력하세요.
	String LGD_VENDERNO			= "1068511710";                       // 사업자번호를 입력해 주세요
	String LGD_OPENPAY_MER_UID	= "sangman.park@gmail.com";           // 가맹점 사용자 아이디를 입력해 주세요
	String LGD_OPENPAY_TOKEN	= "";                                 // 가맹점 사용자 로그인토큰을 입력해 주세요 (선택). 미입력시 로그인이나 본인확인이 필요하며 입력시 자동 로그인 처리됩니다.
	 
  	 /*
  	  *************************************************
   	  * SHA512 해쉬암호화 (수정하지 마세요) - BEGIN
   	  *
   	  * SHA512 해쉬암호화는 거래 위변조를 막기위한 방법입니다.
   	  *************************************************
   	  *
   	  * 해쉬 암호화 적용( LGD_VENDERNO + CST_MID + LGD_OPENPAY_MER_UID + LGD_OPENPAY_TOKEN + LGD_TIMESTAMP + LGD_MERTKEY )
   	  * LGD_VENDERNO               : 사업자번호
   	  * LGD_MID                    : 상점아이디
   	  * LGD_OPENPAY_MER_UID        : 가맹점아이디
   	  * LGD_OPENPAY_TOKEN          : 로그인토큰
   	  * LGD_TIMESTAMP              : 타임스탬프
   	  * LGD_MERTKEY                : 상점MertKey (mertkey는 상점관리자 -> 계약정보 -> 상점정보관리에서 확인하실수 있습니다)
   	  *
   	  * SHA512 해쉬데이터 암호화 검증을 위해
   	  * 토스페이먼츠에서 발급한 상점키(MertKey)를 환경설정 파일(lgdacom/conf/mall.conf)에 반드시 입력하여 주시기 바랍니다.
   	  */
	String configPath = "C:/lgdacom";  //토스페이먼츠에서 제공한 환경파일("/conf/lgdacom.conf,/conf/mall.conf") 위치 지정.
      
	if(System.getProperty("os.name").equals("Linux")){
		configPath = "/lgdacom";
 	}
	
   	 XPayUtil xu = new XPayUtil();
   	 xu.Init(configPath);
   	 String LGD_TIMESTAMP		= xu.GetTimeStamp();
  	 String LGD_HASHDATA		= xu.GetHashDataOpenpay(LGD_VENDERNO, LGD_MID, LGD_OPENPAY_MER_UID, LGD_OPENPAY_TOKEN, LGD_TIMESTAMP);
  	 /*
  	  *************************************************
   	  * 2. SHA512 해쉬암호화 (수정하지 마세요) - END
   	  *************************************************
   	  */
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>설정창 호출</title>
<!-- 개발--> 
<script type="text/javascript" src="https://staging1.paynow.co.kr:27443/openpay/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="https://staging1.paynow.co.kr:27443/openpay/js/jquery.alphanumeric.pack.js"></script>

<!-- 운영 
<script type="text/javascript" src="https://www.paynow.co.kr/openpay/js/jquery-3.3.1.js"></script>
<script type="text/javascript" src="https://www.paynow.co.kr/openpay/js/jquery.alphanumeric.pack.js"></script>
-->
<script type="text/javascript">

var isSubmitPossible = true;        // 중복 처리 차단 해제

$(document).ready(function() {
	
	window.addEventListener("message", closeIframe, false);
	
	$("#setRequest").click(function() {
	    // 연동 주소(테스트)
		var url = 'https://staging1.paynow.co.kr:27443/openpay/web/set/setRequest';
	    // 연동 주소(운영)
		//var url = 'https://www.paynow.co.kr/openpay/web/set/setRequest';
        // 설정창 호출 (창 크기 수정하지 마세요)
        var filter = "win16|win32|win64|mac|macintel";
        alert(navigator.platform);
        if(navigator.platform){
            if(0 > filter.indexOf(navigator.platform.toLowerCase())){
                // 모바일
                var popForm = document.frm;
                window.open("", "openpay_popup");
                popForm.action = url;
                popForm.method = "post";
                popForm.target = "openpay_popup";
                popForm.submit();
            }else{
                // 웹
                openFrame('frm', '357', '667', url);
            }
        }
	});
	
});

// 오픈페이 설정창 영역명
var popupName = "openpay";

// 설정창 오픈
function openFrame(formid, iWinX, iWinY, url){
	var iScreenWidth = screen.availWidth;
    var iScreenHeigth = screen.availHeight;
    var iPointX = parseInt(iWinX, 10)/2;
    var iPointY = parseInt(iWinY, 10)/2;
    var installpop = "";
    installpop += "<div id=\"" + popupName + "_div\" style=\"position:fixed; top:0; left:0; width:100%; height:100%; z-index:20000000000000000000000000;\">";
    installpop += "<div style=\"position:absolute; top:0; left:0; width:100%; height:100%; background:#000; background:url(https://xpay.lgdacom.net/xpay/image/red_v25/common/bg.png); line-height:450px;\"></div>";
    installpop += "<div style=\"width:" + iWinX + "px;height:" + iWinY + "px;border-radius:5px;text-align:center;position:absolute;top:50%;left:50%;margin-left:-" + iPointX + "px;margin-top:-" + iPointY + "px;z-index:20000000000000000000000; background:#fff;\">";
    installpop += "<iframe id=\"" + popupName + "_iframe\" name=\"" + popupName + "_iframe\" src=\"\" width=\"100%\" height=\"100%\" scrolling=\"no\" style=\"width:100%; height:100%; z-index: 20000000000000000000000; border:none; border-radius:5px;\"></iframe>";
    installpop += "</div>";
    installpop += "</div>";
    
    var attachElement = document.body;
    var newDiv;
    newDiv = document.createElement("div");
    newDiv.setAttribute("id", popupName);
    newDiv.innerHTML = installpop;
    attachElement.appendChild(newDiv);
    document.getElementById(formid).method = "post";
    document.getElementById(formid).target = popupName + "_iframe";
    document.getElementById(formid).action = url;
    document.getElementById(formid).submit();
    document.getElementById(popupName).style.display = "";
    return document.getElementById(popupName + "_iframe");
}

// 설정창 클로즈
function closeIframe(event) {
	var element = document.getElementById(popupName);
    element.parentNode.removeChild(element);
}

</script>
</head>
<body>
    <button type="button" id="setRequest" name="merchantRequest">설정요청</button><br>
    <form id="frm" name="frm">
            <table>
                <tbody> 
                    <tr>
                        <td width="30%">LGD_VENDERNO :</td>
                        <td><input type="text" name="corpNumber" value="<%=LGD_VENDERNO%>" style="width:100%;"/></td>
                    </tr>
                    <tr>
                        <td width="30%">LGD_MID : </td>
                        <td><input type="text" name="subMerCode" value="<%=LGD_MID%>" style="width:100%;"/></td>
                    </tr>
                    <tr>
                        <td width="30%">LGD_OPENPAY_MER_UID : </td>
                        <td><input type="text" name="openpayMerchantUserId" value="<%=LGD_OPENPAY_MER_UID%>" style="width:100%;"/></td>
                    </tr>
                    <tr>
                        <td width="30%">LGD_OPENPAY_TOKEN : </td>
                        <td><input type="text" name="loginToken" value="<%=LGD_OPENPAY_TOKEN%>" style="width:100%;"/></td>
                    </tr>
                    <tr>
                        <td width="30%">LGD_TIMESTAMP : </td>
                        <td><input type="text" id="timestamp" name="timestamp" value="<%=LGD_TIMESTAMP%>" style="width:100%;"/></td>
                    </tr>
                    <tr>
                        <td width="30%">LGD_HASHDATA : </td>
                        <td><input type="text" id="hashdata" name="hashdata" value="<%=LGD_HASHDATA%>" style="width:100%;"/></td>
                    </tr>
                </tbody>
            </table>
        </form>
</body>
</html>