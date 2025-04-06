-- GradePoints table
CREATE TABLE GradePoints (
  grade VARCHAR(5) PRIMARY KEY,
  gpoints NUMERIC
);

-- Sample GradePoints data
INSERT INTO GradePoints VALUES
('O', 10), ('A+', 9), ('A', 8), ('B+', 7), ('B', 6), ('RA', 0);

-- Emp table
CREATE TABLE students (
  regno VARCHAR(20),
  ayear INT,
  asem INT,
  pys VARCHAR(10),
  coursecode VARCHAR(10),
  coursename VARCHAR(100),
  credits INT,
  grade VARCHAR(5)
);



INSERT INTO students VALUES
('21CSE001', 2023, 1, 'I-I', 'CS101', 'Maths', 4, 'O'),
('21CSE001', 2023, 1, 'I-I', 'CS102', 'Physics', 3, 'A+'),
('21CSE001', 2023, 1, 'I-I', 'CS103', 'Chemistry', 3, 'RA'),

('21CSE002', 2023, 1, 'I-I', 'CS101', 'Maths', 2, 'B+'),
('21CSE002', 2023, 1, 'I-I', 'CS102', 'Physics', 3, 'B'),
('21CSE002', 2023, 1, 'I-I', 'CS103', 'Chemistry', 3, 'RA');


-- Final Query: Students with GPA ≥ 8.0 and at least one backlog, grouped by department

SELECT 
  s.regno,
  ROUND(SUM(g.gpoints * s.credits) * 1.0 / SUM(s.credits), 2) AS GPA,
  COUNT(*) FILTER (WHERE s.grade = 'RA') AS backlog_courses
FROM students s
JOIN GradePoints g ON s.grade = g.grade
GROUP BY s.regno
HAVING 
  ROUND(SUM(g.gpoints * s.credits) * 1.0 / SUM(s.credits), 2) >= 8.0
  AND  COUNT(*) FILTER (WHERE s.grade = 'RA') > 0

