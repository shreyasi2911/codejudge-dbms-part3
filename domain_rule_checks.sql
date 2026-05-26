-- =========================================================
-- TASK 4: DOMAIN & RULE VALIDATION
-- =========================================================

-- =========================================================
-- 1. NEGATIVE SCORES
-- Purpose:
-- Detect impossible negative marks.
-- Expected:
-- No rows should be returned.
-- =========================================================

SELECT *
FROM submissions
WHERE score < 0;

-- Why it matters:
-- Scores cannot logically be negative.



-- =========================================================
-- 2. SCORES GREATER THAN MAXIMUM ALLOWED
-- Purpose:
-- Detect scores exceeding maximum marks.
-- Assumption:
-- Maximum allowed score = 100
-- =========================================================

SELECT *
FROM submissions
WHERE score > 100;

-- Why it matters:
-- Scores above allowed limits indicate corruption or import errors.



-- =========================================================
-- 3. INVALID DIFFICULTY VALUES
-- Allowed:
-- Easy, Medium, Hard
-- =========================================================

SELECT *
FROM problems
WHERE difficulty_level NOT IN
(
    'Easy',
    'Medium',
    'Hard'
);

-- Why it matters:
-- Invalid difficulty values break filtering and analytics.



-- =========================================================
-- 4. INVALID SUBMISSION STATUSES
-- =========================================================

SELECT *
FROM submissions
WHERE status NOT IN
(
    'Accepted',
    'Wrong Answer',
    'Runtime Error',
    'Compilation Error',
    'Time Limit Exceeded'
);

-- Why it matters:
-- Submission status must belong to a standardized set.



-- =========================================================
-- 5. INVALID PROGRAMMING LANGUAGE VALUES
-- =========================================================

SELECT *
FROM submissions
WHERE language NOT IN
(
    'Python',
    'Java',
    'C++',
    'JavaScript'
);

-- Why it matters:
-- Invalid language names reduce reporting consistency.



-- =========================================================
-- 6. INVALID TEST RESULT STATUSES
-- =========================================================

SELECT *
FROM test_results
WHERE result_status NOT IN
(
    'Passed',
    'Failed',
    'Runtime Error',
    'Time Limit Exceeded'
);

-- Why it matters:
-- Test execution systems depend on standardized statuses.



-- =========================================================
-- 7. INVALID ATTENDANCE STATUSES
-- =========================================================

SELECT *
FROM attendance
WHERE attendance_status NOT IN
(
    'Present',
    'Absent',
    'Late'
);

-- Why it matters:
-- Invalid attendance values affect participation analytics.



-- =========================================================
-- 8. INVALID CONTEST STATUSES
-- =========================================================

SELECT *
FROM contests
WHERE contest_status NOT IN
(
    'Upcoming',
    'Active',
    'Completed'
);

-- Why it matters:
-- Contest lifecycle tracking becomes unreliable.



-- =========================================================
-- 9. INVALID OPERATION REQUEST STATES
-- Example:
-- Regrade request statuses
-- =========================================================

SELECT *
FROM regrade_requests
WHERE request_status NOT IN
(
    'Pending',
    'Approved',
    'Rejected',
    'Resolved'
);

-- Why it matters:
-- Invalid workflow states break request management logic.



-- =========================================================
-- 10. END TIME BEFORE START TIME
-- Example:
-- Contests
-- =========================================================

SELECT *
FROM contests
WHERE end_time < start_time;

-- Why it matters:
-- Events cannot end before they begin.



-- =========================================================
-- 11. SESSION END TIME BEFORE START TIME
-- =========================================================

SELECT *
FROM sessions
WHERE end_time < start_time;

-- Why it matters:
-- Invalid session timings affect scheduling systems.



-- =========================================================
-- 12. RESOLVED TIME BEFORE REQUESTED TIME
-- =========================================================

SELECT *
FROM regrade_requests
WHERE resolved_time < requested_time;

-- Why it matters:
-- Requests cannot be resolved before submission.



-- =========================================================
-- 13. EXECUTED TIME BEFORE REQUESTED TIME
-- Example:
-- Test execution timestamps
-- =========================================================

SELECT *
FROM test_results
WHERE executed_time < requested_time;

-- Why it matters:
-- Execution chronology must remain valid.



