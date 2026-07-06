
-- AUTORES: Integrantes del grupo #4
-- FECHA: 05/07/2026
--Descripción: Prueba que SI funciona, el cajero tiene SELECT otorgado sobre FIDE_TARIFA_TB
SELECT * FROM FIDE_ASADA_ADMIN.FIDE_TARIFA_TB;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 05/07/2026
--Descripción: Prueba que NO funciona, el cajero no tiene ningun privilegio sobre FIDE_ORDEN_EMPLEADO_TB directamente
SELECT * FROM FIDE_ASADA_ADMIN.FIDE_ORDEN_EMPLEADO_TB;
/



-- AUTORES: Integrantes del grupo #4
-- FECHA: 05/07/2026
--Descripción: Prueba que SI funciona, el auditor tiene SELECT ANY TABLE, puede leer FIDE_ESTADO_TB
SELECT * FROM FIDE_ASADA_ADMIN.FIDE_ESTADO_TB;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 05/07/2026
--Descripción: Prueba que NO funciona porrque SELECT ANY TABLE no incluye INSERT, el rol es solo de lectura pal auditor
INSERT INTO FIDE_ASADA_ADMIN.FIDE_ESTADO_TB (ID_ESTADO, NOMBRE_ESTADO, CATEGORIA)
VALUES (999, 'PRUEBA_AUDITORIA', 'PRUEBA');
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 05/07/2026
--Descripción: Prueba que SI funciona, el operario tiene SELECT otorgado sobre FIDE_SECTOR_TB
SELECT * FROM FIDE_ASADA_ADMIN.FIDE_SECTOR_TB;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 05/07/2026
--Descripción: Prueba que NO funcion, el operario no tiene ningun privilegio sobre FIDE_ESTADO_TB
SELECT * FROM FIDE_ASADA_ADMIN.FIDE_ESTADO_TB;
/
