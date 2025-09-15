<%-- 
    Document   : user-profile
    Created on : Sep 15, 2025, 2:03:20 AM
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.List, java.util.ArrayList, util.DBConnection" %>

<html>
<head>
    <title>User Profile</title>
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
            width: 90%;
            max-width: 900px;
            margin: 20px auto;
        }

        .title-bar {
            background-color: #000080;
            color: #FFF;
            padding: 5px 8px;
            font-weight: bold;
            font-size: 1.2em;
        }
        
        .navbar {
            background-color: #C0C0C0;
            border-bottom: 2px solid #000000;
            border-right: 2px solid #000000;
            border-top: 2px solid #FFFFFF;
            border-left: 2px solid #FFFFFF;
            box-shadow: 2px 2px #000;
            padding: 5px;
            font-size: 14px;
            display: flex;
            justify-content: flex-end;
            align-items: center;

            /* Start of new CSS for sticky navbar */
            position: sticky;
            top: 0;
            z-index: 100; /* Ensures it stays on top of other content */
            /* End of new CSS */
        }

        .navbar a {
            color: #000;
            text-decoration: none;
            padding: 8px 12px;
            border: 2px solid transparent;
            margin: 0 5px;
            transition: all 0.1s ease-in-out;
            text-transform: uppercase;
        }
        
        .navbar a:hover {
            background-color: #000080;
            color: #FFFFFF;
        }
        
        .navbar a:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            background-color: #B0B0B0;
            transform: translate(1px, 1px);
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

        .section-container {
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            background-color: #F0F0F0;
            padding: 15px;
            margin-bottom: 20px;
        }

        .section-container label {
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
            transition: all 0.1s ease-in-out;
        }
        
        input[type="submit"]:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }

        .order-item {
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            background-color: #D0D0D0;
            padding: 10px;
            margin-bottom: 15px;
        }

        .order-item h3 {
            margin-top: 0;
            font-size: 1.1em;
            border-bottom: 1px solid #A0A0A0;
            padding-bottom: 5px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        
        th, td {
            border: 1px solid #808080;
            padding: 5px;
            text-align: left;
        }

        .address-item {
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            background-color: #E0E0E0;
            padding: 10px;
            margin-bottom: 10px;
        }
        
        .address-item form {
            display: inline;
        }
        
        .address-item .buttons {
            text-align: right;
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

        String userName = "";
        String userEmail = "";
        
        List<String[]> addresses = new ArrayList<>();
        List<String[]> orders = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            // Fetch user info
            String userSql = "SELECT name, email FROM users WHERE id = ?";
            stmt = conn.prepareStatement(userSql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            if (rs.next()) {
                userName = rs.getString("name");
                userEmail = rs.getString("email");
            }
            rs.close();
            stmt.close();

            // Fetch addresses
            String addressSql = "SELECT id, street_address, city, postal_code FROM addresses WHERE user_id = ?";
            stmt = conn.prepareStatement(addressSql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                addresses.add(new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("street_address"),
                    rs.getString("city"),
                    rs.getString("postal_code")
                });
            }
            rs.close();
            stmt.close();

            // Fetch order history
            String orderSql = "SELECT id, status, total_amount FROM orders WHERE user_id = ? ORDER BY id DESC";
            stmt = conn.prepareStatement(orderSql);
            stmt.setInt(1, userId);
            rs = stmt.executeQuery();
            while (rs.next()) {
                orders.add(new String[]{
                    String.valueOf(rs.getInt("id")),
                    rs.getString("status"),
                    String.valueOf(rs.getDouble("total_amount"))
                });
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Database error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
    
    <div class="navbar">
        <a href="products.jsp">Back to Shop</a>
        <a href="logout">Logout</a>
    </div>

    <div class="window">
        <div class="title-bar">
            User Profile
        </div>
        <div class="window-body">
            
            <div class="section-container">
                <h2>Manage Account Details</h2>
                <form action="profile-manager" method="post">
                    <input type="hidden" name="action" value="update-name">
                    <label>Name:</label>
                    <input type="text" name="name" value="<%= userName %>">
                    <input type="submit" value="Update Name">
                </form>
            </div>
            
            <div class="section-container">
                <h2>Manage Addresses</h2>
                <% if (addresses.isEmpty()) { %>
                    <p style="text-align: center;">You have no saved addresses.</p>
                <% } else { %>
                    <% for (String[] address : addresses) { %>
                        <div class="address-item">
                            <p><strong><%= address[1] %></strong></p>
                            <p><%= address[2] %>, <%= address[3] %></p>
                            <div class="buttons">
                                <form action="address-manager" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="address_id" value="<%= address[0] %>">
                                    <input type="submit" value="Delete">
                                </form>
                                <a href="edit-address.jsp?address_id=<%= address[0] %>" class="link-button">Edit</a>
                            </div>
                        </div>
                    <% } %>
                <% } %>
                <form action="address-manager" method="post" class="form-container">
                    <h2>Add New Address</h2>
                    <input type="hidden" name="action" value="add">
                    <label>Street Address:</label>
                    <input type="text" name="street_address" required>
                    <label>City:</label>
                    <input type="text" name="city" required>
                    <label>Postal Code:</label>
                    <input type="text" name="postal_code" required>
                    <input type="submit" value="Add Address">
                </form>
            </div>

            <div class="section-container">
                <h2>Order History</h2>
                <% if (orders.isEmpty()) { %>
                    <p style="text-align: center;">You have not placed any orders yet.</p>
                <% } else { %>
                    <% for (String[] order : orders) { %>
                        <div class="order-item">
                            <h3>Order #<%= order[0] %></h3>
                            <p>Status: <strong><%= order[1] %></strong></p>
                            <p>Total: <strong>$<%= order[2] %></strong></p>
                        </div>
                    <% } %>
                <% } %>
            </div>
            
        </div>
    </div>
</body>
</html>