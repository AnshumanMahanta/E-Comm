package servlet;

import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminControllerServlet")
public class AdminControllerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(AdminControllerServlet.class.getName());

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // **CRUCIAL SECURITY CHECK**
        // A direct redirect to a login page is more secure than an error message.
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isAdmin") == null || !(boolean) session.getAttribute("isAdmin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String command = request.getParameter("command");
        String table = request.getParameter("table");

        if (command == null || table == null) {
            response.sendRedirect("admin_dashboard.jsp?table=dashboard");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String redirectUrl = "admin_dashboard.jsp?table=" + table;

            switch (command) {
                case "delete":
                    handleDelete(request, response, conn, table);
                    break;
                case "add":
                    // Forward to a dedicated form for adding a new record
                    request.getRequestDispatcher("add_form.jsp?table=" + table).forward(request, response);
                    return; // Prevent double-redirect
                case "edit":
                    // Forward to a form pre-filled with existing data
                    request.getRequestDispatcher("edit_form.jsp?table=" + table + "&id=" + request.getParameter("id")).forward(request, response);
                    return; // Prevent double-redirect
                default:
                    // Fallback to the dashboard view
                    break;
            }
            response.sendRedirect(redirectUrl);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during admin operation", e);
            response.getWriter().println("Database Error: " + e.getMessage());
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to close database connection.", e);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // **CRUCIAL SECURITY CHECK**
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("isAdmin") == null || !(boolean) session.getAttribute("isAdmin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String command = request.getParameter("command");
        String table = request.getParameter("table");

        if (command == null || table == null) {
            response.sendRedirect("admin_dashboard.jsp?table=dashboard");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            String redirectUrl = "admin_dashboard.jsp?table=" + table;

            switch (command) {
                case "insert":
                    // This is where you would call a new method to handle form data insertion
                    // Example: handleInsert(request, response, conn, table);
                    break;
                case "update":
                    // This is where you would call a new method to handle form data updates
                    // Example: handleUpdate(request, response, conn, table);
                    break;
                default:
                    break;
            }
            response.sendRedirect(redirectUrl);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during admin operation", e);
            response.getWriter().println("Database Error: " + e.getMessage());
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Failed to close database connection.", e);
            }
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Connection conn, String table) throws SQLException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null) {
            return;
        }

        PreparedStatement stmt = null;
        try {
            String sql = "DELETE FROM " + table + " WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(idParam));
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                LOGGER.log(Level.INFO, "Deleted record with ID {0} from table {1}", new Object[]{idParam, table});
            } else {
                LOGGER.log(Level.WARNING, "Delete operation failed. No record found with ID {0} in table {1}", new Object[]{idParam, table});
            }
        } finally {
            if (stmt != null) {
                stmt.close();
            }
        }
    }
}