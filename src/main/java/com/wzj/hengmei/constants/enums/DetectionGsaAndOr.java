package com.wzj.hengmei.constants.enums;

/**
 * 検出設備 AND OR Enumクラス
 * @author : newtouch
 */
public enum DetectionGsaAndOr {

	/** 検出設備 AND OR[1][ AND ]*/
	DETECTION_GSA_AND("1"," AND "),
	/** 検出設備 AND OR[2][ OR ]*/
	DETECTION_GSA_OR("2"," OR ");

	public final String key;
	public final String value;

	/**
	 * デフォルトコンストラクタ
	 * @param key
	 * @param value
	 */
	private DetectionGsaAndOr(String key, String value) {
		this.key = key;
		this.value = value;
	}

	/**
	 *	キーで値を取得する
	 * @param key
	 * @return value
	 */
	public static String getValue(String key) {
		for (DetectionGsaAndOr enu : DetectionGsaAndOr.values()) {
			if (enu.key.equals(key)) {
				return enu.value;
			}
		}
		return null;
	}
}