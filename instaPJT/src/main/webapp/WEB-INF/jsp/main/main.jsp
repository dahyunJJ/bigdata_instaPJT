<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
      integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<!--    구글 머터리얼 아이콘   -->
<link href="https://fonts.googleapis.com/css?family=Material+Icons|Material+Icons+Outlined|Material+Icons+Two+Tone|Material+Icons+Round|Material+Icons+Sharp" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.sandbox.google.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"/>

<link rel="stylesheet" href="/css/egovframework/main.css" />
<title>Instagram | 메인페이지</title>

<script type="text/javascript">
/* 파일 업로드 관련 변수 */
var fileCnt = 0;
var totalCnt = 10;
var fileNum = 0; // 현재 등록되어 있는 파일 갯수
var content_files = new Array(); // 선택한 파일을 담는 배열
var deleteFiles = new Array(); // 삭제 할 파일을 가지고 있는 배열
/* 파일 업로드 관련 변수 */

	$(document).ready(function(){
		fn_selectList();
		
		$("#btn_search").on('click', function(){
			fn_selectList();
		});
		
		$("#btn_save").on('click', function(){
			fn_save();
		});
		
		/* 수정 버튼 */
	    $("#btn_update").on('click', function(){
	    	$("#statusFlag").val("U");
	    	fn_save();
	    });
		
	    $(".post-upload-btn").on("click", function(){
	    	let postIconBox = document.querySelector('.postIconBox');
	        postIconBox.style.display = 'block';
	        
	    	$(".upload-wrapper").addClass("active");
	    	fn_init();
	    });
					
		$("#fileUpload").on("change", function(e){
			var files = e.target.files;
			// 파일 배열 담기
			var filesArr = Array.prototype.slice.call(files);
			//파일 개수 확인 및 제한
			if(fileCnt + filesArr.length > totalCnt){
				alert("파일은 최대 "+totCnt+"개까지 업로드 할 수 있습니다.");
				return;
			}else{
				fileCnt = fileCnt+ filesArr.length;
			}
			
			// 각각의 파일 배열 담기 및 기타
			filesArr.forEach(function (f){
				var reader = new FileReader();
				reader.onload = function (e){
					// 선택한 파일을 content_files 배열에 push
					content_files.push(f);
					//console.log(f);
					$("#uploadFileList").append(
								'<div id="file'+fileNum+'" style="float:left;">'
								+'<font style="font-size:12px">'
			                     +'<a href="javascript:fn_imgView(\''+fileNum+'\', \'I\');">'
			                     + f.name
			                     + '</a></font>'
			                     +'<a href="javascript:fileDelete(\'file'+fileNum+'\',\'\')">X</a>'
			                     +'</div>'

					);
					fileNum++;
				};
				let postIconBox = document.querySelector('.postIconBox');
	            postIconBox.style.display = 'none';
				reader.readAsDataURL(f);
			});
			//초기화한다.
			//$("#fileUpload").val("");
		}); 		
	});
		
	function fn_selectList(){
		var frm = $("#searchFrm").serialize();
		
		$.ajax({
		    url: '/main/selectFeedList.do',
		    method: 'post',
		    data : frm,
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	// console.log(data.list[0].createId);
		    	// console.log(data.list);
				// console.log("${loginInfo.userId}");
		    	
		    	var postsHtml = '';
	            if (data.list.length > 0) {
	                for (var i = 0; i < data.list.length; i++) {
	                    postsHtml += '<li class="post-item">';
	                    postsHtml += '<div class="profile">';
	                    postsHtml += '<div class="profile-img">';
	                    postsHtml += '<img src="' + data.list[i].profileImage + '" alt="프로필이미지" />';
	                    postsHtml += '</div>';
	                    postsHtml += '<div class="profile-txt">';
	                    postsHtml += '<div class="username">' + data.list[i].createId + '</div>';
	                    postsHtml += '<div class="location">' + data.list[i].location + '</div>';
	                    postsHtml += '</div>';
	                    
	                    // 더보기 메뉴 2가지 방식 처리
	                    var loginId = "${loginInfo.userId}";   // 로그인한 사용자 ID
	            		var createId = data.list[i].createId; // 게시물 작성자 ID
	                    
	            		if(loginId == createId) {
		            		postsHtml += '<button class="option-btn" type="button" onclick="javascript:fn_moreOptionTrue(\''+data.list[i].feedIdx+'\');">';	            				            			
	            		} else {
		            		postsHtml += '<button class="option-btn" type="button" onclick="javascript:fn_moreOptionFalse(\''+data.list[i].feedIdx+'\');">';	            			
	            		}
	                    
	                    postsHtml += '<i class="fa-solid fa-ellipsis"></i>';
	                    postsHtml += '</button>';
	                    postsHtml += '</div>';

	                    postsHtml += '<div id="carousel' + i + '" class="carousel slide" data-bs-touch="false" data-bs-interval="false" style="height: 600px;">';
	                    postsHtml += '<div class="carousel-inner">';
	                    
	                    var fileListLength = data.list[i].fileList.length; // fileList의 길이를 변수에 저장
	                    for (var j = 0; j < fileListLength; j++) {
	                        postsHtml += '<div class="carousel-item' + (j === 0 ? ' active' : '') + '">';
	                        postsHtml += '<img src="/main/feedImgView.do?fileName=' + data.list[i].fileList[j].saveFileName + '" class="d-block w-100 feed-picture" alt="...">';
	                        postsHtml += '</div>';
	                    }
	                    postsHtml += '</div>'; // carousel-inner
	                    if (fileListLength > 1) { // 업로드 된 이미지가 1장이면 슬라이드 버튼 안보이게
		                    postsHtml += '<button class="carousel-control-prev" type="button" data-bs-target="#carousel' + i + '" data-bs-slide="prev">';
		                    postsHtml += '<span class="carousel-control-prev-icon" aria-hidden="true"></span>';
		                    postsHtml += '<span class="visually-hidden">Previous</span>';
		                    postsHtml += '</button>';
		                    postsHtml += '<button class="carousel-control-next" type="button" data-bs-target="#carousel' + i + '" data-bs-slide="next">';
		                    postsHtml += '<span class="carousel-control-next-icon" aria-hidden="true"></span>';
		                    postsHtml += '<span class="visually-hidden">Next</span>';
	                    postsHtml += '</button>';
	                    }
	                    postsHtml += '</div>'; // carousel

	                    postsHtml += '<div class="post-icons">';
	                    postsHtml += '<div>';
	                    
	                    // 좋아요 상태에 대한 style
	                    if(data.list[i].likeYn == 'N') {
	                    	postsHtml += '<span class="post-heart" onclick="javascript:fn_feedLike(\''+data.list[i].feedIdx+'\',\'I\');">';
	                    	postsHtml += '<i class="fa-regular fa-heart" aria-hidden="true"></i>';
	                    	postsHtml += '</span>';
	                    } else {
	                    	postsHtml += '<span class="post-heart active" style="color: tomato;" onclick="javascript:fn_feedLike(\''+data.list[i].feedIdx+'\',\'U\');">';
	                    	postsHtml += '<i class="fa-solid fa-heart" aria-hidden="true"></i>';
	                    	postsHtml += '</span>';
	                    }
	                    
	                    postsHtml += '<span><i class="fa-regular fa-comment"></i></span>';
	                    postsHtml += '</div>';
	                    postsHtml += '<span><i class="fa-regular fa-bookmark"></i></span>';
	                    postsHtml += '</div>';

	                    postsHtml += '<div class="post-likes">좋아요 <span id="like-count">' + data.list[i].likeCount + '</span> 개</div>';
						
	                    postsHtml += '<div class="post-content" style="padding:0 10px;">';
	                    postsHtml += '<p id="feed-count">' + data.list[i].feedContent + '</p>';
                        postsHtml += '</div>';

                        postsHtml += '<div class="post_hashtag" style="padding:0 10px;">';
                        postsHtml += '<span id="feed_hashtag" style="font-weight: lighter; color: dodgerblue;">' + data.list[i].feedHashtag + '</span>';
                        postsHtml += '</div>';
	                    
	                    postsHtml += '<div class="comment-list">';
	                    for (var k = 0; k < data.list[i].commentList.length; k++) {
	                        postsHtml += '<div class="comment" id="comment_'+ data.list[i].commentList[k].commentIdx +'">';
	                        postsHtml += '<div class="comment-detail">';
	                        postsHtml += '<div class="username">' + data.list[i].commentList[k].createId + '</div>';
	                        postsHtml += '<p style="margin-bottom: 0;">' + data.list[i].commentList[k].commentContent + '</p>';
	                        postsHtml += '</div>';
	                        postsHtml += '<div style="display: flex; align-items: center;">';
	                        
	                        postsHtml += '<a href="javascript:fn_nestedComment(\''+data.list[i].commentList[k].commentIdx+'\');" class="comment-btn">';
	                        postsHtml += '답글달기';
	                        postsHtml += '</a>';
	                        
	                      if (data.list[i].commentList[k].createId == "${loginInfo.userId}") {
	                          postsHtml += '<a href="javascript:fn_commentDelete(\''+data.list[i].commentList[k].commentIdx+'\');" class="comment-btn">';
	                          postsHtml += '삭제';
	                          postsHtml += '</a>';
	                      }
	                        postsHtml += '<div class="commnet-heart"><i class="fa-regular fa-heart"></i></div>';
	                        postsHtml += '</div>';
	                        postsHtml += '</div>';
	                    }
	                    postsHtml += '</div>';

	                    postsHtml += '<div class="timer">' + data.list[i].timeDiffer+' 전' + '</div>';

	                    postsHtml += '<div class="comment-input">';
	                    postsHtml += '<input type="text" id="commentContent" name="commentContent" placeholder="댓글달기..." />';
	                    postsHtml += '<button class="upload_btn" type="button" onclick="javascript:fn_saveComment(\''+data.list[i].feedIdx+'\');">게시</button>';
	                    postsHtml += '</div>';
	                    postsHtml += '</li>';
	                }
	            } else {
	                postsHtml += '<li class="post-item"><div style="text-align:center;">조회된 결과가 없습니다.</div></li>';
	            }

	            $("#postList").html(postsHtml);
	        },
	        error: function(data, status, err) {
	            console.log(err);
	        }
		});
	}
	
	// 피드(게시물) 더보기 메뉴 - 로그인 한 아이디가 작성한 게시물일 경우
	function fn_moreOptionTrue(feedIdx){
		$(".more-option").addClass("active");
		var moreHtml = '';
		
		moreHtml += '<ul>';
		moreHtml += '<li class="red-txt" style="color: #DE0A26; font-weight: 600;" onclick="javascript:fn_deleteFeed(\''+feedIdx+'\');">삭제</li>';
		moreHtml += '<li onclick="javascript:fn_detailFeed(\''+feedIdx+'\');">수정</li>';
		moreHtml += '<li>다른 사람에게 좋아요 수 숨기기</li>';
		moreHtml += '<li>댓글 기능 해제</li>';
		moreHtml += '<li>게시물로 이동</li>';
		moreHtml += '<li>공유 대상...</li>';
		moreHtml += '<li>링크 복사</li>';
		moreHtml += '<li>퍼가기</li>';
		moreHtml += '<li class="option-close-btn" onclick="popupClose();">취소</li>';
		moreHtml += '</ul>';
	
      $("#moreOption").html(moreHtml);
	}
	
	// 피드(게시물) 더보기 메뉴 - 다른 사용자가 작성한 게시물일 경우
	function fn_moreOptionFalse(feedIdx){
		$(".more-option").addClass("active");
     	var moreHtml = '';
 
		moreHtml += '<ul>';
		moreHtml += '<li style="color: #DE0A26; font-weight: 600;">팔로우 취소</li>';
		moreHtml += '<li>게시물로 이동</li>';
		moreHtml += '<li>공유 대상...</li>';
		moreHtml += '<li>링크 복사</li>';
		moreHtml += '<li>퍼가기</li>';
		moreHtml += '<li>이 계정 정보</li>';
		moreHtml += '<li class="option-close-btn" onclick="popupClose();">취소</li>';
		moreHtml += '</ul>';
      
      $("#moreOption").html(moreHtml);
   }
	
   function popupClose(){
      $(".more-option").removeClass("active");
   }
	
	// 첨부파일 삭제 기능
	function fileDelete(fileNum, fileIdx){
		var no = fileNum.replace(/[^0-9]/g, "");
		
		// 등록 완료 된 파일을 삭제하기 위해 fileIdx를 가져와서 삭제할 배열에 push 
		if(fileIdx != "") {
			deleteFiles.push(fileIdx);
		} else {
			content_files[no].is_delete = true;
		}
		
		$("#"+fileNum).remove();
		fileCnt--;
	}	
	
	// 피드(게시물) 등록 및 수정
	function fn_save(){
		var formData = new FormData($("#postForm")[0]);
		
		for(var x=0; x<content_files.length; x++){
			//삭제 안한 것만 담아준다.
			if(!content_files[x].is_delete){
				formData.append("fileList", content_files[x]); 
			}
		}
		
		// formData에 등록된 파일 중 삭제를 할 파일을 추가
		if(deleteFiles.length > 0) {
			formData.append("deleteFiles", deleteFiles);			
		}		
		
		$.ajax({
		    url: '/main/saveFeed.do',
		    method: 'post',
		    data : formData,
		    enctype : "multipart/form-data",
		    processData : false,
		    contentType : false,
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	if(data.resultChk > 0){
		    		alert("저장되었습니다.");
		    		fn_selectList();
		    	}else{
		    		alert("저장에 실패하였습니다.");
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
	
	function fn_getFileList(feedIdx){		
		$.ajax({
		    url: '/main/getFileList.do',
		    method: 'post',
		    data : { 
		    	"feedIdx" : feedIdx
		    },
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	// console.log(data);
		    	if(data.fileList.length > 0){
		    		for(var i=0; i<data.fileList.length; i++){
				    	$("#uploadFileList").append(
				    		 '<div id="file'+i+'" style="float:left;">'
			                 +'<font style="font-size:12px">'
			                 +'<a href="javascript:fn_imgView(\''+ data.fileList[i].saveFileName+'\', \'U\');">'
			                 + data.fileList[i].originalFileName 
			                 +'</a></font>'
			                 +'<a href="javascript:fileDelete(\'file'+i+'\',\''+data.fileList[i].fileIdx+'\');">X</a>'
			                 +'</div>'

						);
				    	fileNum = data.fileList.length;
		    		}	
		    	}		    	
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
	
	// 피드 삭제
	function fn_deleteFeed(feedIdx) {
		// console.log(feedIdx);
		
		if(confirm("삭제하시겠습니까?")){
			
			$.ajax({
			    url: '/main/deleteFeed.do',
			    method: 'post',
			    data : {
			    	"feedIdx" : feedIdx
			    },
			    dataType : 'json',
			    success: function (data, status, xhr) {
			    	if(data.resultChk > 0){
			    		alert("삭제되었습니다.");
			    		fn_selectList();
			    	}else{
			    		alert("삭제에 실패하였습니다.");
			    		return;
			    	}
			    },
			    error: function (data, status, err) {
			    	console.log(err);
			    }
			});
		}
	}
	
	// 피드 수정화면 불러오기
	function fn_detailFeed(feedIdx) {
		/* 팝업 닫기 변수 */
		 var uploadPopup = document.querySelector('.upload-wrapper');
		 uploadPopup.classList.add('active');
		 popupClose(uploadPopup); // 팝업 닫기
		 // uploadPopup.classList.remove('active');
		 
	    $("#statusFlag").val("U");
	    $("#feedIdx").val(feedIdx);
	    
		var formData = new FormData($("#saveFrm")[0]);
			
		if ($("#statusFlag").val() === "U") {
		    $("#btn_save").hide();
		    $("#btn_update").show();
		    $(".new_upload_tit").hide();
		    $(".update_upload_tit").show();
		} else {
		    $("#btn_save").show();
		    $("#btn_update").hide();
		    $(".new_upload_tit").show();
		    $(".update_upload_tit").hide();
		}
		 
		$.ajax({
		    url: '/main/getFeedDetail.do',
		    method: 'post',
		    data : { "feedIdx" : feedIdx},
		    dataType : 'json',
		    success: function (data, status, xhr) {
				$("#feedContent").val(data.feedInfo.feedContent);
				$("#feedHashtag").val(data.feedInfo.feedHashtag);
				var innerHtml = '';
				var imgHtml = '';
				let canvas = document.getElementById('img-canvas');
				let ctx = canvas.getContext('2d');
				let postIconBox = document.querySelector('.postIconBox');
				
				let img = new Image();
				
			    img.onload = function(){
			      canvas.width = 500;
			      canvas.height = 400;
			      ctx.drawImage(img,0,0,500,400);
			    };
			    
			    postIconBox.style.display = 'none';
			    
		    	for(var i=0; i<data.fileList.length; i++){
		    		//imgHtml+='<img src="/main/feedImgView.do?fileName=' + data.fileList[i].saveFileName + '" class="d-block w-100 feed-picture" alt="..."/>';
		    		img.src = "/main/feedImgView.do?fileName=" + data.fileList[i].saveFileName;
                   // 파일 삭제 버튼 소스 추가
                   innerHtml += '<div id="file' + i + '" >' +
                                '<font style="font-size:12px">' + 
                                '<a href="javascript:fn_imgView(\''+data.fileList[i].saveFileName+'\', \'U\');">'+ data.fileList[i].originalFileName + '</a></font>' +
                                '<a href="javascript:fileDelete(\'file' + i + '\', \'' + data.fileList[i].fileIdx + '\');">X</a>' +
                                '</div>';
		    	}
		    	
		    	$("#uploadFileList").html(innerHtml);
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
	
	// 댓글 등록
	function fn_saveComment(feedIdx) {
		var commentContent = $("#commentContent").val();
		$.ajax({
		    url: '/main/saveFeedComment.do',
		    method: 'post',
		    data : { 
		    	"feedIdx" : feedIdx,
		    	"commentContent" : commentContent
		    },
		    dataType : 'json',
		    success: function (data, status, xhr) {
		    	if(data.resultChk > 0){
		    		alert("등록되었습니다.");
		    		fn_selectList();
		    	}else{
		    		alert("등록에 실패하였습니다.");
		    	}
		    },
		    error: function (data, status, err) {
		    	console.log(err);
		    }
		});
	}
	
	// 댓글 삭제
	function fn_commentDelete(commentIdx) {
		if(confirm("삭제하시겠습니까?")) {
			$.ajax({
			    url: '/main/deleteFeedComment.do',
			    method: 'post',
			    data : { 
			    	"commentIdx" : commentIdx
			    },
			    dataType : 'json',
			    success: function (data, status, xhr) {
			    	if(data.resultChk > 0){
			    		alert("삭제되었습니다.");
			    		$("#comment_"+commentIdx).remove();
			    	}else{
			    		alert("삭제에 실패하였습니다.");
			    	}
			    },
			    error: function (data, status, err) {
			    	console.log(err);
			    }
			});
		}
	}
	
	// 피드 이미지 로드
	function fn_imgView(fileName, type){
		if(type == 'I'){
			var reader = new FileReader();
			var e = content_files[fileName];
			var canvas = document.getElementById('img-canvas');
			let ctx = canvas.getContext('2d');
		    reader.onload = function(e) {
		    	var img = new Image();
		    	
			    img.onload = function(){
			      canvas.width = 500;
			      canvas.height = 300;
			      ctx.drawImage(img,0,0,500,300);
			    };
			    img.src = e.target.result;
		    };
		    reader.readAsDataURL(e);
		}else{
			let canvas = document.getElementById('img-canvas');
			let ctx = canvas.getContext('2d');
			let img = new Image();
			
		    img.onload = function(){
		      canvas.width = 500;
		      canvas.height = 400;
		      ctx.drawImage(img,0,0,500,400);
		    };
		    img.src = "/main/feedImgView.do?fileName=" + fileName;	
		}		
	}
	
	// 피드 초기화 
	function fn_init(){
		// canvas
	    var cnvs = document.getElementById('img-canvas');
	    // context
	    var ctx = cnvs.getContext('2d');

	    // 픽셀 정리
	    ctx.clearRect(0, 0, cnvs.width, cnvs.height);
	    // 컨텍스트 리셋
	    ctx.beginPath();
	    
	    $("#statusFlag").val("I");
	    $("#btn_save").show();
	    $("#btn_update").hide();
	    $(".new_upload_tit").show();
	    $(".update_upload_tit").hide();
		
	    $("#fileUpload").val("");
	    $("#fileUpload").clear;
	    $("#feedContent").val("");
	    $("#feedHashtag").val("");
	    $("#uploadFileList").html("");
	    content_files = new Array();
	    delete_files = new Array();
	    fileNum = 0;
	    fileCnt = 0;
	}
	
	// 좋아요 기능
	function fn_feedLike(feedIdx, type) {
	  
	   $.ajax({
	       url: '/main/feedLike.do',
	       method: 'post',
	       data : { 
	          "feedIdx" : feedIdx,
	          "likeType" : type //파라미터 type
	       },
	       dataType : 'json',
	       success: function (data, status, xhr) {
	          if(data.resultChk > 0){
	         	 if(type == 'I'){
	         		 // alert("좋아요 성공");	 
	         	 }else if(type == 'U'){
	         		 // alert("좋아요 취소");
	         	 }
	             
	             fn_selectList();
	          }else{
	             alert("좋아요 실패");
	          }
	       },
	       error: function (data, status, err) {
	          console.log(err);
	       }
	   });
	}
	
</script>
</head>
<body>
<div class="wrapper">
      <header class="global-header">
        <div>
          <h1 class="logo">
            <a href="mainPage.do">
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
            <li>
              <i class="fa-regular fa-circle-user"></i>
            </li>
          </ul>
        </div>
      </header>

      <main>
      	<form id="imgFrm" name="imgFrm">
      		<input type="hidden" id="imgPath" name="imgPath" value=""/>
      	</form>
      	
        <ul class="post-list" id="postList" name="postList">
          <!-- <li class="post-item">
          	<div style="text-align:center;">조회된 결과가 없습니다.</div>
          </li> -->
        </ul>

        <div class="recommend lg-only">
          <div class="side-user">
            <div class="profile-img side">
              <a href="/mypage.do">
                <img src="/assets/main-images/potato.jpeg" alt="프로필사진" />
              </a>
            </div>

            <div>
              <div class="username">${loginInfo.userId}</div>
              <div class="ko-name">${loginInfo.name}</div>
            </div>
          </div>

          <div class="recommend-list">
            <div class="reco-header">
              <p>회원님을 위한 추천</p>
              <button class="all-btn" type="button">모두 보기</button>
            </div>

            <div class="thumb-user-list">
              <div class="thumb-user">
                <div class="profile-img">
                  <img src="/assets/main-images/멍2.jpeg" alt="프로필사진" />
                </div>
                <div>
                  <div class="username">zzz_zzz</div>
                  <p>instagram 신규 가입</p>
                </div>
              </div>

              <div class="thumb-user">
                <div class="profile-img">
                  <img src="/assets/main-images/멍3.jpeg" alt="프로필사진" />
                </div>

                <div>
                  <div class="username">lorem</div>
                  <p>회원님을 위한 추천</p>
                </div>
              </div>

              <div class="thumb-user">
                <div class="profile-img">
                  <img src="/assets/main-images/user.jpeg" alt="프로필사진" />
                </div>

                <div>
                  <div class="username">cldieid</div>
                  <p>회원님을 위한 추천</p>
                </div>
              </div>

              <div class="thumb-user">
                <div class="profile-img">
                  <img src="/assets/main-images/user.jpeg" alt="프로필사진" />
                </div>

                <div>
                  <div class="username">abcdefg</div>
                  <p>회원님을 위한 추천</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>

	<div class="upload-wrapper">
        <button class="post-close-btn" type="button">
          <i class="fa-solid fa-xmark"></i>
        </button>

        <div class="post-upload">
            <form class="post_form" id="postForm" name="postForm" action="">
	            <input type="hidden" id="statusFlag" name="statusFlag" value="I"/>
	            <input type="hidden" id="feedIdx" name="feedIdx" value="${feedIdx}"/>
	            <p class="new_upload_tit">새 게시물 만들기</p>
				<p class="update_upload_tit" style="display:none;">게시물 수정하기</p>
	
	            <div class="post-img-preview">
	            	<div class="postIconBox">
		              <div class="plus_icon">
		                <img src="/assets/main-images/upload.png" alt="" />
		              </div>
		
		              <p class="plus_txt">포스트 이미지 추가</p>
	              </div>
	              <canvas id="img-canvas"></canvas>
	            </div>
	            
	            <!-- <div class="post-img-preview" id="postImgPreview">
	            	<div class="plus_icon">
	             		<img src="/assets/main-images/upload.png" alt="" />
	            	</div>
		            <p class="plus_txt">포스트 이미지 추가</p>
		            <div class="slider">
		                <button class="prev" type="button">&#10094;</button>
		                <div class="image-container" id="image-container">	                	
		                    이미지가 여기에 추가됩니다
		                </div>
		                <button class="next" type="button">&#10095;</button>
		            </div>
	        	</div> -->
	
	            <div class="post-file">
	              <input type="file" id="fileUpload" name="fileUpload" required="required" multiple/>
	              <div class="feed-input-group" id="uploadFileList" name="uploadFileList"></div>
	            </div>
	
	            <p class="post-txt">
	              <textarea
	                id="feedContent"
	                name="feedContent"
	                cols="50"
	                rows="5"
	                placeholder="문구를 입력하세요..."
	                value="${feedInfo.feedContent}"
	              ></textarea>
	            </p>
	            
	            <p class="post-txt">
	              <textarea
	                id="feedHashtag"
	                name="feedHashtag"
	                cols="50"
	                rows="1"
	                placeholder="#해시태그 입력"
	                value="${feedInfo.feedHashtag}"
	              ></textarea>
	            </p>

            	<button class="submit_btn btn-blue" type="button" id="btn_save" name="btn_save">공유하기</button>
            	<button style="display:none;" id="btn_update" name="btn_update" class="submit_btn btn-blue" type="button">수정하기</button>
          </form>
        </div>
      </div>

      <div class="more-option" id="moreOption">
        <!-- <ul>
          <li class="red-txt">삭제</li>
          <li>수정</li>
          <li>다른 사람에게 좋아요 수 숨기기</li>
          <li>댓글 기능 해제</li>
          <li>게시물로 이동</li>
          <li>공유 대상...</li>
          <li>링크 복사</li>
          <li>퍼가기</li>
          <li class="option-close-btn">취소</li>
        </ul> -->
      </div>
    </div>
    
    <!-- Option 1: Bootstrap Bundle with Popper -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
        crossorigin="anonymous"></script>
    <script src="<c:url value='/js/main.js'/>"></script>
</body>
</html>