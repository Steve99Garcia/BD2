-- =============================================
-- Respuesta de los ejercicios de la guia: 
-- Ejercicios y Tareas
-- ================================================================================
-- 1)	Mostrar toda la informaci�n sobre los cursos cuya tarifa es menor que 150
-- ================================================================================
SELECT *
FROM CURSO
WHERE CTARIFA < 150
-- ================================================================================
-- 2)Todas las filas en las que el nombre del curso es superior o igual alfab�ticamente
--    a RACIONALISMO.
-- ================================================================================
SELECT *
FROM CURSO
WHERE CNOMBRE >='Racionalismo'
-- ================================================================================
--3)Obtener sin valores repetidos el conjunto de todas las tarifas de los cursos
-- ================================================================================
SELECT distinct CTARIFA 
FROM CURSO
-- ================================================================================
--4)Obtener de la tabla personal ordenada por el nombre de los empleados
-- ================================================================================
SELECT *
FROM PERSONAL
ORDER BY ENOMBRE


-- ================================================================================
-- 53)Visualizar el numero de estudiantes y la fecha de MATRICULA  de todos los estudiantes 
-- que est�n matriculados de al menos un curso ofrecido por un departamento ubicado en el 
-- edificio Ciencias SC.
-- ================================================================================
SELECT SON, FECHA_MAT
FROM MATRICULA
WHERE CON IN (SELECT CNO FROM CURSO WHERE CDEPT IN (
	SELECT DEPT FROM DEPARTAMENTO WHERE DEDIF = 'SC'))


-- ================================================================================
-- 54)Visualizar el nombre y n�mero de ayudantes para aquellos miembros de la 
-- facultad que tienen tantos ayudantes como el n�mero de cr�ditos ofrecidos 
-- por cualquier curso.
-- ================================================================================
SELECT FNUMDPE, FNOMBRE FROM CLAUSTRO
WHERE FNUMDPE = ANY (SELECT CRED FROM CURSO)

-- ================================================================================
-- 55)Visualizar el nombre y el identificador de departamento de cualquier miembro 
-- del claustro asignado a un departamento que ofrezca un curso de 6 cr�ditos
-- ================================================================================

SELECT FDEP,FNO,FNOMBRE FROM CLAUSTRO
WHERE FDEP IN (SELECT CDEPT FROM CURSO WHERE CRED = 6)

-- OTRA FORMA

SELECT FDEP,FNO,FNOMBRE FROM CLAUSTRO WHERE EXISTS (
	SELECT * FROM CURSO WHERE CDEPT = CLAUSTRO.FDEP AND CRED = 6)

-- ================================================================================
-- 57) Visualizar el nombre y el departamento de cualquier miembro de la facultad que no
-- est� impartiendo clases durante este semestre
-- ================================================================================
SELECT FNOMBRE, FDEP FROM CLAUSTRO
WHERE FNO NOT IN (SELECT CINSTRFNO FROM CLASE)

-- ================================================================================
-- 58) Visualizar el n�mero de curso y nombre en donde se halle registrado el estudiante 800.
-- ================================================================================

SELECT CNO, CNOMBRE FROM CURSO WHERE CNO IN 
	(SELECT CON FROM MATRICULA WHERE SON = '800')

-- ================================================================================
-- 59)Visualizar toda la informaci�n acerca de cualquier curso de Inform�tica y Ciencias 
-- de la Informaci�n con una tarifa menor que el sueldo medio de cualquiera asignado al 
-- departamento de Teolog�a.
-- ================================================================================
SELECT * FROM CURSO WHERE CDEPT = 'CIS' AND CTARIFA < (SELECT AVG(ESUELDO)
                 FROM PERSONAL WHERE DEPT = 'THEO')

-- ================================================================================
-- 60) Visualizar el nombre y el salario de cualquier empleado miembro del personal 
-- cuyo sueldo sea menor o igual que la m�xima tarifa del curso.
-- ================================================================================
SELECT ENOMBRE,ESUELDO
FROM PERSONAL
WHERE ESUELDO <= (SELECT MAX(CTARIFA)
                 FROM CURSO)
-- ================================================================================
-- 61)Visualizar el nombre, n�mero, departamento y tarifa de los cursos que tienen 
-- la segunda tarifa mas cara sabiendo que la tarifa mas cara es 500.
-- ================================================================================
SELECT CNOMBRE,CNO,CDEPT,CTARIFA FROM CURSO
WHERE CTARIFA = (SELECT MAX(CTARIFA)  FROM CURSO WHERE CTARIFA <> 500)
-- ================================================================================
-- 62)Visualizar el n�mero, nombre y departamento de los cursos con la m�nima tarifa.
-- ================================================================================
SELECT CNO, CDEPT, CNOMBRE
FROM CURSO
WHERE CTARIFA = (SELECT  MIN(CTARIFA) 
                  FROM CURSO)
