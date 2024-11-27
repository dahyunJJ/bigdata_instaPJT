<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
<!-- favicon -->
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
<link rel="icon" type="image/png" sizes="32x32" href="/assets/favicon/favicon-32x32.png"/>
<link rel="icon" type="image/png" sizes="16x16" href="/assets/favicon/favicon-16x16.png"/>
<!-- font-awesome -->
<script src="https://kit.fontawesome.com/14fce7b7fe.js" crossorigin="anonymous"></script>
<!-- 부트스트랩 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<!--    구글 머터리얼 아이콘   -->
<link href="https://fonts.googleapis.com/css?family=Material+Icons|Material+Icons+Outlined|Material+Icons+Two+Tone|Material+Icons+Round|Material+Icons+Sharp" rel="stylesheet">

<link rel="stylesheet" href="/css/egovframework/mypage.css" />
<title>Instagram | 마이페이지</title>

<script type="text/javascript">
	$(document).ready(function() {
		fn_selectMyFeedList();
		
		$("#btn_search").on('click', function(){
			fn_selectMyFeedList();
		});
		
		// 모달 창 외부를 클릭하면 닫히도록 이벤트 추가
		$(".modal-overlay").on("click", function(event) {
		    if ($(event.target).hasClass("modal-overlay")) { 
		        myDetailClose();
		    }
		});
	}); 
	
	function fn_selectMyFeedList() {
		var frm = $("#searchFrm").serialize();
		
	    $.ajax({
	        url: '/main/selectFeedList.do',
	        method: 'post',
	        data: frm,
	        dataType: 'json',
	        success: function (data, status, xhr) {	        	
	            var modalHtml = '';
	            
	            if (data.list.length > 0) {
	                for (var i = 0; i < data.list.length; i++) {
	                	if (data.list[i].createId == "${loginInfo.userId}") {
		                    modalHtml += '<li id="open-modal" style="background-color: #fafafa; border: none;" onclick="javascript:fn_myFeedDetail(\''+data.list[i].feedIdx+'\')">';		                    
		                 	
		                    // 첫 번째 이미지만 출력하도록 수정
	                        if (data.list[i].fileList && data.list[i].fileList.length > 0) {
	                            modalHtml += '<img src="/main/feedImgView.do?fileName=' + data.list[i].fileList[0].saveFileName + '" class="d-block w-100 feed-picture" alt="...">';
	                        }
			                modalHtml += '</li>';	
	                	}
	                }
	            } else {
	                modalHtml += '<li class="post-item"><div style="text-align:center;">작성된 게시물이 없습니다.</div></li>';
	            }

	            $("#feedList").html(modalHtml);
	        },
	        error: function (data, status, err) {
	            console.log(err);
	        }
	    });
	}	
	
	function fn_myFeedDetail(feedIdx) {
		$(".modal-overlay").addClass("active");
		$("body").css("overflow-y", "hidden");
		
		// 모달 외부 클릭 시 닫기 이벤트 추가
	    $(".modal-overlay").on("click", function(event) {
	        // 클릭한 대상이 modal-body가 아닌 경우
	        if (!$(event.target).closest('.modal_body').length) {
	            myDetailClose();
	        }
	    });
		
		$.ajax({
	        url: '/main/getFeedDetail.do',
	        method: 'post',
	        data: {
	        	"feedIdx" : feedIdx
	        },
	        dataType: 'json',
	        success: function (data, status, xhr) {
	        	console.log(data);
	        	
				var modalHtml = '';
		
			    // 모달 내용 생성
			    modalHtml += '  <div id="modal-script" class="modal_body">';
			    modalHtml += '    <div style="display: flex; flex-direction: row;">';
			    /* modalHtml += '      <img class="modal-image" src="https://cdn.nbnnews.co.kr/news/photo/202111/632351_631208_3045.jpg">'; */
			    
			    modalHtml += '<div id="carousel" class="carousel slide" data-bs-touch="false" data-bs-interval="false">';
                modalHtml += '<div class="carousel-inner">';
                
                var fileListLength = data.fileList.length; // fileList의 길이를 변수에 저장
                for (var j = 0; j < fileListLength; j++) {
                    modalHtml += '<div class="carousel-item' + (j === 0 ? ' active' : '') + '">';
                    modalHtml += '<img src="/main/feedImgView.do?fileName=' + data.fileList[j].saveFileName + '" class="d-block w-100 feed-picture detail-img" alt="...">';
                    modalHtml += '</div>';
                }
                modalHtml += '</div>'; // carousel-inner
                if (fileListLength > 1) { // 업로드 된 이미지가 1장이면 슬라이드 버튼 안보이게
                 modalHtml += '<button class="carousel-control-prev" type="button" data-bs-target="#carousel" data-bs-slide="prev">';
                 modalHtml += '<span class="carousel-control-prev-icon" aria-hidden="true"></span>';
                 modalHtml += '<span class="visually-hidden">Previous</span>';
                 modalHtml += '</button>';
                 modalHtml += '<button class="carousel-control-next" type="button" data-bs-target="#carousel" data-bs-slide="next">';
                 modalHtml += '<span class="carousel-control-next-icon" aria-hidden="true"></span>';
                 modalHtml += '<span class="visually-hidden">Next</span>';
                modalHtml += '</button>';
                }
                modalHtml += '</div>'; // carousel
			    
			    modalHtml += '      <div style="display: flex; flex-direction: column; padding:12px;">';
			    modalHtml += '        <div style="display: flex; flex-direction: row; justify-content: space-between; width: 100%; height: 55px; border-bottom: 1px solid #edebeb">';
			    modalHtml += '          <div style="display: flex; flex-direction: row; align-items: center;">';
			    modalHtml += '            <img class="box-profile" src="https://file2.nocutnews.co.kr/newsroom/image/2021/08/12/202108121210585928_12.jpg">';
			    modalHtml += '            <p style="margin: 0 10px 0;">${loginInfo.userId}</p>';
			    modalHtml += '          </div>';
			    modalHtml += '          <div>';
			    modalHtml += '            <button class="btn-open-popup" style="border: none; background-color: white; margin-top: 5px;">';
			    modalHtml += '              <span class="material-icons-outlined" style="margin-right: 15px;">more_horiz</span>';
			    modalHtml += '            </button>';
			    modalHtml += '          </div>';
			    modalHtml += '        </div>';
		
			    modalHtml += '        <div style="display: flex; flex-direction: row; justify-content: space-between; width: 100%; height: 55px;">';
			    modalHtml += '          <div style="display: flex; flex-direction: row; align-items: center;">';
			    modalHtml += '            <img class="box-profile" src="https://file2.nocutnews.co.kr/newsroom/image/2021/08/12/202108121210585928_12.jpg">';
			    modalHtml += '            <p style="margin: 0 10px 0;">${loginInfo.userId}</p>';
			    modalHtml += '            <p style="margin: 0 10px 0;">';
			    modalHtml += '              <span style="font-weight: lighter; color: dodgerblue;">' + data.feedInfo.feedHashtag + '</span>';
			    modalHtml += '            </p>';
			    modalHtml += '          </div>';
			    modalHtml += '        </div>';
			    
			    modalHtml += '<div class="comment-list">';
                for (var k = 0; k < data.commentList.length; k++) {
                    modalHtml += '<div class="comment" id="comment_'+ data.commentList[k].commentIdx +'" style="padding:0;">';
                    modalHtml += '<div class="comment-detail" style="display:flex; align-items:center;">';
                    modalHtml += '<img class="box-profile" src="https://blog.kakaocdn.net/dn/b0ZMMh/btq4eKTyBG4/aVgQqfsq543UByfJSaK0cK/img.jpg">';
                    modalHtml += '<div class="username">' + data.commentList[k].createId + '</div>';
                    modalHtml += '<p style="margin-bottom: 0;">' + data.commentList[k].commentContent + '</p>';
                    modalHtml += '</div>';
                    modalHtml += '<div style="display: flex; align-items: center;">';
                    
                    modalHtml += '<a href="javascript:fn_nestedComment(\''+data.commentList[k].commentIdx+'\');" class="comment-btn">';
                    modalHtml += '답글달기';
                    modalHtml += '</a>';
                    
                  if (data.commentList[k].createId == "${loginInfo.userId}") {
                      modalHtml += '<a href="javascript:fn_commentDelete(\''+data.commentList[k].commentIdx+'\');" class="comment-btn">';
                      modalHtml += '삭제';
                      modalHtml += '</a>';
                  }
                    modalHtml += '<div class="commnet-heart"><i class="fa-regular fa-heart"></i></div>';
                    modalHtml += '</div>';
                    modalHtml += '</div>';
                }
                modalHtml += '</div>';
		
			    /* modalHtml += '        <div style="display: flex; flex-direction: row; justify-content: space-between; width: 450px; height: 620px;">';
			    modalHtml += '          <div style="display: flex; flex-direction: row;">';
			    modalHtml += '            <a href=""><img class="box-profile" src="https://blog.kakaocdn.net/dn/b0ZMMh/btq4eKTyBG4/aVgQqfsq543UByfJSaK0cK/img.jpg"></a>';
			    modalHtml += '            <p style="margin-left: 10px;">BoYoung</p>';
			    modalHtml += '            <p style="font-weight: lighter; margin-left: 10px;">내일배움 캠퍼 모두 파이팅 !!</p>';
			    modalHtml += '          </div>';
			    modalHtml += '        </div>'; */
		
			    modalHtml += '        <div style="">';
			    modalHtml += '          <div style="margin-top: 2%; display: flex; flex-direction: row; justify-content: space-between; border-top: 1px solid #edebeb; height: 30px;">';
			    modalHtml += '            <div>';
			    modalHtml += '              <span class="material-icons-outlined">favorite_border</span>';
			    modalHtml += '              <span class="material-icons-outlined">mode_comment</span>';
			    modalHtml += '              <span class="material-icons-outlined">send</span>';
			    modalHtml += '            </div>';
			    modalHtml += '            <div>';
			    modalHtml += '              <span class="material-icons-outlined">bookmark_border</span>';
			    modalHtml += '            </div>';
			    modalHtml += '          </div>';
		
			    modalHtml += '          <div style="text-align: left; height: 30px;">';
			    modalHtml += '            <span style="font-weight: bold">kyumin1020</span>님 <span style="font-weight: bold">외 62,364명</span>이 좋아합니다';
			    modalHtml += '          </div>';
		
			    modalHtml += '          <div style="font-weight: lighter; font-size: 10px; text-align: left;">' + data.feedInfo.timeDiffer+' 전' + '</div>';
		
			    modalHtml += '          <div style="margin-top: 10px; border-top: solid 1px #dbdbdb; display: flex; justify-content: space-between; align-items: center;">';
			    modalHtml += '            <input type="text" class="form-control" id="commentContent" name="commentContent" placeholder="댓글 달기 ...">';
			    modalHtml += '			  <button class="upload_btn" type="button" onclick="javascript:fn_saveComment(\''+data.feedInfo.feedIdx+'\');">게시</button>';
			    modalHtml += '          </div>';
			    modalHtml += '        </div>';
			    modalHtml += '      </div>';
			    modalHtml += '    </div>';
			    modalHtml += '  </div>';
			    modalHtml += '  <button id="close-modal" class="close-area" onclick="myDetailClose();">X</button>';
			    // 화면에 추가
			    $("#modalOption").html(modalHtml);
			},
		    error: function (data, status, err) {
		        console.log(err);
		    }
		});
	}	
	
	// 모달 아닌 곳 눌러 닫기  
	function myDetailClose() {
		$(".modal-overlay").removeClass("active");
		$("body").css("overflow-y", "visible");
		
		// 이벤트 해제 (팝업이 닫힌 후에도 이벤트가 남지 않도록)
	    $(".modal-overlay").off("click");
	}	 
	
