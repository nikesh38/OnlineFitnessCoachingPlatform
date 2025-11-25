package com.onlinefitness.dao;

import com.onlinefitness.model.User;
import com.onlinefitness.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
public class UserDAO {

    public Long save(User u) throws SQLException {
        String sql = "INSERT INTO users (name, email, password_hash, role, is_approved, age, gender, height_cm, weight_kg, bio) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPasswordHash());
            ps.setString(4, u.getRole());
            ps.setInt(5, u.isApproved() ? 1 : 0);

            if (u.getAge() == null) ps.setNull(6, Types.INTEGER);
            else ps.setInt(6, u.getAge());

            if (u.getGender() == null) ps.setNull(7, Types.VARCHAR);
            else ps.setString(7, u.getGender());

            if (u.getHeightCm() == null) ps.setNull(8, Types.DOUBLE);
            else ps.setDouble(8, u.getHeightCm());

            if (u.getWeightKg() == null) ps.setNull(9, Types.DOUBLE);
            else ps.setDouble(9, u.getWeightKg());

            if (u.getBio() == null) ps.setNull(10, Types.VARCHAR);
            else ps.setString(10, u.getBio());

            int affected = ps.executeUpdate();
            if (affected == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        long id = rs.getLong(1);
                        u.setId(id);
                        return id;
                    }
                }
            }
        }
        return null;
    }

    public boolean update(User u) throws SQLException {
        boolean updatePassword = u.getPasswordHash() != null && !u.getPasswordHash().isBlank();

        StringBuilder sb = new StringBuilder();
        sb.append("UPDATE users SET name = ?, email = ?, role = ?, is_approved = ?, age = ?, gender = ?, height_cm = ?, weight_kg = ?, bio = ?");
        if (updatePassword) sb.append(", password_hash = ?");
        sb.append(" WHERE id = ?");

        String sql = sb.toString();

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setString(idx++, u.getName());
            ps.setString(idx++, u.getEmail());
            ps.setString(idx++, u.getRole());
            ps.setInt(idx++, u.isApproved() ? 1 : 0);

            if (u.getAge() == null) ps.setNull(idx++, Types.INTEGER);
            else ps.setInt(idx++, u.getAge());

            if (u.getGender() == null) ps.setNull(idx++, Types.VARCHAR);
            else ps.setString(idx++, u.getGender());

            if (u.getHeightCm() == null) ps.setNull(idx++, Types.DOUBLE);
            else ps.setDouble(idx++, u.getHeightCm());

            if (u.getWeightKg() == null) ps.setNull(idx++, Types.DOUBLE);
            else ps.setDouble(idx++, u.getWeightKg());

            if (u.getBio() == null) ps.setNull(idx++, Types.VARCHAR);
            else ps.setString(idx++, u.getBio());

            if (updatePassword) ps.setString(idx++, u.getPasswordHash());

            if (u.getId() == null) ps.setNull(idx, Types.BIGINT);
            else ps.setLong(idx, u.getId());

            return ps.executeUpdate() == 1;
        }
    }

    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public User findById(Long id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (id == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (id == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        }
    }

    public List<User> findPendingCoaches() throws SQLException {
        String sql = "SELECT * FROM users WHERE role = 'COACH' AND is_approved = 0 ORDER BY created_at";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<User> list = new ArrayList<>();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        }
    }

    public boolean approveCoach(Long coachId) throws SQLException {
        String sql = "UPDATE users SET is_approved = 1 WHERE id = ? AND role = 'COACH'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (coachId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, coachId);
            return ps.executeUpdate() == 1;
        }
    }

    public boolean approveCoach(Long coachId, Long approverId) throws SQLException {
        Connection conn = null;
        PreparedStatement upd = null;
        PreparedStatement logIns = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            String updSql = "UPDATE users SET is_approved = 1 WHERE id = ? AND role = 'COACH'";
            upd = conn.prepareStatement(updSql);
            if (coachId == null) upd.setNull(1, Types.BIGINT);
            else upd.setLong(1, coachId);
            int updCount = upd.executeUpdate();
            if (updCount != 1) {
                conn.rollback();
                return false;
            }

            if (approverId != null && approverId > 0) {
                String insSql = "INSERT INTO coach_approvals (coach_id, approver_id) VALUES (?, ?)";
                logIns = conn.prepareStatement(insSql);
                logIns.setLong(1, coachId);
                logIns.setLong(2, approverId);
                logIns.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException ex) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
            throw ex;
        } finally {
            if (logIns != null) try { logIns.close(); } catch (SQLException ignored) {}
            if (upd != null) try { upd.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ignored) {}
        }
    }

    public List<String> findApprovalLogsForCoach(Long coachId) throws SQLException {
        String sql = "SELECT ca.id, ca.coach_id, ca.approver_id, ca.approved_at, a.name AS approver_name " +
                "FROM coach_approvals ca LEFT JOIN users a ON ca.approver_id = a.id WHERE ca.coach_id = ? ORDER BY ca.approved_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (coachId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, coachId);
            try (ResultSet rs = ps.executeQuery()) {
                List<String> lines = new ArrayList<>();
                while (rs.next()) {
                    Timestamp t = rs.getTimestamp("approved_at");
                    String approverName = rs.getString("approver_name");
                    long approverId = rs.getLong("approver_id");
                    lines.add("Approved by [" + (approverName != null ? approverName : ("id:" + approverId)) + "] at " + t);
                }
                return lines;
            }
        } catch (SQLException ex) {
            return new ArrayList<>();
        }
    }

    public List<User> findAll() throws SQLException {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<User> list = new ArrayList<>();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        }
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();

        long id = rs.getLong("id");
        if (!rs.wasNull()) u.setId(id);

        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));

        int approvedInt = rs.getInt("is_approved");
        u.setApproved(approvedInt == 1);

        int age = rs.getInt("age");
        if (!rs.wasNull()) u.setAge(age);
        else u.setAge(null);

        u.setGender(rs.getString("gender"));

        double h = rs.getDouble("height_cm");
        if (!rs.wasNull()) u.setHeightCm(h);
        else u.setHeightCm(null);

        double w = rs.getDouble("weight_kg");
        if (!rs.wasNull()) u.setWeightKg(w);
        else u.setWeightKg(null);

        u.setBio(rs.getString("bio"));

        try {
            u.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException ignored) {
            u.setCreatedAt(null);
        }

        return u;
    }

    public List<User> findByIds(List<Long> ids) throws SQLException {
        if (ids == null || ids.isEmpty()) return Collections.emptyList();

        StringBuilder ph = new StringBuilder();
        for (int i = 0; i < ids.size(); i++) {
            if (i > 0) ph.append(",");
            ph.append("?");
        }

        String sql = "SELECT * FROM users WHERE id IN (" + ph.toString() + ") ORDER BY created_at DESC";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < ids.size(); i++) {
                ps.setLong(i + 1, ids.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                List<User> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }
}
