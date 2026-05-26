-- =========================================================
-- IMPORT VALIDATION QUERIES
-- =========================================================

-- ---------------------------------------------------------
-- 1. Row count of each table
-- ---------------------------------------------------------

SELECT 'students' AS table_name, COUNT(*) AS row_count FROM students
UNION
SELECT 'courses', COUNT(*) FROM courses
UNION
SELECT 'enrollments', COUNT(*) FROM enrollments
UNION
SELECT 'problems', COUNT(*) FROM problems
UNION
SELECT 'submissions', COUNT(*) FROM submissions
UNION
SELECT 'test_cases', COUNT(*) FROM test_cases
UNION
SELECT 'test_results', COUNT(*) FROM test_results
UNION
SELECT 'attendance', COUNT(*) FROM attendance;

-- ---------------------------------------------------------
-- 2. Distinct primary key count validation
-- ---------------------------------------------------------

SELECT 
    COUNT(student_id) AS total_ids,
    COUNT(DISTINCT student_id) AS distinct_ids
FROM students;

SELECT 
    COUNT(problem_id) AS total_ids,
    COUNT(DISTINCT problem_id) AS distinct_ids
FROM problems;

SELECT 
    COUNT(submission_id) AS total_ids,
    COUNT(DISTINCT submission_id) AS distinct_ids
FROM submissions;

-- ---------------------------------------------------------
-- 3. NULL or blank value checks
-- ---------------------------------------------------------

SELECT *
FROM students
WHERE full_name IS NULL
   OR TRIM(full_name) = '';

SELECT *
FROM students
WHERE email IS NULL
   OR TRIM(email) = '';

SELECT *
FROM problems
WHERE title IS NULL
   OR TRIM(title) = '';

-- ---------------------------------------------------------
-- 4. Empty table detection
-- ---------------------------------------------------------

SELECT 'students' AS table_name
WHERE NOT EXISTS (SELECT 1 FROM students);

SELECT 'submissions' AS table_name
WHERE NOT EXISTS (SELECT 1 FROM submissions);

-- ---------------------------------------------------------
-- 5. Imported row count comparison
-- ---------------------------------------------------------

-- Example expected counts from CSV

SELECT COUNT(*) AS imported_students FROM students;
SELECT COUNT(*) AS imported_courses FROM courses;
SELECT COUNT(*) AS imported_submissions FROM submissions;

-- Compare these manually against CSV row counts.