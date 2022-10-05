use Northwind

--1)
create proc fechaciudad
@FINICIAL DATETIME,
@FFINAL SMALLDATETIME ,
@ciudad NVARCHAR(15)
AS
SELECT Employees.EmployeeID,(Employees.LastName+' '+Employees.FirstName) as [Nombre Empleado], Orders.OrderDate, Employees.City as Ciudad
 from Orders inner join Employees on Orders.EmployeeID = Employees.EmployeeID
WHERE OrderDate BETWEEN @FINICIAL AND @FFINAL
AND City = @ciudad

EXEC fechaciudad '07/23/1996','01/23/1997', 'London'

select * from employees
select * from Orders

-- 2)

CREATE PROCEDURE INSERTA_EMPLEADO
@apellido NVARCHAR(20),
@Nombre NVARCHAR(20),
@title nvarchar(30),
@titlecourtesy nvarchar(25),
@F_Nac datetime,
@H_Date datetime,
@direccion nvarchar(60),
@ciudad nvarchar(15),
@region nvarchar(15),
@postalcode nvarchar(10),
@country nvarchar(15),
@homephone nvarchar(24),
@extension nvarchar(4),
@photo image,
@notes ntext,
@reportsto int,
@photopath nvarchar(255)

AS

INSERT INTO Employees VALUES
(
@apellido,
@Nombre,
@title,
@titlecourtesy,
@F_Nac,
@H_Date,
@direccion,
@ciudad,
@region,
@postalcode,
@country,
@homephone,
@extension,
@photo,
@notes,
@reportsto,
@photopath)

exec INSERTA_EMPLEADO 'Bendaña', 'Fernanda','','','','','','','','','','','','','','',''