USE assignment01;

-- count how many students are enrolled in each subject
SELECT s.subject_name,
       COUNT(e.student_id) AS enrolled_students
FROM Subjects s
         LEFT JOIN Enrollments e ON s.subject_id = e.subject_id
GROUP BY subject_name
ORDER BY enrolled_students DESC;
--


-- create CTE and add info about teachers
WITH num_of_enrled AS (
    SELECT s.subject_name,
           COUNT(e.student_id) AS enrolled_students
    FROM Subjects s
             LEFT JOIN Enrollments e ON s.subject_id = e.subject_id
    GROUP BY subject_name
)
SELECT n.subject_name,
       n.enrolled_students,
       t.first_name,
       t.last_name
FROM num_of_enrled n
         LEFT JOIN subjects s on n.subject_name = s.subject_name
         LEFT JOIN teachers t ON s.subject_id = t.subject_id
ORDER BY enrolled_students DESC;
--


-- find out most active students
WITH num_of_student_enrlment AS (
    SELECT
        student_id,
        COUNT(subject_id) AS subject_count
    FROM
        Enrollments
    GROUP BY
        student_id
)
SELECT
    s.first_name,
    s.last_name,
    se.subject_count
FROM
    Students s
        JOIN
    num_of_student_enrlment se ON s.student_id = se.student_id
WHERE
    se.subject_count > 1;
--


-- find out students enrolled in Math 101 and Science 101 (using UNION)
WITH enrlments AS (SELECT
    s.first_name,
    s.last_name,
    sub.subject_name
FROM
    Students s
        JOIN
    Enrollments e ON s.student_id = e.student_id
        JOIN
    Subjects sub ON e.subject_id = sub.subject_id
)

SELECT *
FROM enrlments
WHERE subject_name = 'Math 101'

UNION ALL

SELECT *
FROM enrlments
WHERE subject_name = 'Science 101'
ORDER BY
    last_name;
--


-- create a schedule for certain student
CREATE PROCEDURE get_student_schedule(student_last_name VARCHAR(50))
BEGIN
    SELECT
        s.first_name,
        s.last_name,
        sub.subject_name,
        sc.day_of_week,
        sc.start_time,
        sc.end_time
    FROM students s
             LEFT JOIN enrollments e ON s.student_id = e.student_id
             LEFT JOIN subjects sub ON e.subject_id = sub.subject_id
             LEFT JOIN schedule sc ON sub.subject_id = sc.subject_id
    WHERE IF(student_last_name IS NOT NULL AND student_last_name != '', 
             s.last_name = student_last_name, 
             TRUE);
END;

CALL get_student_schedule(NULL);
CALL get_student_schedule('');
CALL get_student_schedule('Wilson');
-- end of task01.sql