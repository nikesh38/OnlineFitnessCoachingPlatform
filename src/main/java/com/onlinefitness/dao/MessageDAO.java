package com.onlinefitness.dao;

import com.onlinefitness.model.Message;
import com.onlinefitness.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    public Long sendMessage(Message m) throws SQLException {
        String sql = "INSERT INTO messages (sender_id, receiver_id, message) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (m.getSenderId() == null) ps.setNull(1, Types.BIGINT);
            else ps.setLong(1, m.getSenderId());

            if (m.getReceiverId() == null) ps.setNull(2, Types.BIGINT);
            else ps.setLong(2, m.getReceiverId());

            ps.setString(3, m.getMessage());

            int affected = ps.executeUpdate();
            if (affected == 1) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        long id = rs.getLong(1);
                        m.setId(id);
                        return id;
                    }
                }
            }
        }
        return null;
    }

    public List<Message> conversation(Long userA, Long userB) throws SQLException {
        String sql = "SELECT * FROM messages WHERE (sender_id=? AND receiver_id=?) OR (sender_id=? AND receiver_id=?) ORDER BY sent_at";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userA == null) ps.setNull(1, Types.BIGINT); else ps.setLong(1, userA);
            if (userB == null) ps.setNull(2, Types.BIGINT); else ps.setLong(2, userB);
            if (userB == null) ps.setNull(3, Types.BIGINT); else ps.setLong(3, userB);
            if (userA == null) ps.setNull(4, Types.BIGINT); else ps.setLong(4, userA);

            try (ResultSet rs = ps.executeQuery()) {
                List<Message> list = new ArrayList<>();
                while (rs.next()) {
                    Message m = new Message();
                    long id = rs.getLong("id");
                    if (!rs.wasNull()) m.setId(id);

                    long sender = rs.getLong("sender_id");
                    if (!rs.wasNull()) m.setSenderId(sender);

                    long receiver = rs.getLong("receiver_id");
                    if (!rs.wasNull()) m.setReceiverId(receiver);

                    m.setMessage(rs.getString("message"));
                    m.setSentAt(rs.getTimestamp("sent_at"));
                    list.add(m);
                }
                return list;
            }
        }
    }
}
