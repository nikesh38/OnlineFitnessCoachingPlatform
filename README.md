# OnlineFitnessCoaching

Small fitness coaching web app (Java EE / JSP / Servlets) — manage coaches, programs, workouts, trainee progress and enrollments.

## Contents

- `/src/main/java` - Servlets, DAOs, models (Java)
- `/src/main/webapp/jsp` - JSP views (UI)
- `pom.xml` - Maven build (packaged as a WAR)
- `schema.sql` - MySQL database schema (create tables & sample admin)
- `README.md` - this file

## Quick overview

This project uses:

- Java 17 (compile & target)
- Maven (build)
- JSP + Servlets (web)
- MySQL (database)
- Plain JDBC DAOs (DB connection util in `com.onlinefitness.util.DBUtil`)
- File uploads stored under `uploads/` (not committed)

Primary features:

- Coaches can create programs and add workouts.
- Trainees can browse programs, enroll and track progress.
- Progress entries support photos and CSV export.
- Messaging between users (basic).

## Database

1. Install MySQL (or use Docker)
2. Create a database, for example:

```sql
CREATE DATABASE onlinefitness CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Run schema.sql (this file) to create tables and a sample admin user:

mysql -u root -p onlinefitness < schema.sql

Configure DB connection in DBUtil (or in src/main/resources if your project uses a properties file). Typical values:

jdbcUrl = "jdbc:mysql://localhost:3306/onlinefitness?useSSL=false&serverTimezone=UTC";
username = "your_db_user";
password = "your_db_password";
driver = "com.mysql.cj.jdbc.Driver";


If using a properties file, ensure the servlet container (Tomcat) can access it and DBUtil reads it.

Build & Deploy

Build with Maven:

mvn -U clean package


Deploy target/OnlineFitnessCoaching-1.0-SNAPSHOT.war to Apache Tomcat (drop into webapps/) or use your IDE's run configuration.

Open in browser:

http://localhost:8080/OnlineFitnessCoaching/

Important pages / endpoints

GET / — index.jsp (home)

GET /login (form) → POST /login (servlet)

GET /jsp/program-list.jsp or GET /programs — programs listing

GET /jsp/program-form.jsp or GET /programs/new — create program (coach)

POST /programs — create program

GET /workouts?programId={id} — workouts for program

POST /workouts — add workout (coach)

GET /progress — trainee progress list

POST /progress — add progress (multipart with photo)

GET /progress/edit?id={id} — edit progress

POST /enrollments — enroll in a program

Paths come from JSP forms / servlets in src/main/java/com/onlinefitness/servlet.

DB notes / DAO compatibility

IDs are INT AUTO_INCREMENT in the SQL below. If you convert Java models/DAOs to use Long for IDs, update the SQL types to BIGINT consistently.

The DAOs use null-safe setters (setNull) for optional numeric fields (duration, price, weight, height).

If you change the id type to BIGINT in SQL, also update the DAOs and Program/User models to use Long.

File uploads

Uploaded images are expected under /uploads/... served statically (configure a servlet or let Tomcat serve the folder).

Create uploads/progress/full and uploads/progress/thumbs and ensure the webserver user has write permission.

Common troubleshooting

Compilation errors about package com.yourapp.dao or missing classes: ensure package names are com.onlinefitness.* and imports in servlets/DAOs match exactly.

java.sql type mismatch (int vs Long): be consistent across DAOs and models. Prefer Long for ids or convert SQL to use BIGINT.

MySQL Connector relocation warning: update your pom.xml dependency to com.mysql:mysql-connector-j (groupId changed).

If JSP pages show blank or errors, check server logs (catalina.out) for classpath/mapping errors.

Development tips

Keep DAOs small and focused; unit-test with an in-memory DB (H2) where possible.

Use consistent id types across model, DAO, and servlets.

Add simple validation in servlets before calling DAOs.

License

MIT-style (for personal / educational use).

schema.sql
-- schema.sql
-- MySQL schema for OnlineFitnessCoaching
-- Run against the database you created (example: onlinefitness)

SET FOREIGN_KEY_CHECKS = 0;

-- USERS: coaches & trainees & admins
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(200) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,        -- store bcrypt/argon2 hash
  role VARCHAR(50) NOT NULL DEFAULT 'TRAINEE', -- TRAINEE | COACH | ADMIN
  is_approved TINYINT(1) NOT NULL DEFAULT 1,  -- coaches require approval: 0 = pending
  age INT NULL,
  gender VARCHAR(32) NULL,
  height_cm DECIMAL(6,2) NULL,
  weight_kg DECIMAL(6,2) NULL,
  bio TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- PROGRAMS: created by coaches
CREATE TABLE IF NOT EXISTS programs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  coach_id INT NOT NULL,
  title VARCHAR(150) NOT NULL,
  description TEXT NULL,
  duration_days INT NULL,
  difficulty VARCHAR(50) NULL,
  price DECIMAL(8,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coach_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- WORKOUTS: program sessions
CREATE TABLE IF NOT EXISTS workouts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  program_id INT NOT NULL,
  day_number INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  instructions TEXT NULL,
  media_url VARCHAR(500) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ENROLLMENTS: users enrolled to programs
CREATE TABLE IF NOT EXISTS enrollments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  program_id INT NOT NULL,
  start_date DATE NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE', -- ACTIVE, COMPLETED, CANCELLED, etc.
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
  UNIQUE KEY ux_user_program (user_id, program_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- PROGRESS LOGS: weight/photos/notes
CREATE TABLE IF NOT EXISTS progress_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  log_date DATE NULL,
  weight_kg DECIMAL(6,2) NULL,
  notes TEXT NULL,
  photo_url VARCHAR(500) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- MESSAGES: simple messaging between users
CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id INT NOT NULL,
  receiver_id INT NOT NULL,
  message TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_conv (sender_id, receiver_id, sent_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- coach_approvals: audit of coach approval (optional)
CREATE TABLE IF NOT EXISTS coach_approvals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  coach_id INT NOT NULL,
  approver_id INT NOT NULL,
  approved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coach_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (approver_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- optional indexes
CREATE INDEX idx_program_coach ON programs(coach_id);
CREATE INDEX idx_workout_program ON workouts(program_id);
CREATE INDEX idx_enrollment_user ON enrollments(user_id);
CREATE INDEX idx_progress_user ON progress_logs(user_id);

SET FOREIGN_KEY_CHECKS = 1;

-- Sample seed data
INSERT INTO users (name, email, password_hash, role, is_approved)
VALUES ('Admin User', 'admin@local', 'changeme', 'ADMIN', 1)
ON DUPLICATE KEY UPDATE email = email;

-- Optional: sample program (uncomment to seed)
-- INSERT INTO programs (coach_id, title, description, duration_days, difficulty, price)
-- VALUES (1, 'Sample Program', 'A sample program for testing', 28, 'Beginner', 0.00);
