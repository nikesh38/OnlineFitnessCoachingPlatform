package com.onlinefitness.dao;

import com.onlinefitness.model.ProgressLog;
import com.onlinefitness.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProgressDAO {

    public Long save(ProgressLog log) throws SQLException {
        String sql = "INSERT INTO progress_logs (user_id, log_date, weight_kg, notes, photo_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (log.getUserId() == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, log.getUserId());

            if (log.getLogDate() == null) ps.setNull(2, Types.DATE);
            else ps.setDate(2, log.getLogDate());

            if (log.getWeightKg() == null) ps.setNull(3, Types.DOUBLE);
            else ps.setDouble(3, log.getWeightKg());

            if (log.getNotes() == null) ps.setNull(4, Types.VARCHAR);
            else ps.setString(4, log.getNotes());

            if (log.getPhotoUrl() == null) ps.setNull(5, Types.VARCHAR);
            else ps.setString(5, log.getPhotoUrl());

            int affected = ps.executeUpdate();
            if (affected == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        long id = rs.getLong(1);
                        log.setId(id);
                        return id;
                    }
                }
            }
        }
        return null;
    }

    public List<ProgressLog> findByUser(Long userId) throws SQLException {
        String sql = "SELECT * FROM progress_logs WHERE user_id = ? ORDER BY log_date DESC, id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (userId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<ProgressLog> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }

    public ProgressLog findById(Long id) throws SQLException {
        String sql = "SELECT * FROM progress_logs WHERE id = ?";
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

    public boolean update(ProgressLog log) throws SQLException {
        String sql = "UPDATE progress_logs SET log_date = ?, weight_kg = ?, notes = ?, photo_url = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (log.getLogDate() == null) ps.setNull(1, Types.DATE);
            else ps.setDate(1, log.getLogDate());

            if (log.getWeightKg() == null) ps.setNull(2, Types.DOUBLE);
            else ps.setDouble(2, log.getWeightKg());

            if (log.getNotes() == null) ps.setNull(3, Types.VARCHAR);
            else ps.setString(3, log.getNotes());

            if (log.getPhotoUrl() == null) ps.setNull(4, Types.VARCHAR);
            else ps.setString(4, log.getPhotoUrl());

            if (log.getId() == null) ps.setNull(5, Types.BIGINT);
            else ps.setLong(5, log.getId());

            return ps.executeUpdate() == 1;
        }
    }

    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM progress_logs WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (id == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        }
    }

    private ProgressLog mapRow(ResultSet rs) throws SQLException {
        ProgressLog p = new ProgressLog();

        long id = rs.getLong("id");
        if (!rs.wasNull()) p.setId(id);

        long userId = rs.getLong("user_id");
        if (!rs.wasNull()) p.setUserId(userId);

        p.setLogDate(rs.getDate("log_date"));

        double w = rs.getDouble("weight_kg");
        if (!rs.wasNull()) p.setWeightKg(w);
        else p.setWeightKg(null);

        p.setNotes(rs.getString("notes"));
        p.setPhotoUrl(rs.getString("photo_url"));
        return p;
    }
}
