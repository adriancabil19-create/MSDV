-- PostgreSQL SQL Dump
-- Converted from phpMyAdmin MySQL export
-- Original Host: 127.0.0.1
-- Generation Time: May 26, 2026 at 01:59 PM
-- Original Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

BEGIN TRANSACTION;
SET TIME ZONE = 'UTC';

-- Create enum types for PostgreSQL
CREATE TYPE user_role AS ENUM ('admin', 'teacher', 'csu', 'jassu');

-- =====================================================
-- Table: notifications
-- =====================================================
DROP TABLE IF EXISTS notifications CASCADE;

CREATE TABLE notifications (
  id SERIAL PRIMARY KEY,
  type VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  student_id VARCHAR(20) DEFAULT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Dumping data for table notifications
INSERT INTO notifications (id, type, title, message, student_id, is_read, created_at) VALUES
(1, 'new_violation', '📝 New Violation: Joey John Sucalit', 'Joey John Sucalit (teacher) submitted a Minor violation (Disruptive Behavior) for Joey John Sucalit (ID: 223-09673).', '223-09673', FALSE, '2026-05-26 05:14:21'),
(2, 'new_violation', '📝 New Violation: atay', 'Joey John Sucalit (teacher) submitted a Minor violation (Littering) for atay (ID: 222-22222).', '222-22222', FALSE, '2026-05-26 05:29:58'),
(3, 'new_violation', 'New Violation: Joey John Sucalit', 'System Admin (admin) submitted a Major violation (Cyber Bullying) for Joey John Sucalit (ID: 223-09673).', '223-09673', FALSE, '2026-05-26 05:41:21'),
(4, 'new_violation', 'New Violation: 23323232323', 'Joey John Sucalit (teacher) submitted a Minor violation (Littering) for 23323232323 (ID: 232-33323).', '232-33323', FALSE, '2026-05-26 05:47:58'),
(5, 'new_violation', 'New Violation: 23323232323', 'Joey John Sucalit (teacher) submitted a Minor violation (Unapproved Absences) for 23323232323 (ID: 232-33323).', '232-33323', FALSE, '2026-05-26 10:50:50'),
(6, 'new_violation', 'New Violation: ', 'Joey John Sucalit (teacher) submitted a Minor violation (Failure to Display ID) for  (ID: 233-23434334343443434434).', '233-2343433434344343', FALSE, '2026-05-26 11:39:35');

-- =====================================================
-- Table: students
-- =====================================================
DROP TABLE IF EXISTS students CASCADE;

CREATE TABLE students (
  id SERIAL PRIMARY KEY,
  student_id VARCHAR(20) NOT NULL UNIQUE,
  fullname VARCHAR(100) NOT NULL,
  course VARCHAR(100) NOT NULL,
  year_level VARCHAR(20) NOT NULL,
  department VARCHAR(100) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Dumping data for table students
INSERT INTO students (id, student_id, fullname, course, year_level, department, created_at) VALUES
(1, '223-09673', 'Joey John Sucalit', 'BSIT', '3rd Year', 'School of Technology', '2026-05-25 09:20:26'),
(2, '223-56789', 'allen bayot', 'BSIT', '1st Year', 'School of Technology', '2026-05-25 13:05:32'),
(3, '232-33323', '23323232323', 'BSIT', '1st Year', 'School of Technology', '2026-05-25 13:16:45'),
(5, '11111111111111111111', '33333333333333333333333333333', 'BSBA (HRM)', '1st Year', 'School of Business', '2026-05-25 17:22:08'),
(6, '222-22222', 'atay', 'BEEd', '2nd Year', 'School of Education', '2026-05-25 18:20:31');

-- =====================================================
-- Table: users
-- =====================================================
DROP TABLE IF EXISTS users CASCADE;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  fullname VARCHAR(100) NOT NULL,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL,
  password VARCHAR(255) NOT NULL,
  role user_role NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Dumping data for table users
INSERT INTO users (id, fullname, username, email, password, role, created_at) VALUES
(2, 'System Admin', 'admin', 'admin@gmail.com', '$2y$10$cCl6epuAWV852lTmRT2rX.IgCyjK3rDnNsK/.0T2rADOdPBYxJ/Zi', 'admin', '2026-05-25 08:24:00'),
(8, 'gwapo', 'gwapo', 'gwapo@gmail.com', '$2y$10$maTz0o0pM.6ZflZ5U0BxtuKaCvBWAGeBfFxtxrJFie5zf5y51WC7C', 'jassu', '2026-05-25 09:28:58'),
(9, 'Joey John Sucalit', 'zeeone', 'joeyjohnsucalit23@gmail.com', '$2y$10$HdzhF9D2cegGeKxLAPDtZOi/qOQRnzL7mzw8I7EVImBt69zsbCm/W', 'teacher', '2026-05-25 09:29:15'),
(11, 'Joey John ', 'sasa', 'sdfdf@adfadsf.com', '$2y$10$6YrC62UBhpWBK1AkG55Dvexm65g1EcvdaF6ySTrNmuUOC1rVPJEsC', 'csu', '2026-05-26 05:45:29'),
(12, 'sese', 'siwan', 'adsfasdf@mfasdhf.asdc', '$2y$10$4bIMxb89dyWXh63UjJzfZ.shNvqJ.xMFBy.HuENgntAr5E6lVVKPq', 'jassu', '2026-05-26 05:45:51');

-- =====================================================
-- Table: violations
-- =====================================================
DROP TABLE IF EXISTS violations CASCADE;

CREATE TABLE violations (
  id SERIAL PRIMARY KEY,
  student_id VARCHAR(20) NOT NULL,
  student_name VARCHAR(100) NOT NULL,
  course VARCHAR(100) NOT NULL,
  year_level VARCHAR(50) NOT NULL,
  department VARCHAR(100) NOT NULL,
  violation_category VARCHAR(50) DEFAULT NULL,
  violation_type VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  evidence VARCHAR(255) DEFAULT NULL,
  camera_capture TEXT DEFAULT NULL,
  e_signature TEXT DEFAULT NULL,
  reported_by VARCHAR(100) NOT NULL,
  reporter_role VARCHAR(50) NOT NULL,
  status VARCHAR(50) DEFAULT 'Pending',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sanction TEXT DEFAULT NULL,
  action_start DATE DEFAULT NULL,
  action_end DATE DEFAULT NULL,
  case_status VARCHAR(50) DEFAULT 'Pending',
  disciplinary_level VARCHAR(50) DEFAULT NULL,
  disciplinary_start DATE DEFAULT NULL,
  disciplinary_end DATE DEFAULT NULL
);

-- Dumping data for table violations (sample data)
INSERT INTO violations (id, student_id, student_name, course, year_level, department, violation_category, violation_type, description, evidence, camera_capture, e_signature, reported_by, reporter_role, status, created_at, sanction, action_start, action_end, case_status, disciplinary_level, disciplinary_start, disciplinary_end) VALUES
(8, '223-09673', 'Joey John Sucalit', 'BSIT', '3rd Year', 'School of Technology', 'Minor', 'Disruptive Behavior', 'adsf', '1779707225_20260508194025001.png', NULL, NULL, 'Joey John Sucalit', 'teacher', '', '2026-05-25 11:07:05', NULL, NULL, NULL, 'Completed', NULL, NULL, '2026-05-25');

-- =====================================================
-- Add Foreign Key Constraints
-- =====================================================
ALTER TABLE violations 
ADD CONSTRAINT fk_violations_student 
FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE;

ALTER TABLE notifications 
ADD CONSTRAINT fk_notifications_student 
FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE;

-- =====================================================
-- Create Indexes for Performance
-- =====================================================
CREATE INDEX idx_students_student_id ON students(student_id);
CREATE INDEX idx_students_fullname ON students(fullname);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_violations_student_id ON violations(student_id);
CREATE INDEX idx_violations_created_at ON violations(created_at);
CREATE INDEX idx_notifications_student_id ON notifications(student_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

COMMIT;
