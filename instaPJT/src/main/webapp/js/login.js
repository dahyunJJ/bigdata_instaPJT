$(document).ready(function() {

function updateInputState(input, activeVar) {
  // trim() : 공백 제거
  if (input.value.trim().length > 0) {
    input.parentElement.classList.add("active");
    activeVar = true;
  } else {
    input.parentElement.classList.remove("active");
    activeVar = false;
  }

  return activeVar;
}

let userId = document.getElementById("userId");
let userPw = document.getElementById("userPw");

let idActive = (pwActive = false); // 복합대입연산자

let submitBtn = document.getElementById("btn_login");

function handleInput(e) {
  // e.target : 이벤트가 일어나는 대상
  let input = e.target;
  let type = input.getAttribute("type");

  if (type == "text") {
    idActive = updateInputState(input, idActive);
  } else {
    pwActive = updateInputState(input, pwActive);
  }

  // 아이디, 비밀번호 모두 입력하면 로그인 버튼 활성화
  if (idActive && pwActive) {
    submitBtn.removeAttribute("disabled");
  } else {
    submitBtn.setAttribute("disabled", true);
  }
}

userId.addEventListener("keyup", handleInput);
userPw.addEventListener("keyup", handleInput);

// 비밀번호 표시 or 숨기기
let pwVisible = document.getElementById("pw-visible");

function pwMode() {
  if (userPw.getAttribute("type") == "password") {
    userPw.setAttribute("type", "text");
    pwVisible.innerHTML = `숨기기`;
  } else {
    userPw.setAttribute("type", "password");
    pwVisible.innerHTML = `비밀번호 표시`;
  }
}

pwVisible.addEventListener("click", pwMode);

// 다크모드
let body = document.querySelector("body");
let modeBtn = document.getElementById("mode-toggle");

function modeToggle(e) {
  e.preventDefault();
  body.classList.toggle("dark");

  // 삼항연산자 활용하기
  modeBtn.innerHTML = body.classList.contains("dark")
    ? `Lightmode`
    : `Darkmode`;
}

modeBtn.addEventListener("click", modeToggle);

});
