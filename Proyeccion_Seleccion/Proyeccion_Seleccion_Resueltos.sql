 /*---------------------------------------------------------------------
  -                                                                    -
  -            SQL Select I, Eighteen Practical Excercises             -
  -                   Oracle RDBMS 12c/19c, HR Scheme                  -
  -           Ing. Jesús José Navarrete Baca (@checheswap)             -
  -                           March 2020                               -
  -                                                                    -
  ---------------------------------------------------------------------*/

--
--1. Obtener employee_id y el first_name de los empleados, que su nombre contenga el carácter “R” en cualquier posición.
--
SELECT  employee_id "->ID EMPLEADO", first_name "->NOMBRE" 
FROM    employees 
WHERE   UPPER(first_name) LIKE '%R%' 
ORDER   BY first_name;

--
--2. Obtener  employee_id,  first_name,  job_id y department_id  de  los  empleados, ordenados por job_id  y deparment_id.
--
SELECT    employee_id "->ID EMPLEADO", first_name "->NOMBRE", job_id "->ID EMPLEO", department_id "ID DE DEPARTAMENTO" 
FROM      employees 
ORDER BY  job_id ASC, department_id ASC;

SELECT    employee_id "->ID EMPLEADO", first_name "->NOMBRE", job_id "->ID EMPLEO", department_id "ID DE DEPARTAMENTO" 
FROM      employees 
ORDER BY  job_id DESC, department_id DESC;

--
--3. Obtener employee_id, first_name y commissión_pct de los empleados que no tienen asignado un porcentaje de comisión.
--
SELECT  employee_id "->ID EMPLEADO", first_name "-> NOMBRE", commission_pct || 'SIN ASIGNAR' "->COMISION" 
FROM    employees 
WHERE   commission_pct IS NULL;

--
--4. Obtener el first_name de aquellos empleados que su nombre contenga una letra ‘L’ en la segunda posición.
--
SELECT  first_name FROM employees 
WHERE   UPPER(first_name) LIKE '_L%';

SELECT  first_name 
FROM    employees 
WHERE   first_name LIKE '_L%';

--
--5. Obtener un listado de los puestos (job_id) ocupados en la organización (no repetición).
--
SELECT  DISTINCT job_id 
FROM    jobs;

SELECT    job_id "ID PUESTO" 
FROM      employees 
GROUP BY  job_id 
ORDER BY  job_id ASC;

--
--6. Obtener de los departamentos 10 y 60, el first_name , job_id y el deparment_id  de los empleados que están asignados a dichos departamentos.
--
SELECT    first_name "->NOMBRE", job_id "->ID PUESTO", department_id "->ID DEPARTAMENTO" 
FROM      employees 
WHERE     department_id IN(10,60) 
ORDER BY  job_id DESC;

SELECT      A.first_name "->NOMBRE",  A.job_id "->ID PUESTO", B.department_id "->ID DEPARTAMENTO" 
FROM        employees A 
INNER JOIN  departments B
ON          A.department_id = B.department_id
WHERE       A.department_id IN(10,60) 
ORDER BY    A.first_name ASC;

SELECT        CL.first_name "->NOMBRE", CL.job_id "->ID PUESTO" , DP.department_id "->ID DEPARTAMENTO" 
FROM          departments DP 
LEFT JOIN     employees CL
ON            DP.department_id = CL.department_id 
WHERE         DP.department_id IN (10,60) 
ORDER BY      CL.first_name;

--
--7. Obtener el first_name y commission_pct de los empleados que tienen un porcentaje de  comisión mayor 0.3.
--
SELECT    first_name "-> NOMBRE", commission_pct "->COMISION" 
FROM      employees WHERE commission_pct > .3 
ORDER BY  first_name ASC;

--
--8. Obtener el first_name y salary de los empleados del departamento 50, ordenados descendentemente por salary.
--
SELECT    first_name "->NOMBRE", salary "->SALARIO" 
FROM      employees 
WHERE     department_id = 50 
ORDER BY  salary DESC;

--
--9. Obtener el first_name de los empleados, que su nombre tiene una longitud 4 caracteres.
--
SELECT    first_name "NOMBRE" 
FROM      employees 
WHERE     LENGTH(first_name) = 4 
ORDER BY  first_name ASC;

