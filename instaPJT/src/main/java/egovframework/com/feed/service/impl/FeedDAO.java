package egovframework.com.feed.service.impl;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("FeedDAO")
public class FeedDAO extends EgovAbstractMapper{
	
	public List<HashMap<String, Object>> selectFeedList(HashMap<String, Object> paramMap){
		return selectList("selectFeedList", paramMap);
	}
	
	public int insertFeed(HashMap<String, Object> paramMap) {
		return insert("insertFeed", paramMap);
	}
	
	public int updateFeed(HashMap<String, Object> paramMap) {
		return update("updateFeed", paramMap);
	}
	
	public HashMap<String, Object> selectFeedDetail(int feedIdx) {
		return selectOne("selectFeedDetail", feedIdx);
	}
	
	public int deleteFeed(HashMap<String, Object> paramMap) {
		return update("deleteFeed", paramMap);
	}
	
	public int deleteFeedFile(HashMap<String, Object> paramMap) {
		return update("deleteFeedFile", paramMap);
	}
	
	public int insertComment(HashMap<String, Object> paramMap) {
		return insert("insertComment", paramMap);
	}
	
	public List<HashMap<String, Object>> selectFeedComment(int feedIdx) {
		return selectList("selectFeedComment", feedIdx);
	}
	
	public int deleteComment(HashMap<String, Object> paramMap) {
		return update("deleteComment", paramMap);
	}
	
	// 파일 영역
	public int getFileGroupMaxIdx() {
		return selectOne("getFileGroupMaxIdx");
	}
	
	public int getFileGroupIdx(HashMap<String, Object> paramMap) {
		int result = selectOne("getFileGroupIdx", paramMap);
		System.out.println(result);
		return result; 
	}
	
	public int insertFileAttr(HashMap<String, Object> paramMap) {
		return insert("insertFileAttr", paramMap);
	}
	
	public List<HashMap<String, Object>> selectFileList(int feedIdx) {
		return selectList("selectFileList", feedIdx);
	}
	
	public int deleteFileAttr(HashMap<String, Object> paramMap) {
		System.out.println(2);
		return update("deleteFileAttr", paramMap);
	}
	
	// 좋아요 등록
	public int insertFeedLike(HashMap<String, Object> paramMap) {
		return insert("insertFeedLike", paramMap);
	}
	
	// 좋아요 취소
	public int updateFeedLike(HashMap<String, Object> paramMap) {
		return update("updateFeedLike", paramMap);
	}

}
