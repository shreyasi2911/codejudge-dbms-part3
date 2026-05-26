-- =========================================================
-- TASK 2: PRIMARY KEY & UNIQUENESS AUDIT
-- =========================================================

-- ---------------------------------------------------------
-- 1. Duplicate Primary Key Values
-- ---------------------------------------------------------

SELECT 
    student_id,
    COUNT(*) AS duplicate_count
FROM students
GROUP BY student_id
HAVING COUNT(*) > 1;

-- Why it matters:
-- Duplicate primary keys break entity integrity and make records ambiguous.


-- ---------------------------------------------------------
-- 2. Duplicate Candidate Key Values
-- Purpose:
-- Detect duplicate usernames if usernames are expected unique.
-- ---------------------------------------------------------

SELECT 
    username,
    COUNT(*) AS duplicate_count
FROM students
GROUP BY username
HAVING COUNT(*) > 1;

-- Status:
-- PASS if no duplicate usernames exist.

-- Why it matters:
-- Candidate keys should uniquely identify records even if not primary keys.



-- ---------------------------------------------------------
-- 3. Duplicate Email Values
-- ---------------------------------------------------------

SELECT 
    email,
    COUNT(*) AS duplicate_count
FROM students
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

-- Why it matters:
-- Duplicate emails can create login/authentication conflicts.



-- ---------------------------------------------------------
-- 4. Duplicate Enrollment Records
-- Purpose:
-- Detect same student enrolled multiple times
-- in the same course.
-- ---------------------------------------------------------

SELECT
    student_id,
    course_id,
    COUNT(*) AS duplicate_count
FROM enrollments
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;

-- Why it matters:
-- Duplicate enrollments inflate analytics and attendance counts.



-- ---------------------------------------------------------
-- 5. Duplicate Contest-Problem Records
-- ---------------------------------------------------------

SELECT
    contest_id,
    problem_id,
    COUNT(*) AS duplicate_count
FROM contest_problems
GROUP BY contest_id, problem_id
HAVING COUNT(*) > 1;

-- Why it matters:
-- Same problem should not appear repeatedly in one contest.



-- ---------------------------------------------------------
-- 6. Duplicate Test Case Records
-- ---------------------------------------------------------

SELECT
    problem_id,
    input_data,
    expected_output,
    COUNT(*) AS duplicate_count
FROM test_cases
GROUP BY problem_id, input_data, expected_output
HAVING COUNT(*) > 1;

-- Why it matters:
-- Duplicate test cases waste execution resources.



-- ---------------------------------------------------------
-- 7. Duplicate Test Result Records
-- ---------------------------------------------------------

SELECT
    submission_id,
    testcase_id,
    COUNT(*) AS duplicate_count
FROM test_results
GROUP BY submission_id, testcase_id
HAVING COUNT(*) > 1;

-- Why it matters:
-- One submission should generate only one result per test case.



-- ---------------------------------------------------------
-- 8. Duplicate Attendance Records
-- ---------------------------------------------------------

SELECT
    student_id,
    session_id,
    COUNT(*) AS duplicate_count
FROM attendance
GROUP BY student_id, session_id
HAVING COUNT(*) > 1;

-- Why it matters:
-- Duplicate attendance records produce incorrect participation reports.



-- =========================================================
-- TASK 3: FOREIGN KEY & RELATIONSHIP AUDIT
-- =========================================================

-- ---------------------------------------------------------
-- 1. Students Linked to Missing Batches
-- ---------------------------------------------------------

SELECT s.*
FROM students s
LEFT JOIN batches b
    ON s.batch_id = b.batch_id
WHERE b.batch_id IS NULL;

-- Why it matters:
-- Students assigned to missing batches create orphan academic records.



-- ---------------------------------------------------------
-- 2. Enrollments Linked to Missing Students
-- ---------------------------------------------------------

SELECT e.*
FROM enrollments e
LEFT JOIN students s
    ON e.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Why it matters:
-- Enrollment without valid student reference is meaningless.



-- ---------------------------------------------------------
-- 3. Enrollments Linked to Missing Courses
-- ---------------------------------------------------------

SELECT e.*
FROM enrollments e
LEFT JOIN courses c
    ON e.course_id = c.course_id
WHERE c.course_id IS NULL;

-- Why it matters:
-- Students cannot enroll in nonexistent courses.



-- ---------------------------------------------------------
-- 4. Problems Linked to Missing Courses
-- ---------------------------------------------------------

SELECT p.*
FROM problems p
LEFT JOIN courses c
    ON p.course_id = c.course_id
WHERE c.course_id IS NULL;

-- Why it matters:
-- Problems should belong to valid courses.



-- ---------------------------------------------------------
-- 5. Test Cases Linked to Missing Problems
-- ---------------------------------------------------------

SELECT tc.*
FROM test_cases tc
LEFT JOIN problems p
    ON tc.problem_id = p.problem_id
WHERE p.problem_id IS NULL;

