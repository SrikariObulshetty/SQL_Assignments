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
DECLARE rec RECORD;
      stu_cursor CURSOR 
      FOR
      SELECT s.regno, SUM(gp.gpoints * s.credits) as tot_cred
      FROM students as s JOIN GradePoints as gp ON s.grade=gp.grade
      GROUP BY s.regno
      HAVING SUM(gp.gpoints*s.credits) >=10;
      
      BEGIN 
           OPEN stu_cursor;
           LOOP
               FETCH stu_cursor INTO rec;
               EXIT WHEN NOT FOUND;
               RAISE NOTICE 'Student ID : %, Total Credits: %', rec.regno, rec.tot_cred;
            END LOOP;
      CLOSE stu_cursor;
END $$;
               
