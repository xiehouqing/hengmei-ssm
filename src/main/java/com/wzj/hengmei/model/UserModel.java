/**
 *
 */
package com.wzj.hengmei.model;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import com.wzj.hengmei.entity.User;

/**
 * TODO(用一句话描述该文件做什么)
 * @author : newtouch
 */
public class UserModel extends User {

	/* (非 Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		StringBuffer sb = new StringBuffer("UserModel{")
		.append(" [id]= ").append(getId())
		.append(" , [username]= ").append(getUserName())
		.append(" , [password]= ").append(getPassword())
		.append(" , [age]= ").append(getAge())
		.append("}");
		return sb.toString();
	}

	public String toStrings(Object obj){
		try {
			StringBuffer sb = new StringBuffer();
			// 获取实体类的所有属性，返回Field数组
			//getDeclaredFields()只能获取自己声明的各种字段，包括public，protected，private。
			//getFields()只能获取public的字段，包括父类的。
			Field[] fields = obj.getClass().getDeclaredFields();
			//Field[] fields = obj.getClass().getFields();
			// 遍历所有属性
			for (Field field : fields) {
				//获取属性名
				String fieldName = field.getName();
				//将属性的首字符大写，方便构造get，set方法
				fieldName = fieldName.substring(0, 1).toUpperCase() + fieldName.substring(1);
				//获取属性类型
				String fieldType = field.getGenericType().toString();
				Method fieldMethod = obj.getClass().getMethod("get"+fieldName,new Class[0]);
				// 调用getter方法获取属性值
				String value = String.valueOf(fieldMethod.invoke(obj, new Object[0]));
				sb.append(", (").append(fieldType).append(")")
				.append(" [").append(fieldName).append("] = ")
				.append("{").append(value).append("}");
			}
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}