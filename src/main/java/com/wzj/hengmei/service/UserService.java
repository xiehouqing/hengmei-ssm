/**
 *
 */
package com.wzj.hengmei.service;

import javax.annotation.Resource;

import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import com.wzj.hengmei.entity.User;
import com.wzj.hengmei.mapper.UserMapper;
import com.wzj.hengmei.model.UserModel;

/**
 * TODO(用一句话描述该文件做什么)
 *
 * @author : newtouch
 */
@Service("userService")
public class UserService {
	@Resource
	UserMapper userMapper;

	public UserModel getUserModelById(Integer id){
		User user = userMapper.selectByPrimaryKey(id);
		UserModel userModel = new UserModel();
		if (user != null) {
			BeanUtils.copyProperties(user, userModel);
		}
		return userModel;
	}
}
