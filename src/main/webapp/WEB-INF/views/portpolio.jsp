<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html lang="en">

<head>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>Project Portpolio</title>

  <!-- Bootstrap core CSS -->
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/vendor/bootstrap/css/bootstrap.css">

  <!-- Custom fonts for this template -->
  <link href="https://fonts.googleapis.com/css?family=Saira+Extra+Condensed:500,700" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css?family=Muli:400,400i,800,800i" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/vendor/fontawesome-free/css/all.min.css">

  <!-- Custom styles for this template -->
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/resume.min.css">
	
  <style>
  	td {padding-right:15px;]}
  </style>
</head>

<body id="page-top">

  <nav class="navbar navbar-expand-lg navbar-dark bg-primary fixed-top" id="sideNav">
    <a class="navbar-brand js-scroll-trigger" href="#page-top">
      <span class="d-none d-lg-block">
        <!--img class="img-fluid img-profile rounded-circle mx-auto mb-2" src="img/profile.jpg" alt=""-->
      </span>
    </a>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link js-scroll-trigger" href="#about">About Me</a>
        </li>
        <li class="nav-item">
          <a class="nav-link js-scroll-trigger" href="#lab">실습실 예약 웹 애플리케이션</a>
        </li>
        <li class="nav-item">
          <a class="nav-link js-scroll-trigger" href="#lunar_calendar">Lunar Calendar</a>
        </li>
        <li class="nav-item">
          <a class="nav-link js-scroll-trigger" href="#speed_camera">Speed Camera</a>
        </li>
        <li class="nav-item">
          <a class="nav-link js-scroll-trigger" href="#sound_classifier">Sound Classifier</a>
        </li>
      </ul>
    </div>
  </nav>

  <div class="container-fluid p-0">

    <section class="resume-section p-3 p-lg-5 d-flex align-items-center" id="about">
      <div class="w-100">
        <h1 class="mb-0">Lee Won Jun's
          <span class="text-primary">Project Portpolio</span>
        </h1>
        <div class="subheading mb-5">경상남도 김해시 분성로 14 · +82 10 2823 7618 ·
          <a href="mailto:name@email.com">rhkdqhrehddl@naver.com</a>
        </div>
        <table class="lead mb-5">
        	<tr>
        		<td rowspan="6" style="margin-right:30px;">
        			<img src="${pageContext.request.contextPath}/resources/images/portpolio.jpg" width="500px" height="600px">
        		</td>
        		<td>
        			Age
        		</td>
        		<td>
        			29 (1994-08-15)
        		</td>
        	</tr>
        	<tr>
        		<td>
        			Main Language
        		</td>
        		<td>
        			Java, Python
        		</td>
        	</tr>
        	<tr>
        		<td>
        			Available Technology
        		</td>
        		<td>
        			JSP, Spring Framework, Big Data, Machine Learning, Raspberry Pi
        		</td>
        	</tr>
        	<tr>
        		<td rowspan="3">
        			Education
        		</td>
        		<td>
        			김해가야고등학교 (문과, 2010. 3 ~ 2013. 2)
        		</td>
        	</tr>
        	<tr>
				<td>
					연암공과대학교 (스마트소프트웨어학과, 2013. 3 ~ 2019. 2)
				</td>
			</tr>
			<tr>
				<td>
					연암공과대학교 (스마트소프트웨어학과[학사학위전공심화과정]), 2019. 3 ~ 2020. 2)
				</td>
			</tr>
        </table>
      </div>
    </section>

    <hr class="m-0">

    <section class="resume-section p-3 p-lg-5 d-flex justify-content-center" id="lab">
      <div class="w-100">
        <h2 class="mb-5">실습실 예약 웹 애플리케이션</h2>

        <div class="resume-item d-flex flex-column flex-md-row justify-content-between mb-5">
          <div class="resume-content">
            <h3 class="mb-0">:  실습실 예약절차를 웹 애플리케이션으로 구현 </h3>
            <table width="1000" align="center">
				<tr>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/jav.png" width="200px" height="300px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/jsp.png" width="300px" height="300px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/html5.png" width="300px" height="300px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/mysql.jpg" width="300px" height="300px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/json.gif" width="300px" height="300px">
					</td>
				</tr>
				<tr>
					<td colspan="5">
						개발 동기 : 저녁이나 주말에 실습실을 사용하기 위한 실습실 예약의 번거로움을 해소하기 위해 실습실 예약 기능을 웹 애플리케이션으로 제작하였습니다.	</br>
						개발 환경 : JAVA, JSP, HTML5, mysql, json	</br>
						개발 인원 : 9명	</br>
						맡은 역할 : 관리자 페이지를 구현하는 팀의 팀장으로써, 관리자 페이지에서 제공하는 여러 기능들을 구현하였습니다.</br>
						개발 기간 : 3개월 (2016. 9 ~ 2016. 11)	</br>
						주요 기능	</br>
						1. 사용자(학생) : 실습실 예약 현황 확인, 실습실 예약, 예약 사항 변경 등	</br>
						2. 관리자(조교) : 예약 신청 현황 확인, 예약 승인/거부 및 SMS 전송등	</br>
						개발기간 : 2 ~ 3 개월 </br>
						<a href="http://localhost:8080/Lab/login.jsp">관련 Link</a>	</br>
					</td>
				</tr>
			</table>
		  </div>
        </div>
      </div>
    </section>

    <hr class="m-0">

    <section class="resume-section p-3 p-lg-5 d-flex align-items-center" id="lunar_calendar">
      <div class="w-100">
        <h2 class="mb-5">Lunar Calendar</h2>

        <div class="resume-item d-flex flex-column flex-md-row justify-content-between mb-5">
          <div class="resume-content">
            <h3 class="mb-0">: Android Application으로 구현한 음력 달력</h3>
            
			<table width="1000" align="center">
				<tr>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/calendar1.jpg" width="250px" height="400px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/calendar2.jpg" width="250px" height="400px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/calendar3.jpg" width="250px" height="400px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/calendar4.jpg" width="250px" height="400px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/calendar5.jpg" width="250px" height="400px">
					</td>
				</tr>
				<tr>
					<td colspan="5">
						개발 동기 : 양력만을 이용하여 일정을 등록하는 기존 달력 어플들과의 차별점을 두기 위하여 음력날짜를 이용해 여러가지 기능을 제공하고자 개발해보았습니다.</br>
						개발 환경 : JAVA, Android Studio	</br>
						개발 인원 : 1명	</br>
						개발 기간 : 6주 (2018. 4 ~ 2018. 5)	</br>
						주요 기능 	</br>
						1. ChineseCalendar API를 이용하여 양력 날짜와 함께 음력날짜를 출력해줍니다.	</br>
						2. VerticalViewPager를 이용하여 위 아래로 슬라이드함에 따라 페이지에 출력되는 달의 저번 달이나 다음 달의 달력을 보여줍니다. </br>
						3. 해당 날짜를 클릭하여 양력 또는 음력으로 원하는 날에 일정을 추가할 수 있습니다. 	</br>
						4. 등록해둔 일정 하루 전 날 정오에 일정에 대한 알림을 보냅니다.		</br>
						<a href="https://onestore.co.kr/userpoc/apps/view?pid=0000729341">One Store Link</a>
					</td>
				</tr>
			</table>
		  </div>
        </div>
      </div>
    </section>

    <hr class="m-0">

    <section class="resume-section p-3 p-lg-5 d-flex align-items-center" id="speed_camera">
      <div class="w-100">
        <h2 class="mb-5">Speed Camera</h2>

        <div class="resume-item d-flex flex-column flex-md-row justify-content-between mb-5">
          <div class="resume-content">
            <h3 class="mb-0">: Raspberry Pi와 적외선 센서를 이용한 과속 카메라</h3>
            
			<table width="1000" align="center">
				<tr>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/camera_outer1.jpg" width="300px" height="300px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/camera_outer2.jpg" width="300px" height="300px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/camera_outer3.jpg" width="300px" height="300px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/camera_android.jpg" width="300px" height="400px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/camera_android2.png" width="300px" height="400px">
					</td>
				</tr>
				<tr>
					<td colspan="5">
						개발 동기 : 학교 정문 쪽을 통과하는 차량들의 속도 규제하고자 라즈베리파이와 적외선 센서를 이용해 과속카메라를 제작해보았습니다.	</br>
						개발 환경 : 라즈베리파이 - Python, 안드로이드 애플리케이션 - Java, Android Studio	</br>
						개발 인원 : 2명	</br>
						맡은 역할 : 적외선 센서를 이용한 속도 측정, 제한 속도 초과시 사진 촬영 및 안드로이드 기기와의 블루투스 통신 구현	</br>
						개발 기간 : 2개월 (2018. 4 ~ 2018. 6)	</br>
						주요 기능	</br>
						1. 두 개의 적외선 센서를 이용해 지나가는 차량의 속도를 측정합니다. (속도 = 거리/시간)	</br>
						2. picamera 모듈을 이용해 규정 속도를 초과하는 차량의 사진을 촬영합니다.	</br>
						3. bluetooth 모듈을 이용해 안드로이드 기기로 차량의 사진과 속도를 전송합니다. [소켓 통신]	</br>
						4. 안드로이드 애플리케이션에서는 연결 버튼을 눌러 라즈베리파이와 블루투스 연결작업을 수행합니다.	</br>
						5. 차량의 사진이 전송된 후 저장 버튼을 누르면 안드로이드 기기의 화면이 캡쳐되어 저장됩니다.
					</td>
				</tr>
			</table>
		  </div>
        </div>
      </div>
    </section>

    <hr class="m-0">

    <section class="resume-section p-3 p-lg-5 d-flex align-items-center" id="sound_classifier">
      <div class="w-100">
        <h2 class="mb-5">Sound Classifier</h2>
        <div class="resume-item d-flex flex-column flex-md-row justify-content-between mb-5">
          <div class="resume-content">
            <h3 class="mb-0">: 음성파일 속 목소리를 통해 화자의 성별과 연령대를 예측</h3>
            
			<table width="1000" align="center">
				<tr>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/common_voice.jpg" width="300px" height="250px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/Hadoop-Streaming-in-Python.png" width="300px" height="250px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/python.jpg" width="400px" height="250px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/librosa.png" width="250px" height="250px">
					</td>
					<td>
						<img src="${pageContext.request.contextPath}/resources/images/tensorflow.jpg" width="250px" height="250px">
					</td>
				</tr>
				<tr>
					<td colspan="5">
						개발 동기 : 최근들어 음성인식이나 스마트 스피커와 같이 사람의 목소리를 이용한 기술들이 다양하게 사용되어지기 때문에, 대용량의 음성 파일을 다루어 볼 필요성을 느껴 프로젝트를 진행해 보았습니다.	 </br>
						개발 환경 : 주파수 분석 - Hadoop Streaming with Python, Machine Learing - Tensorflow, librosa, Python	</br>
						개발 인원 : 1명 	</br>
						개발 기간 : 7주 (2018. 11 ~ 2018. 12)	 </br>
						프로젝트 진행과정	</br>
						1. Mozila사의 오픈 프로젝트인 'Common Voice'를 통해 음성파일을 수집하였습니다.	</br>
						2. 라벨링이 되어있는 음성파일에서 주파수 스펙트럼을 추출하여 필터링 작업을 진행했습니다.	</br>
						3. 필터링된 주파수 스펙트럼들을 분석하며 연령별 / 성별에 따라 주파수 스펙트럼의 분포를 분석하였습니다.	</br>
						4. 스펙트럼을 분석한 결과를 바탕으로 하둡 스트리밍을 이용하여 라벨링이 되어있지 않은 음성파일들의 라벨링 작업을 수행하였습니다.	</br>
						5. tensorflow를 이용하여 RNN 모델을 만든 후 라벨링된 음성파일들을 학습시켰습니다.	</br>
						6. 학습된 모델을 불러와 임의의 음성파일을 입력으로 주어 화자의 성별과 연령대를 예측합니다.	</br>
						7. 학습된 모델의 정확성을 테스트하는 기능과 기존 모델에 학습되지 않은 음성파일을 학습시키는 기능도 구현하였습니다.
					</td>
				</tr>
			</table>
		  </div>
        </div>
      </div>
    </section>

    <hr class="m-0">

  </div>

  <!-- Bootstrap core JavaScript -->
  <script src="<c:url value="/resources/vendor/jquery/jquery.min.js" />">
  <script src="<c:url value="/resources/vendor/bootstrap/js/bootstrap.bundle.min.js" />">

  <!-- Plugin JavaScript -->
  <script src="<c:url value="/resources/vendor/jquery-easing/jquery.easing.min.js" />">

  <!-- Custom scripts for this template -->
  <script src="<c:url value="/resources/js/resume.min.js" />">

</body>

</html>
