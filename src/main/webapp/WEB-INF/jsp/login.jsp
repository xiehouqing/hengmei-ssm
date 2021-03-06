<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login</title>
</head>
<body>
	<form:form action="login" method="post" modelAttribute="model" role="form" id="userForm">
		<input type="hidden" id="test" value='<spring:message code="screen.button.login" />'/>
		<input type="hidden" id="test1" value='<spring:message code="screen.paswordBack.forgetPassword" />'/>
		<label for="userName"><spring:message code="screen.login.username"/>: </label>
		<form:input path="userName" label="userName"/>
		<br>
		<label for="password"><spring:message code="screen.login.password"/> : </label>
		<form:password path="password" label="password"/>
		<br>
		<form:button type="submit"><spring:message code="screen.button.login" /></form:button>
	</form:form>
</body>
</html>