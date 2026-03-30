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

-- Upload spec.yaml to this stage:
--   PUT file://spec.yaml @todo_stage AUTO_COMPRESS=FALSE OVERWRITE=TRUE;

-- 4. Compute Pool
CREATE COMPUTE POOL IF NOT EXISTS todo_compute_pool
  MIN_NODES = 1
  MAX_NODES = 1
  INSTANCE_FAMILY = CPU_X64_XS;

-- 5. Create Service
-- NOTE: Replace <IMAGE_REPO_URL> with the output from SHOW IMAGE REPOSITORIES
--
-- Option A: From stage
-- CREATE SERVICE todo_service
--   IN COMPUTE POOL todo_compute_pool
--   FROM @todo_stage
--   SPECIFICATION_FILE = 'spec.yaml';
--
-- Option B: Inline specification
-- CREATE SERVICE todo_service
--   IN COMPUTE POOL todo_compute_pool
--   FROM SPECIFICATION $$
--   spec:
--     containers:
--       - name: todo-app
--         image: <IMAGE_REPO_URL>/todo-app:latest
--         readinessProbe:
--           port: 8080
--           path: /healthcheck
--     endpoints:
--       - name: todoendpoint
--         port: 8080
--         public: true
--   $$;

-- 6. Verify
-- SHOW SERVICES;
-- DESCRIBE SERVICE todo_service;
-- CALL SYSTEM$GET_SERVICE_STATUS('todo_service');

-- 7. Get public endpoint URL
-- SHOW ENDPOINTS IN SERVICE todo_service;
