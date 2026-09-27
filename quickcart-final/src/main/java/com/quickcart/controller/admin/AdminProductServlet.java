package com.quickcart.controller.admin;

import com.quickcart.dao.ProductDAO;
import com.quickcart.model.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Admin controller for Product Catalog CRUD operations:
 * - /admin/product-action (handles add, edit, delete)
 */
@WebServlet("/admin/product-action")
public class AdminProductServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
            return;
        }

        try {
            switch (action) {
                case "add": {
                    String name = request.getParameter("name");
                    String category = request.getParameter("category");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int discount = Integer.parseInt(request.getParameter("discount"));
                    int stock = Integer.parseInt(request.getParameter("stock"));
                    String image = request.getParameter("image");

                    Product p = new Product(name, category, description, price, discount, stock, image, 4.5);
                    productDAO.addProduct(p);
                    break;
                }

                case "edit": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String name = request.getParameter("name");
                    String category = request.getParameter("category");
                    String description = request.getParameter("description");
                    double price = Double.parseDouble(request.getParameter("price"));
                    int discount = Integer.parseInt(request.getParameter("discount"));
                    int stock = Integer.parseInt(request.getParameter("stock"));
                    String image = request.getParameter("image");

                    Product p = new Product();
                    p.setId(id);
                    p.setName(name);
                    p.setCategory(category);
                    p.setDescription(description);
                    p.setPrice(price);
                    p.setDiscount(discount);
                    p.setStock(stock);
                    p.setImage(image);

                    productDAO.updateProduct(p);
                    break;
                }

                case "delete": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    productDAO.deleteProduct(id);
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/products.jsp");
    }
}
