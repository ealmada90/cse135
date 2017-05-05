<html>

<body>
Welcome: <%=session.getAttribute("name") %>
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
            ResultSet rs2 = null;
            String category = request.getParameter("category");
            String search = request.getParameter("search");
            
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
                    .prepareStatement("INSERT INTO product ( product_name, sku, category_id, price, owner_id) VALUES ( ?, ?, ?, ?,?)");
					
                    pstmt.setString(1, request.getParameter("product_name"));
                    pstmt.setString(2, request.getParameter("sku"));
                    pstmt.setString(3, request.getParameter("category_id"));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("price")));
                    pstmt.setString(5, (String) session.getAttribute("name"));
					
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    
                    
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE categories SET product_count = product_count +1 WHERE category_name = ?");

                    
                    pstmt.setString(1, request.getParameter("category_id"));
                    rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %> Successfully inserted product:"<%=request.getParameter("product_name") %>" <%
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
                        .prepareStatement("UPDATE product SET price = ? WHERE id = ?");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("price")));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("id")));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    %> Successfully updated product:"<%=request.getParameter("product_name") %>" <%
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
                        .prepareStatement("DELETE FROM product WHERE sku = ?");

                    pstmt.setString(1, request.getParameter("sku"));
                    int rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);
                    
                    
                    conn.setAutoCommit(false);

                    // Create the prepared statement and use it to
                    // UPDATE student values in the Students table.
                    pstmt = conn
                        .prepareStatement("UPDATE categories SET product_count = product_count -1 WHERE category_name = ?");

                    
                    pstmt.setString(1, request.getParameter("category_id"));
                    rowCount = pstmt.executeUpdate();

                    // Commit transaction
                    conn.commit();
                    conn.setAutoCommit(true);

                    %> Successfully deleted product:"<%=request.getParameter("product_name") %>" <%
                }
            %>
            
            
            <%-- -------- SELECT Statement Code -------- --%>
            <%
                // Create the statement
                Statement statement = conn.createStatement();
            // Create the statement
            Statement statement2 = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                
                if((category == null || category.equals("all")) && search ==null){
               	 rs = statement.executeQuery("SELECT * FROM product");
                }
                else if(search ==null){
                	rs = statement.executeQuery("SELECT * FROM product WHERE category_id = '" + category+"'");
                }
                else if(category == null){
                	rs = statement.executeQuery("SELECT * FROM product WHERE product_name Like '%" + search+"%'");
                }
                else{
                    	rs = statement.executeQuery("SELECT * FROM product WHERE product_name Like '%" + search+"%' AND category_id = '" + category+"'");
                }
                
                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs2 = statement2.executeQuery("SELECT * FROM categories");
                %>	
            	<form action="productBrowsing.jsp" method="POST">
					 <input value="" name="search" size="15" required/>
					 <input type="submit" value="Search">
				</form>
				
    			<li><a href="productBrowsing.jsp?category=all" name="category">All </a></li>    
    					
    			
                <%
                while(rs2.next()){
                	
            %>	
            	
					
					<li><a href="productBrowsing.jsp?category=<%=rs2.getString("category_name")%>" name="category"><%=rs2.getString("category_name")%> </a></li>    
					
			
            <% } %>
            
            
            <!-- Add an HTML table header row to format the results -->
            
            <table border="1" style="margin-top:-70px; margin-left:100px;">
            <tr>
                <th>Name</th>
                <th>SKU</th>
                <th>Category</th>
                <th>Price</th>
                <th>Buy Link</th>
            </tr>
            
            
   
            

            <%-- -------- Iteration Code -------- --%>
            <%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>

            <tr>
            
            <form action="productBrowsing.jsp" method="POST">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>"/>
                <td>
                    <%=rs.getString("product_name")%>
                </td>

                <td>
                    <%=rs.getString("sku")%>
                </td>

                <td>
                    <%=rs.getString("category_id")%>
                </td>
                <td>
                   <%=rs.getInt("price")%>
                </td>
                
                <td>
                <a href="productOrder.jsp?product=<%=rs.getInt("id")%>" name="product">BUY </a>
                </td>
                </form>

            </tr>
            <%
                }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();
				rs2.close();
                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
            	%> data modification error, please go back to product page  <%
            }catch(NumberFormatException e) {
            	%> data modification error, please go back to product page  <%
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
        </td>
    </tr>
</table>
</body>

</html>

