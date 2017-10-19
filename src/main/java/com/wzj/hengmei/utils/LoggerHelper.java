package com.wzj.hengmei.utils;

import org.apache.logging.log4j.LogManager;

public class LoggerHelper {

	private org.apache.logging.log4j.Logger logger;

	/**
	 * ログ対象を作成する
	 *
	 */
	public static LoggerHelper getLogger(Class classObject) {
		return new LoggerHelper(LogManager.getLogger(classObject));
	}

	private LoggerHelper(org.apache.logging.log4j.Logger log4jLogger) {
		logger = log4jLogger;
	}

	public void debug(Object object) {
		logger.debug(object);
	}

	public void debug(Object object, Throwable e) {
		logger.debug(object, e);
	}

	public void info(Object object) {
		logger.info(object);
	}

	public void info(Object object, Throwable e) {
		logger.info(object, e);
	}

	public void warn(Object object) {
		logger.warn(object);
	}

	public void warn(Object object, Throwable e) {
		logger.warn(object, e);
	}

	public void error(Object object) {
		logger.error(object);
	}

	public void error(Object object, Throwable e) {
		logger.error(object, e);
	}

	public void fatal(Object object) {
		logger.fatal(object);
	}

	public String getName() {
		return logger.getName();
	}

	public org.apache.logging.log4j.Logger getLog4jLogger() {
		return logger;
	}
}