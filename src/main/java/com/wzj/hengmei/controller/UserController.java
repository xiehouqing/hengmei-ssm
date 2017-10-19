/**
 *
 */
package com.wzj.hengmei.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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

	/**
	 * ファイルダウンロード処理
	 * @param filePath
	 * @param newFileName
	 * @return
	 */
	public void fileDownload(String filePath, String newFileName,HttpServletResponse response) {
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		try {
			File file = new File(filePath + newFileName);
			if (file.exists()) {
				response.reset();
				response.setContentType("application/octet-stream;charset=UTF-8");
				response.setHeader("Content-disposition", "attachment; filename=" + URLEncoder.encode(newFileName, "UTF-8"));
				response.setHeader("Content-Length", String.valueOf(file.length()));
				bis = new BufferedInputStream(new FileInputStream(file));
				bos = new BufferedOutputStream(response.getOutputStream());
				bos.write(new   byte []{( byte ) 0xEF ,( byte ) 0xBB ,( byte ) 0xBF });//BOM
				byte[] buff = new byte[2048];
				int bytesRead;
				while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
					bos.write(buff, 0, bytesRead);
				}
				bos.flush();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				bis.close();
			} catch (Exception ex) {
			}
			try {
				bos.close();
			} catch (Exception ex) {
			}
		}
	}
}