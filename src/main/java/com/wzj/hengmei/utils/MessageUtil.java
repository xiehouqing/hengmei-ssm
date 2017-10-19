package com.wzj.hengmei.utils;

import java.util.Locale;

import org.springframework.context.NoSuchMessageException;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationObjectSupport;

/**
 * メッセージUtil
 *
 */
@Component("messageUtil")
public class MessageUtil extends WebApplicationObjectSupport {

	LoggerHelper logger = LoggerHelper.getLogger(this.getClass());

	/**
     * メッセージを取得
     *
     * @param messageId メッセージID
     * @param locale
     * @return メッセージ
     */
	public String getMessage(String messageId, Locale locale){

		String ret = "";
		try {
			ret = getWebApplicationContext().getMessage(messageId, null, locale);
		} catch (NoSuchMessageException e) {
			logger.error(e, e);
			ret = messageId;
		}
		return ret;
	}

	/**
     * メッセージを取得
     *
     * @param messageId メッセージID
     * @param arguments パラメータ
     * @param locale
     * @return メッセージ
     */
	public String getMessage(String messageId,Object[] arguments,Locale locale){
		String ret = "";
		try {
			ret = getWebApplicationContext().getMessage(messageId, arguments, locale);
		} catch (NoSuchMessageException e) {
			logger.error(e, e);
			ret = messageId;
		}
		return ret;
	}
}
