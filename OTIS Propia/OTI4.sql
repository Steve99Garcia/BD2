--OTI 5
use Northwind

/*A) Realizar un procedimiento almacenado que reciba como
	parámetro el año. Determinar la recaudación más alta por
	empleado y por cada mes.
	Presentar:
	Columnas a presentar: Año - Mes - Recaudación - EmployeeID –
	Nombre Empleado*/

create proc SP_Recaudacion
@anio int
as

 select distinct @anio as anio, MONTH(Orders.OrderDate) as mes, 
 MAX(OD.[Quantity]*OD.UnitPrice) as Recaudacion,
 Employees.EmployeeID,(Employees.LastName+' '+Employees.FirstName) as [Nombre Empleado]
 from Orders inner join Employees on Orders.EmployeeID = Employees.EmployeeID
 inner join [Order Details] as OD on Orders.OrderID = OD.OrderID
 where YEAR(Orders.OrderDate)=@anio
 group by MONTH(Orders.OrderDate), Employees.EmployeeID,Employees.LastName,Employees.FirstName
 order by MONTH(Orders.OrderDate)


 exec SP_Recaudacion 1996

 /*
 B) Realizar un procedimiento almacenado que reciba como
parámetro el nombre del mes y el año. Indicar el nombre del
producto y cantidad de unidades vendida que haya obtenido la
tercera posición en montos de ventas.
 Columnas: IdProducto - Nombre del Producto- Cantidades
 Vendidas
 */

 --Creando funcion para convertir el nombre del mes a numero :)
create function fn_nombre_mes_a_numero (@NombMes varchar(25))
returns int as
begin
	declare @NumMes as int;
	select @NumMes =
		case @NombMes
		when 'Enero' then 01
		when 'Febrero' then 02
		when 'Marzo' then 03
		when 'Abril' then 04
		when 'Mayo' then 05
		when 'Junio' then 06
		when 'Julio' then 07
		when 'Agosto' then 08
		when 'Septiembre' then 09
		when 'Octubre' then 10
		when 'Noviembre' then 11
		when 'Diciembre' then 12

		--En Ingles :)
		when 'January' then 01
		when 'February' then 02
		when 'March' then 03
		when 'April' then 04
		when 'May' then 05
		when 'June' then 06
		when 'July' then 07
		when 'August' then 08
		when 'September' then 09
		when 'October' then 10
		when 'November' then 11
		when 'December' then 12
end
	return @NumMes
end


create proc SP_topventas3 
 @mes varchar(25),
 @anio int
 as

 select P.ProductID, P.ProductName, SUM(OD.Quantity) as [Cantidad Unds Vendidas]
  from [Order Details] as OD INNER JOIN Orders as O on O.OrderID=OD.OrderID
  INNER JOIN Products as P on P.ProductID=OD.ProductID
  where YEAR(O.OrderDate)=@anio and MONTH(O.OrderDate) = dbo.fn_nombre_mes_a_numero(@mes)
  group by P.ProductID, P.ProductName, OD.Quantity
 order by SUM(OD.ProductID * OD.Quantity)desc
  OFFSET 2 Rows
  Fetch Next 1 row only

  exec SP_topventas3 'Abril',1997


