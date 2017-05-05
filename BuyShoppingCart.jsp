<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Buy Shopping Cart</title>
	</head>

<body>
		
		<table border="1">
			<tr>
				<th>Product</th>
		        <th>Quantity</th>
		        <th>Unit Price</th>
		        <th>Total Product Price</th>
			</tr>
			
			<%-- Import the java.sql package --%>
            <%@ page import="java.sql.*"%>
            <%-- -------- Open Connection Code -------- --%>
            <%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost:5432/CSE135_DB", "postgres", "admin");
				System.out.println("connected to database");

            %>
            
 
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                session.setAttribute("name", "aaa");
                System.out.println(session.getAttribute("name"));
                rs = statement.executeQuery("SELECT p.PRODUCT_ID AS PID, a.PRICE AS PRICE, p.QUANTITY FROM CUSTOMER_CART p, PRODUCTS a, users u WHERE p.PRODUCT_ID = a.ID AND p.OWNER_ID = u.ID AND u.user_name = '"+ (String)session.getAttribute("name") + "'");
       //         rs = statement.executeQuery("SELECT * FROM product_order p, users u WHERE p.USER_ID = u.ID AND u.user_name = '"+ (String)session.getAttribute("name") + "'");
                System.out.println("aaaaa");
                float total = 0.0f;
            %>
            
            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
                	total += Integer.parseInt(rs.getString("PRICE"))*rs.getInt("QUANTITY");
            %>

            <tr>
                <form action="BuyShoppingCart.jsp" method="POST">

	                <%-- Get the product name --%>
	                <td>
	                    <%=rs.getString("PID")%>
	                </td>
	
	                <%-- Get the Quantity --%>
	                <td>
	                 	<%=rs.getInt("QUANTITY")%>
	                </td>
	                
	                <%-- Get the Unit Price --%>
	                <td>
	                 	<%=rs.getInt("PRICE")%>
	                </td>
					
					<%-- Get the Total Product Price --%>
	                <td>
	                 	<%=Integer.parseInt(rs.getString("PRICE"))*rs.getInt("QUANTITY")%>
	                </td>
                
                </form>
            </tr>

            <%
                }
            %>
            <tr>
            	<td>
            	N/A
            	</td>
            	<td>
            	N/A
            	</td>
            	<td>
            	N/A
            	</td>
            	<td>
            	<%= total %>
            	</td>
            </tr>
            <%-- -------- Close Connection Code -------- --%>
            <%
            // Close the ResultSet
            rs.close();

            // Close the Statement
            statement.close();


                // Close the Connection
                conn.close();
            
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
		</table>
		
		<form action="ProcessPurchase.jsp" method="POST">
		  <input type="hidden" name="action" value="card"/>
		  Credit Card Number: <input type="text" name="cnum" required><br>
		  <input type="submit" value="Purchase">
		</form>
	</body>
</html>