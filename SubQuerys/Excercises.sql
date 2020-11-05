 /*---------------------------------------------------------------------
  -                                                                    -
  -                 SQL Subqueryng I, Ten Practical Excercises         -
  -                     Oracle RDBMS 12c/19c, HR Scheme                -
  -             Ing. Jesús José Navarrete Baca (@checheswap)           -
  -                            June 2020                               -
  -                                                                    -
  ---------------------------------------------------------------------*/

---***EXCERCISE 1
---CREATE A QUERY THAT SHOWS THE DEPARTMENT [ID, NAME] AND THE NUMBER OF EMPLOYEES. THAT DEPARTMENT NEED BE THE MOST POPULAR IN THE DIRECTION

----F1
SELECT E.DEPARTMENT_ID "ID DEPARTAMENTO", D.DEPARTMENT_NAME "NOMBRE DEPTO", 
       (COUNT(E.EMPLOYEE_ID)) "TOTAL EMPLEADOS" 
FROM       EMPLOYEES E 
INNER JOIN DEPARTMENTS D 
ON         (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
GROUP BY   E.DEPARTMENT_ID , D.DEPARTMENT_NAME 
HAVING COUNT(E.EMPLOYEE_ID) = (SELECT MAX(COUNT(*)) 
                               FROM EMPLOYEES 
                               WHERE DEPARTMENT_ID IS NOT NULL
                               GROUP BY DEPARTMENT_ID);
---F2
SELECT *
FROM
    (SELECT d.department_id, d.department_name, COUNT(e.employee_id) "Employee Count"
    FROM   employees e, departments d
    WHERE  e.department_id = d.department_id
    GROUP  BY d.department_id, d.department_name
    ORDER  BY 3 DESC)
WHERE ROWNUM = 1;

---F3
SELECT dx.DEPARTMENT_ID, dx.DEPARTMENT_NAME "NOMBRE DEPTO",(SELECT COUNT(*)
                                                            FROM   employees
                                                            WHERE  department_id = dx.department_id)"TOTAL EMPLEADOS"
FROM DEPARTMENTS dx
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 
                       FROM EMPLOYEES 
                       GROUP BY DEPARTMENT_ID 
                       HAVING COUNT(*) = (SELECT MAX(COUNT(*)) 
                                         FROM EMPLOYEES 
                                         WHERE DEPARTMENT_ID IS NOT NULL 
                                         GROUP BY DEPARTMENT_ID));



---***EXCERCISE 2
---CRETE A QUERY THAT RETURNS THE EMPLOYEES THAT HAVE A SALARY MAJOR THAT HERMANN'S SALARY
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE", '$ '||SALARY "SALARIO" 
FROM   EMPLOYEES 
WHERE  SALARY > (SELECT SALARY 
                 FROM EMPLOYEES 
                 WHERE UPPER(FIRST_NAME) = 'HERMANN')
ORDER BY 2 ASC;

---***EXCERCISE 3
---CREATE A QUERY THAT RETURNS THE EMPLOYEES WITH MAJOR SALARY THAT THE MAX SALARY OF A IT DEPARTMENT

---F1
SELECT FIRST_NAME || ' '|| LAST_NAME "NOMBRE", '$ ' || SALARY "SALARIO" 
FROM   EMPLOYEES 
WHERE  SALARY > (SELECT MAX(SALARY) 
                 FROM   EMPLOYEES 
                 WHERE  DEPARTMENT_ID = (SELECT DEPARTMENT_ID 
                                         FROM   DEPARTMENTS 
                                         WHERE  UPPER(DEPARTMENT_NAME) = 'IT')) 
ORDER BY 2 DESC;

---F2
SELECT FIRST_NAME || ' '|| LAST_NAME "NOMBRE", '$ ' || SALARY "SALARIO" 
FROM   EMPLOYEES 
WHERE  SALARY > ALL (SELECT SALARY 
                     FROM   EMPLOYEES 
                     WHERE  DEPARTMENT_ID = (SELECT DEPARTMENT_ID 
                                             FROM   DEPARTMENTS 
                                             WHERE  UPPER(DEPARTMENT_NAME) = 'IT' ) ) 
ORDER BY SALARY DESC;

