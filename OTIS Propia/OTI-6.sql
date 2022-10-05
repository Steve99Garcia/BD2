--OTI 6
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


 create proc recaudacionMasAltaEM @anio int
AS
	SELECT * FROM(
	SELECT '' + @anio Anio ,*, RANK() OVER (PARTITION BY Mes ORDER BY [Recaudacion mensual] DESC) C
	FROM
	(SELECT MONTH(O.OrderDate) Mes, SUM(OD.UnitPrice * OD.Quantity) [Recaudacion mensual], E.EmployeeID ID, E.LastName Apellido
	FROM Orders O
	JOIN Employees E ON E.EmployeeID = O.EmployeeID
	JOIN [Order Details] OD ON OD.OrderID = O.OrderID
	WHERE YEAR(OrderDate) = @anio
	GROUP BY MONTH(O.OrderDate), E.LastName, E.EmployeeID) TEMP) AUX
	WHERE AUX.C = 1

EXEC recaudacion 1997

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


  --C)  Calcular las recaudaciones por año y por trimestre.

select YEAR(O.OrderDate) Anio, DATEPART(QUARTER, O.OrderDate) Trimestre,
SUM(OD.UnitPrice * OD.Quantity - (OD.UnitPrice * OD.Quantity * OD.Discount)) Recaudacion
from Orders O
join [Order Details] OD on OD.OrderID = O.OrderID
group by YEAR(O.OrderDate), DATEPART(QUARTER, O.OrderDate)
order by YEAR(O.OrderDate) ,DATEPART(QUARTER,O.OrderDate) asc

/*D) Tomando de referencia el ejercicio anterior, presentar
únicamente los trimestres cuya recaudación sea mayor a
140,000.00*/

select YEAR(O.OrderDate) Anio, DATEPART(QUARTER, O.OrderDate) Trimestre,
SUM(OD.UnitPrice * OD.Quantity - (OD.UnitPrice * OD.Quantity * OD.Discount)) Recaudacion
from Orders O
join [Order Details] OD on OD.OrderID = O.OrderID
group by YEAR(O.OrderDate), DATEPART(QUARTER, O.OrderDate)
having SUM(OD.UnitPrice * OD.Quantity - (OD.UnitPrice * OD.Quantity * OD.Discount)) > 140000.00
order by YEAR(O.OrderDate)

-- E) Calcular las recaudaciones por año y por mes.

select YEAR(O.OrderDate) as Anio, DATENAME(MONTH,O.OrderDate) as Mes,
SUM(OD.UnitPrice * OD.Quantity - (OD.UnitPrice * OD.Quantity * OD.Discount)) as Recaudacion
From [Order Details] as OD join Orders as O on OD.OrderID = O.OrderID
Where YEAR(O.OrderDate) is not Null
group by YEAR(O.OrderDate),DATENAME(MONTH,O.OrderDate)
order by Anio asc 

/*F) Calcular el promedio de recaudación por año. Consistirá en la
sumatoria de recaudaciones por mes divididas entre el número de
meses en las que hubo recaudación.*/

select Anio, AVG([Importe mensual]) [Promedio de Recaudacion Anual]
from (select YEAR(O.OrderDate) Anio, MONTH(O.OrderDate) Mes,
SUM(OD.UnitPrice * OD.Quantity - (OD.UnitPrice * OD.Quantity * OD.Discount)) [Importe mensual]
		from Orders O
		join [Order Details] OD
		on O.OrderID = OD.OrderID
		group by MONTH(O.OrderDate), YEAR(O.OrderDate)) TEMP
group by Anio

/*G) Utilizando SubConsulta Escalar, presentar la siguiente
información: IdProducto, ProductName, CantidadVendida:
Sumatoria de las cantidades vendidas del producto;
CantidadÓrdenes: Cantidad de órdenes en la que el producto ha
sido vendido; CantidadDescuento: Cantidad de órdenes en la
que el producto ha recibido descuento; CantidadSinDescuento:
Cantidad de órdenes en la que el producto no ha recibido
descuento.*/

Select P.ProductID,P.ProductName,Sum(OD.Quantity)as [Cantidad Vendida],COUNT(OD.Quantity) as [CantidadÓrdenes],
(Select COUNT(ProductID) From [Order Details] Where ProductID = P.ProductID and Discount != 0) as [Cantidad Descuentos],
(Select COUNT(ProductID) From [Order Details]
Where ProductID = P.ProductID and Discount = 0) as [Cantidad sin Descuentos]
From Products as P join [Order Details] as OD on OD.ProductID = P.ProductID 
group by P.ProductID,P.ProductName
order by [Cantidad Vendida] desc

