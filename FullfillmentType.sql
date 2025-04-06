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
('21CSE001', 2023, 1, 'I-I', 'CS103', 'Chemistry', 3, 'A'),

('21CSE002', 2023, 1, 'I-I', 'CS101', 'Maths', 2, 'B+'),
('21CSE002', 2023, 1, 'I-I', 'CS102', 'Physics', 3, 'B'),
('21CSE002', 2023, 1, 'I-I', 'CS103', 'Chemistry', 3, 'RA');


DO $$
DECLARE
  rec RECORD;
  stu_cursor CURSOR FOR
    SELECT 
      regno,
      SUM(s.credits * gp.gpoints) AS total_credits
    FROM students as s JOIN GradePoints as gp ON gp.grade=s.grade
    GROUP BY  regno;
BEGIN
  OPEN stu_cursor;
  LOOP
    FETCH stu_cursor INTO rec;
    EXIT WHEN NOT FOUND;

    IF rec.total_credits = 190 THEN
      RAISE NOTICE ' Student: %, Credits: % => Exactly 190',  rec.regno, rec.total_credits;
    ELSIF rec.total_credits > 190 THEN
      RAISE NOTICE ' Student: %, Credits: % => More than 190', rec.regno, rec.total_credits;
    ELSE
      RAISE NOTICE ' Student: %, Credits: % => Less than 190', rec.regno, rec.total_credits;
    END IF;
  END LOOP;
  CLOSE stu_cursor;
END $$;

               
      
      