---SALARY LIST OF IT
SELECT SALARY 
FROM   EMPLOYEES 
WHERE  DEPARTMENT_ID = (SELECT DEPARTMENT_ID 
                        FROM   DEPARTMENTS 
                        WHERE  DEPARTMENT_NAME = 'IT') 
ORDER BY SALARY DESC;



---***EXCERCISE 4
---CREATE A QUERY THAT GET NAME AND SURNAME OF EMPLOYEES THAT THEIR CURRENT POSITION IS THE ONLY POSITION THEY HAVE HELD IN THE COMPANY
--F1
SELECT   FIRST_NAME || ' ' || LAST_NAME "NOMBRE" 
FROM     EMPLOYEES 
WHERE    EMPLOYEE_ID NOT IN (SELECT   EMPLOYEE_ID 
                             FROM     JOB_HISTORY 
                             GROUP BY EMPLOYEE_ID) 
ORDER BY (FIRST_NAME || ' ' || LAST_NAME) ASC;

--F2
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" 
FROM   EMPLOYEES 
MINUS
SELECT     E.FIRST_NAME || ' ' || E.LAST_NAME "NOMBRE" 
FROM       EMPLOYEES E
INNER JOIN JOB_HISTORY 
USING      (EMPLOYEE_ID);


---***EXCERCISE 5
--- CREATE A QUERY THAT GETS THE DEPARTMENT_NAME OF THE DEPARTMENTS THAT ARE NOT ASSIGNED EMPLOYEES AT THIS TIME.
--F1
SELECT DEPARTMENT_NAME "NOMBRE DEPARTAMENTO" 
FROM   DEPARTMENTS
MINUS
SELECT     D.DEPARTMENT_NAME 
FROM       EMPLOYEES E 
INNER JOIN DEPARTMENTS D 
USING      (DEPARTMENT_ID);
--F2
SELECT DEPARTMENT_NAME 
FROM   DEPARTMENTS 
WHERE  DEPARTMENT_ID NOT IN (SELECT DEPARTMENT_ID 
                             FROM EMPLOYEES 
                             WHERE DEPARTMENT_ID IS NOT NULL 
                             GROUP BY DEPARTMENT_ID) 
ORDER BY 1 ASC;

---***EXCERCISE 6
--CREATE A QUERY THAT OBTAINS THE FIRST_NAME AND LAST_NAME OF THE EMPLOYEES WHO EARN MORE THAN AT LEAST ONE OF THE EMPLOYEES OF THE ‘IT’ DEPARTMENT (FIRST_NAME, LAST_NAME, SALARY).

---F1
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" , '$ '||SALARY "SALARIO" 
FROM   EMPLOYEES 
WHERE  SALARY > ANY (SELECT SALARY 
                    FROM EMPLOYEES 
                    WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 
                                           FROM   DEPARTMENTS 
                                           WHERE  UPPER(DEPARTMENT_NAME) = 'IT') 
                    GROUP BY SALARY)
ORDER BY SALARY ASC;

---F2
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" , '$ '||SALARY "SALARIO" 
FROM   EMPLOYEES 
WHERE  SALARY > (SELECT MIN(SALARY) 
                 FROM EMPLOYEES 
                 WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID 
                                        FROM   DEPARTMENTS 
                                        WHERE  UPPER(DEPARTMENT_NAME) = 'IT' ))
ORDER BY 2 ASC;

---***EXCERCISE 7
---CREATE A QUERY THAT OBTAINS THE FIRST_NAME AND LAST_NAME OF EMPLOYEES WHO HAVE THE SAME POSITION AS THE EMPLOYEE ‘RANDALL’ AND THE SAME SALARY AS ‘PETER’ (FIRST_NAME, LAST_NAME, JOB_ID, SALARY).

SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" ,  JOB_ID "PUESTO", '$ '||SALARY "SALARIO" 
FROM EMPLOYEES 
WHERE JOB_ID  IN (SELECT JOB_ID 
                  FROM EMPLOYEES 
                  WHERE UPPER(FIRST_NAME)='RANDALL')
AND SALARY    IN (SELECT  SALARY 
                  FROM EMPLOYEES 
                  WHERE UPPER(FIRST_NAME) = 'PETER')
