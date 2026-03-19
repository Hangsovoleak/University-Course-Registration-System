# University Course Registration System
# Documents:
#       Course offering list/section list,
#       Enrollment confirmation,
#       Class timetable,
#       Grade sheet/transcript
# Business rules:
#       One course can have many sections,
#       A student can enroll in many sections,
#       Enrollment can be dropped/withdrawn
# Required outputs:
#       Students in a section,
#       Student weekly timetable,
#       Transcript/grades report

use UniSystem;

create table Student (
    student_id int auto_increment primary key,
    name varchar(100) not null,
    email varchar(100) unique,
    major varchar(50),
    year int,
    gpa decimal(3, 2) default 0.00
);

create table Instructor (
    instructor_id int auto_increment primary key,
    name varchar(100) not null,
    email varchar(100) unique,
    department varchar(100)
);

create table Course (
    course_id int auto_increment primary key,
    course_name varchar(100) not null,
    credits int not null
);

create table Prerequisite (
    course_id int not null,
    prereq_course_id int not null,
    primary key (course_id, prereq_course_id),
    foreign key (course_id) references Course(course_id) on delete cascade,
    foreign key (prereq_course_id) references Course(course_id) on delete cascade
);

create table Section (
    section_id int auto_increment primary key,
    course_id int not null,
    instructor_id int null,
    semester varchar(50),
    year int,
    capacity int not null,
    foreign key (course_id) references Course(course_id) on delete cascade,
    foreign key (instructor_id) references Instructor(instructor_id) on delete set null
);

create table Schedule (
    schedule_id int auto_increment primary key,
    section_id int not null,
    day_of_week ENUM('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'),
    start_time time,
    end_time time,
    room varchar(50),
    foreign key (section_id) references Section(section_id) on delete cascade,
    check ( start_time < end_time )
);

create table Enrollment (
    enrollment_id int auto_increment primary key,
    student_id int not null,
    section_id int not null,
    status enum('ENROLLED', 'WAITLIST', 'DROPPED', 'WITHDRAWN') default 'ENROLLED',
    grade ENUM('A', 'B', 'C', 'D', 'F', 'I'),
    enrolled_at timestamp default current_timestamp,
    foreign key (student_id) references Student(student_id) on delete cascade,
    foreign key (section_id) references Section(section_id) on delete cascade,
    unique (student_id, section_id)
);

create index idx_enrollment_student on Enrollment(student_id);
create index idx_enrollment_section on Enrollment(section_id);

create view StudentGPA as
select e.student_id,
       SUM(c.credits * case e.grade
            when 'A' then 4.0 when 'B' then 3.0
            when 'C' then 2.0 when 'D' then 1.0
            else 0.0
       end) / sum(c.credits) as gpa
from Enrollment e
join Section s on e.section_id = s.section_id
join Course c on s.course_id = c.course_id
where e.grade IS not null and e.status = 'ENROLLED'
group by e.student_id;

show tables ;

INSERT INTO Student (name, email, major, year) VALUES
('Rith Sopheak', 'rith.sopheak@example.com', 'Computer Science', 2),
('Sok Dara', 'sok.dara@example.com', 'Information Systems', 3),
('Chhoeun Vichea', 'chhoeun.vichea@example.com', 'Software Engineering', 1),
('Ly Pisey', 'ly.pisey@example.com', 'Computer Science', 4);

INSERT INTO Instructor (name, email, department) VALUES
('Dr. Kim Sovann', 'kim.sovann@unisystem.edu', 'Computer Science'),
('Prof. Chea Sreymom', 'chea.sreymom@unisystem.edu', 'Information Systems');

INSERT INTO Course (course_name, credits) VALUES
('Introduction to Programming', 3),
('Data Structures', 4),
('Databases', 3),
('Operating Systems', 3);

INSERT INTO Prerequisite (course_id, prereq_course_id) VALUES
(2, 1),  -- Data Structures requires Intro to Programming
(3, 1),  -- Databases requires Intro to Programming
(4, 2);  -- Operating Systems requires Data Structures

INSERT INTO Section (course_id, instructor_id, semester, year, capacity) VALUES
(1, 1, 'Spring', 2026, 30),
(2, 1, 'Spring', 2026, 25),
(3, 2, 'Spring', 2026, 20),
(4, 2, 'Spring', 2026, 15);

INSERT INTO Schedule (section_id, day_of_week, start_time, end_time, room) VALUES
(1, 'Mon', '09:00:00', '10:30:00', 'Room 101'),
(1, 'Wed', '09:00:00', '10:30:00', 'Room 101'),
(2, 'Tue', '10:00:00', '11:30:00', 'Room 102'),
(2, 'Thu', '10:00:00', '11:30:00', 'Room 102'),
(3, 'Mon', '11:00:00', '12:30:00', 'Room 103'),
(3, 'Wed', '11:00:00', '12:30:00', 'Room 103'),
(4, 'Tue', '13:00:00', '14:30:00', 'Room 104'),
(4, 'Thu', '13:00:00', '14:30:00', 'Room 104');

INSERT INTO Enrollment (student_id, section_id, status, grade) VALUES
(1, 1, 'ENROLLED', 'A'),    -- Rith Sopheak in Intro to Programming
(1, 2, 'ENROLLED', 'B'),    -- Rith Sopheak in Data Structures
(2, 1, 'ENROLLED', 'B'),    -- Sok Dara in Intro to Programming
(2, 3, 'ENROLLED', 'A'),    -- Sok Dara in Databases
(3, 1, 'ENROLLED', NULL),   -- Chhoeun Vichea in Intro to Programming, grade pending
(4, 4, 'WAITLIST', NULL);   -- Ly Pisey trying to enroll in OS but waitlisted

select * from Enrollment;
select * from Prerequisite;
select * from Instructor;
select * from Schedule;
select * from Student;
select * from Section;
select * from Course;