#  University Course Registration System (Database Project)

##  Overview

This project is a **Relational Database System** designed to manage university course registration. It allows students to enroll in course sections while enforcing academic rules such as prerequisites, seat capacity, and schedule conflicts.

The system also supports grade management and transcript generation.

---

##  Objectives

* Design a normalized relational database (up to 3NF)
* Implement real-world academic rules using constraints
* Support student enrollment and academic record tracking
* Provide useful outputs such as timetable and transcript

---

##  Database Structure

### Main Tables

* **Student** – stores student information and GPA
* **Instructor** – stores instructor details
* **Course** – defines courses and credits
* **Section** – course offerings per semester
* **Schedule** – class time and room information
* **Enrollment** – links students and sections (core table)
* **Prerequisite** – defines course dependencies

---

##  Relationships

* One **Course** → Many **Sections**
* One **Student** → Many **Enrollments**
* Many-to-Many:

  * Student ↔ Section (via Enrollment)
* Course ↔ Course (via Prerequisite)

---

##  Business Rules

* A course can have multiple sections
* A student can enroll in multiple sections
* Enrollment can be:

  * ENROLLED
  * WAITLIST
  * DROPPED
  * WITHDRAWN
* Prerequisites must be satisfied before enrollment
* Section capacity must not be exceeded
* Schedule conflicts are not allowed

---

##  Features

###  Enrollment Management

* Students can register for course sections
* System tracks enrollment status

###  Academic Validation

* Prerequisite relationships stored in database
* Capacity and schedule logic supported via queries

###  Grade Management

* Instructors assign grades
* Grades stored in Enrollment table

###  GPA Calculation

* GPA calculated using a database **VIEW (StudentGPA)**

---

##  Required Outputs

### 1. Students in a Section

Displays all students enrolled in a specific section.

### 2. Student Weekly Timetable

Shows class schedule grouped by day and time.

### 3. Transcript / Grade Report

Lists all completed courses with grades and credits.

---

##  Sample Query Examples

### Students in a Section

```sql
SELECT s.name, e.status, e.grade
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
WHERE e.section_id = ?;
```

### Student Timetable

```sql
SELECT sch.day_of_week, sch.start_time, sch.end_time, c.course_name
FROM Enrollment e
JOIN Section sec ON e.section_id = sec.section_id
JOIN Course c ON sec.course_id = c.course_id
JOIN Schedule sch ON sec.section_id = sch.section_id
WHERE e.student_id = ?;
```

### GPA View

```sql
SELECT * FROM StudentGPA;
```

---

##  How to Run

1. Create database:

```sql
CREATE DATABASE UniSystem;
USE UniSystem;
```

2. Run the SQL script:

* Create tables
* Insert sample data
* Create indexes and views

3. Execute queries to test:

* Enrollment
* Timetable
* Transcript

---

##  Design Highlights

* Fully normalized schema (3NF)
* Strong use of **foreign keys** and **constraints**
* Uses **ENUM** for controlled values
* Implements **composite primary key** for prerequisites
* Includes **view for GPA calculation**

---

## 📌 Technologies

* MySQL
* SQL (DDL, DML, Views)

---

##  Author

* Student Name: Rorn Hangsovoleak
* Department: ITE (Rupp)
* Course: Database(MySQL)

---

##  Notes

This project focuses on **database design and logic**, not user interface. All operations are performed using SQL queries.

---
