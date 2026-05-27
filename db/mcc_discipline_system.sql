-- PostgreSQL SQL Dump
-- Converted from phpMyAdmin MySQL export
-- Original Host: 127.0.0.1
-- Generation Time: May 26, 2026 at 01:59 PM
-- Original Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

BEGIN TRANSACTION;

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
-- (no initial data)

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
-- (no initial data)

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
-- (no initial data)

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
-- (no initial data)

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
