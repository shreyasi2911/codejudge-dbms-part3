# Repair Plan

## Overview

This document explains how detected integrity and domain issues will be repaired safely.

Repairs will NOT be applied directly to original imported tables.

Instead:

- staging tables will be created
- corrections will be tested safely
- before/after evidence will be preserved

---

# Repair Strategy by Issue Type

| Issue Type | Repair Action |
|------------|---------------|
| Invalid emails | Correct if recoverable |
| Duplicate records | Remove duplicate copy |
| Missing foreign keys | Move to rejected table |
| Invalid statuses | Standardize values |
| Negative scores | Manual verification |
| Impossible timestamps | Correct if obvious |
| NULL mandatory values | Manual verification |
| Orphan records | Delete or quarantine |

---

# Dataset-Specific Examples

## Example 1 — Invalid Email

Student ID: S0018  
Issue: ravi.no-at-symbol.codejudge.edu

Repair:
Update to `ravi@code.judge.edu`

Reason:
Clearly missing '@' symbol.

---

## Example 2 — Duplicate Enrollment

Student ID: S0001  
Course ID: C006

Repair:
Delete duplicate enrollment row.

Reason:
Student should only enroll once per course.

---

## Example 3 — Negative Score

Submission ID: S0148  
Score: -10

Repair:
Move to manual verification.

Reason:
Cannot safely infer correct score.

---

## Example 4 — Invalid Difficulty

Problem ID: P0010 
Difficulty: Very Hard

Repair:
Convert to `Medium`.

Reason:
Equivalent allowed category.

---

## Example 5 — Missing Student Reference

Enrollment ID: 7005

Repair:
Move to rejected staging table.

Reason:
Referenced student does not exist.

---

## Example 6 — Invalid Language

Submission ID: SUB000001  
Language: C

Repair:
Convert to `C++`.

Reason:
Standardization issue.

---

## Example 7 — Invalid Attendance Status

Attendance ID: A000046  
Status: `joined`

Repair:
Convert to `Present`.

Reason:
Equivalent semantic meaning.

---

## Example 8 — Contest End Before Start

Contest ID: CT005

Repair:
Manual verification.

Reason:
Correct timestamp cannot be inferred safely.

---

# Repair Principles

The following principles are followed:

- preserve original data
- avoid destructive updates
- document every change
- verify repairs after execution
- quarantine suspicious records

---

# Staging Table Policy

All repairs occur on tables named:

- `students_staging`
- `submissions_staging`
- `attendance_staging`
- etc.

This allows rollback and auditing.
