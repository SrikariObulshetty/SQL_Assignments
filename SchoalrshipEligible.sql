-- GradePoints table
CREATE TABLE GradePoints (
  grade VARCHAR(5) PRIMARY KEY,
  gpoints NUMERIC
);

-- Sample GradePoints data
INSERT INTO GradePoints VALUES
('O', 10), ('A+', 9), ('A', 8), ('B+', 7), ('B', 6), ('RA', 0);

-- Emp table
CREATE TABLE Emp (
  regno VARCHAR(20),
  ayear INT,
  asem INT,
  pys VARCHAR(10),
  coursecode VARCHAR(10),
  coursename VARCHAR(100),
  credits INT,
  grade VARCHAR(5)
);



INSERT INTO Emp VALUES
('21CSE001', 2023, 1, 'I-I', 'CS101', 'Maths', 4, 'O'),
('21CSE001', 2023, 1, 'I-I', 'CS102', 'Physics', 3, 'A+'),
('21CSE001', 2023, 1, 'I-I', 'CS103', 'Chemistry', 3, 'A'),

('21CSE002', 2023, 1, 'I-I', 'CS101', 'Maths', 4, 'B+'),
('21CSE002', 2023, 1, 'I-I', 'CS102', 'Physics', 3, 'B'),
('21CSE002', 2023, 1, 'I-I', 'CS103', 'Chemistry', 3, 'RA');


DO $$
DECLARE
  rec RECORD;
  student_cursor CURSOR FOR
    SELECT
      e.regno,
      ROUND(SUM(g.gpoints * e.credits)::NUMERIC / SUM(e.credits), 2) AS cgpa,
      SUM(e.credits) AS total_credits
    FROM Emp e
    JOIN GradePoints g ON e.grade = g.grade
    GROUP BY e.regno
    HAVING ROUND(SUM(g.gpoints * e.credits)::NUMERIC / SUM(e.credits), 2) >= 7.5
           AND SUM(e.credits) >= 10;
BEGIN
  OPEN student_cursor;

  LOOP
    FETCH student_cursor INTO rec;
    EXIT WHEN NOT FOUND;

    RAISE NOTICE 'Eligible: % (CGPA: %, Credits: %)', rec.regno, rec.cgpa, rec.total_credits;
  END LOOP;

  CLOSE student_cursor;
END $$;