-- ================================================================================
-- 63)Hallar la tarifa media para aquellos departamentos en los que dicha 
-- tarifa media sea mayor que 100 y que ofrezcan menos de seis cursos.
-- ================================================================================
SELECT  AVG(CTARIFA) AS [TARIFA MEDIA], CDEPT
FROM CURSO
GROUP BY CDEPT
HAVING AVG(CTARIFA) > 100 AND COUNT(*) < 6
-- ================================================================================
-- 64) Hallar las tarifas media, m�xima y m�nima por cr�dito dentro de cada 
-- departamento s�lo para aquellos grupos con tarifa m�nima positiva.
-- ================================================================================
SELECT CDEPT, CRED, AVG(CTARIFA) AS [TARIFA MEDIA], MAX(CTARIFA) AS [TARIFA MAXIMA],
MIN(CTARIFA)AS [TARIFA MINIMA] FROM CURSO
GROUP BY CRED,CDEPT
HAVING MIN(CTARIFA) > 0

-- ================================================================================
-- 65)Pata todos los departamentos excepto el de Teolog�a, que tengan una tarifa media 
-- de sus cursos mayor que 100, obtener su identificaci�n y su tarifa media.
-- ================================================================================
SELECT CDEPT,AVG(CTARIFA) AS [TARIFA MEDIA] FROM CURSO WHERE CDEPT <>'THEO' 
GROUP BY CDEPT HAVING AVG(CTARIFA) > 100

-- ================================================================================
-- 68)Para cada departamento al que se hace referencia en la tabla PERSONAL formar un 
-- comit� compuesto por dos miembros del personal del departamento de modo que, para cada 
-- posible pareja de miembros del personal se visualice su c�digo de departamento seguido 
-- de los nombres de los miembros del personal. El resultado debe contener una fila por cada 
-- posible pareja de miembros del personal.

-- ================================================================================
SELECT distinct PER1.ENOMBRE, PER2.ENOMBRE
FROM PERSONAL PER1 INNER JOIN PERSONAL PER2
ON PER1.DEPT = PER2.DEPT AND PER1.ENOMBRE < > PER2.ENOMBRE
-- ================================================================================
-- 69)	Para cualquier curso que tenga un miembro del personal disponible para ser 
-- tutor, visualizar el n�mero, nombres y cargos de los miembros del personal que pueden 
-- servir de tutores para ese curso y la ubicaci�n de sus respectivos edificios 
--  y despachos. Clasificar la salida por nombre de los miembros del personal y n�mero de curso.
-- ================================================================================
SELECT CNO,ENOMBRE,CARGO
FROM CURSO,PERSONAL,DEPARTAMENTO
WHERE CDEPT = PERSONAL.DEPT AND PERSONAL.DEPT = DEPARTAMENTO.DEPT
ORDER BY CNO, ENOMBRE
-- ================================================================================
-- 70)Para cada departamento que ofrece servicios de tutor�a, visualizar el identificador 
-- de departamento junto con la tarifa media de los cursos que �ste ofrece y el sueldo medio 
-- de los miembros del personal que pueden autorizar dichos cursos. Clasificar la salida por 
-- identificador de departamento.
-- ================================================================================

SELECT AVG(CTARIFA)AS [TARIFA MEDIA],CDEPT,AVG(ESUELDO)AS [SUELDO MEDIO]
FROM CURSO,PERSONAL
WHERE CDEPT = DEPT
GROUP BY CDEPT
ORDER BY CDEPT

-- ================================================================================
-- 72)Para cada curso con una tarifa superior a 175, mostrar el nombre del curso, 
-- tarifa y numero de facultativo del jefe responsable del curso, visualizando la 
-- salida en orden ascendente por nombre de curso.
-- ================================================================================
SELECT CNOMBRE, CTARIFA
FROM CURSO INNER JOIN DEPARTAMENTO
ON CDEPT = DEPT AND  CTARIFA > 175
ORDER BY CNOMBRE
-- ================================================================================
-- 73) Para cada miembro del personal cuyo salario anual excede de 1000 visualizar 
--     su nombre, c�digo de departamento y edificio de destino.
-- ================================================================================
SELECT ENOMBRE,ESUELDO,DEPARTAMENTO.DEPT,DEDIF
FROM PERSONAL INNER JOIN DEPARTAMENTO
ON PERSONAL.DEPT = DEPARTAMENTO.DEPT where ESUELDO > 1000
-- ================================================================================
--74)  De todo el personal asignado a los actuales departamentos, seleccionar toda
--     la informaci�n acerca del personal y sus respectivos departamentos.
-- ================================================================================
SELECT ENOMBRE, CARGO, ESUELDO,DEPARTAMENTO.DEPT
FROM PERSONAL,DEPARTAMENTO
WHERE PERSONAL.DEPT = DEPARTAMENTO.DEPT
-- Consulta analoga con INNER JOIN
SELECT ENOMBRE, CARGO, ESUELDO,DEPARTAMENTO.DEPT
FROM PERSONAL INNER JOIN DEPARTAMENTO
ON PERSONAL.DEPT = DEPARTAMENTO.DEPT
