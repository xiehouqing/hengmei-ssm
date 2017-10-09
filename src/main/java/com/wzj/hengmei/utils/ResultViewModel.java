package com.wzj.hengmei.utils;

/**
 * ResultViewModel
 *
 */

public class ResultViewModel {

	/** success */
	private Boolean success;
	/** error dom */
	private String errorDom;
	/** error message */
	private String errorMsg;
	/** result data */
	private Object resultData;

	/**
	 * ResultViewModel作成
	 */
	public ResultViewModel() {
		this.initModel(true, "", "", "");
	}

	/**
	 * ResultViewModel作成
	 *
	 * @param errorMsg
	 */
	public ResultViewModel(String errorMsg){
		this.initModel(false, "", errorMsg, "");
	}

	/**
	 * ResultViewModel作成
	 *
	 * @param errorDom
	 * @param errorMsg
	 */
	public ResultViewModel(String errorDom, String errorMsg) {
		this.initModel(false, errorDom, errorMsg, "");
	}

	/**
	 * successを取得します。
	 * @return success
	 */
	public Boolean getSuccess() {
	    return success;
	}

	/**
	 * successを設定します。
	 * @param success success
	 */
	public void setSuccess(Boolean success) {
	    this.success = success;
	}

	/**
	 * error domを取得します。
	 * @return error dom
	 */
	public String getErrorDom() {
	    return errorDom;
	}

	/**
	 * error messageを取得します。
	 * @return error message
	 */
	public String getErrorMsg() {
	    return errorMsg;
	}

	/**
	 * error messageを設定します。
	 * @param errorMsg error message
	 */
	public void setErrorMsg(String errorMsg) {
		this.success = false;
		this.errorDom = "";
	    this.errorMsg = errorMsg;
	}

	/**
	 * error messageを設定します。
	 * @param errorMsg error message
	 */
	public void setErrorMsg(String errorDom, String errorMsg) {
		this.success = false;
		this.errorDom = errorDom;
	    this.errorMsg = errorMsg;
	}

	/**
	 * result dataを取得します。
	 * @return result data
	 */
	public Object getResultData() {
	    return resultData;
	}

	/**
	 * result dataを設定します。
	 * @param resultData result data
	 */
	public void setResultData(Object resultData) {
	    this.resultData = resultData;
	}

	/**
	 * 初期化
	 *
	 * @param success
	 * @param errorDom
	 * @param errorMsg
	 * @param resultData
	 */
	private void initModel(boolean success, String errorDom, String errorMsg, Object resultData) {
		this.success = success;
		this.resultData = resultData;
		this.errorDom = errorDom;
		this.errorMsg = errorMsg;
	}
}