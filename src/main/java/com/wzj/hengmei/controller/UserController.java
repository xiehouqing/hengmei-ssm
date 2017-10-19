/**
 *
 */
package com.wzj.hengmei.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.wzj.hengmei.model.UserModel;
import com.wzj.hengmei.service.UserService;
import com.wzj.hengmei.utils.BaseController;

/**
 * TODO(用一句话描述该文件做什么)
 * @author : newtouch
 */
@Controller
@RequestMapping("/user")
public class UserController extends BaseController{

	@Resource
	UserService userService;

	@RequestMapping("/showUser")
	public String toIndex(HttpServletRequest request,Model model){
		int id = Integer.parseInt(request.getParameter("id"));
		UserModel userModel = userService.getUserModelById(id);
		model.addAttribute("user",userModel);
		return "showUser";
	}

	@RequestMapping("/init")
	public ModelAndView init(){
		ModelAndView mv = new ModelAndView();
		UserModel userModel = new UserModel();
		mv.addObject("userModel", userModel);
		mv.setViewName("login");
		return mv;
	}

	@RequestMapping("/login")
	@ResponseBody
	public String login(UserModel userModel){
		ModelAndView mv = new ModelAndView();
		System.out.println(userModel);
		return userModel.toString();
	}
}