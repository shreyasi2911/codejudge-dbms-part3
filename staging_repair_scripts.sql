-- =========================================================
-- STAGING TABLE CREATION
-- =========================================================

CREATE TABLE students_staging AS
SELECT * FROM students;

CREATE TABLE submissions_staging AS
SELECT * FROM submissions;

CREATE TABLE attendance_staging AS
SELECT * FROM attendance;

CREATE TABLE enrollments_staging AS
SELECT * FROM enrollments;

CREATE TABLE problems_staging AS
SELECT * FROM problems;

-- =========================================================
-- REPAIR 1 — INVALID EMAIL
-- =========================================================

-- BEFORE

SELECT *
FROM students_staging
WHERE student_id = "S0018";

-- REPAIR

UPDATE students_staging
SET email = 'ravi@code.judge.edu'
WHERE student_id = "S0018";

-- AFTER

SELECT *
FROM students_staging
WHERE student_id = "S0018";

-- =========================================================
-- REPAIR 2 — INVALID LANGUAGE
-- =========================================================

-- BEFORE

SELECT *
FROM submissions_staging
WHERE submission_id = "SUB000001";

-- REPAIR

UPDATE submissions_staging
SET language = 'C++'
WHERE submission_id = "SUB000001"
  AND language = 'C';

-- AFTER

SELECT *
FROM submissions_staging
WHERE submission_id = "SUB000001";

-- =========================================================
-- REPAIR 3 — INVALID DIFFICULTY
-- =========================================================

-- BEFORE

SELECT *
FROM problems_staging
WHERE problem_id = "P0010";

-- REPAIR

UPDATE problems_staging
SET difficulty = 'Medium'
WHERE problem_id = "P0010"
  AND difficulty = 'Very Hard';

-- AFTER

SELECT *
FROM problems_staging
WHERE problem_id = "P0010";

-- =========================================================
-- REPAIR 4 — INVALID ATTENDANCE STATUS
-- =========================================================

-- BEFORE

SELECT *
FROM attendance_staging
WHERE attendance_id = "A000046";

-- REPAIR

UPDATE attendance_staging
SET attendance_status = 'Present'
WHERE attendance_id = "A000046"
  AND attendance_status = 'joined';

-- AFTER

SELECT *
FROM attendance_staging
WHERE attendance_id = "A000046";

-- =========================================================
-- REPAIR 5 — DUPLICATE ENROLLMENT
-- =========================================================

-- BEFORE

SELECT *
FROM enrollments_staging
WHERE student_id = "S0001"
  AND course_id = 'C006';

-- REPAIR

DELETE FROM enrollments_staging
WHERE enrollment_id =
(
    SELECT MAX(enrollment_id)
    FROM enrollments_staging
    WHERE student_id = "S0001"
      AND course_id = 'C006'
);

-- AFTER

SELECT *
FROM enrollments_staging
WHERE student_id = "S0001"
  AND course_id = 'C006';
  


-- =========================================================
-- REPAIR 6 — NEGATIVE SCORE
-- Submission ID: "S0148"
-- =========================================================

-- BEFORE REPAIR

SELECT submission_id, student_id, score
FROM submissions_staging
WHERE submission_id = "S0148";

-- REPAIR ACTION

UPDATE submissions_staging
SET score = NULL
WHERE submission_id ="S0148"
  AND score < 0;

-- AFTER REPAIR

SELECT submission_id, student_id, score
FROM submissions_staging
WHERE submission_id = "S0148";

-- COMMENT:
-- Invalid negative score removed and marked for manual verification.



-- =========================================================
-- REPAIR 7 — ENROLLMENT LINKED TO MISSING STUDENT
-- Enrollment ID: 7005
-- =========================================================

-- CREATE REJECTED TABLE

CREATE TABLE IF NOT EXISTS rejected_enrollments AS
SELECT *
FROM enrollments_staging
WHERE 1 = 0;

-- BEFORE REPAIR

SELECT *
FROM enrollments_staging
WHERE enrollment_id = 7005;

-- MOVE INVALID RECORD

INSERT INTO rejected_enrollments
SELECT *
FROM enrollments_staging
WHERE enrollment_id = 7005;

DELETE FROM enrollments_staging
WHERE enrollment_id = 7005;

-- AFTER REPAIR

SELECT *
FROM enrollments_staging
WHERE enrollment_id = 7005;

SELECT *
FROM rejected_enrollments
WHERE enrollment_id = 7005;

-- COMMENT:
-- Orphan enrollment moved safely to rejected table.

-- =========================================================
-- REPAIR 8 — CONTEST END TIME BEFORE START TIME
-- Contest ID: 9002
-- =========================================================

-- CREATE MANUAL REVIEW TABLE

CREATE TABLE IF NOT EXISTS manual_review_contests AS
SELECT *
FROM contests_staging
WHERE 1 = 0;

-- BEFORE REPAIR

SELECT contest_id, start_time, end_time
FROM contests_staging
WHERE contest_id = 9002;

-- MOVE TO MANUAL REVIEW

INSERT INTO manual_review_contests
SELECT *
FROM contests_staging
WHERE contest_id = 9002
  AND end_time < start_time;

DELETE FROM contests_staging
WHERE contest_id = 9002
  AND end_time < start_time;

-- AFTER REPAIR

SELECT *
FROM contests_staging
WHERE contest_id = 9002;

SELECT *
FROM manual_review_contests
WHERE contest_id = 9002;

-- COMMENT:
-- Invalid contest timing requires human verification.


