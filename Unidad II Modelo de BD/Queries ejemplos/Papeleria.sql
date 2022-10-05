-- Último ejercicio del PDF

use master

go

-- Verifica si la base de datos existe para eliminarla
if exists(select * from master.sys.sysdatabases 
          where name='Papeleria')
begin
    drop database Papeleria
end

go

-- Creando la base de datos
create database Papeleria

go

-- Restaurando la base de datos
--restore database Papeleria from disk='D:\Papeleria.bak' with replace

use Papeleria

go

-- Creando tablas

-- Creando tabla de cliente
create table Cliente(
	Codigo int not null,
	Descrip nvarchar(30),
	Dir nvarchar(30)

	constraint PK_Cliente primary key (Codigo)

)

go

-- Creando tabla de Vendedor
create table Vendedor(
	Codigo int not null,
	Telefono int,
	Nombre nvarchar(16),
	Dir nvarchar(30),

	constraint PK_Vendedor primary key (Codigo)

)

go

-- Creando tabla de Producto
create table Producto(
	Codigo int not null,
	Descrip nvarchar(16),
	Precio int,

	constraint PK_Producto primary key (Codigo)
)

go

-- Creando tabla de Factura
create table Factura(
	Numero int not null,
	Fecha_V date,
	Forma_Pago nvarchar(10),
	Codigo_Cliente int,
	Codigo_Vendedor int,
	Fecha date,
	Descuento int

	constraint PK_Factura primary key (Numero)
)

go

-- Creando tabla de detalle_factura
create table Detalle_Factura(
	
	Numero int not null,
	Codigo_Producto int not null,
	Und_Vendidas int,

	
)

go

-- Agregando las foreign keys

-- Relación Cliente - Factura
Alter table Factura
add foreign key (Codigo_Cliente) references Cliente(Codigo)

go

-- Relación Factura - Vendedor
Alter table Factura
add foreign key (Codigo_Vendedor) references Vendedor(Codigo)

go

-- Relación Detalle_Factura - Producto
Alter table Detalle_Factura
add foreign key (Codigo_Producto) references Producto(Codigo)

go

-- Relación Detalle_Factura - Factura
Alter table Detalle_Factura
add foreign key (Numero) references Factura(Numero)

-- Creación de clave primaria compuesta
Alter table Detalle_Factura
add primary key (Numero, Codigo_Producto)

-- Realizando el respaldo de la base de datos
--backup database Papeleria to disk='D:\Papeleria.bak'