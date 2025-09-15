package servlet;

import util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String street = request.getParameter("street");
        String city = request.getParameter("city");
        String postalCode = request.getParameter("postalCode");
        double totalAmount = Double.parseDouble(request.getParameter("total_amount"));

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // 1. Insert address
            String addressSql = "INSERT INTO addresses (user_id, street_address, city, postal_code) VALUES (?, ?, ?, ?)";
            PreparedStatement addressStmt = conn.prepareStatement(addressSql, Statement.RETURN_GENERATED_KEYS);
            addressStmt.setInt(1, userId);
            addressStmt.setString(2, street);
            addressStmt.setString(3, city);
            addressStmt.setString(4, postalCode);
            addressStmt.executeUpdate();
            ResultSet addressRs = addressStmt.getGeneratedKeys();
            addressRs.next();
            int addressId = addressRs.getInt(1);

            // 2. Insert into orders
            String orderSql = "INSERT INTO orders (user_id, address_id, status, total_amount) VALUES (?, ?, 'Processing', ?)";
            PreparedStatement orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setInt(2, addressId);
            orderStmt.setDouble(3, totalAmount);
            orderStmt.executeUpdate();
            ResultSet orderRs = orderStmt.getGeneratedKeys();
            orderRs.next();
            int orderId = orderRs.getInt(1);

            // 3. Move items from cart to order_items
            String cartItemsSql = "SELECT ci.product_id, ci.quantity, p.price " +
                                  "FROM cart_items ci " +
                                  "JOIN products p ON ci.product_id = p.id " +
                                  "JOIN carts c ON ci.cart_id = c.id " +
                                  "WHERE c.user_id = ?";
            PreparedStatement cartItemsStmt = conn.prepareStatement(cartItemsSql);
            cartItemsStmt.setInt(1, userId);
            ResultSet cartItemsRs = cartItemsStmt.executeQuery();

            String orderItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
            PreparedStatement orderItemStmt = conn.prepareStatement(orderItemSql);
            while (cartItemsRs.next()) {
                orderItemStmt.setInt(1, orderId);
                orderItemStmt.setInt(2, cartItemsRs.getInt("product_id"));
                orderItemStmt.setInt(3, cartItemsRs.getInt("quantity"));
                orderItemStmt.setDouble(4, cartItemsRs.getDouble("price"));
                orderItemStmt.addBatch();
            }
            orderItemStmt.executeBatch();

            // 4. Clear the user's cart
            String clearCartSql = "DELETE FROM cart_items WHERE cart_id = (SELECT id FROM carts WHERE user_id = ?)";
            PreparedStatement clearCartStmt = conn.prepareStatement(clearCartSql);
            clearCartStmt.setInt(1, userId);
            clearCartStmt.executeUpdate();

            conn.commit(); // Commit the transaction
            response.sendRedirect("order_confirmation.jsp?orderId=" + orderId);

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback(); // Rollback on error
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            response.getWriter().println("Checkout failed: " + e.getMessage());
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    }
}