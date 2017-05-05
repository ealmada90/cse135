<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>login page</title>
</head>
<body>

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
                    "jdbc:postgresql://localhost:5432/project1", "postgres", "ea112390");
				System.out.println("connected to database");

            %>
    
	        <%
                // Create the statement
                Statement statement = conn.createStatement();
                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM users WHERE user_name = '"+ request.getParameter("name")+ "'");
                if(rs.next()){
	           		session.setAttribute("name", rs.getString("user_name"));
	           		session.setAttribute("role", rs.getString("user_role"));
	           	
	           		System.out.println(session.getAttribute("name"));
	           		System.out.println(session.getAttribute("role"));
	           		%>
	           		<jsp:include page="/home.jsp" />
	           		<%
           		}
                else{
                	%>
                	<h2>Name was incorrect </h2>
                	<jsp:include page="/login.html" />
                	<% 
                }
           		
           		
           %>        

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
            

</body>
</html>