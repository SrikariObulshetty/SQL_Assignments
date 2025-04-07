CREATE TABLE emp (
    empno INT PRIMARY KEY,
    ename TEXT,
    job TEXT,
    hiredate DATE,
    mgr INT,
    sal INT,
    comm INT,
    deptno INT
);



INSERT INTO emp (empno, ename, job, hiredate, mgr, sal, comm, deptno) VALUES
(7369, 'SMITH', 'CLERK', '1980-12-17', 7902, 800, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', '1981-02-20', 7698, 1600, 300, 30),
(7521, 'WARD', 'SALESMAN', '1981-02-22', 7698, 1250, 500, 30),
(7566, 'JONES', 'MANAGER', '1981-04-02', 7839, 2975, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', '1981-09-28', 7698, 1250, 1400, 30),
(7698, 'BLAKE', 'MANAGER', '1981-05-01', 7839, 2850, NULL, 30),
(7782, 'CLARK', 'MANAGER', '1981-06-09', 7839, 2450, NULL, 10),
(7788, 'SCOTT', 'ANALYST', '1987-04-19', 7566, 3000, NULL, 20),
(7839, 'KING', 'PRESIDENT', '1981-11-17', NULL, 5000, NULL, 10),
(7844, 'TURNER', 'SALESMAN', '1981-09-08', 7698, 1500, 0, 30),
(7876, 'ADAMS', 'CLERK', '1987-05-23', 7788, 1100, NULL, 20),
(7900, 'JAMES', 'CLERK', '1981-12-03', 7698, 950, NULL, 30),
(7902, 'FORD', 'ANALYST', '1981-12-03', 7566, 3000, NULL, 20),
(7934, 'MILLER', 'CLERK', '1982-01-23', 7782, 1300, NULL, 10);



WITH RECURSIVE emp_hierarchy AS (
    -- Base case: Top-level manager (e.g., PRESIDENT)
    SELECT empno, ename, mgr, 1 AS level
    FROM emp
    WHERE mgr IS NULL OR empno = 7839  -- KING is PRESIDENT

    UNION ALL

    -- Recursive case: Employees reporting to the above
    SELECT e.empno, e.ename, e.mgr, eh.level + 1
    FROM emp e
    JOIN emp_hierarchy eh ON e.mgr = eh.empno
)
SELECT * FROM emp_hierarchy
ORDER BY level, empno;

