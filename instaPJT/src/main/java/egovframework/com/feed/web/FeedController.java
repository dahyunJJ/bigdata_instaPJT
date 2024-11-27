package egovframework.com.feed.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.feed.service.FeedService;

@Controller
public class FeedController {
	
	@Resource(name="FeedService")
	private FeedService feedService;
	
	@RequestMapping("/main/mainPage.do")
	public String boardList(HttpSession session, Model model) {
		HashMap<String, Object> loginInfo = null;
		loginInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		
		if(loginInfo != null) {
			model.addAttribute("loginInfo", loginInfo);
			return "main/main";
		}else {
			return "redirect:/login.do";
		}
	}
	
	@RequestMapping("/main/selectFeedList.do")
	public ModelAndView selectBoardList(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		
		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
	    paramMap.put("userId", sessionInfo.get("userId").toString());
		
		List<HashMap<String, Object>> list = feedService.selectFeedList(paramMap);		
		
		mv.addObject("list", list);			
		mv.setViewName("jsonView");
		return mv;
	}	
	
	// 데이터를 조회해서 json으로 넘겨주는 용도 (ajax에서 사용)
	@RequestMapping("/main/getFeedDetail.do")
	public ModelAndView getFeedDetail(@RequestParam(name="feedIdx") int feedIdx) {
		ModelAndView mv = new ModelAndView();
		
		HashMap<String, Object> feedInfo = feedService.selectFeedDetail(feedIdx);
		List<HashMap<String, Object>> fileList = feedService.selectFileList(feedIdx);
		List<HashMap<String, Object>> commentList = feedService.selectFeedComment(feedIdx);
		
		mv.addObject("feedInfo", feedInfo);
		mv.addObject("fileList", fileList);
		mv.addObject("commentList", commentList);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/main/saveFeed.do")
	public ModelAndView saveBoard(@RequestParam HashMap<String, Object> paramMap, @RequestParam(name="fileList") List<MultipartFile> multipartFile, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		
		int resultChk = 0;
		
		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		paramMap.put("userId", sessionInfo.get("userId").toString());
		
		resultChk = feedService.saveFeed(paramMap, multipartFile);
		
		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/main/deleteFeed.do")
	public ModelAndView deleteFeed(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		
		int resultChk = 0;
		
		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		paramMap.put("userId", sessionInfo.get("userId").toString());
		
		resultChk = feedService.deleteFeed(paramMap);
		
		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
	// 댓글 등록
	@RequestMapping("/main/saveFeedComment.do")
	public ModelAndView saveFeedComment(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		
		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		paramMap.put("userId", sessionInfo.get("userId").toString());
		
		int resultChk = 0;
		
		resultChk = feedService.insertComment(paramMap);
		
		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
	@RequestMapping("/main/deleteFeedComment.do")
	public ModelAndView deleteFeedComment(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		
		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		paramMap.put("userId", sessionInfo.get("userId").toString());
		
		int resultChk = 0;
		
		resultChk = feedService.deleteComment(paramMap);
		
		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
	// 업로드한 파일 목록을 게시글에 보여주기
	@RequestMapping("/main/getFileList.do")
	public ModelAndView getFileList(@RequestParam(name="feedIdx") int feedIdx) {
		ModelAndView mv = new ModelAndView();
		
		List<HashMap<String, Object>> fileList = feedService.selectFileList(feedIdx);
		
		mv.addObject("fileList", fileList);
		mv.setViewName("jsonView");
		return mv;
	}
	
	// 피드 이미지를 메인 화면에 불러오기
	@RequestMapping("/main/feedImgView.do")
	public void feedImgView(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = "C:/ictsaeil/insta/";
		String fileName = request.getParameter("fileName").toString();
        
        File imageFile = new File(path, fileName);
        
        if (imageFile.exists()) {
            response.setContentType("image/jpeg");
            FileInputStream in = new FileInputStream(imageFile);
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                response.getOutputStream().write(buffer, 0, bytesRead);
            }
            in.close();
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }	
	
	// 좋아요 기능 구현
	@RequestMapping("/main/feedLike.do")
	public ModelAndView insertFeedLike(@RequestParam HashMap<String, Object> paramMap, HttpSession session) {
		ModelAndView mv = new ModelAndView();
		
		int resultChk = 0;

		HashMap<String, Object> sessionInfo = (HashMap<String, Object>) session.getAttribute("loginInfo");
		paramMap.put("userId", sessionInfo.get("userId").toString());
		paramMap.put("userIdx", sessionInfo.get("userIdx").toString());

		resultChk = feedService.insertFeedLike(paramMap);

		mv.addObject("resultChk", resultChk);
		mv.setViewName("jsonView");
		return mv;
	}
	
}
