package com.example.carrental;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

public class CarServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Car> cars = Arrays.asList(
            new Car("Toyota Corolla", "Sedan", 2020),
            new Car("Honda Civic", "Sedan", 2021),
            new Car("Ford Escape", "SUV", 2022)
        );
        request.setAttribute("cars", cars);
        request.getRequestDispatcher("/cars.jsp").forward(request, response);
    }
}
