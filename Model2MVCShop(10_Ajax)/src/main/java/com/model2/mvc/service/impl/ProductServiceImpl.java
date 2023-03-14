package com.model2.mvc.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.ProductService;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.User;
import com.model2.mvc.service.ProductDAO;

@Service("productServiceImpl")
public class ProductServiceImpl implements ProductService {

	
	@Autowired
	@Qualifier("productDaoImpl")
	private ProductDAO productDAO;
	
	public ProductServiceImpl() {
		System.out.println(this.getClass());
	}
	
	public void insertProduct(Product product) throws Exception {
		productDAO.insertProduct(product);
	}

	public Product findProduct(int productVO) throws Exception {
		return productDAO.findProduct(productVO);
	}

	public Map<String, Object> getProductList(Search search) throws Exception {
		
		List<Product> list= productDAO.getProductList(search);
		int totalCount = productDAO.getTotalCount(search);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list );
		map.put("totalCount", new Integer(totalCount));
		
		return map;
	}

	public Product updateProduct(Product product) throws Exception {		
		productDAO.updateProduct(product);
		return product;
	}
	
	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap) throws Exception {
		return productDAO.autocomplete(paramMap);
	}

}
