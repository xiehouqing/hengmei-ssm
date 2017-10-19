package com.wzj.hengmei.constants;

/**
 * Web常量类
 * @author newtouch
 *
 */
public class Const {
	/** ユーザー情報 */
	public static final String USER = "sessionUser";
	/** 验证APP */
	public static final String AUTH_SERVICE_APP = "auth_service_app";
	/** 验证信息加密方式 */
	public static final String AUTH_SERVICE_ENCRYPT_TYPE = "auth_service_encrypt_type";
	/** 验证服务器IP限制 */
	public static final String AUTH_SERVICE_IP = "auth_service_ip";
	/** 验证错误消息 */
	public static final String AUTH_ERROR_MSG_OTHER = "auth.error.msg.other";

	/** 验证信息加密方式(1：ID和密码都不加密) */
	public static final String AUTH_SERVICE_ENCRYPT_TYPE_1 = "1";
	/** 验证信息加密方式(2：ID不加密，密码加密) */
	public static final String AUTH_SERVICE_ENCRYPT_TYPE_2 = "2";
	/** 验证信息加密方式(3：ID和密码都加密) */
	public static final String AUTH_SERVICE_ENCRYPT_TYPE_3 = "3";

	/** 页面区分 新增权限 */
	public static final String PAGEMODE_ADD = "0";
	/** 页面区分 修改权限 */
	public static final String PAGEMODE_MODIFY = "1";
	/** 页面区分 查看权限 */
	public static final String PAGEMODE_SEE = "2";
	/** 年月日时间控件格式  */
	public static final String DEFAULTDATEPICKER_DATE_FORMAT = "yyyy/MM/dd";

	/** 验证服务器地址 */
	public static final String AUTH_SERVICE_URL = "auth_service_url";
	/** 用户验证 */
	public static final String USER_AUTH_URL = "user_auth_url";
	/** 更新个人资料 */
	public static final String UPDATE_USER_INFO_URL = "update_user_info_url";

	/** 是否可用 标识 */
	public static final String  USABLE_YES="1";
	public static final String  USABLE_NO="0";

	/** 查询用户存在 */
	public static final String CHECK_PHONE_URL= "check_phone_url";
	/** 查询用户密码 */
	public static final String SELECT_PASSWORD_URL = "select_password_url";
	/** 注册新公司信息 */
	public static final String CMS_REGISTER_COMPANY_URL = "cms_register_company_url";
	/** 注册验证用户信息*/
	public static final String CMS_REGISTER_USER_URL = "add_user_url";
	/**修改公司信息 */
	public static final String CMS_UPDATE_COMPANY_URL = "cms_update_company_url";
	/** 修改验证用户信息 */
	public static final String CMS_UPDATE_USER_URL = "update_user_url";
	/** 新建公司套餐信息 */
	public static final String CMS_ADD_COMPANYPACKAGE_URL = "cms_add_companyPackage_url";
	/** 修改公司套餐信息 */
	public static final String CMS_UPDATE_COMPANYPACKAGE_URL = "cms_update_companyPackage_url";
	/** 新增公司与客服关系信息 */
	public static final String CMS_ADD_USER_COMPANY_URL = "cms_add_user_company_url";
	/** 升级公司套餐 */
	public static final String CMS_UPGRADE_VERSION_URL = "cms_upgrade_version_url";

	/** 验证码用途 密码相关 */
	public static final String VER_CODE_TYPE_PASSWORD = "2";
	/**验证码**/
	public static final String VerificationCode = "8888";
	/** 发送验证码模板ID 客户签单 */
	public static final String VER_CODE_TEMP_CUSTOMER_SIGNING = "SMS_71115180";

	/** 验证码限定超时时间*/
	public static final Integer TIME_OUT_PERIOD = 30;

	/** 验证码更新登录user*/
	public static final String INS_USER_WECHAT = "wechat";
	/** 验证履历类型:密码相关 */
	public static final String VERIFICATION_CODE_TYPE_2 = "2";

	/** codename */
	public static final String CODE_NAME = "session_key_codeName";
	/** 城市 */
	public static final String CITY = "session_key_city";

	/** 开通类型 */
	public static final String CREATE_TYPE = "create_type";
	/** 开通类型 (自销)*/
	public static final String CREATE_TYPE_SELFSALE = "0";
	/** 开通类型 (代理商)*/
	public static final String CREATE_TYPE_AGENT = "1";
	/** 套餐版本类型 */
	public static final String VERSION = "version";
	/** 审核区分 (未审核)*/
	public static final String COMPANYSTATUS_00 = "00";
	/** 审核区分 (初级审核通过)*/
	public static final String COMPANYSTATUS_01 = "01";
	/** 审核区分 (最终审核通过)*/
	public static final String COMPANYSTATUS_02 = "02";
	/** 审核区分 (未审核(手机申请))*/
	public static final String COMPANYSTATUS_03 = "03";
	/** 审核区分 (审核拒绝)*/
	public static final String COMPANYSTATUS_09 = "09";
	/** 审核区分 (数据处理中(创建公司))*/
	public static final String COMPANYSTATUS_11 = "11";
	/** 审核区分 (数据处理中(套餐升级))*/
	public static final String COMPANYSTATUS_12 = "12";
	/** 审核区分 (数据处理完成(需创建门店))*/
	public static final String COMPANYSTATUS_21 = "21";
	/** 审核区分 (初级审核通过(套餐升级))*/
	public static final String COMPANYSTATUS_31 = "31";
	/** 审核区分 (最终审核通过(套餐升级))*/
	public static final String COMPANYSTATUS_32 = "32";
	/** 审核区分 (审核拒绝(套餐升级))*/
	public static final String COMPANYSTATUS_39 = "39";
	/** 审核区分 (正常)*/
	public static final String COMPANYSTATUS_80 = "80";
	/** 审核区分 (异常)*/
	public static final String COMPANYSTATUS_90 = "90";

	/** 一级审核客服ID */
	public static final  String FIRST_USER_ID = "1";
	/** 二级审核客服ID */
	public static final  String SECOND_USER_ID = "2";

	/** PC创建 */
	public static final String PC_CREATE_MAINTAIN_FLG = "1";
	/**PHONE创建 */
	public static final String PHONE_CREATE_MAINTAIN_FLG = "2";
	/** 升级 */
	public static final String PC_UPGRADE_MAINTAIN_FLG = "3";

	/** 修改用户状态和公司审核flg信息 */
	public static final String CMS_UPDATE_STATUS_FLG_URL = "cms_update_status_flg_url";
}
