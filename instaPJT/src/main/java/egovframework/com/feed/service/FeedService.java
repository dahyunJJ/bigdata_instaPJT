package egovframework.com.feed.service;

import java.util.HashMap;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface FeedService {
	
	public List<HashMap<String, Object>> selectFeedList(HashMap<String, Object> paramMap);
	
	public int saveFeed(HashMap<String, Object> paramMap, List<MultipartFile> multipartFile);
	
	public HashMap<String, Object> selectFeedDetail(int feedIdx);
	
	public int deleteFeed(HashMap<String, Object> paramMap);
	
	public int insertComment(HashMap<String, Object> paramMap);
	
	public List<HashMap<String, Object>> selectFeedComment(int feedIdx);
	
	public int deleteComment(HashMap<String, Object> paramMap);
	
	public List<HashMap<String, Object>> selectFileList(int feedIdx);
	
	// like 입력
	public int insertFeedLike(HashMap<String, Object> paramMap);

}
