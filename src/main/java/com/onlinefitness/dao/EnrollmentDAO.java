package com.onlinefitness.dao;

import com.onlinefitness.model.Enrollment;
import com.onlinefitness.util.DBUtil;

import java.sql.*;
import java.util.*;

public class EnrollmentDAO {

    public Long enroll(Enrollment e) throws SQLException {
        String sql = "INSERT INTO enrollments (user_id, program_id, start_date, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (e.getUserId() == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, e.getUserId());

            if (e.getProgramId() == null) ps.setNull(2, Types.BIGINT);
            else ps.setLong(2, e.getProgramId());

            if (e.getStartDate() == null) ps.setNull(3, Types.DATE);
            else ps.setDate(3, e.getStartDate());

            ps.setString(4, e.getStatus() == null ? "ACTIVE" : e.getStatus());

            int affected = ps.executeUpdate();
            if (affected == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        long id = rs.getLong(1);
                        e.setId(id);
                        return id;
                    }
                }
            }
        }
        return null;
    }

    public List<Enrollment> findByUser(Long userId) throws SQLException {
        String sql = "SELECT * FROM enrollments WHERE user_id = ? ORDER BY start_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Enrollment> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    public List<Enrollment> findByProgram(Long programId) throws SQLException {
        String sql = "SELECT * FROM enrollments WHERE program_id = ? ORDER BY start_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (programId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, programId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Enrollment> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    public List<Enrollment> findAll() throws SQLException {
        String sql = "SELECT * FROM enrollments ORDER BY start_date DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Enrollment> list = new ArrayList<>();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        }
    }

    public boolean updateStatus(Long enrollmentId, String newStatus) throws SQLException {
        String sql = "UPDATE enrollments SET status = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            if (enrollmentId == null) ps.setNull(2, Types.BIGINT);
            else ps.setLong(2, enrollmentId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM enrollments WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (id == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        }
    }

    public LinkedHashMap<String, Integer> getMonthlyEnrollmentsLast12Months() throws SQLException {
        LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
        java.time.YearMonth now = java.time.YearMonth.now();
        java.time.YearMonth start = now.minusMonths(11);
        for (int i = 0; i < 12; ++i) map.put(start.plusMonths(i).toString(), 0);

        String sql = "SELECT DATE_FORMAT(COALESCE(start_date, CURRENT_DATE), '%Y-%m') AS ym, COUNT(*) AS cnt " +
                "FROM enrollments " +
                "WHERE COALESCE(start_date, CURRENT_DATE) >= DATE_SUB(CURDATE(), INTERVAL 11 MONTH) " +
                "GROUP BY ym ORDER BY ym";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String ym = rs.getString("ym");
                int cnt = rs.getInt("cnt");
                if (map.containsKey(ym)) map.put(ym, cnt);
            }
        }
        return map;
    }

    public List<Map.Entry<String, Integer>> getProgramPopularityTop(int limit) throws SQLException {
        String sql = "SELECT p.title AS title, COUNT(e.id) AS cnt " +
                "FROM programs p LEFT JOIN enrollments e ON p.id = e.program_id " +
                "GROUP BY p.id ORDER BY cnt DESC, p.title LIMIT ?";
        List<Map.Entry<String, Integer>> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new AbstractMap.SimpleEntry<>(rs.getString("title"), rs.getInt("cnt")));
                }
            }
        }
        return list;
    }

    private Enrollment mapRow(ResultSet rs) throws SQLException {
        Enrollment e = new Enrollment();
        long id = rs.getLong("id");
        if (!rs.wasNull()) e.setId(id);

        long userId = rs.getLong("user_id");
        if (!rs.wasNull()) e.setUserId(userId);

        long programId = rs.getLong("program_id");
        if (!rs.wasNull()) e.setProgramId(programId);

        e.setStartDate(rs.getDate("start_date"));
        e.setStatus(rs.getString("status"));
        return e;
    }
}
