create database DWNorthwind

use DWNorthwind

create table [dbo].[DimSuppliers](
	[DimSupplierID] [int] Identity (1,1) not null,
	[SupplierID] [int] not null,
	[CompanyName] [nvarchar] (40) null,
	[ContactName] [nvarchar] (30) null,
	[ContactTitle] [nvarchar] (30) null,
	[Address] [nvarchar] (60) null,
	[City] [nvarchar] (15) null,
	[Region] [nvarchar] (15) null,
	[PostalCode] [nvarchar] (10) null,
	[Country] [nvarchar] (15) null,
	[Phone] [nvarchar] (24) null,
	[Fax] [nvarchar] (24) null,
	[HomePage] [ntext] null,
	FechaInicio date,
	FechaFinal date
)


select * from DimSuppliers where SupplierID = 6

use Northwind
update Northwind.dbo.Suppliers set ContactName = 'Bismark Steve Garcia Toruño'
where SupplierID = 6
update Northwind.dbo.Suppliers set ContactTitle = 'Systems Engineer'
where SupplierID = 6
select * from Suppliers


-- Guia 2
Use DWNorthwind
go
create table [dbo].[DimFechas](
	[DimFechaID] [int] identity (1,1) not null,
	[IDFecha] [date] null,
	[Año] [int] null,
	[NoMes] [int] null,
	[NombreMes] [nvarchar] (50) null,
	[Dia] [int] null,
	[NombreDia] [nvarchar] (50) null,
	[Trimestre] [int] null
)

use Northwind

Select distinct OrderDate as IdFecha,
				YEAR(OrderDate) as Año,
				MONTH(OrderDate) as noMes,
				DAY(OrderDate) as Dia,
				DATENAME(WEEKDAY, OrderDate) as NombreDia,
				DATENAME(MONTH, OrderDate) as NombreMes,
				DATEPART(QQ, OrderDate) as Trimestre
			from Northwind.dbo.Orders

use DWNorthwind
select * from DimFechas


CREATE TABLE [dbo].[DimProducts](
	[DimProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[SupplierID] [int] NULL,
	[CategoryID] [int] NULL,
	[QuantityPerUnit] [nvarchar](20) NULL,
	[UnitPrice] [money] NULL,
	[UnitsInStock] [smallint] NULL,
	[UnitsOnOrder] [smallint] NULL,
	[ReorderLevel] [smallint] NULL,
	[Discontinued] [bit] NOT NULL,
	FechaInicio date,
	FechaFinal date
	)

	CREATE TABLE [dbo].[DimCategories](
	[DimCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[CategoryName] [nvarchar](15) NOT NULL,
	[Description] [ntext] NULL,
	[Picture] [image] NULL,
	FechaInicio date,
	FechaFinal date
	)


	select * from DimProducts
	select * from DimCategories

	create table [dbo].[HechosVentas](
		[DimSupplierID] [int] not null,
		[DimProductID] [int] null,
		[DimFechaID] [int] null,
		[DimCategoryID] [int] null,
		[Cantidad] [int] null,
		[Descuento] [float] null,
		[CantidadDescuento] [int] null,
		[CantidadOrdenes] [int] null
	)

Merge dbo.HechosVentas Destino
Using
(Select 
df.DimfechaID as DimFechaID,
de.DimProductID as DimProductID,
dc.DimSupplierID as DimSupplierID ,
ee.DimCategoryID as DimCategoryID,
count(Distinct o.OrderID) as Cantidad,
round (sum(od.Quantity),2) as CantidadOrdenes,
round (sum(od.Discount),2) as Descuento,
round (sum((od.Quantity)- (od.Quantity * od.Discount)),2) as CantidadDescuento
from Northwind.dbo.Orders o
inner join Northwind.dbo.[Order Details] od
on od.OrderID = o.OrderID
inner join DimFechas df
on df.IdFecha = o.OrderDate
inner join DimProducts de
on de.ProductID = od.ProductID
inner join DimSuppliers dc
on dc.SupplierID = de.SupplierID
inner join DimCategories ee
on ee.CategoryID = de.CategoryID
WHERE de.FechaFinal='9999/12/31' AND 
	  dc.FechaFinal='9999/12/31' AND 
	  ee.FechaFinal='9999/12/31' 
Group by
df.DimFechaID,
de.DimProductID,
dc.DimSupplierID,
ee.DimCategoryID) Origen
on
Destino.DimProductID = Origen.DimProductID and
Destino.DimCategoryID = Origen.DimCategoryID and
Destino.DimSupplierID = Origen.DimSupplierID and
Destino.DimFechaID = Origen.DimFechaID
WHEN MATCHED AND (Destino.Cantidad <> Origen.Cantidad or
                  Destino.Descuento <> Origen.Descuento or
				  Destino.CantidadDescuento <> Origen.CantidadDescuento or
				  Destino.CantidadOrdenes <> Origen.CantidadOrdenes)
				  Then
				  Update set
				  Destino.Cantidad = Origen.Cantidad,
                  Destino.Descuento = Origen.Descuento,
				  Destino.CantidadDescuento = Origen.CantidadDescuento,
				  Destino.CantidadOrdenes =Origen.CantidadOrdenes
WHEN NOT MATCHED THEN 
            INSERT
			(DimFechaID, DimProductID, DimSupplierID, DimCategoryID,
			 Cantidad, Descuento, CantidadDescuento, CantidadOrdenes)
			 Values
			 (Origen.DimFechaID,Origen.DimProductID, Origen.DimSupplierID,
			 Origen.DimCategoryID,Origen.Cantidad, Origen.Descuento, Origen.CantidadDescuento, Origen.CantidadOrdenes);

			 -- Verificación
			 select * from HechosVentas