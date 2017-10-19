package com.wzj.hengmei.utils;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public class DateUtil {

	/**
     * システム日付取得
     *
     * @return
     */
    public static String getSysDate4YMD() {
        return getSysDate("yyyyMMdd");
    }

    /**
     * システム時間取得
     *
     * @return
     */
    public static String getSysDate4HM() {
        return getSysDate("HH:mm");
    }

    /**
     * システム日時取得
     *
     * @return
     */
    public static String getSysDate4YMDHM() {
        return getSysDate("yyyy/MM/dd HH:mm");
    }

    /**
     * システム日時取得
     *
     * @return
     */
    public static String getSysDate4YYYYMMDDHHMM() {
        return getSysDate("yyyyMMddHHmm");
    }

    /**
     * システム日時取得
     *
     * @return
     */
    public static String getSysDate4YYYYMMDDHHMMSS() {
        return getSysDate("yyyyMMddHHmmss");
    }

    /**
     * システム日付取得
     *
     * @return
     */
    public static String getSysDate(String strDateFormat) {

        SimpleDateFormat sdf = null;
        String strNowDate = "";

        // パラメータチェック
        if (strDateFormat == null || strDateFormat.trim().length() == 0) {
            return strNowDate;
        }

        try {
            // システム日付を取得
            Date dateToday = getSysDate();

            // 指定された日付フォーマットに変換
            sdf = new SimpleDateFormat(strDateFormat);
            strNowDate = sdf.format(dateToday);

        } catch (Exception e) {
            // 予想外エラー
            strNowDate = "";
            e.printStackTrace();
        } finally {
            if (sdf != null) {
                sdf = null;
            }
        }

        return strNowDate;
    }

    /**
     * システム日付の取得
     *
     * @return Date システム日付
     */
    public static Date getSysDate() {

        // システム日付を取得
        Calendar calDefault = Calendar.getInstance();
        Date dateToday = calDefault.getTime();

        return dateToday;
    }

    /**
     * 日付フォーマット変換(Date->String)
     *
     * @param dt
     *            日付
     * @param format
     *            フォーマット
     * @return 変換後日付
     */
    public static String convDate2Str(Date date, String format) {
        SimpleDateFormat formatter;
        formatter = new SimpleDateFormat(format);

        return formatter.format(date);
    }

    /**
     * 日付フォーマット変換(Date->String)
     *
     * @return 変換後日付(yyyyMMdd)
     */
	public static String convDate2Str(Date date) {
		return convDate2Str(date, "yyyyMMdd");
	}

    /**
     * 日付フォーマット変換(Date->String)
     *
     * @return 変換後日付(yyyyMM)
     */
	public static String convMonth2Str(Date date) {
		return convDate2Str(date, "yyyyMM");
	}

	/**
     * 文字列をDateオブジェクトに変換します。
     *
     * @param date
     *            日付文字列(yyyy/MM/dd)
     * @return date Dateオブジェクト
     */
	public static Date convStr2Date(String date) {
		return convStr2Date(date, "yyyy/MM/dd");
	}

	/**
     * 文字列をDateオブジェクトに変換します。
     *
     * @param date
     *            日付文字列
     * @param format
     *            SimpleDateFormatに従った文字列パターン
     * @return date Dateオブジェクト
     */
	public static Date convStr2Date(String date, String format) {
		DateFormat fmt = new SimpleDateFormat(format);
		try {
			return fmt.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}

    /**
     * 日付(文字列)フォーマット
     *
     * @param strDate
     *            日付(文字列)
     * @param orgFormat
     *            変換前フォーマット
     * @param targetFormat
     *            変換後フォーマット
     * @return 変換後日付(文字列)
     */
    public static String formatDateStr(String strDate, String orgFormat, String targetFormat) {
        return convDate2Str(convStr2Date(strDate, orgFormat), targetFormat);
    }

    /**
     * 日付(文字列)フォーマット
     *
     * @param strDate
     *            日付(文字列)
     * @param orgFormat
     *            変換前フォーマット
     * @param targetFormat
     *            変換後フォーマット
     * @return 変換後日付(文字列)
     */
    public static String formatDateStrYMD(String strDate) {
        return convDate2Str(convStr2Date(strDate, "yyyyMMdd"), "yyyy/MM/dd");
    }

    /**
     * 日付(文字列)フォーマット
     *
     * @param strDate
     *            日付(文字列)
     * @param orgFormat
     *            変換前フォーマット
     * @param targetFormat
     *            変換後フォーマット
     * @return 変換後日付(文字列)
     */
    public static String formatDateStrYMD2(String strDate) {
    	if (strDate.length() > 8) {
    		strDate = strDate.substring(0, 8);
    	}
        return convDate2Str(convStr2Date(strDate, "yyyyMMdd"), "yyyy年MM月dd日");
    }

    /**
     * 日付の演算
     *
     * @param date
     *            基準日付 （備考）日付の形式は、「日付フォーマット変換（getDateFormat）」と同様。<BR>
     * @param minutes
     *            追加する分数
     */
	public static Date addMinutes(Date date, int minutes) {
		Calendar canlendar = Calendar.getInstance();
		canlendar.setTime(date);
		canlendar.add(Calendar.MINUTE, minutes);

		return canlendar.getTime();
	}

    /**
     * 日付の演算
     *
     * @param date
     *            基準日付 （備考）日付の形式は、「日付フォーマット変換（getDateFormat）」と同様。<BR>
     * @param month
     *            追加する日数
     */
	public static Date addDays(Date date, int days) {
		Calendar canlendar = Calendar.getInstance();
		canlendar.setTime(date);
		canlendar.add(Calendar.DATE, days);

		return canlendar.getTime();
	}

    /**
     * 日付の演算
     *
     * @param date
     *            基準日付 （備考）日付の形式は、「日付フォーマット変換（getDateFormat）」と同様。<BR>
     * @param month
     *            追加する月数
     */
	public static Date addMonths(Date date, int month) {
		Calendar canlendar = Calendar.getInstance();
		canlendar.setTime(date);
		canlendar.add(Calendar.MONTH, month);

		return canlendar.getTime();
	}

	/**
	 * 日付の比較
	 * @param date1
	 * @param date2
	 * @return
	 */
	public static int compareDate(String date1, String date2) {
		DateFormat df = new SimpleDateFormat("yyyyMMdd", Locale.CHINA);
		try {
			Date dt1 = df.parse(date1);
			Date dt2 = df.parse(date2);
			if (dt1.getTime() > dt2.getTime()) {
				return 1;
			} else if (dt1.getTime() < dt2.getTime()) {
				return -1;
			} else {
				return 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	/**
	 * 日付の比較
	 * @param date1
	 * @param date2
	 * @param format
	 * @return
	 */
	public static int formatCompareDate(String date1, String date2, String format) {
		DateFormat df = new SimpleDateFormat(format);
		try {
			Date dt1 = df.parse(date1);
			Date dt2 = df.parse(date2);
			if (dt1.getTime() > dt2.getTime()) {
				return 1;
			} else if (dt1.getTime() < dt2.getTime()) {
				return -1;
			} else {
				return 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
}
