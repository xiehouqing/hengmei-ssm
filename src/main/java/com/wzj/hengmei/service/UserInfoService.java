package com.wzj.hengmei.service;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.wzj.hengmei.entity.UserInfo;
import com.wzj.hengmei.entity.UserInfoExample;
import com.wzj.hengmei.entity.UserInfoExample.Criteria;
import com.wzj.hengmei.mapper.UserInfoMapper;
import com.wzj.hengmei.model.UserInfoModel;
import com.wzj.hengmei.utils.MD5Maker;

/**
 * 
 * @author nxwzj
 *
 */
@Service("userInfoService")
public class UserInfoService {
	@Resource
	UserInfoMapper userInfoMapper;
	
	/**
	 * 验证用户名密码
	 * @param model
	 * @return
	 */
	public boolean checkUser(UserInfoModel model) {
		UserInfoExample example = new UserInfoExample();
		if (model != null && !isEmpty(model.getUserName()) && !isEmpty(model.getPassword())) {
			String userName = model.getUserName();
			String password = model.getPassword();
			String pwMD5 = MD5Maker.md5(password);
			example.createCriteria()
			.andDelFlgEqualTo("0")
			.andUserNameEqualTo(userName)
			.andPasswordEqualTo(pwMD5);
			List<UserInfo> selectByExample = userInfoMapper.selectByExample(example);
			if (!selectByExample.isEmpty()) {
				return true;
			}
		}
		return false;
	}
	
	/**
	 * 查询用户名是否存在
	 * @param model
	 * @return
	 */
	public boolean checkUserName(UserInfoModel model) {
		UserInfoExample example = new UserInfoExample();
		if (model != null && !isEmpty(model.getUserName())) {
			String userName = model.getUserName();
			example.createCriteria().andUserNameEqualTo(userName);
			List<UserInfo> selectByExample = userInfoMapper.selectByExample(example);
			if (!selectByExample.isEmpty()) {
				return true;
			}
		}
		return false;
	}
	
	public boolean isEmpty(String str) {
		return str == null && "".equals(str) ? true: false;
	}
}