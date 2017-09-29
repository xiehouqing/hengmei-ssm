/**
 *
 */
package hengmei;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.BeanUtils;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.wzj.hengmei.entity.User;
import com.wzj.hengmei.model.UserModel;
import com.wzj.hengmei.service.UserService;

/**
 * TODO(用一句话描述该文件做什么)
 * @author : newtouch
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring-mybatis.xml"})
public class TestMybatis {
	private static Logger logger = Logger.getLogger(TestMybatis.class);
	@Resource
	UserService userService;

	@Test
	public void test(){
		UserModel userModel = userService.getUserModelById(1);
		User user = new User();
		BeanUtils.copyProperties(userModel, user);
		//System.out.println(userModel);
		System.out.println(userModel.toStrings(user));
	}
}
