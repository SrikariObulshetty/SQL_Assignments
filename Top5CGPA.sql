-- Table: GradePoints
CREATE TABLE gradepoints (
    grade CHAR(2) PRIMARY KEY,
    gpoints INT
);

-- Table: Students
CREATE TABLE students (
    regno TEXT,
    name TEXT,
    dept TEXT,
    ayear INT,
    asem INT,
    coursecode TEXT,
    coursename TEXT,
    credits INT,
    grade CHAR(2)
);





-- Insert grade points
-- Sample grades
INSERT INTO gradepoints VALUES 
('O', 10), ('A+', 9), ('A', 8), ('B+', 7), ('B', 6), ('C', 5), ('P', 4), ('F', 0);

-- Sample student course records
INSERT INTO students VALUES
('S001', 'Alice', 'CSE', 2023, 1, 'CS101', 'Data Structures', 4, 'O'),
('S001', 'Alice', 'CSE', 2023, 1, 'CS102', 'Algorithms', 4, 'A+'),
('S002', 'Bob', 'CSE', 2023, 1, 'CS101', 'Data Structures', 4, 'B+'),
('S002', 'Bob', 'CSE', 2023, 1, 'CS102', 'Algorithms', 4, 'F'), -- has backlog
('S003', 'Eve', 'ECE', 2023, 1, 'EC101', 'Circuits', 3, 'O'),
('S003', 'Eve', 'ECE', 2023, 1, 'EC102', 'Signals', 3, 'A+'),
('S004', 'Raj', 'ECE', 2023, 1, 'EC101', 'Circuits', 3, 'B+'),
('S004', 'Raj', 'ECE', 2023, 1, 'EC102', 'Signals', 3, 'A'),
('S005', 'Maya', 'CSE', 2023, 1, 'CS101', 'Data Structures', 4, 'O'),
('S005', 'Maya', 'CSE', 2023, 1, 'CS102', 'Algorithms', 4, 'O');



DO $$
DECLARE
    rec RECORD;
    current_dept TEXT;
    student_cursor CURSOR FOR
        SELECT s.regno, s.name, s.dept,
               ROUND(SUM(g.gpoints * s.credits)::NUMERIC / SUM(s.credits), 2) AS cgpa
        FROM students s
        JOIN gradepoints g ON s.grade = g.grade
        WHERE s.grade != 'F'  -- Ignore backlogs
        GROUP BY s.regno, s.name, s.dept
        ORDER BY s.dept, cgpa DESC;

    dept_list TEXT[];
    dept_index INT := 1;
    rank INT := 0;
BEGIN
    -- Get distinct departments
    SELECT ARRAY(SELECT DISTINCT dept FROM students ORDER BY dept) INTO dept_list;

    WHILE dept_index <= array_length(dept_list, 1) LOOP
        current_dept := dept_list[dept_index];
        rank := 0;

        OPEN student_cursor;
        LOOP
            FETCH student_cursor INTO rec;
            EXIT WHEN NOT FOUND;

            IF rec.dept = current_dept THEN
                rank := rank + 1;
                IF rank <= 5 THEN
                    RAISE NOTICE 'Dept: %, Rank: %, RegNo: %, Name: %, CGPA: %',
                        rec.dept, rank, rec.regno, rec.name, rec.cgpa;
                END IF;
            END IF;

        END LOOP;
        CLOSE student_cursor;

        dept_index := dept_index + 1;
    END LOOP;
END $$;



