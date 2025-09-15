package servlet;

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        String query = "SELECT u.id, u.name, a.user_id AS is_admin FROM users u LEFT JOIN admins a ON u.id = a.user_id WHERE u.email = ? AND u.password_hash = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, email);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("id");
                    boolean isAdmin = rs.getInt("is_admin") != 0; // If is_admin is not null or zero, the user is an admin

                    // Set session attributes
                    HttpSession session = request.getSession();
                    session.setAttribute("user_id", userId);
                    session.setAttribute("user_name", rs.getString("name"));
                    session.setAttribute("isAdmin", isAdmin); // Store if user is an admin

                    // Redirect to the appropriate page
                    if (isAdmin) {
                        response.sendRedirect("admin_dashboard.jsp");
                    } else {
                        response.sendRedirect("products.jsp");
                    }
                } else {
                    // Invalid credentials
                    response.sendRedirect("login.jsp?error=Invalid credentials");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=Database error");
        }
    }
}