<%-- 
    Document   : edit-address
    Created on : Sep 15, 2025, 2:11:04 AM
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<html>
<head>
    <title>Edit Address</title>
    <style>
        body {
            background-color: #008080;
            font-family: 'Courier New', Courier, monospace, sans-serif;
            margin: 0;
            padding: 20px;
            color: #000;
        }
        
        .window {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 3px;
            border-color: #FFFFFF #6F6F6F #6F6F6F #FFFFFF;
            box-shadow: 4px 4px #000;
            padding: 4px;
            width: 80%;
            max-width: 600px;
            margin: 20px auto;
        }

        .title-bar {
            background-color: #000080;
            color: #FFF;
            padding: 5px 8px;
            font-weight: bold;
            font-size: 1.2em;
        }

        .window-body {
            padding: 15px;
            background-color: #C0C0C0;
        }

        h2 {
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 1.5em;
            text-transform: uppercase;
            text-align: left;
            border-bottom: 2px solid #808080;
            padding-bottom: 5px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input[type="text"], input[type="submit"] {
            background-color: #FFF;
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            padding: 3px;
            box-sizing: border-box;
            width: 100%;
            margin-bottom: 10px;
        }
        
        input[type="submit"] {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 2px;
            border-color: #FFF #6F6F6F #6F6F6F #FFF;
            padding: 5px 12px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            width: auto;
            margin-top: 10px;
        }

        input[type="submit"]:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }
        
        .back-link {
            display: inline-block;
            margin-top: 20px;
            padding: 5px 10px;
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 2px;
            border-color: #FFF #6F6F6F #6F6F6F #FFF;
            text-decoration: none;
            color: #000;
        }
        
        .back-link:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }
    </style>
</head>
<body>
    <%
        HttpSession currentSession = request.getSession(false);
        if (currentSession == null || currentSession.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userId = (Integer) currentSession.getAttribute("user_id");
        String addressIdStr = request.getParameter("address_id");
        int addressId = 0;
        
        String street = "", city = "", postalCode = "";

        if (addressIdStr != null) {
            try {
                addressId = Integer.parseInt(addressIdStr);
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;

                try {
                    conn = DBConnection.getConnection();
                    String sql = "SELECT street_address, city, postal_code FROM addresses WHERE id = ? AND user_id = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, addressId);
                    stmt.setInt(2, userId);
                    rs = stmt.executeQuery();
                    
                    if (rs.next()) {
                        street = rs.getString("street_address");
                        city = rs.getString("city");
                        postalCode = rs.getString("postal_code");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<p>Database error: " + e.getMessage() + "</p>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            } catch (NumberFormatException e) {
                // Handle invalid address ID
            }
        }
    %>

    <div class="window">
        <div class="title-bar">
            Edit Address
        </div>
        <div class="window-body">
            <h2>Edit Address</h2>
            <% if (addressId > 0 && street != null) { %>
                <form action="address-manager" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="address_id" value="<%= addressId %>">
                    
                    <label>Street Address:</label>
                    <input type="text" name="street_address" value="<%= street %>" required>
                    
                    <label>City:</label>
                    <input type="text" name="city" value="<%= city %>" required>
                    
                    <label>Postal Code:</label>
                    <input type="text" name="postal_code" value="<%= postalCode %>" required>
                    
                    <input type="submit" value="Update Address">
                </form>
            <% } else { %>
                <p>Address not found or you do not have permission to edit it.</p>
            <% } %>
            <a href="user-profile.jsp" class="back-link">Back to Profile</a>
        </div>
    </div>
</body>
</html>
