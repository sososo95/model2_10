package com.model2.mvc;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.domain.Product;
import com.model2.mvc.service.ProductService;


//==> 회원관리 Controller
@Controller
@RequestMapping("/product/*")
public class ProductController {
	
	///Field
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	//setter Method 구현 않음
		
	public ProductController(){
		System.out.println(this.getClass());
	}
	

	@Value("#{commonProperties['pageUnit'] ?: 3}")
	int pageUnit;
	
	@Value("#{commonProperties['pageSize'] ?: 2}") 
	int pageSize;
	
	

	@RequestMapping(value="addProduct", method=RequestMethod.POST ) // 상품 추가
	public String addProduct(@ModelAttribute("product") Product product, 
			MultipartHttpServletRequest file ,Model model ) throws Exception {

		System.out.println("addProduct POST방식");
					
		List<MultipartFile> fileList = file.getFiles("file");
		
		String path = "/Users/sojaeyeon/workspace/10.Model2MVCShop(Ajax)/src/main/webapp/images/uploadFiles/";
		
		String listFile = ""; // 여러개 파일 담을 곳
		
		for(MultipartFile mf : fileList) {
			
			String FileName = System.currentTimeMillis() + "_" + mf.getOriginalFilename().trim();
						
			if(mf.getOriginalFilename().equals("")) {
				product.setFileName("");
			} else {
				mf.transferTo(new File(path + FileName)); // 경로에 파일 저장 
				listFile += FileName + "/";
				
				if(fileList.size() == fileList.size()) {
					product.setFileName(listFile.substring(0, listFile.length() - 1));
				}
			}	
		}
		
		if(product.getFileName() != null) { // 이미지 넣고 확인용
			List<String> image = new ArrayList<String>();
			StringTokenizer str = new StringTokenizer(listFile , "/");
			
			while(str.hasMoreTokens()) {
				image.add(str.nextToken());
			}
			
			model.addAttribute("image", image);
		}
		
		productService.insertProduct(product);
		model.addAttribute("pro", product);
		
		return "forward:/product/productView.jsp";
	}
	
	
	@RequestMapping(value="getProduct", method=RequestMethod.GET) // 상품 정보 확인
	public String getProduct( @RequestParam("prodNo") int prodNo , Model model ) throws Exception {
		
		System.out.println("getProduct GET 방식");
		
		Product product = productService.findProduct(prodNo);
		

		System.out.println("프로덕트 이미지 확인용 :   " + product);
		
		// 다중 이미지일 경우에 사용
		if(product.getFileName() != null) {
			System.out.println("오류가 나더라도 확인용");
			
			List<String> image = new ArrayList<String>();
			
			StringTokenizer str = new StringTokenizer(product.getFileName(), "/");
			
			while(str.hasMoreTokens()) {
				image.add(str.nextToken());
			}
		
			System.out.println("image 리스트 값 확인 :   " + image);
			
			model.addAttribute("image", image);
		}
		
		model.addAttribute("pro", product);
		model.addAttribute("search", "search");
		
		return "forward:/product/getProduct.jsp";
	}
	
	@RequestMapping(value="listProduct") // 상품 리스트
	public String listProduct( @ModelAttribute("search") Search search , Model model) throws Exception{
		
		
		System.out.println("listProduct GET/POST");
		
		if(search.getPage() ==0 ){
			search.setPage(1);
		}
		search.setPageSize(pageSize);
		
		// Business logic 수행
		Map<String , Object> map=productService.getProductList(search);
		
		Page resultPage = new Page( search.getPage(), ((Integer)map.get("totalCount")).intValue(), 
									pageUnit, pageSize);
		
		// Model 과 View 연결
		model.addAttribute("list", map.get("list"));
		model.addAttribute("resultPage", resultPage);
		model.addAttribute("search", search);
		//model.addAttribute("window", "product");
		
		return "forward:/product/listProduct.jsp";
	}
	
	
	@RequestMapping(value="updateProduct", method=RequestMethod.GET) // 업데이트 뷰 확인
	public String updateProduct( @RequestParam("prodNo") int prodNo, Model model ) throws Exception{

		System.out.println("updateProductView GET 방식");
		
		Product product = productService.findProduct(prodNo);
		
		model.addAttribute("pro", product);
		
		return "forward:/product/updateProductView.jsp"; 
	}

	@RequestMapping(value="updateProduct", method=RequestMethod.POST) 
	public String updateProduct(@ModelAttribute("product") Product product , Model model
			, MultipartHttpServletRequest file) throws Exception{

		System.out.println("updateProduct POST 방식");
		
		
		List<MultipartFile> fileList = file.getFiles("file");
		System.out.println("리스트 확인 :    " + fileList);
		
		String path = "/Users/sojaeyeon/workspace/10.Model2MVCShop(Ajax)/src/main/webapp/images/uploadFiles/";	
		
		String listFile = ""; // 여러개 파일 담을 곳
		
		for(MultipartFile mf : fileList) {
			
			String FileName = System.currentTimeMillis() + "_" + mf.getOriginalFilename().trim();
						
			if(mf.getOriginalFilename().equals("")) {
				product.setFileName(product.getFileName()); // 별도 수정안하면 기존꺼 저장
			} else {
				mf.transferTo(new File(path + FileName)); 
				listFile += FileName + "/";
				
				if(fileList.size() == fileList.size()) {
					product.setFileName(listFile.substring(0, listFile.length() - 1));
				}
			}
		}
		
		if(product.getFileName() != null) { // 이미지 넣고 확인
			
			List<String> image = new ArrayList<String>();
			
			StringTokenizer str = new StringTokenizer(product.getFileName(), "/");
			
			while(str.hasMoreTokens()) {
				image.add(str.nextToken());
			}
		
			System.out.println("image 리스트 값 확인 :   " + image);
			
			model.addAttribute("image", image);
		}

		productService.updateProduct(product);
		
		model.addAttribute("pro", product);
		
		return "forward:/product/getProduct.jsp"; 
	}

}