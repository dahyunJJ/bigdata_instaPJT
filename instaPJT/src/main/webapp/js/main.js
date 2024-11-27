document.addEventListener("DOMContentLoaded", function () {
	var uploadPopup = document.querySelector(".upload-wrapper");
	var postAddBtn = document.querySelector(".post-upload-btn");
	var postCloseBtn = document.querySelector(".post-close-btn");
	
	function popupOpen(item) {
	  item.classList.add("active");
	}
	
	function popupClose(item) {
	  item.classList.remove("active");
	}
	
	//postAddBtn.addEventListener("click", () => {
	//  popupOpen(uploadPopup);
	//});
	postCloseBtn.addEventListener("click", () => {
	  popupClose(uploadPopup);
	});
});


// Canvas image
let fileUploadBtn = document.getElementById("fileUpload");
let canvas = document.getElementById("img-canvas");
let ctx = canvas.getContext("2d");

function handleImage(e) {
	  let reader = new FileReader();
	  reader.onload = function (event) {
	    let img = new Image();
	
	    img.onload = function () {
	      canvas.width = 500;
	      canvas.height = 400;
	      ctx.drawImage(img, 0, 0, 500, 400);
	    };
		
	    img.src = event.target.result;
	  };
	
	  reader.readAsDataURL(e.target.files[0]);
	}

fileUploadBtn.addEventListener("change", handleImage);

