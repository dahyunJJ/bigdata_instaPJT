<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<!-- favicon -->
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
<link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon/favicon-32x32.png" />
<link rel="icon" type="image/png" sizes="16x16" href="/assets/favicon/favicon-16x16.png" />
<link rel="stylesheet" href="/css/egovframework/login.css" />
<script src="<c:url value='/js/login.js'/>"></script>
<title>Instagram | 로그인</title>
<script type="text/javascript">
	$(document).ready(function() {
		$("#btn_login").on('click', function() {
			fn_login();
		})
	})

	function fn_createAccount() {
		var frm = $("#loginFrm");
		frm.attr("action", "/join.do");
		frm.submit();
	}
	
	function fn_login() {
		var frm = $("#loginFrm");
		var userId = $("#userId").val();
		var userPw = $("#userPw").val();
		
		if (userId === "") {
			alert("사용자 이름을 입력해주세요.");
			return;
		} else if (userPw === "") {
			alert("비밀번호를 입력해주세요.");
			return;
		} else {
			frm.attr("method", "POST");
			frm.attr("action", "/member/loginAction.do");
			frm.submit();
		}
	}
	
	/* function fn_findIdView() {
		var frm = $("#frm");		
		frm.attr("method", "POST");
		frm.attr("action", "/findIdView.do");
		frm.submit();
	} */
	
	function fn_findPwView() {
		var frm = $("#loginFrm");		
		frm.attr("method", "POST");
		frm.attr("action", "/findPwView.do");
		frm.submit();
	}
	
</script>
</head>
<body>
<div class="wrapper">
      <div class="form-container">
        <div class="box input-box">
          <h1 class="logo">
            <a class="light-logo" href="#">
              <img src="/assets/images/logo-light.png" alt="insta-logo-light" />
            </a>
            <a class="dark-logo" href="#">
              <img src="/assets/images/logo-dark.png" alt="insta-logo-dark" />
            </a>
          </h1>

          <form id="loginFrm" class="loginFrm" action="/member/loginAction.do">
            <div class="animate-input">
              <!-- <input id="userId" type="text" autocomplete="user-id" />
              <span>전화번호, 사용자 이름 또는 이메일</span> -->
              <input id="userId" name="userId" type="text" />
              <span>아이디를 입력하세요</span>
            </div>
            <div class="animate-input userpw">
              <input id="userPw" name="userPw" type="password" />
              <span>비밀번호</span>
              <button id="pw-visible" type="button">비밀번호 표시</button>
            </div>
            <button id="btn_login" class="btn-blue" type="submit" disabled>로그인</button>
          </form>

          <div class="or-box">
            <div></div>
            <div>또는</div>
            <div></div>
          </div>

          <div class="fb-btn">
            <a href="#">
              <img src="/assets/images/facebook-icon.png" alt="facebook-icon"/>
              <span>Facebook으로 로그인</span>
            </a>
          </div>

          <a href="javascript:fn_findPwView();" class="forgot-pw">비밀번호를 잊으셨나요?</a>
        </div>

        <div class="box join-box">
          <p> 계정이 없으신가요?
            <a href="javascript:fn_createAccount();"><span>가입하기</span></a>
          </p>
        </div>

        <p class="app-txt">앱을 다운로드하세요.</p>
        <div class="app-down">
          <a href="#">
            <img src="/assets/images/app-store.png" alt="app-store" />
          </a>
          <a href="#">
            <img src="/assets/images/gg-play.png" alt="google-play" />
          </a>
        </div>
      </div>

      <footer>
        <ul class="footer-menu-list">
          <li><a href="#">Meta</a></li>
          <li><a href="#">소개</a></li>
          <li><a href="#">블로그</a></li>
          <li><a href="#">채용 정보</a></li>
          <li><a href="#">도움말</a></li>
          <li><a href="#">API</a></li>
          <li><a href="#">개인정보처리방침</a></li>
          <li><a href="#">약관</a></li>
          <li><a href="#">인기 계정</a></li>
          <li><a id="mode-toggle" href="#">Darkmode</a></li>
        </ul>

        <p class="copyright">© 2023 Instagram from Meta</p>
      </footer>
    </div>
    
    <%-- <script src="<c:url value='/js/login.js'/>"></script> --%>
</body>
</html>