-- Why it matters:
-- Test cases without valid problems cannot be executed properly.



-- ---------------------------------------------------------
-- 6. Contests Linked to Missing Courses
-- ---------------------------------------------------------

SELECT ct.*
FROM contests ct
LEFT JOIN courses c
    ON ct.course_id = c.course_id
WHERE c.course_id IS NULL;

-- Why it matters:
-- Contests should belong to valid courses.



-- ---------------------------------------------------------
-- 7. Contest-Problem Mappings Linked to Missing Contests
-- ---------------------------------------------------------

SELECT cp.*
FROM contest_problems cp
LEFT JOIN contests c
    ON cp.contest_id = c.contest_id
WHERE c.contest_id IS NULL;

-- Why it matters:
-- Contest mappings become unusable if contest is missing.



-- ---------------------------------------------------------
-- 8. Contest-Problem Mappings Linked to Missing Problems
-- ---------------------------------------------------------

SELECT cp.*
FROM contest_problems cp
LEFT JOIN problems p
    ON cp.problem_id = p.problem_id
WHERE p.problem_id IS NULL;

-- Why it matters:
-- Invalid problem references break contest question lists.



-- ---------------------------------------------------------
-- 9. Submissions Linked to Missing Students
-- ---------------------------------------------------------

SELECT s.*
FROM submissions s
LEFT JOIN students st
    ON s.student_id = st.student_id
WHERE st.student_id IS NULL;

-- Why it matters:
-- Every submission must belong to a valid student.



-- ---------------------------------------------------------
-- 10. Submissions Linked to Missing Problems
-- ---------------------------------------------------------

SELECT s.*
FROM submissions s
LEFT JOIN problems p
    ON s.problem_id = p.problem_id
WHERE p.problem_id IS NULL;

-- Why it matters:
-- Submission evaluation depends on a valid problem.



-- ---------------------------------------------------------
-- 11. Submissions Linked to Missing Contests
-- ---------------------------------------------------------

SELECT s.*
FROM submissions s
LEFT JOIN contests c
    ON s.contest_id = c.contest_id
WHERE s.contest_id IS NOT NULL
  AND c.contest_id IS NULL;

-- Why it matters:
-- Contest submissions require valid contest references.



-- ---------------------------------------------------------
-- 12. Test Results Linked to Missing Submissions
-- ---------------------------------------------------------

SELECT tr.*
FROM test_results tr
LEFT JOIN submissions s
    ON tr.submission_id = s.submission_id
WHERE s.submission_id IS NULL;

-- Why it matters:
-- Test results cannot exist without submissions.



-- ---------------------------------------------------------
-- 13. Test Results Linked to Missing Test Cases
-- ---------------------------------------------------------

SELECT tr.*
FROM test_results tr
LEFT JOIN test_cases tc
    ON tr.testcase_id = tc.testcase_id
WHERE tc.testcase_id IS NULL;

-- Why it matters:
-- Result records require valid test case references.



-- ---------------------------------------------------------
-- 14. Sessions Linked to Missing Courses
-- ---------------------------------------------------------

SELECT se.*
FROM sessions se
LEFT JOIN courses c
    ON se.course_id = c.course_id
WHERE c.course_id IS NULL;

-- Why it matters:
-- Sessions must belong to valid courses.



-- ---------------------------------------------------------
-- 15. Attendance Linked to Missing Sessions
-- ---------------------------------------------------------

SELECT a.*
FROM attendance a
LEFT JOIN sessions s
    ON a.session_id = s.session_id
WHERE s.session_id IS NULL;

-- Why it matters:
-- Attendance cannot exist without valid sessions.



-- ---------------------------------------------------------
-- 16. Attendance Linked to Missing Students
-- ---------------------------------------------------------

SELECT a.*
FROM attendance a
LEFT JOIN students s
    ON a.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Why it matters:
-- Attendance records must reference valid students.



-- ---------------------------------------------------------
-- 17. Regrade Requests Linked to Missing Submissions
-- ---------------------------------------------------------

SELECT r.*
FROM regrade_requests r
LEFT JOIN submissions s
    ON r.submission_id = s.submission_id
WHERE s.submission_id IS NULL;

-- Why it matters:
-- Regrade requests require valid submissions.



-- ---------------------------------------------------------
-- 18. Regrade Requests Linked to Missing Students
-- ---------------------------------------------------------

SELECT r.*
FROM regrade_requests r
LEFT JOIN students s
    ON r.student_id = s.student_id
WHERE s.student_id IS NULL;

-- Why it matters:
-- Every regrade request must belong to a valid student.



-- ---------------------------------------------------------
-- 19. Plagiarism Flags Linked to Missing Submissions
-- ---------------------------------------------------------

SELECT pf.*
FROM plagiarism_flags pf
LEFT JOIN submissions s
    ON pf.submission_id = s.submission_id
WHERE s.submission_id IS NULL;

-- Why it matters:
-- Plagiarism reports must reference valid submissions.