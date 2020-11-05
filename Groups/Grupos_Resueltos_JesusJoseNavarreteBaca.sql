 /*---------------------------------------------------------------------
  -                                                                    -
  -                 SQL Grouping I, Ten Practical Excercises           -
  -                     Oracle RDBMS 12c/19c, HR Scheme                -
  -             Ing. Jesús José Navarrete Baca (@checheswap)           -
  -                            November 2020                           -
  -                                                                    -
  ---------------------------------------------------------------------*/

--
--1. Obtener la nómina (suma de los salary de los empleados del departamento) que paga cada uno de los departamentos (department_id y nomina).
--
SELECT   DEPARTMENT_ID "DEPARTAMENTO", SUM(SALARY) "NOMINA" 
FROM     EMPLOYEES 
WHERE    DEPARTMENT_ID IS NOT NULL 
GROUP BY DEPARTMENT_ID 
ORDER BY SUM(SALARY) DESC; 

--
--2. Obtener el salario menor y mayor que se está pagando por puesto (job_id, salario menor y salario mayor). 
--
SELECT    JOB_ID "PUESTO" , MIN(SALARY) "SALARIO MINIMO" , MAX(SALARY) "SALARIO MAYOR" , COUNT (*) "TOTAL EMPLEADOS" 
FROM      EMPLOYEES 
GROUP BY  JOB_ID 
ORDER BY  JOB_ID; 

--
--3. Obtener los departamentos que tienen asignados más de 30 empleados (department_id, no. empleados).     
--
SELECT   DEPARTMENT_ID "DEPARTAMENTO", COUNT(*) "NUMERO EMPLEADOS" 
FROM     EMPLOYEES 
GROUP BY DEPARTMENT_ID 
HAVING   (COUNT(*) > 30); 

--
--4. Obtener el salario promedio que se paga por puesto (job_id, salario promedio). 
--
SELECT    JOB_ID "PUESTO", '$ ' || AVG(SALARY) "SALARIO PROMEDIO" 
FROM      EMPLOYEES 
GROUP BY  JOB_ID 
ORDER BY  AVG(SALARY) ASC; 

--
--5. Obtener los departamentos con más de un movimiento de puesto de su personal (department_id, no. movimientos). 
--
SELECT    DEPARTMENT_ID "DEPARTAMENTO" , COUNT(EMPLOYEE_ID) "MOVIMIENTOS" 
FROM      JOB_HISTORY 
GROUP BY  DEPARTMENT_ID 
HAVING    (COUNT(EMPLOYEE_ID) > 1) 
ORDER BY  COUNT(EMPLOYEE_ID); 

SELECT    DEPARTMENT_ID "DEPARTAMENTO", COUNT(*) "MOVIMIENTOS" 
FROM      JOB_HISTORY 
GROUP BY  DEPARTMENT_ID 
HAVING    (COUNT(*) > 1) 
ORDER BY  COUNT(*); 

--
--6. Obtener la nómina que se paga por puesto, no incluir el puesto  SA_REP, para aquellos puestos que tienen una nómina mayor a $50000 (job_id, nómina). 
--
SELECT    JOB_ID "PUESTO", '$ ' || SUM(SALARY) "NOMINA" 
FROM      EMPLOYEES 
WHERE     JOB_ID NOT IN('SA_REP') 
GROUP BY  JOB_ID 
HAVING    SUM(SALARY) > 50000 
ORDER BY  SUM(SALARY) DESC;

SELECT      JOB_ID "PUESTO", '$ ' || SUM(SALARY) "NOMINA" 
FROM        EMPLOYEES  
WHERE       JOB_ID <> 'SA_REP' 
GROUP BY    JOB_ID 
HAVING      SUM(SALARY) > 50000 
ORDER BY    SUM(SALARY) DESC;

--
--7. Obtener el número de empleados por departamento, para los empleados que tienen un salario en el rango de 2000 a 10000 ( department_id, no. empleados). 
--
SELECT      DEPARTMENT_ID "DEPARTAMENTO", COUNT(EMPLOYEE_ID) "EMPLEADOS" 
FROM        EMPLOYEES 
WHERE       SALARY BETWEEN 2000 AND 10000 AND DEPARTMENT_ID IS NOT NULL 
GROUP BY    DEPARTMENT_ID 
ORDER BY    DEPARTMENT_ID ASC; 

SELECT    DEPARTMENT_ID "DEPARTAMENTO", COUNT(*) "EMPLEADOS" 
FROM      EMPLOYEES 
WHERE     SALARY BETWEEN 2000 AND 10000 AND DEPARTMENT_ID IS NOT NULL 
GROUP BY  DEPARTMENT_ID 
ORDER BY  DEPARTMENT_ID ASC; 

--
--8. Obtener el número de empleados que tienen comisión, por puesto (job_id, no.  empleados). 
--
SELECT      JOB_ID "PUESTO", COUNT(EMPLOYEE_ID) "NO. EMPLEADO(S)" 
FROM        EMPLOYEES 
WHERE       COMMISSION_PCT IS NOT NULL 
GROUP BY    JOB_ID 
ORDER BY    COUNT(EMPLOYEE_ID) DESC; 

SELECT      JOB_ID "PUESTO", COUNT(*) "NO. EMPLEADO(S)" 
FROM        EMPLOYEES 
WHERE       NVL(COMMISSION_PCT,0)>0 
GROUP BY    JOB_ID 
ORDER BY    COUNT(*) DESC; 

--
--9. Obtener el no. mayor de empleados a cargo de un administrador. 
--
SELECT      MANAGER_ID "ID ADMINISTRADOR", COUNT(EMPLOYEE_ID) "EMPLEADOS" 
FROM        EMPLOYEES 
WHERE       MANAGER_ID IS NOT NULL 
GROUP BY    MANAGER_ID 
ORDER BY    COUNT(EMPLOYEE_ID) DESC; 

SELECT      MANAGER_ID "ID ADMINISTRADOR", COUNT(*) "EMPLEADOS" 
FROM        EMPLOYEES 
WHERE       MANAGER_ID IS NOT NULL 
GROUP BY    MANAGER_ID 
ORDER BY    COUNT(*) DESC; 

SELECT      MANAGER_ID "ID ADMINISTRADOR", COUNT(*) "NUMERO EMPLEADOS" 
FROM        EMPLOYEES 
WHERE       MANAGER_ID IS NOT NULL 
GROUP BY    MANAGER_ID HAVING COUNT(*) = (SELECT MAX(COUNT(EMPLOYEE_ID)) 
FROM        EMPLOYEES 
WHERE       MANAGER_ID IS NOT NULL 
GROUP BY    MANAGER_ID); 

--
--10. Obtener la primera y última fecha de ingreso o contratación para cada departamento. 
--
SELECT      DEPARTMENT_ID "DEPARTAMENTO" , MIN(HIRE_DATE) || '  ' "PRIMER FECHA", MAX(HIRE_DATE) || '   ' "ULTIMA FECHA"  
FROM        EMPLOYEES 
WHERE       DEPARTMENT_ID IS NOT NULL 
GROUP BY    DEPARTMENT_ID 
ORDER BY    MIN(HIRE_DATE); 
