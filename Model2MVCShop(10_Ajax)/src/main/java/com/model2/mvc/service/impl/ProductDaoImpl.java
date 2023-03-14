package com.model2.mvc.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.ProductService;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.ProductDAO;

@Service("productDaoImpl")
public class ProductDaoImpl implements ProductDAO {

	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	public ProductDaoImpl() {
		System.out.println(this.getClass());
	}
	
	public void insertProduct(Product product) throws Exception {
		sqlSession.insert("ProductMapper.insertProduct", product);
	}

	public Product findProduct(int productVO) throws Exception {
		return sqlSession.selectOne("ProductMapper.findProduct", productVO);
	}

	public List<Product> getProductList(Search search) throws Exception {
		return sqlSession.selectList("ProductMapper.getProductList", search);
	}

	public void updateProduct(Product product) throws Exception {		
		sqlSession.update("ProductMapper.updateProduct", product);
	}
	
	public int getTotalCount(Search search) throws Exception {
		return sqlSession.selectOne("ProductMapper.getTotalCount", search);
	}

	public List<Map<String, Object>> autocomplete(Map<String, Object> paramMap) throws Exception {
		return sqlSession.selectList("ProductMapper.getautoList", paramMap);
	}

}