AND EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID 
                       FROM   EMPLOYEES 
                       WHERE UPPER(FIRST_NAME) = 'RANDALL' 
                       OR    UPPER(FIRST_NAME) = 'PETER')
ORDER BY 3 ASC;

---***EXCERCISE 8
---CREATE A QUERY THAT GETS THE FIRST_NAME AND LAST_NAME OF EMPLOYEES WHO HAVE THE SAME POSITION THAT THE EMPLOYEE ‘RANDALL’ OR THE SAME SALARY THAT ‘PETER’ (FIRST_NAME, LAST_NAME, JOB_ID, SALARY).
--F1
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" ,  JOB_ID  "PUESTO", '$ '||SALARY "SALARIO"  
FROM   EMPLOYEES 
WHERE (JOB_ID  IN (SELECT JOB_ID 
                   FROM EMPLOYEES 
                   WHERE UPPER(FIRST_NAME)='RANDALL')
OR SALARY IN (SELECT SALARY 
              FROM EMPLOYEES 
              WHERE UPPER(FIRST_NAME) = 'PETER'))
AND EMPLOYEE_ID NOT IN( SELECT EMPLOYEE_ID 
                        FROM EMPLOYEES 
                        WHERE UPPER(FIRST_NAME)= 'RANDALL' 
                        OR UPPER(FIRST_NAME) = 'PETER') 
ORDER BY SALARY ASC;

--F2
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" ,  JOB_ID  "PUESTO", '$ '||SALARY "SALARIO" 
FROM EMPLOYEES 
WHERE (JOB_ID, SALARY) IN(SELECT JOB_ID, SALARY 
                          FROM   EMPLOYEES 
                          WHERE  JOB_ID IN (SELECT JOB_ID 
                                            FROM   EMPLOYEES 
                                            WHERE UPPER(FIRST_NAME) = 'RANDALL')
OR  SALARY IN(SELECT SALARY 
              FROM EMPLOYEES 
              WHERE UPPER(FIRST_NAME) = 'PETER'))
AND EMPLOYEE_ID NOT IN(SELECT EMPLOYEE_ID 
                       FROM   EMPLOYEES 
                       WHERE  UPPER(FIRST_NAME) = 'RANDALL' 
                       OR     UPPER(FIRST_NAME) = 'PETER') 
ORDER BY SALARY ASC;

---***EXCERCISE 9
---CREATE A QUERY THAT GETS THE FIRST_NAME AND LAST_NAME OF THE EMPLOYEES WHO EARN MORE THAN ALL THE SUBORDINATE EMPLOYEES OF ‘SHANTA’ (FIRST_NAME, LAST_NAME, SALARY).

SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" , '$ ' || SALARY "SALARIO" 
FROM   EMPLOYEES 
WHERE SALARY > ALL (SELECT SALARY 
                    FROM   EMPLOYEES 
                    WHERE  MANAGER_ID IN (SELECT EMPLOYEE_ID 
                                          FROM   EMPLOYEES 
                                          WHERE  UPPER(FIRST_NAME) = 'SHANTA')
GROUP BY SALARY) ORDER BY SALARY DESC;

SELECT MAX(SALARY )
FROM   EMPLOYEES 
WHERE MANAGER_ID = 123;

---***EXCERCISE 10
---CREATE A QUERY THAT GETS THE FIRST_NAME AND LAST_NAME OF EMPLOYEES WHO EARN MORE THAN AT LEAST ONE OF THE SUBORDINATE EMPLOYEES OF ‘SHANTA’ (FIRST_NAME, LAST_NAME, SALARY).

SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" , '$ ' || SALARY "SALARIO" 
FROM   EMPLOYEES 
WHERE SALARY > ANY(SELECT SALARY 
                   FROM   EMPLOYEES 
                   WHERE MANAGER_ID IN (SELECT EMPLOYEE_ID 
                                        FROM   EMPLOYEES 
                                        WHERE  UPPER(FIRST_NAME) = 'SHANTA')
                                        GROUP BY SALARY) 
ORDER BY SALARY DESC;

SELECT MIN(SALARY) 
FROM   EMPLOYEES 
WHERE MANAGER_ID = 123;


/*---Created and Revised by I.S.C.H. Jesús José Navarrete Baca @ChecheSwap*/





