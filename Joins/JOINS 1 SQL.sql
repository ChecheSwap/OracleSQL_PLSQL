 /*----------------------------------------------------
  -                                                   -
  -        SQL Joins I, Ten Practical Excercises      -
  --         Oracle RDBMS 12c/19c, HR Scheme          -
  -     Ing. Jesús José Navarrete Baca (@checheswap)  -
  -                   04/11/2020                      -
  -                                                   -
  -----------------------------------------------------*/
  
--
-- Excercise #1.- Obtain for all departments of the company, the name of the department and the name of the head of the department.
--

--Method 1
SELECT d.department_name, e.first_name||' '||e.last_name manager
FROM   departments d, employees e
WHERE  d.manager_id = e.employee_id
ORDER BY 1 ASC;

--Method 2
SELECT d.department_name, e.first_name||' '||e.last_name manager
FROM   departments d
INNER JOIN employees e
ON    d.manager_id = e.employee_id
ORDER BY 1 ASC;

--
--Excercise #2.- Get the name of the region in which the employee "Steven" works (region_name, first_name, last_name)
--

-- Method 1
SELECT r.region_name, e.first_name, e.last_name
FROM   employees e, departments d, locations l, 
       countries c, regions r
WHERE  e.department_id = d.department_id
AND    d.location_id   = l.location_id
AND    l.country_id    = c.country_id
AND    c.region_id     = r.region_id
AND    UPPER(e.first_name) = 'STEVEN'
AND    ROWNUM = 1;

-- Method 2
SELECT r.region_name, e.first_name, e.last_name
FROM   employees e 
INNER  JOIN departments d
ON     (e.department_id = d.department_id)
INNER  JOIN locations l 
ON     (d.location_id = l.location_id) 
INNER  JOIN countries c
ON     (l.country_id = c.country_id )
INNER  JOIN regions r
ON     (c.region_id = r.region_id)
WHERE  UPPER(e.first_name) = 'STEVEN'
AND   ROWNUM = 1;

--
-- Excercise #3.- Get the names of the departments that do not have employees assigned at this time
--

--Method 1
SELECT d.*
FROM   employees e, departments d
WHERE  e.department_id (+)= d.department_id
AND    e.department_id IS NULL
ORDER BY 2 ASC;

--Method 2
SELECT d.*
FROM   employees e 
RIGHT JOIN departments d
ON    (e.department_id = d.department_id)
WHERE  e.department_id IS NULL
ORDER BY 2 ASC;

--
-- Excercise #4.- Obtain the names of employees who have no assigned department at this time.
--

--Method 1
SELECT e.*
FROM   employees e, departments d
WHERE  e.department_id = d.department_id(+)
AND    e.department_id IS NULL
ORDER BY 2 ASC;

SELECT *
FROM   employees 
WHERE  department_id IS NULL;

--
-- Excercise #5.- Get the names of the regions that do not have assigned departments
--

--Method 1
SELECT r.region_name
FROM   regions r,(SELECT DISTINCT(r.region_name), r.region_id
                  FROM   departments d, locations l, countries c, regions r
                  WHERE  d.location_id = l.location_id
                  AND    c.country_id  = l.country_id
                  AND    c.region_id   = r.region_id) rt
WHERE  r.region_id = rt.region_id(+)
AND    rt.region_id IS NULL
ORDER BY 1 ASC;

--Method 2
SELECT region_name
FROM   regions
WHERE  region_id NOT IN(
                        SELECT r.region_id
                        FROM   departments d, locations l, countries c, regions r
                        WHERE  d.location_id = l.location_id
                        AND    c.country_id  = l.country_id
                        AND    c.region_id   = r.region_id
                        GROUP BY r.region_id, r.region_name)
ORDER BY 1 ASC;

--
--Excercise #6.- Get employees who have income that is in the range of the salary paid to the position "AD_ASST" (name, name, job, salary)
--
SELECT e.employee_id, salary, jt.min_salary, jt.max_salary
FROM   employees e, (SELECT *
                     FROM   jobs
                     WHERE  UPPER(job_id) = 'AD_ASST'
                     AND    ROWNUM = 1) jt
