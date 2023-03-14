package com.model2.mvc.service;

import java.util.List;
import java.util.Map;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;


public interface ProductDAO {
	

	public void insertProduct(Product product) throws Exception ;
		

	public Product findProduct(int product) throws Exception ;
		
	
	public List<Product> getProductList(Search search) throws Exception ;


	public void updateProduct(Product product) throws Exception ;
		

	public int getTotalCount(Search serach) throws Exception ;
	
	
	public List<Map<String, Object>>autocomplete(Map<String, Object> paramMap) throws Exception;

}
