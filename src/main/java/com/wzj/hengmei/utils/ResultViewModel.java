package com.wzj.hengmei.utils;

public class ResultViewModel {

	public boolean result;
	
	public String errorMsg;
	
	public Object resultData;

	
	
	public ResultViewModel() {
		this.result = false;
	}
	public boolean isResult() {
		return result;
	}
	public void setResult(boolean result) {
		this.result = result;
	}
	public String getErrorMsg() {
		return errorMsg;
	}
	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}
	public Object getResultData() {
		return resultData;
	}
	public void setResultData(Object resultData) {
		this.resultData = resultData;
	}
}