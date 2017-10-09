package com.wzj.hengmei.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.wzj.hengmei.model.UserInfoModel;
import com.wzj.hengmei.service.UserInfoService;
import com.wzj.hengmei.utils.ResultViewModel;
/**
 * 用户信息表Controller
 * @author nxwzj
 *
 */
@Controller
@RequestMapping("/userInfo")
public class UserInfoController {

	@Resource
	UserInfoService userInfoService;

	@RequestMapping("/init")
	public ModelAndView init(){
		ModelAndView mv = new ModelAndView();
		UserInfoModel model = new UserInfoModel();
		mv.addObject("model", model);
		mv.setViewName("login");
		return mv;
	}

	@RequestMapping("/login")
	@ResponseBody
	public ResultViewModel login(UserInfoModel model)throws Exception{
		ResultViewModel resultModel = new ResultViewModel();
		if (model !=null) {
			if (userInfoService.checkUser(model)) {
				resultModel.setResultData(model);
			}else {
				resultModel.setErrorMsg("用户名或密码有误");
			}
		}else {
			resultModel.setErrorMsg("请检查参数");
		}
		return resultModel;
	}
}
