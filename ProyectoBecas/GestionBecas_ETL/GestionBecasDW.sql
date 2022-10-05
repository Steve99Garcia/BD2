USE master;
go
CREATE DATABASE GestionBecasDW;
go

USE GestionBecasDW;
go
CREATE TABLE DimPrograma 
(
	[IDDimPrograma] INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	[IDPrograma] [int] NULL,
	[TituloPrograma] [nvarchar](70) NULL,
	[TipoEspecialidad] [nvarchar](40) NULL,
	[Creditos] [int] NULL,
	[Diplomados] [int] NULL,
	[Duracion] [nvarchar](10) NULL,
	[FechaInicio] [date] NULL,
	[FechaFinal] [date] NULL
);
go

CREATE TABLE [DimCandidato](
	[IDDimCandidato] INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[IDCandidato] [int] NULL,
	[PrimerNombre] [nvarchar](30) NULL,
	[PrimerApellido] [nvarchar](30) NULL,
	[Correo] [nvarchar](70) NULL,
	[Estado] nvarchar (15) NULL,
	[FechaInicio] [date] NULL,
	[FechaFinal] [date] NULL
);
go

CREATE TABLE [DimPais](
	[IDDimPais] INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	[IDPais] [int] NULL,
	[NombrePais] [nvarchar](80) NULL,
	[FechaInicio] [date] NULL,
	[FechaFinal] [date] NULL
);
go

CREATE TABLE [dbo].[DimCiudad](
	[IDDimCiudad] INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	[IDCiudad] [int] NULL,
	[NombreCiudad] [nvarchar](80) NOT NULL,
	[FechaInicio] [date] NULL,
	[FechaFinal] [date] NULL
);
go

CREATE TABLE [dbo].[DimUniversidad](
	[IDDimUniversidad] INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	[IDUniversidad] [int] NULL,
	[NombreUniversidad] [nvarchar](80) NULL,
	[IDDimPais] [int] NULL FOREIGN KEY (IDDimPais) REFERENCES DimPais (IDDimPais),
	[IDDimCiudad] [int] NULL FOREIGN KEY (IDDimCiudad) REFERENCES DimCiudad (IDDimCiudad),
	[Calle] [nvarchar](60) NULL,
	[NumeroCalle] [int] NULL,
	[Distrito] [nvarchar](40) NULL,
	[Telefono] [nvarchar](13) NULL,
	[FechaInicio] [date] NULL,
	[FechaFinal] [date] NULL
);
go

CREATE TABLE DimFecha 
(
	IDDimFecha INT NOT NULL PRIMARY KEY IDENTITY (1,1),
	[FechaInicio] DATE NULL,
	[Año] INT NULL,
	[Mes] INT NULL,
	[Nombre Mes] NVARCHAR (30) NULL,
	[Dia] INT NULL,
	[Trimestre] INT NULL
);
go

CREATE TABLE HechosOfertaSolicitudes
(
	[IDDimPrograma] [int] NULL FOREIGN KEY (IDDimPrograma) REFERENCES DimPrograma (IDDimPrograma),
	[IDDimUniversidad] [int] NULL FOREIGN KEY (IDDimUniversidad) REFERENCES DimUniversidad (IDDimUniversidad),
	[IDDimCandidato] [int] NULL FOREIGN KEY (IDDimCandidato) REFERENCES DimCandidato (IDDimCandidato),
	[IDDimFecha] [int] NULL FOREIGN KEY (IDDimFecha) REFERENCES DimFecha (IDDimFecha),
	[Monto Oferta] [float] NULL,
	[Financiamiento] [float] NULL,
	[Cantidad Solicitudes] [int] NULL,
	[Universidades Participantes] INT NULL
);