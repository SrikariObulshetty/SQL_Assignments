CREATE TABLE students (
    regno TEXT,
    dept TEXT,
    ayear INT,     -- Academic year
    asem INT,      -- Academic semester
    course_code TEXT,
    grade TEXT,
    credits INT
);

CREATE TABLE gradepoints (
    grade TEXT PRIMARY KEY,
    gpoints INT
);


-- Grade Points
INSERT INTO gradepoints VALUES 
('O', 10), ('A+', 9), ('A', 8), ('B', 7), ('C', 6), ('D', 5), ('F', 0);

-- Student Grades Sample
INSERT INTO students VALUES
-- Student 1 (Improving GPA, No Backlogs)
('S001', 'CSE', 2022, 1, 'CS101', 'A', 3),
('S001', 'CSE', 2022, 2, 'CS102', 'A+', 3),
('S001', 'CSE', 2023, 1, 'CS201', 'O', 3),

-- Student 2 (No improvement)
('S002', 'CSE', 2022, 1, 'CS101', 'A+', 3),
('S002', 'CSE', 2022, 2, 'CS102', 'A+', 3),
('S002', 'CSE', 2023, 1, 'CS201', 'A', 3),

-- Student 3 (Improving GPA, but has backlogs)
('S003', 'ECE', 2022, 1, 'EC101', 'C', 3),
('S003', 'ECE', 2022, 2, 'EC102', 'B', 3),
('S003', 'ECE', 2023, 1, 'EC201', 'F', 3);




DO $$
DECLARE
    rec RECORD;
    prev_gpa NUMERIC := 0;
    is_improving BOOLEAN;
    has_backlog BOOLEAN;
    cg_cursor CURSOR FOR
        SELECT regno, dept, ayear, asem,
               ROUND(SUM(g.gpoints * s.credits)::NUMERIC / SUM(s.credits), 2) AS gpa,
               BOOL_OR(g.grade = 'F') AS has_backlog
        FROM students s
        JOIN gradepoints g ON s.grade = g.grade
        GROUP BY regno, dept, ayear, asem
        ORDER BY regno, ayear, asem;
    curr_regno TEXT := '';
BEGIN
    OPEN cg_cursor;

    LOOP
        FETCH cg_cursor INTO rec;
        EXIT WHEN NOT FOUND;

        IF curr_regno IS DISTINCT FROM rec.regno THEN
            prev_gpa := 0;
            is_improving := TRUE;
            has_backlog := FALSE;
            curr_regno := rec.regno;
        END IF;

        IF rec.has_backlog THEN
            has_backlog := TRUE;
        END IF;

        IF rec.gpa < prev_gpa THEN
            is_improving := FALSE;
        END IF;

        prev_gpa := rec.gpa;

        -- If last semester for this regno is reached
        IF EXISTS (
            SELECT 1 FROM students s2
            WHERE s2.regno = rec.regno AND
                  (s2.ayear > rec.ayear OR (s2.ayear = rec.ayear AND s2.asem > rec.asem))
            LIMIT 1
        ) THEN
            CONTINUE;
        END IF;

        -- Print if improving and no backlogs
        IF is_improving AND NOT has_backlog THEN
            RAISE NOTICE 'Improving: RegNo: %, Dept: %', rec.regno, rec.dept;
        END IF;

    END LOOP;

    CLOSE cg_cursor;
END $$;
