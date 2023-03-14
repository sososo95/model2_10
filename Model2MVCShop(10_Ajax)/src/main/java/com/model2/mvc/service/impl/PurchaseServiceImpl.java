package com.model2.mvc.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.PurchaseService;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.domain.Purchase;
import com.model2.mvc.service.PurchaseDAO;

@Service("purchaseServiceImpl")
public class PurchaseServiceImpl implements PurchaseService {
	
	@Autowired
	@Qualifier("purchaseDaoImpl")
	private PurchaseDAO purchaseDAO;
	
	public PurchaseServiceImpl() {
		System.out.println(this.getClass());
	}

	public Purchase addPurchase(Purchase purchase) throws Exception {
		purchaseDAO.addPurchase(purchase);
		return purchase;
	}

	public Purchase getPurchase(int purchaseVO) throws Exception{
		return purchaseDAO.getPurchase(purchaseVO);
	}

	public Purchase updatePurchase(Purchase purchase) throws Exception {
		purchaseDAO.updatePurchase(purchase);
		return purchase;
	}

	
	public Map<String, Object> getPurchaseList(Search search) throws Exception {
				
		List<Purchase> list= purchaseDAO.getPurchaseList(search);
		int totalCount = purchaseDAO.getTotalCount(search);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list );
		map.put("totalCount", new Integer(totalCount));
		
		return map;
	}
	
	public void updateTranCode(Purchase purchase) throws Exception {
		purchaseDAO.updateTranCode(purchase);
	}

}
