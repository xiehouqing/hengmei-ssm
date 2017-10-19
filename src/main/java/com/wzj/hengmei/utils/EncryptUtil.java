package com.wzj.hengmei.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import org.springframework.stereotype.Component;

/**
 * 暗号化Util
 *
 */
@Component("encryptUtil")
public class EncryptUtil {
	/** 暗号化キー */
	private static String KEY = "nextep";

	private Cipher encryptCipher = null;
	private Cipher decryptCipher = null;

	/**
	 * MD5 暗号化
	 *
	 */
    public String md5(String plainText) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(plainText.getBytes());
            byte b[] = md.digest();

            int i;

            StringBuffer buf = new StringBuffer("");
            for (int offset = 0; offset < b.length; offset++) {
                i = b[offset];
                if (i < 0)
                    i += 256;
                if (i < 16)
                    buf.append("0");
                buf.append(Integer.toHexString(i));
            }
            return buf.toString();

        } catch (NoSuchAlgorithmException e) {
            return plainText;
        }
    }

	/**
	 * 暗号化
	 *
	 */
	public String encrypt(String content) throws Exception {
		if (encryptCipher == null) {
	        encryptCipher = Cipher.getInstance("AES");
	        encryptCipher.init(Cipher.ENCRYPT_MODE, generateKey());
		}

		byte[] byteContent = content.getBytes("utf-8");
		byte[] result = encryptCipher.doFinal(byteContent);
        return parseByte2HexStr(result);
	}

	/**
	 * 復号化
	 *
	 */
	public String decrypt(String content)  throws Exception {
		// 初期化
		if (decryptCipher == null) {
			decryptCipher = Cipher.getInstance("AES");
			decryptCipher.init(Cipher.DECRYPT_MODE, generateKey());
		}

		byte[] decryptFrom = parseHexStr2Byte(content);
		byte[] result = decryptCipher.doFinal(decryptFrom);
		return new String(result);
	}

	/**
	 * キーを作成
	 *
	 */
	private SecretKeySpec generateKey() throws Exception {
		KeyGenerator kgen = KeyGenerator.getInstance("AES");
		SecureRandom secureRandom = SecureRandom.getInstance("SHA1PRNG" );
        secureRandom.setSeed(KEY.getBytes());
        kgen.init(128, secureRandom);
        SecretKey secretKey = kgen.generateKey();

        SecretKeySpec key = new SecretKeySpec(secretKey.getEncoded(), "AES");

        return key;
	}

	/**
	 * Byte to Str
	 *
	 */
	private String parseByte2HexStr(byte buf[]) {
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < buf.length; i++) {
			String hex = Integer.toHexString(buf[i] & 0xFF);
			if (hex.length() == 1) {
				hex = '0' + hex;
			}
			sb.append(hex.toUpperCase());
		}
		return sb.toString();
	}

	/**
	 * HexStr to Byte
	 *
	 */
	private byte[] parseHexStr2Byte(String hexStr) {
		if (hexStr.length() < 1)
			return null;
		byte[] result = new byte[hexStr.length() / 2];
		for (int i = 0; i < hexStr.length() / 2; i++) {
			int high = Integer.parseInt(hexStr.substring(i * 2, i * 2 + 1), 16);
			int low = Integer.parseInt(hexStr.substring(i * 2 + 1, i * 2 + 2), 16);
			result[i] = (byte) (high * 16 + low);
		}
		return result;
	}

	public static void main(String[] args) {
		EncryptUtil encryptUtil = new EncryptUtil();
		try {
			System.out.println("123暗号化AES："+encryptUtil.encrypt("123")+","+encryptUtil.encrypt("123").length());
			System.out.println("1097B1F5690C57F5268CF8CCDF45541E:"+encryptUtil.decrypt("1097B1F5690C57F5268CF8CCDF45541E"));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}