SELECT    first_name "NOMBRE"  
FROM      employees 
WHERE     first_name LIKE ‘____’ 
ORDER BY  first_name ASC;

--
--10. Obtener el first_name y manager_id de los subordinados de los administradores  148 y 149, ordenados por el first_name.
--
SELECT    first_name "->NOMBRE", manager_id "->MANAGER ID" 
FROM      employees 
WHERE     manager_id IN(148,149) 
ORDER BY  first_name ASC;

SELECT    first_name "->NOMBRE", manager_id "->MANAGER ID" 
FROM      employees 
WHERE     manager_id = 148 OR manager_id = 149 
ORDER BY  first_name ASC;

--
--11. Obtener el first_name, job_id, y salary de aquellos empleados que el first_name contenga  el carácter ‘L’ en cualquier posición, el job_id sea ‘SA_REP’ y su salary  sea mayor a 9600.
--
SELECT  first_name "->NOMBRE", job_id "->ID PUESTO", salary "->SALARIO" 
FROM    employees 
WHERE   UPPER(first_name) LIKE '%L%' AND job_id = 'SA_REP' 
        AND salary > 9600;

SELECT  first_name "->NOMBRE", job_id "->ID PUESTO", salary "->SALARIO" 
FROM    employees 
WHERE   first_name LIKE '%L%' 
        AND job_id = 'SA_REP' 
        AND salary > 9600;
--
--12. Obtener employee_id y first_name de aquellos empleados, que su employee_id este en el rango del 170  al  177 incluyéndolos. 
--
SELECT    employee_id "->ID EMPLEADO", first_name "->NOMBRE" 
FROM      employees 
WHERE     employee_id BETWEEN 170 AND 177 
ORDER BY  first_name ASC;

SELECT    employee_id "->ID EMPLEADO", first_name "->NOMBRE" 
FROM      employees 
WHERE     employee_id >= 170 
          AND employee_id <= 177 
ORDER BY  first_name ASC;

--
--13. Obtener el employee_id, first_name y department_id de los empleados que no laboran en el departamento de 50.
--
SELECT    employee_id "->ID EMPLEADO", first_name "->NOMBRE", department_id "->ID DEPARTAMENTO" 
FROM      employees 
WHERE     department_id <> 50 
ORDER BY  first_name ASC;

--
--14. Obtener el employee_id, first_name y job_id de los empleados que ocupan el puesto de SA_MAN, (no incluir a John).
--
SELECT    employee_id "-> ID EMPLEADO", first_name "->NOMBRE", job_id "->ID PUESTO"
FROM      employees 
WHERE     job_id = 'SA_MAN' 
AND       UPPER(first_name) <> 'JOHN' 
ORDER BY  first_name ASC;

--
--15. Obtener el first_name, salary y el salary con un aumento del 1% para los empleados que ocupan el puesto SA_REP y trabajan en el departamento 80.
--
SELECT    first_name "->NOMBRE", salary "SALARIO", ((salary/100) + salary) "->SALARIO + 1%" 
FROM      employees 
WHERE     job_id = 'SA_REP' 
AND       department_id = 80 
ORDER BY  first_name ASC;

--
--16. Obtener el employee_id, first_name y job_id de los empleados que no ocupan el  puesto de SA_MAN, ordenado por el first_name.
--
SELECT    employee_id "->ID EMPLEADO", first_name "->NOMBRE", job_id "->ID PUESTO" 
FROM      employees 
WHERE     job_id <> 'SA_MAN' 
ORDER BY  first_name ASC;

--
--17. Obtener el employee_id, first_name y manager_id de los empleados que no son subordinados del manager 146.
--
SELECT      employee_id "->ID EMPLEADO", first_name "->NOMBRE", manager_id "->MANAGER ID" 
FROM        employees 
WHERE       manager_id <> 146 
ORDER BY    first_name ASC;

--
--18. Obtener e l employee_id , first_name, department_id y salary de los empleados del departamento 50 que tienen un salary mayor a 2500.
--
SELECT    employee_id "->ID EMPLEADO", first_name "->NOMBRE", department_id "->ID DEPARTAMENTO", salary "->SALARIO" 
FROM      employees 
WHERE     department_id = 50 
AND       salary > 2500 
ORDER BY  first_name ASC;




