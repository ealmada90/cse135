<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Home Page</title>
</head>
<body>
<%
if(((String)session.getAttribute("name")) == null){ %>
	<jsp:include page="/login.html" />
	<%} else{ %>



	Welcome: <%=session.getAttribute("name") %>
	<%if(((String)session.getAttribute("role")).equals("owner")){ %>
	<li><a href="categories.jsp">Categories</a></li>
	<li><a href="product.jsp">Products</a></li>
	<%} else{ %>
	<li><a href="">Products Browsing</a></li>
	<li><a href="">Products Order</a></li>
	<li><a href="">Buy Shopping Cart</a></li>
	<%} %>
</body>
<%} %>
</html>