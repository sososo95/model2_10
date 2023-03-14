package com.model2.mvc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;

public interface ProductService {
	
	public void insertProduct(Product product) throws Exception;
	
	public Product findProduct(int productVO) throws Exception;
	
	public Map<String, Object> getProductList(Search searchVO) throws Exception;
	
	public Product updateProduct(Product product) throws Exception;
	
	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap) throws Exception;

}
