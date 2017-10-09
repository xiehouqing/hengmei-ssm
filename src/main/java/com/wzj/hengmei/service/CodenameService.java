/**
 *
 */
package com.wzj.hengmei.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.BeanUtils;

import com.wzj.hengmei.entity.Codename;
import com.wzj.hengmei.entity.CodenameExample;
import com.wzj.hengmei.mapper.CodenameMapper;
import com.wzj.hengmei.model.CodenameModel;
import com.wzj.hengmei.utils.BaseService;

/**
 * 码表Service
 *
 * @author : newtouch
 */
public class CodenameService extends BaseService{
	@Resource
	CodenameMapper codenameMapper;

	/**
	 *根据名称，key值 取得value值
	 * @param name 字段名
	 * @param key code
	 * @return value name
	 */
	public String getValueByKey(String name,String key){
		CodenameModel model = new CodenameModel();
		CodenameExample example = new CodenameExample();
		example.createCriteria()
		.andDelFlgEqualTo("0")
		.andFieldNameEqualTo(name)
		.andCodeEqualTo(key);
		List<Codename> selectByExample = codenameMapper.selectByExample(example);
		if (!selectByExample.isEmpty()) {
			BeanUtils.copyProperties(selectByExample.get(0), model);
		}
		return model.getName();
	}

	/**
	 *根据名称，value值 取得key值
	 * @param name 字段名
	 * @param value name
	 * @return key code
	 */
	public String getKeyByValue(String name,String value){
		CodenameModel model = new CodenameModel();
		CodenameExample example = new CodenameExample();
		example.createCriteria()
		.andDelFlgEqualTo("0")
		.andFieldNameEqualTo(name)
		.andNameEqualTo(value);
		List<Codename> selectByExample = codenameMapper.selectByExample(example);
		if (!selectByExample.isEmpty()) {
			BeanUtils.copyProperties(selectByExample.get(0), model);
		}
		return model.getCode();
	}

	/**
	 *根据名称 取得key,value Map
	 * @param name 字段名
	 * @return Map<key, value> key,value
	 */
	public Map<String, String> getKeyValuesByName(String name){
		Map<String, String> resultMap = new HashMap<String, String>();
		CodenameExample example = new CodenameExample();
		example.createCriteria()
		.andDelFlgEqualTo("0")
		.andFieldNameEqualTo(name);
		List<Codename> selectByExample = codenameMapper.selectByExample(example);
		if (!selectByExample.isEmpty()) {
			for (Codename entity : selectByExample) {
				resultMap.put(entity.getCode(), entity.getName());
			}
		}
		return resultMap;
	}
}