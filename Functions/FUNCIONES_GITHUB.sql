--------------------------------
-- *JESUS JOSE NAVARRETE BACA --
-- *EJERCICIOS FUNCIONES      --
--------------------------------

--1.- Get the full name(first_name, last_name) and the length in characters of the names of the 
--    employees (nombre_empleado, no_caracteres) 

SELECT CONCAT(FIRST_NAME || ' ', LAST_NAME) "NOMBRE", 
       LENGTH(CONCAT(FIRST_NAME, LAST_NAME)) || ' Caracteres' "LONGITUD" 
FROM EMPLOYEES;

--2.- Get the first_name ,last_name and email from employees, taking into account that the domain of the 
--    Company. it's @system.com

SELECT FIRST_NAME "NOMBRE", LAST_NAME "APELLIDO", CONCAT(EMAIL,'@system.com') "EMAIL"
FROM   EMPLOYEES;

-- 3.- Obtain the full name of the employees (name, surname) and the year of entry to the city.

SELECT CONCAT(FIRST_NAME || ' ', LAST_NAME) "NOMBRE", 
       EXTRACT(YEAR FROM HIRE_DATE) "YEAR DE INGRESO" 
FROM EMPLOYEES; 

-- 4.- Obtain the name of the department and the number of employees of the departments, for those
--     departments that have an even number of employees

SELECT D.DEPARTMENT_NAME "NOMBRE DEPARTAMENTO" , COUNT(E.EMPLOYEE_ID) "TOTAL EMPLEDOS"
FROM       EMPLOYEES E 
INNER JOIN DEPARTMENTS D 
USING      (DEPARTMENT_ID)
GROUP BY   D.DEPARTMENT_NAME 
HAVING     (MOD(COUNT(E.EMPLOYEE_ID),2)=0)
ORDER BY COUNT(E.EMPLOYEE_ID) DESC;

-- 5.- Obtain the first_name, last_name and the date of entry of the employees who entered the period of
--     1990 to 1994

SELECT FIRST_NAME "NOMBRE", LAST_NAME "APELLIDO", HIRE_DATE "FECHA DE CONTRATACION" 
FROM   EMPLOYEES 
WHERE  (EXTRACT(YEAR FROM HIRE_DATE) BETWEEN 1990 AND 1994);

-- 6.- Obtain the name, surname and years of service of the employees of the "SALES" department

SELECT E.FIRST_NAME ||' '|| E.LAST_NAME "NOMBRE", FLOOR(MONTHS_BETWEEN(CURRENT_DATE, E.HIRE_DATE)/12)||' Años' "ANTIGUEDAD", 
       CURRENT_DATE "TODAY", E.HIRE_DATE "CONTRATACION"
FROM       EMPLOYEES E 
INNER JOIN DEPARTMENTS D 
USING (DEPARTMENT_ID)
WHERE UPPER(D.DEPARTMENT_NAME) = 'SALES'
ORDER BY 1 ASC;

--7.- Get the no. of days elapsed this year

SELECT TRUNC(CURRENT_DATE,'YYYY') "DESDE", CURRENT_DATE "HASTA" ,
       TRUNC(CURRENT_DATE - TRUNC(CURRENT_DATE,'YYYY')) || ' Dias' "DIAS TRANSCURRIDOS"
FROM DUAL;

/*
  8.- Obtain the first_name, last_name and salary of the employees, as well as a legend indicating the level
   of employee income, based on the following criteria:
    a. Salary <  8000 "Low Income"
    b. Salary <  11000 "Middle Income"
    c. Salary> = 11000 "High Income"
*/
SELECT CONCAT(FIRST_NAME ||' ', LAST_NAME) "NOMBRE", '$ '||SALARY "SALARIO",
       CASE WHEN SALARY < 8000 THEN 'Ingreso Bajo'
            WHEN SALARY < 11000 THEN 'Ingreso Medio'
            WHEN SALARY >= 11000 THEN 'Ingreso Alto'
ELSE 'Imposible de calcular'
END "NIVEL DE INGRESO"
FROM EMPLOYEES 
ORDER BY SALARY DESC;

--9.- Obtain the first_name, last_name and the date of entry of the employees, the date must be presented in
--    "DD / MMM / YYYY" format

SELECT FIRST_NAME ||' '|| LAST_NAME "NOMBRE", TO_CHAR(HIRE_DATE, 'DD/MM/YYYY') "FECHA DE INGRESO" 
FROM EMPLOYEES 
ORDER BY HIRE_DATE DESC;

SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE" , 
       CASE WHEN EXTRACT(DAY FROM HIRE_DATE) <10 THEN '0'||EXTRACT(DAY FROM HIRE_DATE) 
         ELSE TO_CHAR(EXTRACT(DAY FROM HIRE_DATE)) END ||'/'||
       CASE WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 1 THEN 'ENE' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 2 THEN 'FEB' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 3 THEN 'MAR' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 4 THEN 'ABR' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 5 THEN 'MAY' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 6 THEN 'JUN' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 7 THEN 'JUL' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 8 THEN 'AGO' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 9 THEN 'SEP' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 10 THEN 'OCT' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 11 THEN 'NOV' 
            WHEN (EXTRACT(MONTH FROM HIRE_DATE)) = 12 THEN 'DIC' END 
            ||'/'|| EXTRACT(YEAR FROM HIRE_DATE) "FECHA DE INGRESO" FROM EMPLOYEES 
ORDER BY HIRE_DATE DESC;

/* 10.- Obtain a histogram showing the no. of personnel movements by department (one * for each
        movement)
Example:
a. SALES     ** 
b. IT        *** 
c. Marketing **** 
*/

SELECT  RPAD(D.DEPARTMENT_NAME,(SELECT MAX(LENGTH(D.DEPARTMENT_NAME)) 
FROM DEPARTMENTS D
INNER JOIN JOB_HISTORY 
USING (DEPARTMENT_ID)),' ') || RPAD(' ',COUNT(*)+1,'*') "DEPARTAMENTOS", COUNT(J.EMPLOYEE_ID) "MOVIMIENTOS" FROM DEPARTMENTS D INNER JOIN JOB_HISTORY  J
USING(DEPARTMENT_ID) GROUP BY D.DEPARTMENT_NAME 
ORDER BY COUNT(*) DESC;
