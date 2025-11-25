package com.onlinefitness.dao;

import com.onlinefitness.model.Workout;
import com.onlinefitness.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WorkoutDAO {

    public Long create(Workout w) throws SQLException {
        String sql = "INSERT INTO workouts (program_id, day_number, title, instructions, media_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (w.getProgramId() == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, w.getProgramId());

            if (w.getDayNumber() == null) ps.setNull(2, Types.INTEGER);
            else ps.setInt(2, w.getDayNumber());

            ps.setString(3, w.getTitle());
            ps.setString(4, w.getInstructions());

            if (w.getMediaUrl() == null) ps.setNull(5, Types.VARCHAR);
            else ps.setString(5, w.getMediaUrl());

            int affected = ps.executeUpdate();
            if (affected == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        long id = rs.getLong(1);
                        w.setId(id);
                        return id;
                    }
                }
            }
        }
        return null;
    }

    public List<Workout> findByProgramId(Long programId) throws SQLException {
        String sql = "SELECT * FROM workouts WHERE program_id = ? ORDER BY day_number";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (programId == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, programId);

            try (ResultSet rs = ps.executeQuery()) {
                List<Workout> list = new ArrayList<>();
                while (rs.next()) {
                    Workout w = new Workout();

                    long id = rs.getLong("id");
                    if (!rs.wasNull()) w.setId(id);

                    long pid = rs.getLong("program_id");
                    if (!rs.wasNull()) w.setProgramId(pid);

                    int day = rs.getInt("day_number");
                    if (!rs.wasNull()) w.setDayNumber(day);
                    else w.setDayNumber(null);

                    w.setTitle(rs.getString("title"));
                    w.setInstructions(rs.getString("instructions"));
                    w.setMediaUrl(rs.getString("media_url"));

                    list.add(w);
                }
                return list;
            }
        }
    }

    public boolean update(Workout w) throws SQLException {
        String sql = "UPDATE workouts SET day_number = ?, title = ?, instructions = ?, media_url = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (w.getDayNumber() == null) ps.setNull(1, Types.INTEGER);
            else ps.setInt(1, w.getDayNumber());

            ps.setString(2, w.getTitle());
            ps.setString(3, w.getInstructions());

            if (w.getMediaUrl() == null) ps.setNull(4, Types.VARCHAR);
            else ps.setString(4, w.getMediaUrl());

            if (w.getId() == null) ps.setNull(5, Types.BIGINT);
            else ps.setLong(5, w.getId());

            return ps.executeUpdate() == 1;
        }
    }

    public boolean delete(Long id) throws SQLException {
        String sql = "DELETE FROM workouts WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (id == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, id);
            return ps.executeUpdate() == 1;
        }
    }
}
