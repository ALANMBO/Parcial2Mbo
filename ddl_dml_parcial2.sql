
CREATE DATABASE Parcial2Ajavp;
GO

CREATE DATABASE Parcial2mbo;
GO

USE [master];
GO
CREATE LOGIN [usrparcial2] WITH PASSWORD = N'12345678',
    DEFAULT_DATABASE = [Parcial2mbo],
    CHECK_EXPIRATION = OFF,
    CHECK_POLICY = ON;
GO

USE [Parcial2mbo];
GO
CREATE USER [usrparcial2] FOR LOGIN [usrparcial2];
GO
ALTER ROLE [db_owner] ADD MEMBER [usrparcial2];
GO

IF OBJECT_ID('Serie', 'U') IS NOT NULL 
    DROP TABLE Serie;
GO

CREATE TABLE Serie (
    id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    titulo VARCHAR(250) NOT NULL,
    sinopsis VARCHAR(5000) NOT NULL,
    director VARCHAR(100) NOT NULL,
    episodios BIGINT NOT NULL,
    fechaEstreno DATETIME NOT NULL DEFAULT GETDATE(),
    tipoGenero VARCHAR(50) NOT NULL,
    estado SMALLINT NOT NULL DEFAULT 1 -- -1: Eliminado, 0: Inactivo, 1: Activo
);
GO

IF OBJECT_ID('paSerieListar', 'P') IS NOT NULL
    DROP PROCEDURE paSerieListar;
GO

CREATE PROCEDURE paSerieListar @parametro VARCHAR(50)
AS
BEGIN
    SELECT * FROM Serie
    WHERE estado <> -1 AND titulo LIKE '%' + REPLACE(@parametro, ' ', '%') + '%';
END;
GO

INSERT INTO Serie (titulo, sinopsis, director, episodios, fechaEstreno, tipoGenero, estado)
VALUES 
('The Crown', 'Una dramatización de la vida de la reina Isabel II y los eventos políticos de su reinado.', 'Peter Morgan', 60, '2016-11-04', 'Histórico', 1),
('Dark', 'Una historia compleja sobre viajes en el tiempo y los misterios en un pequeño pueblo alemán.', 'Baran bo Odar', 26, '2017-12-01', 'Thriller', 1);
GO

SELECT * FROM Serie;
GO

EXEC paSerieListar 'Mindhunter';   
EXEC paSerieListar 'The';       
EXEC paSerieListar 'House';      
EXEC paSerieListar 'Black';  
GO
