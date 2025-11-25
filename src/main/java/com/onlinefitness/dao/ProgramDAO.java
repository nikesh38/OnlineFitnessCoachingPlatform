package com.onlinefitness.dao;

import com.onlinefitness.model.Program;
import com.onlinefitness.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProgramDAO {

    public Long create(Program p) throws SQLException {
        String sql = "INSERT INTO programs (coach_id, title, description, duration_days, difficulty, price) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (p.getCoachId() == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, p.getCoachId());

            ps.setString(2, p.getTitle());
            ps.setString(3, p.getDescription());

            if (p.getDurationDays() == null || p.getDurationDays() <= 0) ps.setNull(4, Types.INTEGER);
            else ps.setInt(4, p.getDurationDays());

            ps.setString(5, p.getDifficulty());

            if (p.getPrice() == null) ps.setNull(6, Types.DOUBLE);
            else ps.setDouble(6, p.getPrice());

            int affected = ps.executeUpdate();
            if (affected == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        long id = rs.getLong(1);
                        p.setId(id);
                        return id;
                    }
                }
            }
        }
        return null;
    }

    public boolean update(Program p) throws SQLException {
        String sql = "UPDATE programs SET title = ?, description = ?, duration_days = ?, difficulty = ?, price = ? WHERE id = ? AND coach_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getTitle());
            ps.setString(2, p.getDescription());

            if (p.getDurationDays() == null || p.getDurationDays() <= 0) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, p.getDurationDays());

            ps.setString(4, p.getDifficulty());

            if (p.getPrice() == null) ps.setNull(5, Types.DOUBLE);
            else ps.setDouble(5, p.getPrice());

            if (p.getId() == null) ps.setNull(6, Types.BIGINT);
            else ps.setLong(6, p.getId());

            if (p.getCoachId() == null) ps.setNull(7, Types.BIGINT);
            else ps.setLong(7, p.getCoachId());

            return ps.executeUpdate() == 1;
        }
    }

    public boolean delete(Long programId, Long coachId) throws SQLException {
        String sql = "DELETE FROM programs WHERE id = ? AND coach_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (programId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, programId);

            if (coachId == null) ps.setNull(2, Types.BIGINT);
            else ps.setLong(2, coachId);

            return ps.executeUpdate() == 1;
        }
    }

    public List<Program> findByCoach(Long coachId) throws SQLException {
        String sql = "SELECT * FROM programs WHERE coach_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (coachId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, coachId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Program> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    public List<Program> findByCoachId(Long coachId) throws SQLException {
        return findByCoach(coachId);
    }

    public List<Program> findAll() throws SQLException {
        String sql = "SELECT * FROM programs ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Program> list = new ArrayList<>();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        }
    }

    public Program findById(Long id) throws SQLException {
        String sql = "SELECT * FROM programs WHERE id = ?";
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

    public List<Program> findByFilters(Long coachId,
                                       String q,
                                       String difficulty,
                                       Integer minDuration,
                                       Integer maxDuration,
                                       Double maxPrice) throws SQLException {

        StringBuilder sb = new StringBuilder("SELECT * FROM programs WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (coachId != null && coachId > 0) { sb.append(" AND coach_id = ?"); params.add(coachId); }
        if (q != null && !q.isBlank()) {
            sb.append(" AND (title LIKE ? OR description LIKE ?)");
            String like = "%" + q.trim() + "%";
            params.add(like); params.add(like);
        }
        if (difficulty != null && !difficulty.isBlank() && !"ALL".equalsIgnoreCase(difficulty)) {
            sb.append(" AND difficulty = ?"); params.add(difficulty);
        }
        if (minDuration != null && minDuration > 0) { sb.append(" AND duration_days >= ?"); params.add(minDuration); }
        if (maxDuration != null && maxDuration > 0) { sb.append(" AND duration_days <= ?"); params.add(maxDuration); }
        if (maxPrice != null && maxPrice >= 0.0) { sb.append(" AND price <= ?"); params.add(maxPrice); }

        sb.append(" ORDER BY created_at DESC");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else if (p instanceof Long) ps.setLong(i + 1, (Long) p);
                else if (p instanceof Double) ps.setDouble(i + 1, (Double) p);
                else ps.setString(i + 1, p.toString());
            }

            try (ResultSet rs = ps.executeQuery()) {
                List<Program> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    private Program mapRow(ResultSet rs) throws SQLException {
        Program p = new Program();

        long id = rs.getLong("id");
        if (!rs.wasNull()) p.setId(id);

        long coachId = rs.getLong("coach_id");
        if (!rs.wasNull()) p.setCoachId(coachId);

        p.setTitle(rs.getString("title"));
        p.setDescription(rs.getString("description"));

        int dur = rs.getInt("duration_days");
        if (!rs.wasNull()) p.setDurationDays(dur);
        else p.setDurationDays(null);

        p.setDifficulty(rs.getString("difficulty"));

        double price = rs.getDouble("price");
        if (!rs.wasNull()) p.setPrice(price);
        else p.setPrice(null);

        try {
            Timestamp ts = rs.getTimestamp("created_at");
            if (ts != null) p.setCreatedAt(ts);
        } catch (SQLException ignored) {}

        return p;
    }
}
