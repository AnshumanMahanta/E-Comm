package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/products.jsp", "/cart.jsp", "/checkout.jsp", "/checkout"})
public class LoginFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("user_id") != null);
        String loginURI = httpRequest.getContextPath() + "/login.jsp";

        if (isLoggedIn || httpRequest.getRequestURI().equals(loginURI)) {
            // User is logged in or requesting the login page, so continue the request
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect them to the login page
            httpResponse.sendRedirect(loginURI);
        }
    }

    public void init(FilterConfig fConfig) throws ServletException {
        // Initialization code (not needed for this simple case)
    }

    public void destroy() {
        // Cleanup code (not needed for this simple case)
    }
}