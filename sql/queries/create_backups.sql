USE master;
GO

BACKUP DATABASE ContosoDB
TO DISK = N'/var/opt/mssql/backups/ContosoDB.bak'
WITH
    FORMAT,         -- crea un nuevo archivo .bak (reemplaza si existe)
    INIT,           -- inicializa el medio de backup
    COMPRESSION,    -- reduce el tamaño del archivo
    STATS = 10;     -- muestra progreso cada 10%
GO