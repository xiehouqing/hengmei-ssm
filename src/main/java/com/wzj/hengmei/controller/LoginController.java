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
import com.wzj.hengmei.utils.BaseController;
import com.wzj.hengmei.utils.LoggerHelper;
import com.wzj.hengmei.utils.ResultViewModel;

/**
 * 登录Controller
 *
 * @author : newtouch
 */
@Controller
@RequestMapping("/login")
public class LoginController extends BaseController{
	@Autowired
	UserInfoService userInfoService;
	/** ログ */
	private LoggerHelper log = LoggerHelper.getLogger(this.getClass());
	/**
	 * 登录画面初始化
	 * @return
	 */
	@RequestMapping("/init")
	public ModelAndView init(){
		ModelAndView mv = new ModelAndView();
		UserInfoModel model = new UserInfoModel();
		log.error(getMessage("error.authentication.credentials.ip.bad"));
		mv.addObject("model", model);
		log.debug("text debug");
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
		log.info("登录开始--------------------------------------------------");
		if (model !=null) {
			if (userInfoService.checkUser(model)) {
				resultModel.setResultData(model);
			}else {
				resultModel.setErrorMsg(getMessage("error.authentication.credentials.validDate.bad"));
				log.warn(getMessage("error.authentication.credentials.bad"));
			}
		}else {
			resultModel.setErrorMsg("请检查参数");
			log.warn(getMessage("auth.error.msg.other"));
		}
		log.info("登录结束---------------------------------------------------");
		return resultModel;
	}
}