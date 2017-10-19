package com.wzj.hengmei.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Maker {

	public final static String md5(String pass) {
		try {
			if (pass == null) {
				throw new NullPointerException("NullPointerException");
			}
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(pass.getBytes());
			byte[] test = md.digest();
			String md5pass = "";
			for (int i = 0; i < 16; i++) {
				md5pass += byteHEX(test[i]);
			}
			return md5pass;
		} catch (NoSuchAlgorithmException e) {
			return null;
		}
	}

	private static String byteHEX(byte ib) {
		char[] Digit = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A',
				'B', 'C', 'D', 'E', 'F' };
		char[] ob = new char[2];
		ob[0] = Digit[(ib >>> 4) & 0X0F];
		ob[1] = Digit[ib & 0X0F];
		String s = new String(ob);
		return s;
	}

}