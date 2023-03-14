package com.model2.mvc;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.model2.mvc.common.Page;
import com.model2.mvc.common.Search;
import com.model2.mvc.service.UserService;
import com.model2.mvc.service.domain.User;


//==> 회원관리 RestController
@RestController
@RequestMapping("/user/*")
public class UserRestController {
	
	///Field
	@Autowired
	@Qualifier("userServiceImpl")
	private UserService userService;
	//setter Method 구현 않음
		
	public UserRestController(){
		System.out.println(this.getClass());
	}
	
	
	@Value("#{commonProperties['pageUnit']}")
	int pageUnit;
	@Value("#{commonProperties['pageSize']}")
	int pageSize;
	
	
	@RequestMapping( value="json/getUser/{userId}", method=RequestMethod.GET )
	public User getUser( @PathVariable String userId ) throws Exception{
		
		System.out.println("/user/json/getUser : GET");
		
		//Business Logic
		return userService.getUser(userId);
	}

	@RequestMapping( value="json/login", method=RequestMethod.POST )
	public User login(	@RequestBody User user,
									HttpSession session ) throws Exception{
	
		System.out.println("/user/json/login : POST");
		//Business Logic
		System.out.println("::"+user);
		User dbUser=userService.getUser(user.getUserId());
		
		// 아이디가 없다면.
		if( dbUser==null ) {
			dbUser = new User();
		}
		
		if( user.getPassword().equals(dbUser.getPassword())){
			session.setAttribute("user", dbUser);
		}
	
		return dbUser;
	}
	
	
	@RequestMapping( value="json/addUser", method=RequestMethod.POST )
	public Map<String, User> addUser( @RequestBody  User user ) throws Exception {

		System.out.println("/addUser POST 방식");
		//Business Logic
		userService.addUser(user);
				
		Map<String, User>  map = new HashMap<String, User>();
		map.put("user", user);
		
		System.out.println("받은 값을 리턴하는 맵 :   " + map);
		
		return map;
	}
	
	@RequestMapping( value="json/updateUser/{userId}", method=RequestMethod.GET )
	public User updateUser( @PathVariable String userId ) throws Exception{

		System.out.println("updateUser GET 방식");
		//Business Logic
		User user = userService.getUser(userId);
		// Model 과 View 연결
		
		return user;
	}
	
	
	@RequestMapping( value="json/updateUser", method=RequestMethod.POST )
	public Map<String, User> updateUser( @RequestBody User user) throws Exception{

		System.out.println("updateUser POST 방식");
		//Business Logic
		System.out.println("아이디값 확인 :   " + user);
		userService.updateUser(user);
		System.out.println("업데이트 진행여부 확인");
		
		Map<String, User> map = new HashMap<String, User>();
		map.put("user", user);
		
		System.out.println("맵값 확인 : " + map);
		
		return map;
	}
	
	
	@RequestMapping( value="/json/autocomplete" , method=RequestMethod.POST )
	public @ResponseBody Map<String, Object> autocomplete( @RequestParam Map<String, Object> paramMap) throws Exception{
		
		System.out.println("autoList  POST");

		
		List<Map<String, Object>> autoList = userService.autocomplete(paramMap);
		paramMap.put("autoList", autoList);
		//System.out.println("확인용 데이터1111 :::::   " + autoList);
		//System.out.println("확인용 데이터2222 :::::   " + paramMap);
		
		return paramMap;
	}
	
	
	@RequestMapping( value="/json/listUser" , method=RequestMethod.POST )
	public List<User> listUser(  @RequestBody Search search ) throws Exception{
		
		System.out.println("/user/json/listUser");
		
		search.setPageSize(pageSize);
				
		Map<String , Object> map=userService.getUserList(search);
		List<User> list = (List<User>) map.get("list");
				
		return list;
	}
	
}