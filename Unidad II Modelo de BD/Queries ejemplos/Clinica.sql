-- 1 Ejercicio (Clinica) del PDF

use master

go

-- Verifica si la base de datos existe para eliminarla
if exists(select * from master.sys.sysdatabases 
          where name='Clinica3')
	begin
		drop database Clinica3
	end

go

-- Creando la base de datos
create database Clinica3

go

-- Restaurando la base de datos
--restore database Papeleria from disk='D:\Clinica3.bak' with replace

use Clinica3

go

-- Creando tablas

-- Creando tabla de Paciente
create table Paciente(
	No_Paciente int not null,
	P_Nombre nvarchar(15) not null,
	S_Nombre nvarchar(15),
	Apellido_P nvarchar(15),
	Apellido_M nvarchar(15),
	Cedula nvarchar(16),
	Edad int,

	constraint PK_Paciente primary key (No_Paciente)

)

go

-- Creando tabla de Medico
create table Medico(
	Id_Medico int not null,
	P_Nombre nvarchar(15) not null,
	S_Nombre nvarchar(15),
	Apellido_P nvarchar(15),
	Apellido_M nvarchar(15),
	Especilizacion nvarchar(30)

	constraint PK_Medico primary key (Id_Medico)

)

go

-- Creando tabla de Medicamento
create table Medicamento(
	No_Medicamento int not null,
	Nombre nvarchar(15)

	constraint PK_Medicamento primary key (No_Medicamento)
)

go

-- Creando tabla Consulta
create table Consulta(
	No_Consulta int not null,
	No_Paciente int,
	Id_Medico int,
	Fecha date,

	constraint PK_Consulta primary key (No_Consulta)
)

go

-- Creando tabla de Detalle_Consulta
create table Detalle_Consulta(
	
	No_Consulta int not null,
	No_Medicamento int not null,
	Cantidad int,
	Dosis int,

	
)

go

-- Agregando las foreign keys

-- Relación Consulta - Medico
Alter table Consulta
add foreign key (No_Paciente) references Paciente(No_Paciente)

go

-- Relación Consulta -	Medico
Alter table Consulta
add foreign key (Id_Medico) references Medico(Id_Medico)

go

-- Relación Consulta -  Detalle_Consulta
Alter table Detalle_Consulta
add foreign key (No_Consulta) references Consulta(No_Consulta)

go

-- Relación Detalle_Factura - Medico
Alter table Detalle_Consulta
add foreign key (No_Medicamento) references Medicamento(No_Medicamento)

-- Creación de clave primaria compuesta
Alter table Detalle_Consulta
add primary key (No_Consulta, No_Medicamento)

-- Realizando el respaldo de la base de datos
--backup database Papeleria to disk='D:\Clinica3.bak'