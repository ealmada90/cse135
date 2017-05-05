<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Processing</title>
</head>
<body>
<%
                // Check if a delete is requested
                if (request.getParameter("cnum") !=null) {
                //	int cardNum = Integer.parseInt(request.getParameter("cnum"));
                	int length = (request.getParameter("cnum")).length();
					System.out.println("card input");
					if(length == 16){
						System.out.println("VALID CARD");%>
						
						
						<%-- Import the java.sql package --%>
			            <%@ page import="java.sql.*"%>
			            <%-- -------- Open Connection Code -------- --%>
			            <%
			            
			            Connection conn = null;
			            PreparedStatement pstmt = null;
			            ResultSet rs = null;
			            ResultSet rs2 = null;
			            ResultSet rs3 = null;
			            ResultSet rs4 = null;
			            ResultSet rs5 = null;
			            ResultSet rs6 = null;

			            try {
			                // Registering Postgresql JDBC driver with the DriverManager
			                Class.forName("org.postgresql.Driver");
			
			                // Open a connection to the database using DriverManager
			                conn = DriverManager.getConnection(
			                    "jdbc:postgresql://localhost:5432/CSE135_DB", "postgres", "admin");
							System.out.println("connected to database");
			
			                // Create the statement
			                Statement statement = conn.createStatement();%>
			                <%-- -------- Save Purchase Info -------- --%>
			                
			                <%
			                rs = statement.executeQuery("SELECT u.ID AS UID FROM users u WHERE u.user_name = '"+ session.getAttribute("name")+ "'");
			                rs2 = statement.executeQuery("SELECT DISTINCT PRODUCT_ID AS PID FROM CART WHERE '"+ rs.getString("UID") +"= OWNER_ID");
			                //loop
			                while(rs2.next()){
				                rs3 = statement.executeQuery("SELECT PRICE AS PRC FROM PRODUCTS WHERE ID = '"+ rs2.getInt("PID")+"'");
				                rs4 = statement.executeQuery("SELECT COUNT(*) AS CNT FROM CART WHERE '"+rs.getString("UID") + "' = OWNER_ID AND '"+ rs2.getInt("PID")+"' = PRODUCT_ID");
				                rs5 = statement.executeQuery("INSERT INTO PRODUCT_ORDER (QUANTITY, USER_ID, PRODUCT_ID, PRICE) VALUES ('"+rs4.getInt("CNT")+"', '"+
				                                             rs.getString("UID")+"', '"+ rs2.getInt("PID")+"', '"+ rs3.getInt("PRC")+"')");
				                
			                }
			                rs6 = statement.executeQuery("DELETE FROM CART WHERE USER_ID = '"+ rs.getString("UID")+"'");
				            // Close the ResultSet
				            rs.close();
			                rs2.close();
			                rs3.close();
			                rs4.close();
			                rs5.close();
			                rs6.close();
	
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
				                }%>
				                <%@ include file="PurchaseConfirmation.jsp" %>
				                <%
				            }
				    }
					else{
						System.out.println("INVALID CARD");
						%>
						INVALID CARD
						<%@ include file="PurchaseConfirmation.jsp" %>
						<%
					}
                    // Begin transaction
            ///        conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
           //         pstmt = conn
           //             .prepareStatement("DELETE FROM Students WHERE id = ?");

           //         pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
           //         int rowCount = pstmt.executeUpdate();

           //         // Commit transaction
           //         conn.commit();
            //        conn.setAutoCommit(true);
                }
            %>
</body>
</html>