-- 3 Ejercicio (Mantenimiento) del PDF

use master

go

-- Verifica si la base de datos existe para eliminarla
if exists(select * from master.sys.sysdatabases 
          where name='Mantenimiento')
	begin
		drop database Mantenimiento
	end

go

-- Creando la base de datos
create database Mantenimiento

go

-- Restaurando la base de datos
--restore database Papeleria from disk='D:\Mantenimiento.bak' with replace

use Mantenimiento

go

-- Creando tablas

-- Creando tabla de Cliente
create table Cliente(
	Id_Cliente int not null,
	P_Nombre nvarchar(15) not null,
	S_Nombre nvarchar(15),
	Apellido_P nvarchar(15),
	Apellido_M nvarchar(15),
	

	constraint PK_Cliente primary key (Id_Cliente)

)

go

-- Creando tabla de Vehiculo
create table Vehiculo(
	Id_Vehiculo int not null,
	Placa nvarchar(16) not null,
	Id_Cliente int not null,

	constraint PK_Vehiculo primary key (Id_Vehiculo)

)

go

-- Creando tabla de Respuesto
create table Repuesto(
	No_Repuesto int not null,
	Titulo nvarchar(20),
	Descrip nvarchar(30),
	Marca nvarchar(15),
	Modelo nvarchar(15),
	Precio money

	constraint PK_Repuesto primary key (No_Repuesto)
)

go

-- Creando tabla Mantenimiento
create table Mantenimiento(
	No_Servicio int not null,
	Descrip nvarchar(30),
	Precio Money,
	Tipo nvarchar(10),
	Id_Cliente int not null,
	Id_Vehiculo int not null,
	Fecha_Ingreso date,
	Fecha_Salida date,

	constraint PK_Mantenimiento primary key (No_Servicio)
)

go

-- Creando tabla de Detalle_Mantenimiento
create table Detalle_Mantenimiento(
	
	No_Servicio int not null,
	No_Repuesto int not null,
	Cantidad int,
	
)

go

-- Agregando las foreign keys

-- Relación Cliente - Vehiculo
Alter table Vehiculo
add foreign key (Id_Cliente) references Cliente(Id_Cliente)

-- Relación Cliente - Mantenimiento
Alter table Mantenimiento
add foreign key (Id_Cliente) references Cliente(Id_Cliente)

-- Relación Mantenimiento - Vehiculo
Alter table Mantenimiento
add foreign key (Id_Vehiculo) references Vehiculo(Id_Vehiculo)

-- Relación Mantenimiento -  Detalle_Mantenimiento
Alter table Detalle_Mantenimiento
add foreign key (No_Servicio) references Mantenimiento(No_Servicio)

-- Relación Mantenimiento -  Detalle_Mantenimiento
Alter table Detalle_Mantenimiento
add foreign key (No_Repuesto) references Repuesto(No_Repuesto)

-- Creación de clave primaria compuesta
Alter table Detalle_Mantenimiento
add primary key (No_Servicio, No_Repuesto)

-- Realizando el respaldo de la base de datos
--backup database Papeleria to disk='D:\Mantenimiento.bak'