/*H) Utilizando Inner Join establecer un análisis de venta por cada uno
de los empleados de la organización: EmployeeID,
NombreCompleto: Nombre + Apellido, EdadEmpleado, Cantidad:
Cantidad de órdenes atendidas, CantidadPaíses: Cantidad de
Países atendidos, CantidadClientes: CantidadClientes,
VentasEmpleado: Monto por ventas incluyendo descuentos por
empleado.*/
select E.EmployeeID, E.FirstName + E.LastName [Nombre completo], (YEAR(GETDATE()) - YEAR(E.BirthDate)) [Edad],
COUNT(distinct O.OrderID) Cantidad, COUNT(distinct C.Country) [Cantidad de paises],
COUNT(distinct C.CustomerID) [Cantidad de clientes],
SUM(OD.UnitPrice * OD.Quantity - (OD.UnitPrice * OD.Quantity * OD.Discount)) [Ventas empleado]
from Orders O
inner join [Order Details] OD on O.OrderID = OD.OrderID
inner join Employees E on O.EmployeeID = E.EmployeeID
inner join Customers C on C.CustomerID = O.CustomerID
group by E.EmployeeID, E.FirstName + E.LastName, (YEAR(GETDATE()) - YEAR(E.BirthDate))

/*I) Establecer la cantidad de órdenes por país y su representación en
porcentaje respecto a la cantidad total de órdenes. Nota: La
Sumatoria en porcentaje tiene que ser 100.*/

select distinct ShipCountry, COUNT(OrderID) [Cantidad de ordenes], CONVERT(varchar,
CAST(COUNT(ShipCountry) * 100.0 / (select COUNT(OrderID) from Orders) as decimal(18, 2))) + ' %' Porcentaje
from Orders
group by ShipCountry
order by COUNT(OrderID) desc

/*J) Consultar la cantidad de órdenes realizadas por país y ciudad,
ordenarlo por país y cantidad de órdenes en forma descendente.*/

select ShipCountry as Pais, ShipCity as Ciudad, COUNT(OrderID) [Cantidad de ordenes]
from Orders
group by ShipCountry, ShipCity
order by ShipCountry, COUNT(OrderID) desc

/*k) Tomando de referencia el ejercicio anterior, consultar la cantidad
de órdenes realizadas por país y ciudad, mostrando únicamente
el país con la ciudad que ha realizado la mayor cantidad de
órdenes.*/

select ShipCountry as Pais, ShipCity as Ciudad, [Cantidad de ordenes] [Cantida maxima]
from (select *, RANK() over(partition by ShipCountry order by [Cantidad de ordenes] desc) AUX
from (select ShipCountry, ShipCity, COUNT(OrderID) [Cantidad de ordenes]
	from Orders
	group by ShipCountry, ShipCity) CC) TEMP
where TEMP.AUX = 1
order by ShipCountry, [Cantidad de ordenes] desc

/* N) Realizar un procedimiento almacenado que reciba como
parámetro el año. Calcular el promedio de recaudación basado en
12 meses y presente cual es la recaudación del mes más cercana 
al promedio.
*/

create proc promreacuda @anio int
as
	declare @recaudacionPromedioAnual float
	set @recaudacionPromedioAnual = (select [Recaudacion anual] / 12 [Recaudacion anual promedio]
	from(select SUM(case when YEAR(O.OrderDate) = @anio 
	then (OD.UnitPrice * OD.Quantity - (OD.UnitPrice * OD.Quantity * OD.Discount)) else 0 end) [Recaudacion anual]
		from Orders O
	join [Order Details] OD on OD.OrderID = O.OrderID) AUX)

	select top(1) *
	from(select  @anio Anio, MONTH(O.OrderDate) Mes,
	DateName( month , DateAdd( month , MONTH(O.OrderDate) , 0 ) - 1 ) [Nombre del mes], @recaudacionPromedioAnual [Recaudacion promedio anual],
	SUM(case when YEAR(O.OrderDate) = @anio then (OD.UnitPrice * OD.Quantity - (OD.UnitPrice * OD.Quantity * OD.Discount)) else NULL end) [Recaudacion mensual]
		from Orders O
		join [Order Details] OD on OD.OrderID = O.OrderID
		GROUP BY MONTH(O.OrderDate)
	) TA
	where [Recaudacion mensual] is not null
	order by ABS([Recaudacion promedio anual] - [Recaudacion mensual]) asc

exec promreacuda 1997
