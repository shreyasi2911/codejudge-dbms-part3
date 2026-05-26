# Data Integrity Audit, Debugging & Repair Plan — Part 3

## Overview

This repository contains the implementation for **Part 3 — Data Integrity Audit, Debugging & Repair Plan** of the Database Management System project.

The purpose of this part is to audit the imported database for:

- data consistency
- relational correctness
- domain validation
- duplicate detection
- foreign key integrity
- invalid or suspicious records

The project also demonstrates how database engineers safely repair corrupted or inconsistent data using staging tables instead of directly modifying production tables.

---

# Repository Structure

| File Name | Description |
|------------|-------------|
| `README.md` | Project overview and execution guide |
| `import_validation.sql` | Row count and import validation queries |
| `integrity_audit.sql` | Primary key, uniqueness, and foreign key audits |
| `domain_rule_checks.sql` | Domain and business rule validation queries |
| `repair_plan.md` | Repair strategy and dataset-specific correction plan |
| `staging_repair_scripts.sql` | Safe repair scripts using staging tables |
| `before_after_evidence.md` | Before-and-after repair evidence and validation |

---

# Objectives

This project focuses on:

- validating imported database contents
- identifying duplicate or inconsistent data
- detecting broken relationships
- verifying business rules
- planning safe repair strategies
- demonstrating controlled repair operations

---

# Audit Categories

## 1. Import Validation

Checks performed:

- row count verification
- distinct primary key validation
- NULL and blank value checks
- empty table detection
- imported row comparison with source CSV data

---

## 2. Primary Key & Uniqueness Audit

Checks performed:

- duplicate primary keys
- duplicate candidate keys
- duplicate emails
- duplicate enrollment records
- duplicate contest-problem mappings
- duplicate attendance records
- duplicate test-case results

---

## 3. Foreign Key & Relationship Audit

Relationship checks include:

- missing student references
- missing course references
- invalid contest mappings
- orphan submissions
- orphan attendance records
- orphan plagiarism flags
- invalid regrade references
- missing session references

---

## 4. Domain & Business Rule Validation

Validation checks include:

- negative scores
- impossible marks
- invalid status values
- invalid difficulty levels
- invalid programming languages
- invalid attendance states
- invalid timestamps
- incorrect chronological order
- NULL values in mandatory fields

---

## 5. Repair Planning

The repair plan explains how issues are handled safely using:

- corrections
- deletions
- staging/rejected tables
- manual verification
- controlled exceptions

The plan includes dataset-specific examples using actual IDs.

---

## 6. Safe Staging Repairs

Repairs are performed only on staging copies of tables.

Each repair script contains:

- BEFORE query
- UPDATE / DELETE / INSERT operation
- AFTER query
- explanation of repair decision

This prevents accidental corruption of original imported data.

---

# Tables Used

The database contains the following main tables:

- `students`
- `batches`
- `courses`
- `enrollments`
- `problems`
- `contests`
- `contest_problems`
- `submissions`
- `test_cases`
- `test_results`
- `sessions`
- `attendance`
- `regrade_requests`
- `plagiarism_flags`

---

# SQL Concepts Demonstrated

This project demonstrates practical usage of:

- `COUNT()`
- `DISTINCT`
- `GROUP BY`
- `HAVING`
- `LEFT JOIN`
- `NOT EXISTS`
- subqueries
- aggregate validation
- domain validation
- staging table repair workflow

---

# Repair Philosophy

The project follows safe database engineering principles:

- Never modify imported production tables directly
- Use staging copies for repair operations
- Preserve evidence before repair
- Validate corrections after repair
- Avoid deleting data without justification

---

# How to Execute

## Step 1 — Import Database

Import the provided schema and dataset into your SQL environment.

Supported systems:

- MySQL
- PostgreSQL
- SQLite

---

## Step 2 — Run Validation Scripts

Execute:

```sql
SOURCE import_validation.sql;
SOURCE integrity_audit.sql;
SOURCE domain_rule_checks.sql;
```
