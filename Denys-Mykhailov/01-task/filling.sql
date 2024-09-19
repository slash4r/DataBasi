USE assignment01;


INSERT INTO Students (first_name, last_name, gender, date_of_birth) VALUES
    ('John', 'Doe', 'M', '2005-06-15'),
    ('Jane', 'Smith', 'F', '2006-08-22'),
    ('Michael', 'Brown', 'M', '2005-12-02'),
    ('Emily', 'Davis', 'F', '2006-03-18'),
    ('Daniel', 'Wilson', 'M', '2005-11-30'),
    ('Sophia', 'Taylor', 'F', '2006-01-25'),
    ('James', 'Anderson', 'M', '2005-07-14'),
    ('Olivia', 'Thomas', 'F', '2006-09-05'),
    ('William', 'Jackson', 'M', '2005-10-20'),
    ('Ava', 'White', 'F', '2006-04-12');



INSERT INTO Teachers (first_name, last_name, subject) VALUES
    ('Alice', 'Johnson', 'Mathematics'),
    ('Robert', 'Miller', 'Science'),
    ('Laura', 'Garcia', 'History'),
    ('James', 'Martinez', 'English'),
    ('Patricia', 'Hernandez', 'Physical Education'),
    ('David', 'Lopez', 'Art'),
    ('Linda', 'Gonzalez', 'Music'),
    ('Barbara', 'Wilson', 'Geography'),
    ('Richard', 'Clark', 'Biology'),
    ('Susan', 'Lewis', 'Chemistry');


INSERT INTO Subjects (subject_name, teacher_id) VALUES
    ('Math 101', 1),
    ('Science 101', 2),
    ('History 101', 3),
    ('English 101', 4),
    ('PE 101', 5),
    ('Art 101', 6),
    ('Music 101', 7),
    ('Geography 101', 8),
    ('Biology 101', 9),
    ('Chemistry 101', 10);


INSERT INTO Enrollments (student_id, subject_id, status, enrollment_date) VALUES
    (1, 1, TRUE, '2023-09-01'),
    (2, 2, TRUE, '2023-09-01'),
    (3, 3, FALSE, '2023-09-01'),
    (4, 4, TRUE, '2023-09-01'),
    (5, 5, TRUE, '2023-09-01'),
    (6, 6, TRUE, '2023-09-01'),
    (7, 7, FALSE, '2023-09-01'),
    (8, 8, TRUE, '2023-09-01'),
    (9, 9, TRUE, '2023-09-01'),
    (10, 10, FALSE, '2023-09-01'),
    (1, 2, TRUE, '2023-09-01'),
    (2, 3, TRUE, '2023-09-01'),
    (3, 4, FALSE, '2023-09-01'),
    (4, 5, TRUE, '2023-09-01'),
    (5, 6, TRUE, '2023-09-01');


INSERT INTO Schedule (subject_id, day_of_week, start_time, end_time) VALUES
    (1, 'Monday', '09:00:00', '10:30:00'),
    (2, 'Tuesday', '10:45:00', '12:15:00'),
    (3, 'Wednesday', '13:00:00', '14:30:00'),
    (4, 'Thursday', '09:00:00', '10:30:00'),
    (5, 'Friday', '11:00:00', '12:30:00'),
    (6, 'Monday', '14:00:00', '15:30:00'),
    (7, 'Tuesday', '09:00:00', '10:30:00'),
    (8, 'Wednesday', '10:45:00', '12:15:00'),
    (9, 'Thursday', '13:00:00', '14:30:00'),
    (10, 'Friday', '09:00:00', '10:30:00');