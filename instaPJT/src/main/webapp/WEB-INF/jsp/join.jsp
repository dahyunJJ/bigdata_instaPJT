<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"
	integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
	crossorigin="anonymous"></script>
<!-- favicon -->
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
<link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon/favicon-32x32.png" />
<link rel="icon" type="image/png" sizes="16x16" href="/assets/favicon/favicon-16x16.png" />
<!-- font-awesome -->
<script src="https://kit.fontawesome.com/14fce7b7fe.js" crossorigin="anonymous"></script>
<link rel="stylesheet" href="/css/egovframework/join.css" />
<!-- <script src="/js/join.js" defer></script> -->
<title>Instagram | 회원가입</title>
<script type="text/javascript">
	$(document).ready(function() {
		$("#btn_idChk").on('click', function() {
			fn_idChk();
		});
	});

	function fn_join() {
		var userEmail = $("#userEmail").val();
		var userName = $("#userName").val();
		var userId = $("#userId").val();
		var userPw = $("#userPw").val();

		if (userEmail === "") {
			alert("이메일 주소를 입력해주세요.");
			return;
		} else if (userName === "") {
			alert("이름을 입력해주세요.");
			return;
		} else if (userId === "") {
			alert("사용자 이름을 입력해주세요.");
			return;
		} else if (userPw === "") {
			alert("비밀번호를 입력해주세요.");
			return;
		} else {
			// 회원가입이 되는 부분
			var frm = $("#joinFrm").serialize();
			$.ajax({
			    url: "/member/insertMember.do",
			    method: 'post',
			    data : frm,
			    dataType : 'json',
			    success: function (data, status, xhr) {
			    	console.log(data);			    	
			        if(data.resultChk > 0) {
			        	alert("회원 가입이 완료되었습니다!");
			        	location.href = "/login.do";
			        } else {
			        	alert("회원 가입에 실패하였습니다.");
			        	return;
			        }
			    },
			    error: function (data, status, err) {
			    	console.log(err);
			    }
			});
			
		}
	};
	
	function fn_idChk() {
		var accountId = $("#accountId").val();
		if(accountId === "") {
			alert("중복 검사할 아이디를 입력해주세요.");
		} else {
			$.ajax({
			    url: '/member/idChk.do',
			    method: 'post',
			    data : {
			    	'accountId' : accountId
			    },
			    dataType : 'json',
			    success: function (data, status, xhr) {
			        console.log(data);
			        if(data.idChk > 0) {
			        	alert("이미 등록된 아이디입니다.");
			        	return;
			        } else {
			        	$("#idChkYn").val('Y');
			        	alert("사용 가능한 아이디입니다.");
			        }
			    },
			    error: function (data, status, err) {
			    }
			});
		}
	};
	
	function fn_goLogin() {
		var frm = $("#joinFrm");
		frm.attr("action", "/login.do")
		frm.submit();
	}
</script>
</head>
<body>
	<div class="wrapper">
      <div class="form-container">
        <div class="box input-box">
          <h1 class="logo">
            <img
              src="/assets/images/logo-light.png"
              alt="insta-logo"
              class="logo-light"
            />
          </h1>

          <p class="join-para">친구들의 사진과 동영상을 보려면 가입하세요.</p>

          <button class="btn-blue fb-btn">
            <i class="fa-brands fa-square-facebook"></i>
            <span>Facebook으로 로그인</span>
          </button>

          <div class="or-box">
            <div></div>
            <div>또는</div>
            <div></div>
          </div>

          <form action="" name="joinFrm" id="joinFrm">
            <div class="animate-input">
              <span>이메일 주소</span>
              <input id="userEmail" name="userEmail" type="text" />
            </div>

            <div class="animate-input">
              <span>성명</span>
              <input id="userName" name="userName" type="text" />
            </div>

            <div class="animate-input">
              <span>사용자 이름</span>
              <input id="userId" name="userId" type="text" />
            </div>

            <div class="animate-input">
              <span>비밀번호</span>
              <input id="userPw" name="userPw" type="password" />
              <button id="pw-btn" type="button">비밀번호 표시</button>
            </div>

            <p class="more-info">저희 서비스를 이용하는 사람이 회원님의 연락처 정보를 Instagram에 업로드했을 수도 있습니다.
              <a href="">더 알아보기</a>
            </p>

            <button id="join-btn" type="button" class="btn-blue" onclick="fn_join();" disabled>가입하기</button>
          </form>
        </div>

        <div class="box join-box">
          <p>계정이 있으신가요?
            <a href="javascript:fn_goLogin();">로그인</a>
          </p>
        </div>

        <div class="app-download">
          <p>앱을 다운로드하세요.</p>
          <div class="store-link">
            <a href="">
              <img src="/assets/images/app-store.png" alt="app-store-img" />
            </a>
            <a href="">
              <img src="/assets/images/gg-play.png" alt="gg-play-img" />
            </a>
          </div>
        </div>
      </div>

      <footer>
        <ul class="links">
          <li><a href="">Meta</a></li>
          <li><a href="">소개</a></li>
          <li><a href="">블로그</a></li>
          <li><a href="">채용 정보</a></li>
          <li><a href="">도움말</a></li>
          <li><a href="">API</a></li>
          <li><a href="">개인정보처리방침</a></li>
          <li><a href="">약관</a></li>
          <li><a href="">위치</a></li>
          <li><a href="">Instagram Lite</a></li>
          <li><a href="" id="mode-toggle">Darkmode</a></li>
        </ul>
        <p class="copyright">© 2024 Instagram from Meta</p>
      </footer>
    </div>
    
	<script src="<c:url value='/js/join.js'/>"></script>
</body>
</html>