WHERE  e.salary BETWEEN jt.min_salary 
                AND     jt.max_salary;

--
--Excercise #7.- Get the employees that their current position is the only position they have held in the company (firs_name, last_name, job_id)
--

--Method 1
SELECT e.first_name, e.last_name, e.job_id
FROM   employees e, (SELECT DISTINCT(employee_id)
                     FROM   employees e
                     JOIN   job_history jh
                     USING  (employee_id)) t
WHERE  e.employee_id = t.employee_id(+)
AND    t.employee_id IS NULL
ORDER BY 1 ASC;

--Method 2
SELECT e.first_name, e.last_name, e.job_id
FROM   employees e
LEFT
JOIN   (SELECT DISTINCT(employee_id)
        FROM   job_history) j
ON     (e.employee_id = j.employee_id)
WHERE   j.employee_id IS NULL
ORDER BY 1 ASC;

--COMPROBATION!, SHOULD BE A NULL SET.
SELECT e.first_name, e.last_name, e.job_id
FROM   employees e, (SELECT DISTINCT(employee_id)
                     FROM   employees e
                     JOIN   job_history jh
                     USING  (employee_id)) t
WHERE  e.employee_id = t.employee_id(+)
AND    t.employee_id IS NULL
MINUS
SELECT e.first_name, e.last_name, e.job_id
FROM   employees e
LEFT
JOIN   (SELECT DISTINCT(employee_id)
        FROM   job_history) j
ON     (e.employee_id = j.employee_id)
WHERE   j.employee_id IS NULL;

--
--Excercise #8 Obtain employees who have held more than one position in the department in which they currently work (name, surname)
--

--Method 1
SELECT   e.employee_id ID, e.first_name || ' '|| e.last_name name, COUNT(*) "Total Positions"
FROM     job_history j, employees e
WHERE    e.employee_id   = j.employee_id
AND      e.department_id = j.department_id
GROUP BY e.employee_id , e.department_id, j.department_id, e.first_name || ' '|| e.last_name 
ORDER BY 3 DESC;

--Method 2
SELECT   e.employee_id ID, e.first_name || ' '|| e.last_name name, COUNT(*) "Total Positions"
FROM     employees e
INNER 
JOIN     job_history j
ON       (e.employee_id = j.employee_id AND e.department_id = j.department_id)
GROUP BY e.employee_id, e.first_name || ' '|| e.last_name
ORDER BY 3 DESC;

--
--Excercise #9 Obtain the largest number of (direct) subordinates for a boss / administrator (no. of subordinates)
--

--Method 1
SELECT e.manager_id,  (SELECT first_name || ' '|| last_name
                       FROM   employees
                       WHERE  employee_id = e.manager_id) manager_name,
       COUNT(*) "Sub Ordinados"
FROM   departments d, employees e
WHERE  d.manager_id(+) = e.manager_id 
AND    e.manager_id IS NOT NULL
GROUP BY e.manager_id
ORDER BY 3 DESC;

--Method 2
SELECT   e.manager_id, (SELECT first_name || ' '|| last_name
                        FROM   employees
                        WHERE  employee_id = e.manager_id) manager_name, 
         COUNT(*) "Sub ordinados"
FROM     employees e
WHERE    e.manager_id IS NOT NULL
GROUP BY e.manager_id
ORDER BY 3 DESC;

--
--Excercise #10  Obtain the highest existing staff turnover for the departments of the company (no. of movements)
--

--Method 1
SELECT   j.department_id , d.department_name, COUNT(*) "Movements"
FROM     departments d, job_history j
WHERE    d.department_id (+)= j.department_id
GROUP BY j.department_id, d.department_name
ORDER BY 3 DESC;

--Method 2
SELECT   j.department_id , d.department_name, COUNT(*) "Movements"
FROM     departments d
RIGHT 
JOIN     job_history j
ON       (d.department_id = j.department_id)
GROUP BY j.department_id, d.department_name
ORDER BY 3 DESC;












