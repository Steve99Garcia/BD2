-- 2 Ejercicio (Matricula) del PDF

use master

go

-- Verifica si la base de datos existe para eliminarla
if exists(select * from master.sys.sysdatabases 
          where name='Matricula')
	begin
		drop database Matricula
	end

go

-- Creando la base de datos
create database Matricula

go

-- Restaurando la base de datos
--restore database Papeleria from disk='D:\Mantenimiento.bak' with replace

use Matricula

go

-- Creando tablas

-- Creando tabla de Estudiante
create table Estudiante(
	Numero int not null,
	P_Nombre nvarchar(15) not null,
	S_Nombre nvarchar(15),
	Apellido_P nvarchar(15),
	Apellido_M nvarchar(15),
	F_Nacimiento date,
	Edad int,
	F_Ingreso date
	

	constraint PK_Estudiante primary key (Numero)

)

go

-- Creando tabla de Facultad
create table Facultad(
	Numero int not null,
	Nombre nvarchar(30) not null,
	Recinto nvarchar(40) not null

	constraint PK_Facultad primary key (Numero)

)

go

-- Creando tabla de Carrera
create table Carrera(
	Numero int not null,
	Nombre nvarchar(30),
	
	constraint PK_Carrera primary key (Numero)
)

go

-- Creando tabla de Profesor
create table Profesor(
	Numero int not null,
	P_Nombre nvarchar(15) not null,
	S_Nombre nvarchar(15),
	Apellido_P nvarchar(15),
	Apellido_M nvarchar(15),
	Dir nvarchar(50),
	Telefono nvarchar(8),
	
	constraint PK_Profesor primary key (Numero)
)

go

-- Creando tabla Matricula
create table Matricula(
	Numero int not null,
	No_Estudiante int not null,
	Nombre_Estudiante nvarchar(40),
	Año date,

	constraint PK_Matricula primary key (Numero)
)

go

-- Creando tabla de Detalle_Matricula
create table Detalle_Matricula(
	
	No_Matricula int not null,
	No_Carrera int not null,
	No_Facultad int not null,
	No_Asignatura int not null,
	Aula nvarchar(20) not null,
	Grupo nvarchar(6) not null,
	Estado smallint,
	
)

go

-- Creando tabla de DAsignatura
create table Asignatura(
	
	No_Asignatura int not null,
	No_Profesor int not null,
	Semestre int not null,
	Clasificación float not null,

	constraint PK_Asignatura primary key (No_Asignatura)
)

go


-- Agregando las foreign keys

-- Relación Estudiantes - Matricula
Alter table Matricula
add foreign key (No_Estudiante) references Estudiante(Numero)

-- Relación Mantenimiento -  Detalle_Mantenimiento
Alter table Asignatura
add foreign key (No_Profesor) references Profesor(Numero)

-- Relación DetalleMartricula - Estudiante
Alter table Detalle_Matricula
add foreign key (No_Carrera) references Carrera(Numero)

-- Relación DetalleMartricula - Facultad
Alter table Detalle_Matricula
add foreign key (No_Facultad) references Facultad(Numero)

-- Relación Mantenimiento -  Detalle_Mantenimiento
Alter table Detalle_Matricula
add foreign key (No_Asignatura) references Asignatura(No_Asignatura)

-- Relación Mantenimiento -  Detalle_Mantenimiento
Alter table Detalle_Matricula
add foreign key (No_Matricula) references Matricula(Numero)

-- Creación de clave primaria compuesta
Alter table Detalle_Matricula
add primary key (No_Matricula)

-- Realizando el respaldo de la base de datos
--backup database Papeleria to disk='D:\Matricula.bak'