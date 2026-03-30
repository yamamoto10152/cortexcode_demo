-- ==============================================
-- SPCS ToDo App Setup
-- ==============================================

-- 1. Database & Schema
CREATE DATABASE IF NOT EXISTS todo_db;
CREATE SCHEMA IF NOT EXISTS todo_db.todo_schema;

USE DATABASE todo_db;
USE SCHEMA todo_schema;

-- 2. Image Repository
CREATE IMAGE REPOSITORY IF NOT EXISTS todo_repo;

-- Confirm repository URL (use this for docker push)
SHOW IMAGE REPOSITORIES IN SCHEMA;

-- 3. Stage for spec file
CREATE STAGE IF NOT EXISTS todo_stage
  DIRECTORY = (ENABLE = TRUE);

-- 4. Compute Pool
CREATE COMPUTE POOL IF NOT EXISTS todo_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS;
