package com.wzj.hengmei.utils;

import java.math.BigDecimal;
import java.math.BigInteger;

import org.springframework.util.StringUtils;
/**
 * 共通Service
 * @author nxwzj
 *
 */
public class BaseService {

	/**
	 * BigInteger → int
	 * @param bigint
	 * @return int
	 */
	public static int bigInteger2Int(BigInteger bigint){
		return bigint.intValue();
	}

	/**
	 * BigDecimal转string
	 * @param bigDecimal
	 * @return String
	 */
	public static String bigDecimal2String(BigDecimal bigDecimal){
		if (bigDecimal != null ) {
			return String.valueOf(bigDecimal);
		}else{
			return "0.00";
		}
	}

	/**
	 * Number转BigDecimal
	 * @param num(int||double)
	 * @return BigDecimal
	 */
	public static BigDecimal number2BigDecimal(Number num){
		if (num instanceof Integer) {
			return new BigDecimal(num.intValue());
		}else if (num instanceof Double) {
			return new BigDecimal(num.doubleValue()).setScale(2,BigDecimal.ROUND_HALF_DOWN);
		}
		return new BigDecimal(0);
	}

	/**
	 * 判断是否为空
	 * @param object
	 * @return boolean(true:空、false:非空)
	 */
    public static boolean isEmpty(Object object) {
    	if (object instanceof String) {
			return StringUtils.isEmpty(object);
		}
    	return object == null;
    }
}