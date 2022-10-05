Use GestionBecas

 --Director del departamento de becas
Create login director with password='directordepartamento'
create user director for login director

alter role db_owner add member director

-- Secretaria del departamento de becas.
Create login secretaria with password='secretariadepartamento'
create user secretaria for login secretaria

alter role db_securityadmin add member secretaria
alter role db_ddladmin add member secretaria
alter role db_datawriter add member secretaria
alter role db_datareader add member secretaria

-- Persona que atiende la ventanilla xd
Create login ventanilla with password='ventanilla'
create user ventanilla for login ventanilla

alter role db_datawriter add member secretaria
alter role db_datareader add member secretaria