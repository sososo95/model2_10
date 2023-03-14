package com.model2.mvc.common;


public class Search {
	
	private int page; // 하단 페이지
	String searchCondition; // 0 또는 1로 회원인지 아니면 아이디인지
	String searchKeyword; // 검색한 값
	int pageSize; // 리스트 보여주는 줄의 갯수
	
	private int endRowNum;
	private int startRowNum;
	
	public Search(){
	}
	
	public int getPageSize() {
		return pageSize;
	}
	public void setPageSize(int paseSize) {
		this.pageSize = paseSize;
	}
	
	public int getPage() { 
		return page;
	}
	public void setPage(int page) { 
		this.page = page;
	}

	public String getSearchCondition() {
		return searchCondition;
	}
	public void setSearchCondition(String searchCondition) {
		this.searchCondition = searchCondition;
	}
	public String getSearchKeyword() {
		return searchKeyword;
	}
	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}
	
	
	public int getEndRowNum() {
		return getPage()*getPageSize();
	}
	//==> Select Query 시 ROWNUM 시작 값
	public int getStartRowNum() {
		return (getPage()-1)*getPageSize()+1;
	}

	@Override
	public String toString() {
		return "Search [currentPage=" + page + ", searchCondition="
				+ searchCondition + ", searchKeyword=" + searchKeyword
				+ ", pageSize=" + pageSize + ", endRowNum=" + endRowNum
				+ ", startRowNum=" + startRowNum + "]";
	}
}