-- =========================================================
-- 14. SUBMISSION BEFORE ENROLLMENT DATE
-- =========================================================

SELECT
    s.submission_id,
    s.student_id,
    s.submission_timestamp,
    e.enrollment_date
FROM submissions s
JOIN enrollments e
    ON s.student_id = e.student_id
WHERE s.submission_timestamp < e.enrollment_date;

-- Why it matters:
-- Students should not submit before enrollment.



-- =========================================================
-- 15. NULL OR BLANK VALUES IN MANDATORY COLUMNS
-- =========================================================

-- Students: mandatory full name

SELECT *
FROM students
WHERE full_name IS NULL
   OR TRIM(full_name) = '';



-- Students: mandatory email

SELECT *
FROM students
WHERE email IS NULL
   OR TRIM(email) = '';



-- Courses: mandatory course name

SELECT *
FROM courses
WHERE course_name IS NULL
   OR TRIM(course_name) = '';



-- Problems: mandatory title

SELECT *
FROM problems
WHERE title IS NULL
   OR TRIM(title) = '';



-- =========================================================
-- 16. INVALID EMAIL FORMAT
-- =========================================================

SELECT *
FROM students
WHERE email IS NOT NULL
  AND email NOT LIKE '%@%.%';

-- Why it matters:
-- Invalid emails break communication and authentication systems.



-- =========================================================
-- 17. INVALID PHONE NUMBER LENGTH
-- Assumption:
-- Valid phone number = 10 digits
-- =========================================================

SELECT *
FROM students
WHERE LENGTH(phone_number) <> 10;

-- Why it matters:
-- Incorrect phone formats reduce contact reliability.



-- =========================================================
-- 18. DUPLICATE ACTIVE CONTESTS AT SAME TIME
-- Additional business rule
-- =========================================================

SELECT
    c1.contest_id,
    c2.contest_id
FROM contests c1
JOIN contests c2
    ON c1.contest_id <> c2.contest_id
   AND c1.start_time < c2.end_time
   AND c1.end_time > c2.start_time;

-- Why it matters:
-- Overlapping contests may create scheduling conflicts.



-- =========================================================
-- 19. INVALID PLAGIARISM PERCENTAGE
-- Allowed Range:
-- 0 to 100
-- =========================================================

SELECT *
FROM plagiarism_flags
WHERE similarity_percentage < 0
   OR similarity_percentage > 100;

-- Why it matters:
-- Similarity percentages outside valid range are impossible.



-- =========================================================
-- 20. INVALID TEST EXECUTION TIME
-- Negative execution duration
-- =========================================================

SELECT *
FROM test_results
WHERE execution_time_ms < 0;

-- Why it matters:
-- Execution time cannot be negative.



-- =========================================================
-- 21. STUDENTS WITH FUTURE ADMISSION DATES
-- =========================================================

SELECT *
FROM students
WHERE admission_date > CURRENT_DATE;

-- Why it matters:
-- Future admission dates may indicate import mistakes.



-- =========================================================
-- 22. BLANK PROGRAMMING LANGUAGE VALUES
-- =========================================================

SELECT *
FROM submissions
WHERE language IS NULL
   OR TRIM(language) = '';

-- Why it matters:
-- Every submission must specify a programming language.



-- =========================================================
-- 23. INVALID SCORE WITH ACCEPTED STATUS
-- Example Rule:
-- Accepted solutions should score at least 50
-- =========================================================

SELECT *
FROM submissions
WHERE status = 'Accepted'
  AND score < 50;

-- Why it matters:
-- Accepted solutions usually imply successful evaluation.



-- =========================================================
-- 24. DUPLICATE EMAILS
-- Additional consistency rule
-- =========================================================

SELECT
    email,
    COUNT(*) AS duplicate_count
FROM students
GROUP BY email
HAVING COUNT(*) > 1;

-- Why it matters:
-- Duplicate emails may create user-account conflicts.



-- =========================================================
-- 25. INVALID BATCH YEAR
-- Example Rule:
-- Batch year should be reasonable
-- =========================================================

SELECT *
FROM batches
WHERE batch_year < 2015
   OR batch_year > 2035;

-- Why it matters:
-- Invalid academic years indicate corrupted data.