# Before and After Repair Evidence

This document contains before-and-after evidence for repair operations performed on staging tables.

All corrections were applied safely without modifying the original imported database tables.

---

# Example 1 — Invalid Email Format

## Problem

Student email was missing the '@' symbol.

### Record ID

- student_id = S0018

---

## Before Repair

| student_id | full_name | email |
|------------|------------|-------------------|
|S0018 | Anika Patel | ravi.no-at-symbol.codejudge.edu |

---

## Repair Action

```sql
UPDATE students_staging
SET email = 'ravi@code.judge.edu'
WHERE student_id = S0018;
```

---

## After Repair

| student_id | full_name | email |
|------------|------------|-------------------|
| S0018	| Anika Patel |	ravi@codejudge.edu

---

## Validation

The email format is now valid and follows standard email formatting rules.

---

# Example 2 — Duplicate Enrollment Record

## Problem

Student was enrolled multiple times in the same course.

### Record Details

- student_id = S0001
- course_id =  C006

---

## Before Repair

| enrollment_id | student_id | course_id |
|---------------|------------|-----------|
| E00001 | S0001 | C006 |
| E00717 | S0001 |C006 |

---

## Repair Action

```sql
DELETE FROM enrollments_staging
WHERE enrollment_id = E00001;
```

---

## After Repair

| enrollment_id | student_id | course_id |
|---------------|------------|-----------|
| E00717 | S0001 | C006 |

---

## Validation

Only one enrollment record remains for the same student-course combination.

---

# Example 3 — Invalid Difficulty Value

## Problem

Problem difficulty used a non-standard value.

### Record ID

- problem_id =  P0010

---

## Before Repair

| problem_id | title | difficulty_level |
|------------|------------------|----------------|
| P0010 | Knapsack 10 | Very Hard |

---

## Repair Action

```sql
UPDATE problems_staging
SET difficulty_level = 'Medium'
WHERE problem_id = P0010;
```

---

## After Repair

| problem_id | title | difficulty_level |
|------------|------------------|----------------|
|P0010 | KnapSnack | Medium |

---

## Validation

Difficulty value now belongs to the allowed domain values:

- Easy
- Medium
- Hard

---

# Example 4 — Invalid Programming Language

## Problem

Submission used abbreviated language name.

### Record ID

- submission_id = SUB000001

---

## Before Repair

| submission_id | language |
|---------------|----------|
| SUB000001 | C |

---

## Repair Action

```sql
UPDATE submissions_staging
SET language = 'C++'
WHERE submission_id = SUB000001;
```

---

## After Repair

| submission_id | language |
|---------------|----------|
| SUB000001 | C++ |

---

## Validation

Programming language now matches standardized system values.

---

# Example 5 — Invalid Attendance Status

## Problem

Attendance record used an invalid status value.

### Record ID

- attendance_id = A000046

---

## Before Repair

| attendance_id | attendance_status |
|---------------|-------------------|
| A000046 | joined |

---

## Repair Action

```sql
UPDATE attendance_staging
SET attendance_status = 'Present'
WHERE attendance_id = A000046;
```

---

## After Repair

| attendance_id | attendance_status |
|---------------|-------------------|
| A000046 | Present |

---

## Validation

Attendance status now belongs to the valid set:

- Present
- Absent
- Late

---

# Summary of Repairs

| Example | Issue Type | Repair Method |
|----------|------------|---------------|
| 1 | Invalid Email | Corrected |
| 2 | Duplicate Enrollment | Duplicate Deleted |
| 3 | Invalid Difficulty | Standardized |
| 4 | Invalid Language | Standardized |
| 5 | Invalid Attendance Status | Corrected |

---

# Final Verification

After repairs:

- invalid values were corrected
- duplicate records were removed
- standardized domain values were enforced
- consistency improved across tables
- original imported data remained unchanged

All operations were executed safely on staging tables only.
