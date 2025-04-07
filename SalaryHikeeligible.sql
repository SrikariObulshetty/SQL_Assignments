CREATE TABLE emp (
    empid INT PRIMARY KEY,
    ename TEXT,
    dept TEXT,
    old_salary NUMERIC,
    new_salary NUMERIC
);





INSERT INTO emp(empid, ename, dept, old_salary, new_salary) 
VALUES
(101, 'Alice', 'CSE', 50000, 62000),  -- 24% increase ✔️
(102, 'Bob', 'CSE', 48000, 52000),    -- 8% increase ❌
(103, 'Charlie', 'ECE', 45000, 55000),-- 22% increase ✔️
(104, 'David', 'ECE', 60000, 70000),  -- 16.6% increase ❌
(105, 'Eva', 'EEE', 40000, 51000);    -- 27.5% increase ✔️




DO $$
DECLARE
    rec RECORD;
    emp_cursor CURSOR FOR
        SELECT empid, ename, dept, old_salary, new_salary,
               ROUND((new_salary - old_salary) * 100.0 / old_salary, 2) AS increase_percent
        FROM emp;
BEGIN
    OPEN emp_cursor;

    LOOP
        FETCH emp_cursor INTO rec;
        EXIT WHEN NOT FOUND;

        IF rec.increase_percent >= 20 THEN
            RAISE NOTICE 'Eligible for Promotion -> EmpID: %, Name: %, Dept: %, Salary Increase: %%',
                rec.empid, rec.ename, rec.dept, rec.increase_percent;
        END IF;

    END LOOP;

    CLOSE emp_cursor;
END $$;




