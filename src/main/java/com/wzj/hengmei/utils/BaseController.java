package com.wzj.hengmei.utils;


import java.io.Serializable;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.wzj.hengmei.constants.Const;
import com.wzj.hengmei.model.UserInfoModel;

public class BaseController implements Serializable{

	private static final long serialVersionUID = 6357869213649815390L;

	/** ログ */
	protected LoggerHelper logger = LoggerHelper.getLogger(this.getClass());

	@Resource(name="messageUtil")
	protected MessageUtil messageUtil;

	/**
	 * ResultViewModelを作成
	 * （Ajax用）
	 *
	 * @return ResultViewModel
	 */
	public ResultViewModel getResultViewModel(){
		return new ResultViewModel();
	}

	/**
	 * ModelAndViewを作成
	 *
	 * @return ModelAndView
	 */
	public ModelAndView getModelAndView(){
		return new ModelAndView();
	}

	/**
	 * requestを取得
	 */
	public HttpServletRequest getRequest() {
		return ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getRequest();
	}

	/**
	 * responseを取得
	 */
	public HttpServletResponse getResponse() {
		return ((ServletRequestAttributes)RequestContextHolder.getRequestAttributes()).getResponse();
	}

	/**
	 * メッセージを取得
	 *
	 * @param messageId
	 * @return メッセージ内容
	 */
	public String getMessage(String messageId) {
		return messageUtil.getMessage(messageId, RequestContextUtils.getLocale(getRequest()));
	}

	/**
	 * メッセージを取得
	 *
	 * @param messageId メッセージID
	 * @param arg パラメータ
	 * @return メッセージ内容
	 */
	public String getMessage(String messageId, String arg) {
		return messageUtil.getMessage(messageId, new String[]{arg}, RequestContextUtils.getLocale(getRequest()));
	}

	/**
	 * メッセージを取得
	 *
	 * @param messageId メッセージID
	 * @param arg1 パラメータ1
	 * @param arg2 パラメータ2
	 * @return メッセージ内容
	 */
	public String getMessage(String messageId, String arg1, String arg2) {
		return messageUtil.getMessage(messageId, new String[]{arg1, arg2}, RequestContextUtils.getLocale(getRequest()));
	}

	/**
	 * メッセージを取得
	 *
	 * @param messageId メッセージID
	 * @param args パラメータ
	 * @return メッセージ内容
	 */
	public String getMessage(String messageId, Object[] args) {
		return messageUtil.getMessage(messageId, args, RequestContextUtils.getLocale(getRequest()));
	}

	/**
	 * セッションから、attributeを取得
	 *
	 * @param key
	 * @return valule
	 */
	public Object getSessionAttr(String key) {
		HttpSession session = getRequest().getSession();
		return session.getAttribute(key);
	}

	/**
	 * セッションに、attributeを設定
	 *
	 * @param key
	 * @param valule
	 */
	public void setSessionAttr(String key, Object valule) {
		HttpSession session = getRequest().getSession();
		session.setAttribute(key, valule);
	}

	/**
	 * セッションに、attributeを削除
	 *
	 * @param key
	 */
	public void removeSessionAttr(String key) {
		HttpSession session = getRequest().getSession();
		session.removeAttribute(key);
	}

	/**
	 *
	 * @return
	 */
	protected UserInfoModel getLoginUserInfo() {
		return (UserInfoModel)getSessionAttr(Const.USER);
	}
}