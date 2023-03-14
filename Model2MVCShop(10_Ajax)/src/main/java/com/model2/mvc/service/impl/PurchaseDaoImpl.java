package com.model2.mvc.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.PurchaseDAO;

@Service("purchaseDaoImpl")
public class PurchaseDaoImpl implements PurchaseDAO {
	
	@Autowired
	@Qualifier("sqlSessionTemplate")
	private SqlSession sqlSession;
	public void setSqlSession(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	public PurchaseDaoImpl() {
		System.out.println(this.getClass());
	}

	public Purchase addPurchase(Purchase purchase) throws Exception {
		sqlSession.insert("PurchaseMapper.insertPurchase", purchase);
		return purchase;
	}

	public Purchase getPurchase(int purchase) throws Exception {
		return sqlSession.selectOne("PurchaseMapper.findPurchase", purchase);
	}

	public List<Purchase> getPurchaseList(Search search) throws Exception {
		return sqlSession.selectList("PurchaseMapper.getPurchaseList", search);
	}

	public Purchase updatePurchase(Purchase purchase) throws Exception {
		return sqlSession.selectOne("PurchaseMapper.updatePurchase", purchase);
	}

	public void updateTranCode(Purchase purchase) throws Exception {
		sqlSession.selectOne("PurchaseMapper.updateTranCode", purchase);
	}

	public int getTotalCount(Search search) {
		return sqlSession.selectOne("PurchaseMapper.getTotalCount", search);
	}
	

}
