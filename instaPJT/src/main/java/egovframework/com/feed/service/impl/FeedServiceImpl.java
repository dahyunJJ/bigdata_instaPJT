package egovframework.com.feed.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.com.feed.service.FeedService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("FeedService")
public class FeedServiceImpl extends EgovAbstractServiceImpl implements FeedService{

	@Resource(name="FeedDAO")
	private FeedDAO feedDAO;

	@Override
	public List<HashMap<String, Object>> selectFeedList(HashMap<String, Object> paramMap) {
		List<HashMap<String, Object>> list = feedDAO.selectFeedList(paramMap);
		
        for (int i=0; i< list.size(); i++) {
           List<HashMap<String, Object>> fileList = null;
           List<HashMap<String, Object>> commentList = null;
           
           HashMap<String, Object> feedMap = list.get(i);
         
           int feedIdx = Integer.parseInt(feedMap.get("feedIdx").toString());         
           fileList = feedDAO.selectFileList(feedIdx);
           commentList = feedDAO.selectFeedComment(feedIdx);
           
           // 파일 리스트에 전체 경로 추가
           for (HashMap<String, Object> fileMap : fileList) {
               String fileName = fileMap.get("saveFileName").toString(); // 파일 이름을 가져옴
               String fullPath = "C:\\ictsaeil\\insta\\" + fileName; // 전체 경로 구성
               fileMap.put("fullPath", fullPath); // 전체 경로 추가
           }
           
           feedMap.put("commentList", commentList);
           feedMap.put("fileList", fileList);
         }
        
        // System.out.println("파일리스트와 댓글리스트 >>>>>>>>>>>>>>>>>>>>>>>");
        // System.out.println(list);
        
        return list;
	}

	@Override
	public int saveFeed(HashMap<String, Object> paramMap, List<MultipartFile> multipartFile) {
		int resultChk = 0;
		
		String flag = paramMap.get("statusFlag").toString();
		int fileGroupIdx = 0;
		
		if ("I".equals(flag)) {
			resultChk = feedDAO.insertFeed(paramMap);
			fileGroupIdx = feedDAO.getFileGroupMaxIdx();
			
		} else if ("U".equals(flag)) {
			resultChk = feedDAO.updateFeed(paramMap);
			// fileGroupIdx = feedDAO.getFileGroupIdx(paramMap);
			
			if(paramMap.get("deleteFiles") != null) {
				resultChk = feedDAO.deleteFileAttr(paramMap);				
			}
		}
		
		// file을 저장할 위치 지정하기
		String filePath = "/ictsaeil/insta";
		int index = 0;
		
		// get(0)을 한 이유 : 첫번째 파일이 없으면 두번째 파일도 없기 때문에 (0)으로 설정
		if(multipartFile.size() > 0 && !multipartFile.get(0).getOriginalFilename().equals("")) {
			for (MultipartFile file : multipartFile) {
				SimpleDateFormat date = new SimpleDateFormat("yyyyMMddHms");
				Calendar cal = Calendar.getInstance(); // Calendar에서 현재 시간을 가져옴
				String today = date.format(cal.getTime()); // cal 변수로 가져온 현재 시간을 "yyyyMMddHms" 형태로 변환
				
				try {
					File fileFolder = new File(filePath);
					
					if(!fileFolder.exists()) {
						if(fileFolder.mkdirs()) {
							// mkdirs() : 폴더를 생성해주는 메소드, 상위 폴더가 없으면 상위 폴더까지 생성 <-> mkdir() : 상위 폴더 없으면 하위 폴더 생성 안됨
							System.out.println("[file.mkdirs] : Success");
						}						
					}
					
					// fileExt : 파일의 확장자만 뽑아내기
					String fileExt = FilenameUtils.getExtension(file.getOriginalFilename());
					File saveFile = new File(filePath, "file_" + today + "_" + index + "." + fileExt);
					file.transferTo(saveFile); // multipartFile로 받아온 file을 saveFile로 바꿔주기
					
					HashMap<String, Object> uploadFile = new HashMap<String, Object>();
					uploadFile.put("feedIdx", fileGroupIdx);
					uploadFile.put("originalFileName", file.getOriginalFilename());
					uploadFile.put("saveFileName", "file_" + today + "_" + index + "." + fileExt);
					uploadFile.put("saveFilePath", filePath);
					uploadFile.put("fileSize", file.getSize());
					uploadFile.put("fileExt", fileExt);
					uploadFile.put("userId", paramMap.get("userId").toString());
					
					System.out.println(uploadFile.toString());
					resultChk = feedDAO.insertFileAttr(uploadFile);
					
					index++;
					
				} catch(Exception e) {
					e.printStackTrace();
				}
			}
		}
		
		return resultChk;
	}

	@Override
	public HashMap<String, Object> selectFeedDetail(int feedIdx) {
		return feedDAO.selectFeedDetail(feedIdx);
	}

	@Override
	public int deleteFeed(HashMap<String, Object> paramMap) {
		int resultChk = 0;
		
		feedDAO.deleteFeedFile(paramMap);
		resultChk = feedDAO.deleteFeed(paramMap);
		
		return resultChk;
	}

	@Override
	public int insertComment(HashMap<String, Object> paramMap) {
		return feedDAO.insertComment(paramMap);
	}

	@Override
	public List<HashMap<String, Object>> selectFeedComment(int feedIdx) {
		return feedDAO.selectFeedComment(feedIdx);
	}

	@Override
	public int deleteComment(HashMap<String, Object> paramMap) {
		return feedDAO.deleteComment(paramMap);
	}
	
	@Override
	public List<HashMap<String, Object>> selectFileList(int feedIdx) {
		return feedDAO.selectFileList(feedIdx);
	}

	// 좋아요 기능 구현
	@Override
	public int insertFeedLike(HashMap<String, Object> paramMap) {
		int resultChk = 0;
		String type = paramMap.get("likeType").toString();
		
		if("I".equals(type)) {
			resultChk = feedDAO.insertFeedLike(paramMap);
		}else if("U".equals(type)){
			resultChk = feedDAO.updateFeedLike(paramMap);
		}
		return resultChk;
	}	
	
}
