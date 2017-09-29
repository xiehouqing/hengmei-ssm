package com.wzj.hengmei.constants.enums;

public enum RoleValue {
	/** 查看权限参考值【00001】 */
	ROLE_LOOK_VALUE(1),
	/** 添加权限参考值【00010】 */
	ROLE_ADD_VALUE(2),
	/** 修改权限参考值【00100】 */
	ROLE_UPDATE_VALUE(4),
	/** 删除权限参考值【01000】 */
	ROLE_DELETE_VALUE(8),
	/** 导出权限参考值【10000】 */
	ROLE_DOWNLOAD_VALUE(16),
	/** 带有下载权限的全部权限参考值【11111】 */
	ROLE_ALL_VALUE(31);

	public final int code;

	private RoleValue(int code) {
		this.code = code;
	}

	public int code() {
		return code;
	}
}
