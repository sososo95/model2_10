package com.model2.mvc.service;

import java.util.List;
import java.util.Map;

import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Purchase;

public interface PurchaseDAO {
	
	public Purchase addPurchase(Purchase purchase) throws Exception ;


	public Purchase getPurchase(int PurchaseVO) throws Exception ;
	
	
	public List<Purchase> getPurchaseList(Search search) throws Exception ;
	

	public Purchase updatePurchase(Purchase purchase) throws Exception ;

	
	public void updateTranCode(Purchase purchase) throws Exception ;


	public int getTotalCount(Search search);

}
