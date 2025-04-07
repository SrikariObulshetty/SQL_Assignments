-- Step 1: Create the table
CREATE TABLE emp_bonus (
    empid INT PRIMARY KEY,
    ename TEXT,
    old_salary NUMERIC,
    new_salary NUMERIC,
    years_of_service INT,
    bonus NUMERIC DEFAULT 0
);

-- Step 2: Insert sample data
INSERT INTO emp_bonus VALUES
(101, 'Alice', 50000, 55000, 5),   -- Bonus
(102, 'Bob', 60000, 66000, 3),     -- No bonus (less years)
(103, 'Charlie', 70000, 80000, 6), -- Bonus
(104, 'David', 65000, 65000, 7),   -- No bonus (no raise)
(105, 'Eva', 40000, 44000, 5);     -- Bonus

-- Step 3: Bonus Calculation Logic using Cursor
DO $$
DECLARE
    rec RECORD;
    raise_percent NUMERIC;
BEGIN
    FOR rec IN SELECT * FROM emp_bonus LOOP
        raise_percent := ((rec.new_salary - rec.old_salary) * 100.0) / rec.old_salary;

        IF raise_percent >= 10 AND rec.years_of_service >= 5 THEN
            UPDATE emp_bonus
            SET bonus = 10000
            WHERE empid = rec.empid;

            RAISE NOTICE 'Bonus Awarded → % (Raise: %, Service: % years)', 
                         rec.ename, ROUND(raise_percent, 2)::TEXT, rec.years_of_service::TEXT;
        ELSE
            RAISE NOTICE 'No Bonus → % (Raise: %%, Service: % years)', 
                         rec.ename, ROUND(raise_percent, 2)::TEXT, rec.years_of_service::TEXT;
        END IF;
    END LOOP;
END $$;