</script>
</head>
<body style="background-color: #fafafa; width: 100%;">
	<header class="global-header">
        <div>
          <h1 class="logo">
            <a href="/main/mainPage.do">
              <img src="/assets/images/logo-light.png" alt="logo" />
            </a>
          </h1>
          
          <form id="searchFrm" name="searchFrm">
			<input type="text" id="searchKeyword" name="searchKeyword" placeholder="#해시태그 검색" class="txt search-txt" />
			<input type="button" id="btn_search" name="btn_search" value="검색" class="btn_blue_l"/>
		  </form>
		  
          <ul class="gnb-icon-list">
            <li class="post-upload-btn">
              <i class="fa-regular fa-square-plus"></i>
            </li>
            <li>
              <i class="fa-regular fa-compass"></i>
            </li>
            <li>
              <i class="fa-regular fa-heart"></i>
            </li>
            <li>
              <i class="fa-solid fa-magnifying-glass"></i>
            </li>
          </ul>
        </div>
      </header>
	<!-- 상단 프로필 페이지-------------------------------------------------------------------------------------------------->
	<div
		style="top: 95px; position: relative; height: 230px; max-width: 950px; width: 100%; margin: auto; display: flex; flex-direction: row;">
		<!--  --------------------      프로필 사진------------------------------------------------------------------------->
		<div style="margin-left: 90px;">
			<div class="main-profile">
				<img class="profile" src="https://file2.nocutnews.co.kr/newsroom/image/2021/08/12/202108121210585928_12.jpg" alt="profile-img"/>
			</div>
		</div>
		<!-----------------------    프로필 정보----------------------------------------------------------------------------->
		<div style="display: flex; flex-direction: row; margin-left: 80px;">
			<div style="margin-left: 10px">
				<h2 style="font-weight: lighter;">${loginInfo.userId}</h2>
				<div style="display: flex; flex-direction: row; margin-top: 20px;">
					<div>
						게시물 <span style="font-weight: bold">9</span>
					</div>
					<div style="margin-left: 40px;">
						팔로워 <span style="font-weight: bold">100k</span>
					</div>
					<div style="margin-left: 40px;">
						팔로우 <span style="font-weight: bold">150</span>
					</div>
				</div>
				<div style="display: flex; margin-top: 20px; font-weight: bold;">${loginInfo.name}</div>

			</div>
			<!--    -------------     프로필 편집 세팅 버튼------------------------------------------------------------------->
			<div
				style="margin-left: -160px; margin-top: 5px; display: flex; flex-direction: row;">
				<div>
					<button
						style="background-color: #fafafa; border: 1px solid #c7c7c7; border-radius: 3px; font-weight: bold; padding: 3px 8px 3px 8px; font-size: 14px;">
						프로필 편집</button>
				</div>
				<div>
					<button
						style="border: none; background-color: #fafafa; margin-left: 10px;">
						<span class="material-icons-outlined">settings</span>
					</button>
				</div>
			</div>
		</div>
	</div>
	<!------------------------       개인 게시글 페이지---------------------------------------------------------------------->
	<div
		style="border-top: 1px solid #c7c7c7; max-height: 1000px; height: 100%; max-width: 895px; width: 100%; margin: auto; position: relative; top: 70px;">
		<!--                 테두리 아래, 아이콘, 텍스트-------------------------------------------------------------------------->
		<div
			style="display: flex; flex-direction: row; justify-content: center;">
			<span class="material-icons-outlined" style="margin: 10px 0 0 20px;">grid_on</span>
			<div style="font-size: 12px; margin-top: 12px; margin-left: 5px;">
				<button style="background-color: #fafafa; border: none">게시물</button>
			</div>
			<span class="material-icons-outlined" style="margin: 10px 0 0 40px;">bookmark_border</span>
			<div style="font-size: 12px; margin-top: 12px; margin-left: 5px;">
				<button style="background-color: #fafafa; border: none">저장됨</button>
			</div>
			<span class="material-icons-outlined" style="margin: 10px 0 0 40px;">account_box</span>
			<div style="font-size: 12px; margin-top: 12px; margin-left: 5px;">
				<button style="background-color: #fafafa; border: none">태그됨</button>
			</div>
		</div>
		<!------------------     게시글---------------------------------------------------------------------------------------->
		<ul class="feed-list" id="feedList" name="feedList">
			<!-- 로그인 한 사용자가 작성한 게시물 표시 -->
		</ul>
	</div>

	<!-----------모달 댓글창------------------------------------------------------------------------------------------------------>
	<div id="modalOption" class="modal-overlay" style="">
		<!-- 모달 창 영역 표시 -->
	</div>

	<!-- Option 1: Bootstrap Bundle with Popper -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
		crossorigin="anonymous"></script>
</body>
</html>