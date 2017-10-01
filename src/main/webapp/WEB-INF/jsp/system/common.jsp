<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<c:set value="${pageContext.request.contextPath}" var="contextPath"/>

<base href="<%=basePath%>">

<script type="text/javascript">
	var contextPath = "${contextPath}";
</script>

<script type="text/javascript" src="${contextPath}/resources/js/jquery.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery-ui.js"></script>
<script type="text/javascript" src="${contextPath}/resources/js/jquery-ui.custom.js"></script>

<link rel="stylesheet" href="${contextPath}/resources/css/jquery.css" />
<link rel="stylesheet" href="${contextPath}/resources/css/jquery-ui.css" />
<link rel="stylesheet" href="${contextPath}/resources/css/jquery-ui.custom.css" />
