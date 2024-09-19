CREATE SCHEMA IF NOT EXISTS assignment01;
USE assignment01;

CREATE TABLE Students (
                          student_id INT PRIMARY KEY AUTO_INCREMENT,
                          first_name VARCHAR(50),
                          last_name VARCHAR(50),
                          gender CHAR(1),
                          date_of_birth DATE
);

CREATE TABLE Teachers (
                          teacher_id INT PRIMARY KEY AUTO_INCREMENT,
                          first_name VARCHAR(50),
                          last_name VARCHAR(50),
                          subject VARCHAR(50)
);

CREATE TABLE Subjects (
                          subject_id INT PRIMARY KEY AUTO_INCREMENT,
                          subject_name VARCHAR(50),
                          teacher_id INT,
                          FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);

CREATE TABLE Enrollments (
                             enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
                             student_id INT,
                             subject_id INT,
                             status BOOLEAN,
                             enrollment_date DATE,
                             FOREIGN KEY (student_id) REFERENCES Students(student_id),
                             FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

CREATE TABLE Schedule (
                          schedule_id INT PRIMARY KEY AUTO_INCREMENT,
                          subject_id INT,
                          day_of_week VARCHAR(10),
                          start_time TIME,
                          end_time TIME,
                          FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
);

-- changing something

ALTER TABLE teachers DROP COLUMN subject;
ALTER TABLE teachers ADD COLUMN subject_id INT;
ALTER TABLE teachers ADD FOREIGN KEY (subject_id) REFERENCES subjects(subject_id);

-- DELETE rows
DELETE FROM teachers WHERE first_name IS NULL;

-- |-11 + teacher_id| to aboid negative values
UPDATE teachers SET subject_id = teacher_id
WHERE TRUE;
    