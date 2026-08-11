-- Funcion verifica password
CREATE OR REPLACE FUNCTION VERIFICA_PASSWORD (
USERNAME VARCHAR2,
PASSWORD VARCHAR2,
OLD_PASSWORD VARCHAR2
) RETURN BOOLEAN IS
    BEGIN
    IF LENGTH(PASSWORD) < 12 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Contrasenia debe tener mas de 12 caracteres');
    END IF;
    IF OLD_PASSWORD IS NOT NULL AND PASSWORD=OLD_PASSWORD THEN
    RAISE_APPLICATION_ERROR(-20002, 'Constrasenia no puede ser igual a la anterior');
    END IF;
    IF NOT REGEXP_LIKE(PASSWORD, '[A-Z]') THEN 
        RAISE_APPLICATION_ERROR(-20003, 'Constrasenia minimo con una mayuscula');
    END IF;
    IF NOT REGEXP_LIKE(PASSWORD, '[a-z]') THEN 
        RAISE_APPLICATION_ERROR(-20004, 'Constrasenia minimo con una minuuscula'); 
    END IF;
    IF NOT REGEXP_LIKE(PASSWORD, '[0-9]') THEN 
        RAISE_APPLICATION_ERROR(-20005, 'Constrasenia minimo con un numero'); 
    END IF;
    IF NOT REGEXP_LIKE(PASSWORD, '[^A-Za-z0-9]') THEN
        RAISE_APPLICATION_ERROR(-20006, 'Constrasenia minimo con 1 caracter espepcial'); 
    END IF;
    IF REGEXP_LIKE(LOWER(PASSWORD), 'oracle|password|admin|fidelitas|abcdef' ) THEN 
        RAISE_APPLICATION_ERROR(-20007, 'Constrasenia debil o tiene palabras restringidas'); 
    END IF;
    IF REGEXP_LIKE(PASSWORD, '\s') THEN
        RAISE_APPLICATION_ERROR(-20008, 'La nueva contraseña no debe de contener espacios en ella.');
    END IF;
    IF REGEXP_LIKE(PASSWORD, '(.)\1') THEN
            RAISE_APPLICATION_ERROR(-20009, 'La nueva contraseña no debe de contener caracteres iguales seguidos');
        END IF;
    IF INSTR(LOWER(PASSWORD), LOWER(USERNAME))>0 THEN
        RAISE_APPLICATION_ERROR(-20010,'La nueva contraseña no debe de contener el nombre de Usuario.'); 
    END IF;
RETURN TRUE;
END;
/



--Creacion del perfil
CREATE PROFILE FIDE_PROYECTO_FINAL_PROF LIMIT
    SESSIONS_PER_USER 1
    FAILED_LOGIN_ATTEMPTS 3
    PASSWORD_REUSE_MAX 3
    PASSWORD_LIFE_TIME 90
    PASSWORD_LOCK_TIME 1
    PASSWORD_GRACE_TIME 7
    PASSWORD_VERIFY_FUNCTION ADMIN.VERIFICA_PASSWORD; --está función es la que hicimos en clase


-- AUTORES: Integrates del grupo #4
-- FECHA: 03/07/2026
--Descripción: Crear un rol admin
CREATE ROLE FIDE_PROYECTO_ADMIN_ROL NOT IDENTIFIED;


-- AUTORES: Integrates del grupo #4
-- FECHA: 03/07/2026
-- Descripción: Dar privilegios iniciales basicos al rol
GRANT RESOURCE TO FIDE_PROYECTO_ADMIN_ROL;


-- AUTORES: Integrates del grupo #4
-- FECHA: 03/07/2026
-- Descripción: Dar privilegios de inicio de sesion al rol
GRANT CREATE SESSION TO FIDE_PROYECTO_ADMIN_ROL;


-- AUTORES: Integrates del grupo #4
-- FECHA: 03/07/2026
--Descripción: Crear usuario
CREATE USER FIDE_ASADA_ADMIN
    IDENTIFIED BY A$ada2026_Fide
    DEFAULT TABLESPACE DATA
    TEMPORARY TABLESPACE TEMP
    PROFILE FIDE_PROYECTO_FINAL_PROF
    QUOTA UNLIMITED ON DATA;

-- AUTORES: Integrates del grupo #4
-- FECHA: 03/07/2026
-- Descripción: Dar privilegios de inicio de sesion al admin
GRANT CREATE SESSION TO FIDE_ASADA_ADMIN;

-- AUTORES: Integrates del grupo #4
-- FECHA: 02/07/2026
--Descripción: Asignar el rol al usuario
GRANT FIDE_PROYECTO_ADMIN_ROL TO FIDE_ASADA_ADMIN;


-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Rol para el cajero encargado de facturación y pagos de abonados
CREATE ROLE FIDE_CAJERO_FACTURACION_ROL;
/











-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre catálogos necesarios para facturar
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_ABONADO_TB TO FIDE_CAJERO_FACTURACION_ROL;
/


-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias para facturar
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_TARIFA_TB TO FIDE_CAJERO_FACTURACION_ROL;
/



-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias para facturar
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_METODO_PAGO_TB TO FIDE_CAJERO_FACTURACION_ROL;
/



