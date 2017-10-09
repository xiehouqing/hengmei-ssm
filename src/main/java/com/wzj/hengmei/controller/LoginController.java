/**
 *
 */
package com.wzj.hengmei.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.wzj.hengmei.model.UserInfoModel;
import com.wzj.hengmei.service.UserInfoService;
import com.wzj.hengmei.utils.ResultViewModel;

/**
 * 登录Controller
 *
 * @author : newtouch
 */
@Controller
@RequestMapping("/login")
public class LoginController {
	@Autowired
	UserInfoService userInfoService;

	/**
	 * 登录画面初始化
	 * @return
	 */
	@RequestMapping("/init")
	public ModelAndView init(){
		ModelAndView mv = new ModelAndView();
		UserInfoModel model = new UserInfoModel();
		mv.addObject("model", model);
		mv.setViewName("login");
		return mv;
	}

	/**
	 * 登录
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping("/login")
	public ResultViewModel login(UserInfoModel model) throws Exception{
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