package servlet;

import util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        // Ensure user is logged in
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addProductToCart(request, response, userId);
        } else if ("update".equals(action)) {
            updateCartItem(request, response);
        } else if ("delete".equals(action)) {
            deleteCartItem(request, response);
        }
    }
    
    private void updateCartItem(HttpServletRequest request, HttpServletResponse response)
    throws IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try (Connection conn = DBConnection.getConnection()) {
            if (quantity > 0) { // If the new quantity is positive, update the item
                String updateSql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, quantity);
                updateStmt.setInt(2, itemId);
                updateStmt.executeUpdate();
            } else { // If quantity is 0 or less, delete the item from the cart
                String deleteSql = "DELETE FROM cart_items WHERE id = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setInt(1, itemId);
                deleteStmt.executeUpdate();
            }
            
            response.sendRedirect("cart.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
    
    private void deleteCartItem(HttpServletRequest request, HttpServletResponse response)
    throws IOException {
        int itemId = Integer.parseInt(request.getParameter("item_id"));
        
        try (Connection conn = DBConnection.getConnection()) {
            String deleteSql = "DELETE FROM cart_items WHERE id = ?";
            PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
            deleteStmt.setInt(1, itemId);
            deleteStmt.executeUpdate();
            
            response.sendRedirect("cart.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }

    private void addProductToCart(HttpServletRequest request, HttpServletResponse response, int userId)
    throws IOException {
        int productId = Integer.parseInt(request.getParameter("product_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        try (Connection conn = DBConnection.getConnection()) {
            // Check if cart already exists for the user
            String checkCartSql = "SELECT id FROM carts WHERE user_id = ?";
            PreparedStatement checkCartStmt = conn.prepareStatement(checkCartSql);
            checkCartStmt.setInt(1, userId);
            ResultSet rs = checkCartStmt.executeQuery();

            int cartId;
            if (rs.next()) {
                cartId = rs.getInt("id");
            } else {
                // If not, create a new cart
                String createCartSql = "INSERT INTO carts (user_id) VALUES (?)";
                PreparedStatement createCartStmt = conn.prepareStatement(createCartSql, Statement.RETURN_GENERATED_KEYS);
                createCartStmt.setInt(1, userId);
                createCartStmt.executeUpdate();
                ResultSet generatedKeys = createCartStmt.getGeneratedKeys();
                generatedKeys.next();
                cartId = generatedKeys.getInt(1);
            }

            // Check if product is already in the cart
            String checkItemSql = "SELECT quantity FROM cart_items WHERE cart_id = ? AND product_id = ?";
            PreparedStatement checkItemStmt = conn.prepareStatement(checkItemSql);
            checkItemStmt.setInt(1, cartId);
            checkItemStmt.setInt(2, productId);
            ResultSet itemRs = checkItemStmt.executeQuery();

            if (itemRs.next()) {
                // If yes, update the quantity
                int currentQuantity = itemRs.getInt("quantity");
                String updateSql = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND product_id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, currentQuantity + quantity);
                updateStmt.setInt(2, cartId);
                updateStmt.setInt(3, productId);
                updateStmt.executeUpdate();
            } else {
                // If no, insert a new item
                String insertSql = "INSERT INTO cart_items (cart_id, product_id, quantity) VALUES (?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, cartId);
                insertStmt.setInt(2, productId);
                insertStmt.setInt(3, quantity);
                insertStmt.executeUpdate();
            }

            response.sendRedirect("products.jsp?status=success");

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}