-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias para facturar
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_LECTURA_TB TO FIDE_CAJERO_FACTURACION_ROL;
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre facturación y pagos
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_FACTURA_TB TO FIDE_CAJERO_FACTURACION_ROL;
/



-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre facturación y pagos
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_DETALLE_FACTURA_TB TO FIDE_CAJERO_FACTURACION_ROL;
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre facturación y pagos
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_PAGO_TB TO FIDE_CAJERO_FACTURACION_ROL;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Usuario para el cajero de facturación
CREATE USER FIDE_ASADA_CAJERO
    IDENTIFIED BY A$ada2026_Fide
    DEFAULT TABLESPACE DATA
    TEMPORARY TABLESPACE TEMP
    PROFILE FIDE_PROYECTO_FINAL_PROF
    QUOTA UNLIMITED ON DATA;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Permiso de conexión al cajero
GRANT CREATE SESSION TO FIDE_ASADA_CAJERO;
/





-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Asignación del rol de cajero
GRANT FIDE_CAJERO_FACTURACION_ROL TO FIDE_ASADA_CAJERO;
/


-- =========================================================
-- ROL 2: AUDITORIA
-- =========================================================

-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Rol de auditoría con acceso de solo lectura a todo el sistema
CREATE ROLE FIDE_AUDITORIA_ROL;
/





-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegio de lectura sobre todas las tablas de la base de datos
GRANT SELECT ANY TABLE ON SCHEMA FIDE_ASADA_ADMIN TO FIDE_AUDITORIA_ROL;
/



-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Usuario para el auditor del sistema
CREATE USER FIDE_ASADA_AUDITOR
    IDENTIFIED BY A$ada2026_Fide
    DEFAULT TABLESPACE DATA
    TEMPORARY TABLESPACE TEMP
    PROFILE FIDE_PROYECTO_FINAL_PROF
    QUOTA UNLIMITED ON DATA;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Permiso de conexión al audutor
GRANT CREATE SESSION TO FIDE_ASADA_AUDITOR;
/






-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción Asignación del rol de auditoria
GRANT FIDE_AUDITORIA_ROL TO FIDE_ASADA_AUDITOR;
/



-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Rol para el operario de campo encargado de lecturas, averías e inventario
CREATE ROLE FIDE_OPERARIO_CAMPO_ROL;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_TIPO_AVERIA_TB TO FIDE_OPERARIO_CAMPO_ROL;
/


-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_TIPO_MEDIDOR_TB TO FIDE_OPERARIO_CAMPO_ROL;
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_TIPO_ORDEN_TRABAJO_TB TO FIDE_OPERARIO_CAMPO_ROL;
/






-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_SECTOR_TB TO FIDE_OPERARIO_CAMPO_ROL;
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_UNIDAD_MEDIDA_TB TO FIDE_OPERARIO_CAMPO_ROL;
/






-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de solo lectura sobre tablas necesarias
GRANT SELECT ON FIDE_ASADA_ADMIN.FIDE_INVENTARIO_TB TO FIDE_OPERARIO_CAMPO_ROL;
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre lecturas, averías,óodenes de trabajo e inventario
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_LECTURA_TB TO FIDE_OPERARIO_CAMPO_ROL;
/


-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre lecturas, averías,óodenes de trabajo e inventario
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_MEDIDOR_TB TO FIDE_OPERARIO_CAMPO_ROL;
/


-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre lecturas, averías,óodenes de trabajo e inventario
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_AVERIA_TB TO FIDE_OPERARIO_CAMPO_ROL;
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre lecturas, averías,óodenes de trabajo e inventario
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_ORDEN_TRABAJO_TB TO FIDE_OPERARIO_CAMPO_ROL;
/





-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre lecturas, averías,óodenes de trabajo e inventario
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_ORDEN_EMPLEADO_TB TO FIDE_OPERARIO_CAMPO_ROL;
/





-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre lecturas, averías,óodenes de trabajo e inventario
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_ORDEN_INVENTARIO_TB TO FIDE_OPERARIO_CAMPO_ROL;
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Privilegios de lectura y escritura sobre lecturas, averías,óodenes de trabajo e inventario
GRANT SELECT, INSERT, UPDATE ON FIDE_ASADA_ADMIN.FIDE_MOVIMIENTO_INVENTARIO_TB TO FIDE_OPERARIO_CAMPO_ROL;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Usuario para el operario de campo
CREATE USER FIDE_ASADA_OPERARIO
    IDENTIFIED BY A$ada2026_Fide
    DEFAULT TABLESPACE DATA
    TEMPORARY TABLESPACE TEMP
    PROFILE FIDE_PROYECTO_FINAL_PROF
    QUOTA UNLIMITED ON DATA;
/

-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Permiso de conexión y asignación del rol de operario de campo
GRANT CREATE SESSION TO FIDE_ASADA_OPERARIO;
/





-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Permiso de conexión y asignación del rol de operario de campo
GRANT FIDE_OPERARIO_CAMPO_ROL TO FIDE_ASADA_OPERARIO;
/




-- AUTORES: Integrantes del grupo #4
-- FECHA: 04/07/2026
--Descripción: Commit
COMMIT;
/







