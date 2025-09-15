<%-- 
    Document   : cart
    Created on : Sep 14, 2025, 11:20:37 PM
    Author     : ASUS
--%>

<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Your Shopping Cart</title>
    <style>
        /* General page and text styling for a retro look */
        body {
            background-color: #008080; /* Teal background from Windows 95 */
            font-family: 'Courier New', Courier, monospace, sans-serif;
            margin: 0;
            padding: 20px;
            color: #000;
        }

        /* Container styled as a classic window */
        .window {
            background-color: #C0C0C0; /* Standard gray window color */
            border-style: outset;
            border-width: 3px;
            border-color: #FFFFFF #6F6F6F #6F6F6F #FFFFFF;
            box-shadow: 4px 4px #000;
            padding: 4px;
            width: 90%;
            max-width: 900px;
            margin: 20px auto;
        }

        /* Title bar for the window */
        .title-bar {
            background-color: #000080; /* Classic blue title bar */
            color: #FFF;
            padding: 5px 8px;
            font-weight: bold;
            font-size: 1.2em;
        }

        /* Main content body of the window */
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
        
        /* Table and cell styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-style: inset; /* Inset border for a recessed look */
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            background-color: #F0F0F0;
        }

        th, td {
            border: 1px solid #808080;
            padding: 12px;
            text-align: left;
            background-color: #C0C0C0; /* Cell background color */
        }

        th {
            background-color: #B0B0B0; /* Header background color */
            font-weight: bold;
        }
        
        .total-row td {
            background-color: #D0D0D0;
        }

        /* Buttons and links styled as retro buttons */
        input[type="submit"], button, .button-link {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 2px;
            border-color: #FFF #6F6F6F #6F6F6F #FFF;
            padding: 5px 12px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            text-decoration: none; /* For the link-like buttons */
            color: #000;
            transition: all 0.1s ease-in-out;
            display: inline-block; /* To make links look like buttons */
            text-align: center;
        }

        input[type="submit"]:active, button:active, .button-link:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }
        
        /* Specific button styling */
        .delete-button {
            background-color: #d9534f;
            color: white;
        }
        .delete-button:active {
            background-color: #c9302c;
        }

        /* Other elements */
        .empty-cart {
            text-align: center;
            color: #777;
            margin-top: 50px;
            padding: 20px;
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            background-color: #F0F0F0;
        }
        
        .nav-links { 
            text-align: right; 
            margin-top: 20px; 
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

    </style>
</head>
<body>
    <div class="window">
        <div class="title-bar">
            Your Shopping Cart
        </div>
        <div class="window-body">
            
            <%
                if (session.getAttribute("user_id") == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                Integer userId = (Integer) session.getAttribute("user_id");
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                double totalCartPrice = 0.0;
                
                try {
                    conn = DBConnection.getConnection();
                    String sql = "SELECT p.name, p.price, ci.quantity, ci.id AS item_id, (p.price * ci.quantity) AS subtotal " +
                                 "FROM cart_items ci " +
                                 "JOIN products p ON ci.product_id = p.id " +
                                 "JOIN carts c ON ci.cart_id = c.id " +
                                 "WHERE c.user_id = ?";
                    
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    rs = stmt.executeQuery();
            %>

            <% if (!rs.isBeforeFirst()) { %>
                <p class="empty-cart">Your cart is empty.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <th>Product Name</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            while (rs.next()) {
                                double subtotal = rs.getDouble("subtotal");
                                totalCartPrice += subtotal;
                                int currentQuantity = rs.getInt("quantity");
                        %>
                        <tr>
                            <td><%= rs.getString("name") %></td>
                            <td>$<%= String.format("%.2f", rs.getDouble("price")) %></td>
                            <td><%= currentQuantity %></td>
                            <td>$<%= String.format("%.2f", subtotal) %></td>
                            <td>
                                <form action="cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="update" />
                                    <input type="hidden" name="item_id" value="<%= rs.getInt("item_id") %>" />
                                    <input type="hidden" name="quantity" value="<%= currentQuantity - 1 %>" />
                                    <button type="submit" <% if (currentQuantity <= 1) { %> disabled <% } %>>-</button>
                                </form>
                                <form action="cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="update" />
                                    <input type="hidden" name="item_id" value="<%= rs.getInt("item_id") %>" />
                                    <input type="hidden" name="quantity" value="<%= currentQuantity + 1 %>" />
                                    <button type="submit">+</button>
                                </form>
                                <form action="cart" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="item_id" value="<%= rs.getInt("item_id") %>" />
                                    <button type="submit" class="delete-button">Delete</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                        <tr class="total-row">
                            <td colspan="3" style="text-align:right;">Total:</td>
                            <td>$<%= String.format("%.2f", totalCartPrice) %></td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
                <br/>
                <div class="nav-links">
                    <a href="products.jsp" class="button-link">Continue Shopping</a>
                    <a href="checkout.jsp" class="button-link">Proceed to Checkout</a>
                </div>
            <% } %>

            <%
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("Database error: " + e.getMessage());
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </div>
    </div>
</body>
</html>