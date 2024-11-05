CREATE DATABASE Parcial2Mbo;
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

INSERT INTO Serie (titulo, sinopsis, director, episodios, fechaEstreno, estado)
VALUES 
('The Crown', 'Una dramatización de la vida de la reina Isabel II y los eventos políticos de su reinado.', 'Peter Morgan', 60, '2016-11-04', 1),
('Dark', 'Una historia compleja sobre viajes en el tiempo y los misterios en un pequeño pueblo alemán.', 'Baran bo Odar', 26, '2017-12-01', 1),
('The Boys', 'Un grupo de vigilantes lucha contra superhéroes corruptos.', 'Eric Kripke', 24, '2019-07-26', 1),
('Chernobyl', 'La historia del desastre nuclear de Chernobyl y sus consecuencias.', 'Craig Mazin', 5, '2019-05-06', 1),
('Mindhunter', 'Dos agentes del FBI investigan la psicología de asesinos en serie.', 'Joe Penhall', 19, '2017-10-13', 1),
('The Umbrella Academy', 'Hermanos adoptivos con poderes intentan prevenir el apocalipsis.', 'Steve Blackman', 30, '2019-02-15', 1),
('House of Cards', 'Un ambicioso político asciende en la política estadounidense a través de tácticas implacables.', 'Beau Willimon', 73, '2013-02-01', 1),
('Peaky Blinders', 'Una familia de gánsters intenta expandir su poder en la Inglaterra de la posguerra.', 'Steven Knight', 36, '2013-09-12', 1),
('Black Mirror', 'Una antología que explora la tecnología y sus efectos oscuros en la sociedad.', 'Charlie Brooker', 22, '2011-12-04', 1),
('True Detective', 'Investigaciones de detectives en casos complejos y oscuros en diferentes partes de EE. UU.', 'Nic Pizzolatto', 24, '2014-01-12', 1);

SELECT * FROM Serie WHERE estado <> -1;
GO

EXEC paSerieListar 'Mindhunter';   
EXEC paSerieListar 'The';       
EXEC paSerieListar 'House';      
EXEC paSerieListar 'Black';  
GO
