<html>
<title>Categories Page</title>
<body>
<jsp:include page="/home.jsp" /> </br></br>
<%if(((String)session.getAttribute("role")).equals("owner")){ %>

<table>
    <tr>
        <td valign="top">
            <%-- -------- Include menu HTML code -------- --%>
        </td>
        <td>
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
            %>
            
                        
            <%-- -------- INSERT Code -------- --%>
            <%
                String action = request.getParameter("action");
                // Check if an insertion is requested
                if (action != null && action.equals("insert")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // INSERT student values INTO the students table.
                    pstmt = conn
                    .prepareStatement("INSERT INTO categories ( category_name, description, product_count) VALUES ( ?, ?, ?)");
					
                    pstmt.setString(1, request.getParameter("category_name"));
                    pstmt.setString(2, request.getParameter("description"));
                    pstmt.setInt(3, 0);

                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %> Successfully inserted category:"<%=request.getParameter("category_name") %>" <%

                }
            %>
            
            <%-- -------- UPDATE Code -------- --%>
            <%
                // Check if an update is requested
                if (action != null && action.equals("update")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE categories SET category_name = ?, description = ? WHERE id = ?");

                    pstmt.setString(1, request.getParameter("category_name"));
                    pstmt.setString(2, request.getParameter("description"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %> Successfully updated category:"<%=request.getParameter("category_name") %>" <%

                }
            %>
            
            <%-- -------- DELETE Code -------- --%>
            <%
                // Check if a delete is requested
                if (action != null && action.equals("delete")) {

                    // Begin transaction
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // DELETE students FROM the Students table.
                    pstmt = conn
                        .prepareStatement("DELETE FROM categories WHERE id = ?");
					
                    if(Integer.parseInt(request.getParameter("count")) ==0){
	                    pstmt.setInt(1, Integer.parseInt(request.getParameter("id")));
	                    int rowCount = pstmt.executeUpdate();
	
	                    // Commit transaction
	                    conn.commit();
	                    conn.setAutoCommit(true);
	                    %> Successfully deleted category:"<%=request.getParameter("category_name") %>" <%
                    }
                    else{ %>Cannot delete category because it is linked to a product!<% 
                    	
                    }
                }
            %>
            
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM categories");
            %>
            
            <!-- Add an HTML table header row to format the results -->
            <table border="1">
            <tr>
                <th>Name</th>
                <th>Description</th>
                <th>Count</th>
            </tr>
            
            
            <tr>
                <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="insert" />
                    <th><input value="" name="category_name" size="15" required/></th>
                    <th><input value="" name="description" size="15" required/></th>
                    <th>&nbsp;</th>
                    <th><input type="submit" value="Insert"/></th>
                </form>
            </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
             <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>
                <td>
                   <input value="<%=rs.getString("category_name")%>" name="category_name" size="15" required/>
                </td>

                <td>
                   <input value="<%=rs.getString("description")%>" name="description" size="15" required/>
                </td>

                <td>
                    <%=rs.getInt("product_count")%>
                </td>
                	<input type="hidden" value="<%=rs.getString("category_name")%>" name="category_name"/>
                  <td><input type="submit" value="Update"></td>
                </form>
                
                
                <form action="categories.jsp" method="POST">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" value="<%=rs.getInt("id")%>" name="id"/>
                    <input type="hidden" value="<%=rs.getString("category_name")%>" name="category_name"/>
                    <input type="hidden" value="<%=rs.getInt("product_count")%>" name="count"/>
                    <%-- Button --%>
                <td><input type="submit" value="Delete"/></td>
                </form>
            </tr>
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
            	%> data modification error, please go back to category page  <%
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
}
else{
	%> Sorry, this page is for owners only! <%
}
%>
            
           
        </table>
        </td>
    </tr>
</table>
</body>

</html>
