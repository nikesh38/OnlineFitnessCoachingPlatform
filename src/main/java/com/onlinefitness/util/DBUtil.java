package com.onlinefitness.util;

import java.sql.*;

public class DBUtil {
    // Get from environment variables, with fallback to localhost for local development
    private static final String URL = System.getenv("DATABASE_URL") != null
            ? System.getenv("DATABASE_URL")
            : "jdbc:mysql://localhost:3306/onlinefitness?useSSL=false&serverTimezone=UTC";

    private static final String USER = System.getenv("DB_USER") != null
            ? System.getenv("DB_USER")
            : "root";

    private static final String PASS = System.getenv("DB_PASSWORD") != null
            ? System.getenv("DB_PASSWORD")
            : "hnxn";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    public static void close(AutoCloseable ac) {
        if (ac != null) {
            try { ac.close(); } catch (Exception ignored) {}
        }
    }
}