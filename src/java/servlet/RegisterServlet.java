package servlet;

import util.DBConnection;
import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password"); // Plaintext password from the form

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (name, email, phone, password_hash) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, password); // Use hashed password in real apps

            int rows = stmt.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("login.jsp");
            } else {
                response.getWriter().println("Registration failed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Database error.");
        }
    }
}