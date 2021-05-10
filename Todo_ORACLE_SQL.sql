
--------------------------------------------{  TIPS DATAMODELER  }--------------------------------------

-- Tips para generar nombres de relaciones mas cortos:

-- Herramientas >> Configuración a nivel de diseño >> Cambiar clave ajena : FK_SUBSTR(2, 3, FRONT, {parent})_SUBSTR(3, 3,FRONT,  {child})
-- Herramientas >> Configuración a nivel de diseño >> Cambiar clave ajena de columna : {ref column} 


-----------------------------------{  CREACIÓN DE USUARIO GENÉRICO  }-------------------------------------

-- Creación de usuario JUAN
CREATE USER JUAN
IDENTIFIED BY JUAN
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;
ALTER USER JUAN QUOTA UNLIMITED ON USERS;
GRANT CREATE SESSION, CREATE VIEW TO JUAN;
GRANT RESOURCE TO JUAN;
ALTER USER JUAN DEFAULT ROLE RESOURCE;

/ 

-- Conocer que privilegios tiene el usuario JUAN
SELECT * FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'JUAN';

/

-- Conocer que rol tiene el usuario JUAN
SELECT * FROM DBA_ROLE_PRIVS
WHERE GRANTEE = 'JUAN';

/

-- Conocer que privilegios tiene un ROL
SELECT * FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'RESOURCE';

SELECT * FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'CONNECT';


-----------------------------------{  CREACIÓN DE USUARIO EN ORACLE XE  }-------------------------------------


--> Conectados como usuario SYSTEM ejecutamos el siguiente script:


-- Script de creación del usuario HR usando Oracle XE (BD en el localhost)
CREATE USER HR                           -- Se le asigna un nombre de usuario
IDENTIFIED BY HR                         -- Se le asigna una contraseña (No es necesario usar doble comillas para hacerla case sensitive)
DEFAULT TABLESPACE USERS                 -- En Oracle XE se usa el tablespace USERS para almacenar los objetos de los usuarios
TEMPORARY TABLESPACE TEMP;               -- Asignar un tablespace temporal para los datos temporales de la sesión del usuario
ALTER USER HR QUOTA UNLIMITED ON USERS;  -- Asignar una couta de almacenamiento en el tablespace USERS
GRANT CREATE SESSION TO HR;              -- Privilegio que permite que el usuario se pueda conectar a la BD (Iniciar Sesión)
GRANT CREATE VIEW TO HR;                 -- Privilegio de sistema que permite crear vistas (necesario para ejecutar script hr.sql)
GRANT RESOURCE TO HR;                    -- Asignar el rol "RESOURCE" (permite crear TABLE, SEQUENCE, TRIGGER, PROCEDURE, etc.)
ALTER USER HR DEFAULT ROLE RESOURCE;     -- Se le asigna RESOURCE como el rol por defecto

   
--* Script para desbloquear el usuario HR en Oracle XE 18c
ALTER USER HR IDENTIFIED BY HR ACCOUNT UNLOCK;

--> Después de desbloquear HR debemos crear una nueva conexión(+) con el usuario HR (el esquema HR ya viene instalado)
--> En nombre de servicio se debe poner: XEPDB1

-- Si se desea otorgar varios privilegios a un usuario se puede usar: GRANT <lista de privilegios> TO <usuario>;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TRIGGER TO JUANITO;

--> En Oracle XE las contraseñas no requieren cumplir tantos requisitos de seguridad como en Oracle Cloud:

--     Tener entre 12 y 30 caracteres
--     Tener mayúsculas, minúsculas y números
--     No puede contener el nombre del usuario
--     Deben ser distintas de las 4 últimas contraseñas (si cambias la contraseña)
--     No se puede volver a usar una contraseña en 24 horas (si cambias la contraseña)


-----------------------------------{  CREACIÓN DE USUARIO HR EN ORACLE CLOUD  }-------------------------------------


--> Conectados como usuario ADMIN ejecutamos el siguiente script:

-- Script de creación del usuario HR usando Oracle Cloud (BD en la nube)
CREATE USER HR_NUBE
IDENTIFIED BY "Clave1234567"
DEFAULT TABLESPACE DATA         -- En Oracle Cloud se usa DATA
TEMPORARY TABLESPACE TEMP;
ALTER USER HR_NUBE QUOTA UNLIMITED ON DATA;
GRANT CREATE SESSION TO HR_NUBE;
GRANT CREATE VIEW TO HR_NUBE;
GRANT RESOURCE TO HR_NUBE;
ALTER USER HR_NUBE DEFAULT ROLE RESOURCE;

--> Después de ejecutar el script como usuario ADMIN debemos crear una nueva conexión(+) con el usuario creado
--> En "tipo de conexión" debemos poner "cartera de cloud" y agregar la ubicación del Wallet
--> Después de crear la conexión debemos ejecutar con el usuario HR el script de la creación de la BD


------------------------------------------{  CAMBIAR CONTRASEÑA DE SYSTEM  }--------------------------------------------


-- (1) WINDOWS + R >> CMD >> ENTER
-- (2) sqlplus / as sysdba >> ENTER
-- (3) ALTER USER SYSTEM IDENTIFIED BY nueva_contraseña; >> ENTER >> exit


------------------------------------------{  LEVANTAR EL LISTENER  }--------------------------------------------


-- Lupa >> Servicios >> OracleOraDB18Home1TNSListener >> Verificar que este en EJECUCIÓN y AUTOMÁTICO


---------------------------------------------{  BD a MR  }------------------------------------------------------------


--> Modelo Conceptual (MER) - Modelo Lógico (MER Extendido) - Modelo Físico (MR)
--> Las tablas creadas en una BD (Script de creación de la BD) son la implementación del Modelo Relacional o MR (Modelo Físico)
--> Convertir las tablas físicas de la BD en un MR se le conoce como "Ingeniería Inversa o Reversa"


--> Para pasar una BD a MR usando Datamodeler debemos seguir los siguientes pasos:

-- Archivo >> Importar >> Diccionario de Datos >> Agregar (Se rellenan los datos de la conexión, Probar y Guardar) 
-- >> Seleccionar la Conexión >> Siguiente >> Seleccionar el esquema >> Siguiente >> Seleccionar todo >> Siguiente >> Terminar

--> Para guardar el modelo en el Datamodeler: Archivo >> Imprimir Diagrama >> En archivo PDF


--------------------------------------------------{  Tablespace  }------------------------------------------------------------


--> Un Tablespace es una ubicación de almacenamiento en el servidor de BD en donde se guardan los archivos de datos (datafiles) correspondiente a los objetos de una BD
--> Si al crear un usuario no le asignamos un Tablespace específico, los objetos creados por el usuario se almacenarán en el Tablespace por defecto que es SYSTEM
--> En Oracle existen 5 Tablespace por defecto: SYSTEM, SYSAUX, UNDO, USERS y TEMP.


-----------------------------------------------{  ALTER SESSION SET  }----------------------------------------------------


--> Se puede configurar el idioma, formatos de fecha, formatos de hora, separador de decimales, entre otras cosas usando sentencias
--> También se puede realizar esta configuración en el Developer (Herramientas >> Preferencias >> Base de Datos >> NLS) 

-- Establecer Formato de fecha - Formato 12-08-2020
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';

-- Establecer Formato de fecha - Formato 12-08-2020 13:48:05
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

-- Establecer lenguaje del servidor
ALTER SESSION SET NLS_DATE_LANGUAGE = 'SPANISH';


-----------------------------------------------{  LENGUAJE SQL  }--------------------------------------------


--> Lenguaje universal de las BD relacionales (estándar ANSI e ISO)
--> En la practica SQL no es estándar, ya que hay variaciones dependiendo del motor de BD que se utilice
--> SQL no es case-sensitive (no es sensible a mayúsculas y minúsculas, escribir where o WHERE da lo mismo)
--> Las sentencias deben finalizar con un punto y coma ;
--> Por convención las palabras reservadas se escriben en mayúsculas (SELECT, AS, WHERE, ORDER BY, JOIN, DISTINCT, etc.)
--> Por convención los nombres de tablas y columnas se escriben en minúsculas ( SELECT first_name, last_name FROM employees; )
--> Por convención se debe escribir cada cláusula en líneas diferentes
--> Las sentencias SQL pueden ser parte del código de otro lenguaje que se considera anfitrión (PL/SQL, C, Java, HTML, etc.)


-------------------------------------------{  SENTENCIAS SQL  }------------------------------------


-->      DDL : Lenguaje de Definición de Datos       [ CREATE, ALTER, DROP, RENAME, TRUNCATE, COMMENT ] 
-->      DML : Lenguaje de Manipulación de Datos     [ SELECT, INSERT, UPDATE, DELETE, MERGE ]
-->      DCL : Lenguaje de Control de Datos          [ GRANT, REVOKE ]        
-->      TCL : Lenguaje de Control de Transacciones  [ SAVEPOINT, ROLLBACK, COMMIT ]   


-->  DDL : Permiten crear, configurar, modificar y eliminar la estructura de una tabla
-->  DML : Permiten recuperar datos de la BD, insertar nuevas filas, modificar las filas existentes y eliminar las filas no deseadas
-->  DCL : Permiten otorgar (GRANT) o revocar (REVOKE) permisos de acceso a la BD como a los objetos creados en ella
-->  TCL : Permiten administrar los cambios de datos realizados en las tablas a través de sentencias DML

-->  Trabajar con los objetos:

--   CREATE : Crear objetos en la BD
--    ALTER : Modificar objetos en la BD
--     DROP : Eliminar un objeto de la BD
--   RENAME : Renombrar objetos en la BD
-- TRUNCATE : Borrar todas las filas de una tabla de la BD
--  COMMENT : Colocar comentarios al crear objetos


--> Trabajar con los datos:

-- SELECT : Seleccionar o consultar datos almacenados en las tablas de la BD
-- INSERT : Insertar filas en las tablas de la BD
-- UPDATE : Actualizar el valor de las columnas en las tablas de la BD
-- DELETE : Eliminar filas de las tablas de la BD
--  MERGE : Sincronizar datos entre una tabla origen a una tabla destino (INSERT + UPDATE + DELETE)


--> Manejar privilegios:

--  GRANT : Otorgar privilegios de sistema o sobre objetos a un usuario o rol
-- REVOKE : Denegar o revocar privilegios de sistema o sobre objetos a un usuario o rol


--> Controlar las Transacciones:

-- SAVEPOINT : Crea un punto de recuperación en la transacción
--  ROLLBACK : Deshacer los cambios en la BD producidos por una transacción (INSERT, UPDATE o DELETE)
--    COMMIT : Confirmar los cambios en la BD producidos por una transacción (INSERT, UPDATE o DELETE)


---------------------------------------{  DESCRIBE  }---------------------------------------------


--> Sintaxis: 
   
DESCRIBE Tabla;

--> Proporciona una descripción de la tabla:  Nombre de la Columna + ¿NULO? + Tipo de Dato(tamaño) 
--> 'Resulset' es el resultado de la ejecución de una sentencia SQL
--> Si solo se desea consultar la estructura de una tabla siempre usar DESCRIBE y no SELECT * (si tiene millones de registros tarda mucho)


-- 1) Mostrar la estructura de la tabla DEPARTMENTS
DESCRIBE DEPARTMENTS;

-- Resulset:

Nombre         ¿Nulo?   Tipo         
-------------- -------- ------------ 
DEPARTMENT_ID   NOT NULL NUMBER(4)    
DEPARTMENT_NAME NOT NULL VARCHAR2(30) 
MANAGER_ID               NUMBER(6)    
LOCATION_ID              NUMBER(4)  


-- 2) Mostrar la estructura de la tabla EMPLOYEES
DESCRIBE EMPLOYEES;

-- Resulset:

Nombre         ¿Nulo?   Tipo         
-------------- -------- ------------ 
EMPLOYEE_ID    NOT NULL NUMBER(6)    
FIRST_NAME              VARCHAR2(20) 
LAST_NAME      NOT NULL VARCHAR2(25) 
EMAIL          NOT NULL VARCHAR2(25) 
PHONE_NUMBER            VARCHAR2(20) 
HIRE_DATE      NOT NULL DATE         
JOB_ID         NOT NULL VARCHAR2(10) 
SALARY                  NUMBER(8,2)  
COMMISSION_PCT          NUMBER(2,2)  
MANAGER_ID              NUMBER(6)    
DEPARTMENT_ID           NUMBER(4)   


-------------------------------------------------{  SELECT * FROM  }----------------------------------------------------------- 

--> Sintaxis:

SELECT * FROM Tabla;


--> La cláusula FROM especifica la tabla que contiene las columnas que se desean mostrar
--> El asterisco (*) se utiliza para seleccionar TODAS las columnas de una tabla de la BD (Mostrar la tabla completa)
--> En ambiente de desarrollo esta muy mal visto usar SELECT * (Como regla general jamas se debe depender del orden de las columnas)


-- 1) Mostrar todas las columnas y filas de la tabla EMPLOYEES
SELECT * FROM EMPLOYEES; -- Muestra 107 empleados (107 filas)


-- 2) Mostrar el contenido de la tabla COUNTRIES;
SELECT * FROM COUNTRIES;  -- Muestra 25 paises (25 filas)


-- 3) Mostrar toda la tabla LOCATIONS
SELECT * FROM LOCATIONS;  -- Muestra 23 ubicaciones (23 filas)


-----------------------------{  SELECT columna FROM Tabla  } ----------------------------

--> Sintaxis:

SELECT columna1,
       columna2,
       columna3
FROM Tabla;


--> Permite seleccionar columnas específicas de una tabla de la BD
--> Muestra TODAS las filas de las columnas especificadas en el SELECT
--> Las columnas se mostrarán en el resulset en el mismo orden en que aparezcan en la selección de columnas (columna1 | columna2 | columna 3)
--> Es recomendable poner cada columna es una fila diferente para hacer más legible la consulta (distinguir más claramente cada columna)
--> Si ponemos una coma antes de la cláusula FROM nos salta el error (ORA-00936: falta una expresión - "missing expression")
--> Si nos falta una coma para separar columnas nos salta el error (ORA-00923: palabra clave FROM no encontrada donde se esperaba)
--> A veces si nos falta una coma para separar columnas no arroja error porque se interpreta como alias de columna y no como otra columna


-- 1) Mostrar la fecha de contratación de todos los empleados
SELECT HIRE_DATE
FROM EMPLOYEES;


-- 2) Mostrar nombre y apellido de los empleados
SELECT FIRST_NAME,
       LAST_NAME
FROM EMPLOYEES;


-- 3) Mostrar de los empleados: el ID, el teléfono, el email y el sueldo
SELECT EMPLOYEE_ID,
       PHONE_NUMBER,
       EMAIL,
       SALARY
FROM EMPLOYEES;


------------------{  Operadores Aritméticos  }-----------{  ALIAS DE COLUMNA  }---------------{  TABLA DUAL  }------------------


-->         + : Suma
-->         - : Resta
-->         * : Multiplicación
-->         / : División


--> Se sigue el mismo orden de jerarquía que en matemáticas (primero * / y después + -)
--> Las "Columnas Calculadas" son aquellas columnas que se muestran como resultado de una operación (no existen realmente en la BD)
--> El resultado de las consultas SQL genera una tabla temporal que se denomina "Resul-Set" (donde se muestran los resultados)
--> Se puede usar la tabla DUAL para probar sentencias. Es una tabla comodín que contiene 1 sola columna "DUMMY" con un valor "X" (SELECT * FROM DUAL;)
--> Los alias de columnas permiten dar un nombre 'lógico' de salida a la columna seleccionada (el nombre que se muestra en el resulset)
--> Los 'alias de columna' solo se pueden utilizar en la cláusula ORDER BY
--> Los alias que tengan espacios en blanco o caracteres especiales(salvo _ ) van entre comillas dobles: "NOMBRE COMPLETO", "TOD@S", etc.
--> Si el alias debe ser Case-Sensitive se debe usar comillas dobles (Nombre_Completo se va a mostrar en el resulset como NOMBRE_COMPLETO)
--> Se puede anteponer la palabra reservada 'AS' cuando se especifica un alias de columna (SELECT HIRE_DATE AS "Fecha de Contrato" FROM EMPLOYEES;)
--> La palabra reservada AS se puede omitir cuando se pone un alias de columna
--> Se recomienda siempre usar AS para los alias de columna ya que AS es el estándar en cualquier motor SQL (MySQL, Microsoft SQL Server, PostgreSQL, etc.)


-- 1.1) Realizar operaciones aritméticas sobre la tabla DUAL
SELECT 1 - 2 + 3 * 10 / 5
FROM DUAL; 


-- 1.2) La palabra "RESULTADO" es solo un 'alias' para darle un nombre de columna más presentable en el resulset
SELECT 1 - 2 + 3 * 10 / 5 AS RESULTADO 
FROM DUAL;


-- 1.3) También se puede omitir la palabra "AS" para poner alias a las columnas
SELECT 1 - 2 + 3 * 10 / 5 SALIDA
FROM DUAL;


-- 1.4) Si queremos que el alias se muestre tal cual como lo escribimos debemos usar comillas dobles " "
SELECT 1 - 2 + 3 * 10 / 5 Salida,
       1 - 2 + 3 * 10 / 5 "Salida"
FROM DUAL;


-- 2.1) Mostrar el salario de cada empleado aumentado un 15% y sumarle un bono de mil dolares
SELECT FIRST_NAME PRIMER_NOMBRE,
       LAST_NAME APELLIDO,
       SALARY SALARIO,
       SALARY * 1.15 + 1000 SALARIO_AUMENTADO
FROM EMPLOYEES;


-- 2.2) Para poner un alias que tenga espacios u otros caracteres especiales se debe usar las comillas dobles " "
SELECT FIRST_NAME "PRIMER NOMBRE",
       LAST_NAME APELLIDO,
       SALARY SALARIO,
       EMAIL "EM@IL",
       SALARY * 1.15 + 1000 "SALARIO AUMENTADO"
FROM EMPLOYEES;


-- 2.3) Se pueden usar paréntesis () para cambiar el orden de prioridad de las operaciones
SELECT FIRST_NAME PRIMER_NOMBRE,
       LAST_NAME APELLIDO,
       SALARY SALARIO,
       SALARY * (1.15 + 1000) SALARIO_AUMENTADO
FROM EMPLOYEES;


-- 3) Si se realizan operaciones aritméticas sobre valores null el resultado es SIEMPRE null
SELECT 5000 * 1500 + NULL + 325 RESULTADO 
FROM DUAL;  -- Arroja (null)


-- 4) Sumar un 5% a la comisión de todos los empleados que tengan comisión
SELECT EMPLOYEE_ID,
       COMMISSION_PCT PORCENTAJE_COMISION,
       COMMISSION_PCT + 0.05 NUEVA_COMISION 
FROM EMPLOYEES;  -- Los que tienen comisión null se quedan igual (null + 0.05 = null)


--------------------------------------------{  CONCATENAR  }------------------------------------------------------------


--> Sintaxis:            'Texto1' || 'Texto2'       Salida: 'Texto1Texto2'     <VARCHAR2>
--> Sintaxis:        CONCAT('Texto1', 'Texto2')     Salida: 'Texto1Texto2'     <VARCHAR2>


--> Para concatenar o unir literales de texto se puede usar el operador || (pipes) o la función de fila CONCAT()
--> Al concatenar varias columnas se mostrará en el resulset como una sola columna (con el alias que se establecio) 
--> Los literales de texto van entre comillas simples: 'No Posee', 'Sin Comisión', 'IT_PROG', etc.
--> Los literales de fecha van entre comillas simples: '02/12/1998', '23 de Septiembre de 2020', etc.
--> Siempre se concatenan textos, si se permite esto: 7 || 5  es solo porque Oracle convierte implicitamente los números a texto antes de concatenar
--> Preferir el operador || para concatenar, ya que si se utiliza la función CONCAT() para concatenar muchos textos queda menos legible (muy anidada)


-- 1) Concatenar con un valor NULL no tiene efecto alguno (unir con nada) 
SELECT 'Chao' || NULL || 'Carlos' "Salida" 
FROM DUAL; -- ChaoCarlos


-- 2.1) Concatenar el nombre y apellido de todos los empleados - Operador ||
SELECT FIRST_NAME || LAST_NAME "NOMBRE COMPLETO" 
FROM EMPLOYEES;


-- 2.2) Concatenar el nombre y apellido de todos los empleados - Función CONCAT()
SELECT CONCAT(FIRST_NAME, LAST_NAME) "NOMBRE COMPLETO" 
FROM EMPLOYEES;


-- 2.3) Concatenar el nombre y apellido de todos los empleados dejando un espacio - Operador ||
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE COMPLETO" 
FROM EMPLOYEES;


-- 2.4) Concatenar el nombre y apellido de todos los empleados dejando un espacio - Función CONCAT() anidada
SELECT CONCAT(CONCAT(FIRST_NAME, ' '), LAST_NAME) "NOMBRE COMPLETO" 
FROM EMPLOYEES;


-- 3.1) Agregar '@gmail.com' a los correos de los empleados - Operador ||
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE COMPLETO",
       EMAIL || '@GMAIL.COM' CORREO 
FROM EMPLOYEES;


-- 3.2) Agregar '@gmail.com' a los correos de los empleados - Operador CONCAT()
SELECT CONCAT(CONCAT(FIRST_NAME, ' '), LAST_NAME) "NOMBRE COMPLETO",
       CONCAT(EMAIL, '@GMAIL.COM') CORREO 
FROM EMPLOYEES;


-- 4) Muestra el nombre completo del empleado y su fecha de contratación
SELECT 'El empleado ' || FIRST_NAME || ' ' || LAST_NAME || ' fue contratado el ' || HIRE_DATE "FECHA DE CONTRATO"
FROM EMPLOYEES;


-- 5) Concatenación de columnas y literales de texto: ( columna || literal_de_texto || columna || literal_de_texto || columna )
SELECT FIRST_NAME || ' ' || LAST_NAME || ' pertenece al departamento ' || DEPARTMENT_ID "DETALLE DE EMPLEADOS"
FROM EMPLOYEES;


----------------------------------------{  ORDEN DE PRECEDENCIA ORACLE  }------------------------------------------


--              1)   Paréntesis  ()
--              2)   Multiplicación y División :  *  / 
--              3)   Suma - Resta - Concatenación :  +  -  ||
--              4)   Comparaciones :  <  <=  >  >=  =  !=  NOT - NOT BETWEEN - IS NULL - IS NOT NULL - LIKE - IN - NOT IN
--              5)   NOT
--              6)   AND
--              7)   OR  


---------------------------{  ORDER BY  }---------------{  NULLS FIRST - NULLS LAST  }---------------------


--> Sintaxis:       

 SELECT columna1,
        columna2,
        columna3
FROM Tabla
ORDER BY columna1 ASC NULLS FIRST,
         columna2 DESC NULLS LAST,
         columna3; 


--> La cláusula ORDER BY siempre va al FINAL de la sentencia SELECT (es siempre la última cláusula)
--> Se puede ordenar por 1 o más columnas, de forma ascendente (ASC) o descendente (DESC)
--> Los números los ordena de menor a mayor (ASC: 1-2-3-4-5) o de mayor a menor (DESC: 5-4-3-2-1)
--> Las palabras las ordena de menor a mayor (ASC: A-B-C-D-E) o de mayor a menor (DESC: Z-Y-X-W-V)
--> El ORDER BY ordena por código ASCII (por ejemplo la A mayúscula [65] es menor que la a minúscula [97] entonces si se ordena ASC va primero la A mayúscula)
--> Cuando se pide ordenar una columna alfabéticamente se refiere a ordenarla en forma ascendente, por ejemplo ORDER BY LAST_NAME ASC;
--> Para ordenar de manera 'ascendente' no es necesario poner la palabra reservada 'ASC' (es el valor por defecto)
--> Las fechas las ordena de la más antigua a la más actual (ASC) o de la más actual a la más antigua (DESC)
--> En los ORDER BY se pueden referenciar las columnas por su alias, por su número de columna o por la expresión completa de la columna
--> La cláusula ORDER BY es la única en donde se puede referenciar por 'alias de columna'
--> Tener mucho cuidado cuando ordenamos por una columna numérica, porque si esa columna la formateamos con TO_CHAR deja de ser numérica
--> Si tenemos la columna: TO_CHAR(SALARY * 12) "SALARIO ANUAL" para ordenarla por el valor numérico debemos poner: ORDER BY SALARY * 12;
--> Si ordenamos por una columna de manera ASC los valores nulos quedan al final y si ordenamos en forma DESC los nulos quedan al principio
--> Para especificar donde queremos que aparezcan los valores nulos cuando usamos ORDER BY podemos usar NULLS FIRST o NULLS LAST 


-- 1.1) Ordenar alfabeticamente por nombre (de manera ascendente)
SELECT FIRST_NAME "NOMBRE" 
FROM EMPLOYEES 
ORDER BY FIRST_NAME ASC;


-- 1.2) Para ordenar en forma ascendente no es necesario poner 'ASC' (se puede omitir)
SELECT FIRST_NAME "NOMBRE" 
FROM EMPLOYEES 
ORDER BY FIRST_NAME;


-- 1.3) Ordenar los nombres en forma descendente
SELECT FIRST_NAME "NOMBRE" 
FROM EMPLOYEES 
ORDER BY FIRST_NAME DESC;


-- 2.1) Ordenar los DEPARTMENT_ID de manera ascendente y los nombres de empleado de manera descendente
SELECT DEPARTMENT_ID "DEPARTAMENTO",
       FIRST_NAME "NOMBRE" 
FROM EMPLOYEES 
ORDER BY DEPARTMENT_ID,
         FIRST_NAME DESC;


-- 2.2) En los ORDER BY se pueden usar los alias para referenciar las columnas
SELECT DEPARTMENT_ID "DEPARTAMENTO",
       FIRST_NAME "NOMBRE" 
FROM EMPLOYEES 
ORDER BY "DEPARTAMENTO",
         "NOMBRE" DESC;


-- 2.3) También se pueden usar los números de columna para referenciar
SELECT DEPARTMENT_ID "DEPARTAMENTO",
       FIRST_NAME "NOMBRE" 
FROM EMPLOYEES 
ORDER BY 1 ASC,
         2 DESC;


-- 3.1) Mostrar los sueldos de mayor a menor y en que departamento trabajan
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO",
       DEPARTMENT_ID "DEPARTAMENTO",
       SALARY "SALARIO" 
FROM EMPLOYEES 
ORDER BY SALARY DESC;


-- 3.2) Mostrar los sueldos de menor a mayor y en que depto trabajan
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO",
       DEPARTMENT_ID "DEPARTAMENTO",
       SALARY "SALARIO" 
FROM EMPLOYEES 
ORDER BY SALARY;


-- 4.1) Ordenar por nombre completo de la A a la Z - Opcion 1: Usando el alias de columna
SELECT FIRST_NAME ||' '|| LAST_NAME "NOMBRE COMPLETO" 
FROM EMPLOYEES 
ORDER BY "NOMBRE COMPLETO";


-- 4.2) Ordenar por nombre completo de la A a la Z - Opción 2: Usando la expresión completa de la columna
SELECT FIRST_NAME ||' '|| LAST_NAME "NOMBRE COMPLETO" 
FROM EMPLOYEES 
ORDER BY FIRST_NAME ||' '|| LAST_NAME;


-- 4.3) Ordenar por nombre completo de la A a la Z - Opción 3: Usando el número de la posición de la columna
SELECT FIRST_NAME ||' '|| LAST_NAME "NOMBRE COMPLETO" 
FROM EMPLOYEES 
ORDER BY 1;


-- 5) Ordenar los empleados por antiguedad laboral (de los más antiguos a los más nuevos)
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE_COMPLETO",
       HIRE_DATE "FECHA_CONTRATO" 
FROM EMPLOYEES 
ORDER BY 2;


-- 6.1) Ordenar los empleados por porcentaje de comisión (de mayor a menor % de comisión)
SELECT LAST_NAME "APELLIDO",
       COMMISSION_PCT "COMISIÓN" 
FROM EMPLOYEES 
ORDER BY "COMISIÓN" DESC;


-- 6.2) Ordenar los empleados por porcentaje de comisión dejando los valores nulos al final - NULLS LAST
SELECT LAST_NAME "APELLIDO",
       COMMISSION_PCT "COMISIÓN" 
FROM EMPLOYEES 
ORDER BY "COMISIÓN" DESC NULLS LAST;


-- 7.1) Ordenar los empleados por MANAGER_ID de manera ascendente
SELECT MANAGER_ID "ID JEFE"
FROM EMPLOYEES 
ORDER BY "ID JEFE";


-- 7.2) Ordenar los empleados por MANAGER_ID dejando los NULL al principio - NULLS FIRST
SELECT MANAGER_ID "ID JEFE"
FROM EMPLOYEES 
ORDER BY "ID JEFE" NULLS FIRST;


-- 8) Aumentar los salarios de los empleados un 9% y mostrar los salarios reajustados de mayor a menor
SELECT EMPLOYEE_ID "ID EMPLEADO",
       SALARY "SALARIO",
       SALARY * 1.09 "SALARIO REAJUSTADO" 
FROM EMPLOYEES 
ORDER BY SALARY * 1.09 DESC;  -- Se puede ordenar por la expresión completa de la columna


-------------------------------------------------{  SELECT DISTINCT  }--------------------------------------------------


--> Sintaxis:

SELECT DISTINCT columna 
FROM Tabla;


--> Se utiliza inmediatamente después de un SELECT para evitar que se muestren filas repetidas (quitar la redundancia)
--> Las filas repetidas son aquellas en donde los valores de los campos son iguales en toda la fila (si se selecciona la PK no pueden haber filas repetidas)
--> DISTINCT se usa mucho cuando las tablas de la BD no están normalizadas (Se puede desnormalizar para mejorar el rendimiento de las consultas)


-- 1.1) Mostrar el campo JOB_ID de la tabla EMPLOYEES (muestra 107 filas y muchas repetidas)
SELECT JOB_ID "TRABAJO"
FROM EMPLOYEES;


-- 1.2) Mostrar los trabajos pero sin filas repetidas (muestra 19 filas)
SELECT DISTINCT JOB_ID "TRABAJO"
FROM EMPLOYEES;


-- 1.3) Si en el resulset no hay filas repetidas DISTINCT no tiene efecto (no aplica)
SELECT DISTINCT EMPLOYEE_ID "ID EMPLEADO", -- Al estar la PK la fila no se repetirá nunca
                JOB_ID "TRABAJO"
FROM EMPLOYEES;


-- 2.1) Mostrar los distintos departamentos de los empleados - Sin DISTINCT
SELECT DEPARTMENT_ID
FROM EMPLOYEES;       -- Arroja 107 filas


-- 2.2) Mostrar los distintos departamentos de los empleados - Con DISTINCT
SELECT DISTINCT DEPARTMENT_ID          -- Al estar la FK si pueden haber filas repetidas
FROM EMPLOYEES
ORDER BY DEPARTMENT_ID NULLS FIRST;    -- Arroja solo 12 filas 


----------------{  OPERADORES LÓGICOS  }-----------{  WHERE|  }----------{  OPERADORES RELACIONALES  }------------


--> Sintaxis:  

SELECT columna1,
       columna2 
FROM Tabla
WHERE columna1 condicion;


--> WHERE restringe a que las filas deben cumplir con una condición para ser visualizadas, actualizadas o eliminadas (SELECT, UPDATE, DELETE)
--> La única sentencia DML que no va con WHERE es el INSERT
--> Se puede utilizar la cláusula WHERE para mostrar solamente las filas que cumplan con una o varias condiciones
--> El WHERE es como un "filtro" que tienen las consultas y hace que se muestren solo las filas que "pasen el filtro"
--> En una sentencia SELECT o DELETE la cláusula WHERE va a continuación de la cláusula FROM (en el UPDATE va después de SET)


-->     * Operadores Lógicos:

-->        AND :  Verdadero, solo si todas las condiciones son Verdaderas (condicion1 AND condicion2 AND condicion3)
-->         OR :  Verdadero, si hay al menos una condición verdadera (condicion1 OR condicion2 OR condicion3)
-->        NOT :  Negación, es decir, cambia una condicion verdadera a falsa (NOT Verdad) y una falsa a verdadera (NOT Falso) 


-->     * Operadores Relacionales:

-->                  Igual:  =
-->               distinto:  !=  <>
-->              mayor que:  >      
-->      mayor o igual que:  >=
-->              menor que:  <      
-->      menor o igual que:  <=


--> Preferir usar el operador != ya que es estándar para todos los motores de BD relacionales (el <> NO es estándar)


-- 1.1) Mostrar todos los empleados que tengan apellido 'Smith'
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO" 
FROM EMPLOYEES 
WHERE LAST_NAME = 'Smith' 
ORDER BY FIRST_NAME;


-- 1.2) Mostrar todos los empleados que NO tengan apellido 'Smith' - NOT
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO" 
FROM EMPLOYEES 
WHERE NOT LAST_NAME = 'Smith'   -- WHERE LAST_NAME != 'Smith' 
ORDER BY LAST_NAME DESC;


-- 2) Mostrar todos los empleados que se llamen 'David' o 'John'
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO"
FROM EMPLOYEES 
WHERE FIRST_NAME = 'David' OR FIRST_NAME = 'John'  -- WHERE FIRST_NAME IN ('David', 'John')
ORDER BY FIRST_NAME, LAST_NAME;


-- 3) Mostrar todos los empleados que ganen más de 12 mil dolares
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE COMPLETO",
       SALARY "SALARIO"
FROM EMPLOYEES 
WHERE SALARY > 12000 
ORDER BY SALARY DESC;


-- 4) Mostrar los empleados cuyo salario este entre 8 mil y 10 mil dolares, ambos incluidos
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE EMPLEADO",
       SALARY "SALARIO"
FROM EMPLOYEES 
WHERE SALARY >= 8000 AND SALARY <= 10000   -- WHERE SALARY BETWEEN 8000 AND 12000
ORDER BY SALARY DESC;


-- 5) Mostrar todos los empleados que no tengan registrado un Depto.
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO",
       DEPARTMENT_ID "DEPARTAMENTO" 
FROM EMPLOYEES 
WHERE DEPARTMENT_ID IS NULL;


-- 6) Mostrar las regiones que no sean ni 'Americas' ni 'Europe' - Operador 'distinto de'
SELECT REGION_NAME "REGIÓN" 
FROM REGIONS 
WHERE REGION_NAME != 'Americas' AND REGION_NAME != 'Europe';  -- WHERE REGION_NAME NOT IN ('Americas', 'Europe')


-- 7) Mostrar todos los empleados que fueron contratados despues del año 2006
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO",
       HIRE_DATE "FECHA_CONTRATACION" 
FROM EMPLOYEES 
WHERE HIRE_DATE >= '01/01/2007' -- El literal de fecha debe tener un formato válido de fecha para que Oracle haga la conversión implícita a DATE
ORDER BY HIRE_DATE;


-- 8) Mostrar nombre completo de los empleados que trabajen en IT_PROG y que ganen más de 5 mil dolares
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE COMPLETO",
       JOB_ID "TRABAJO",
       SALARY "SALARIO"
FROM EMPLOYEES
WHERE JOB_ID = 'IT_PROG' AND SALARY > 5000 
ORDER BY SALARY DESC; 


---------------------------------{  BETWEEN  }---------------------------{  NOT BETWEEN  }-------------------------------


--> Sintaxis:

SELECT columna1,
       columna2
FROM Tabla
WHERE columna2 BETWEEN limiteInferior AND limiteSuperior;


--> Se utiliza para evaluar 'rangos' o 'intervalos'
--> Primero se coloca el valor más pequeño (límite inferior) y luego el valor más grande (límite superior)
--> Los valores que se ponen se incluyen dentro del rango (son inclusive) [limiteInferior - limiteSuperior]
--> Se puede utilizar 'NOT BETWEEN' para mostrar todos los valores que NO esten dentro de un rango


-- 1.1) Mostrar los empleados que ganen entre 10 mil y 14 mil dolares
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO"
FROM EMPLOYEES 
WHERE SALARY BETWEEN 10000 AND 14000 
ORDER BY SALARY; 


-- 1.2) Mostrar los empleados que ganen menos de 3 mil dolares y los que ganen más de 12 mil - Sin NOT BETWEEN
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO" 
FROM EMPLOYEES 
WHERE SALARY < 3000 OR SALARY > 12000 
ORDER BY SALARY DESC;


-- 1.3) Mostrar los empleados que ganen menos de 3 mil dolares y los que ganen más de 12 mil - Usando NOT BETWEEN
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO" 
FROM EMPLOYEES 
WHERE SALARY NOT BETWEEN 3000 AND 12000 
ORDER BY SALARY DESC;


-- 2) Mostrar todos los empleados contratados entre marzo y diciembre del año 2006
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO" 
FROM EMPLOYEES 
WHERE HIRE_DATE BETWEEN '01/03/2006' AND '31/12/2006'
ORDER BY HIRE_DATE;


--------------------------{  IN  }-----------------------{  NOT IN  }--------------------------------


--> Sintaxis:

SELECT columna1,
       columna2
FROM Tabla
WHERE columna1 IN (valor1, valor2, valor3); 


-->         IN : Muestra las filas que cumplan con la condición que los valores de la columna1 se encuentren en la lista
-->     NOT IN : Muestra las filas que cumplan con la condición que los valores de la columna1 NO se encuentren en la lista

-->  WHERE columna IN (valor1, valor2, valor3) es lo mismo que hacer WHERE columna = valor1 OR columna = valor2 OR columna = valor3


-- 1.1) Mostrar todos los empleados que pertenezcan a IT_PROG, MK_MAN o ST_CLERK - Sin usar IN
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOB_ID "TRABAJO"
FROM EMPLOYEES 
WHERE JOB_ID = 'IT_PROG' OR JOB_ID = 'MK_MAN' OR JOB_ID = 'ST_CLERK' 
ORDER BY JOB_ID;


-- 1.2) Mostrar todos los empleados que pertenezcan a IT_PROG, MK_MAN o ST_CLERK - Usando operador IN
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOB_ID "TRABAJO" 
FROM EMPLOYEES 
WHERE JOB_ID IN ('IT_PROG', 'MK_MAN', 'ST_CLERK') 
ORDER BY JOB_ID;


-- 1.3) Mostrar todos los empleados que NO pertenezcan a IT_PROG, MK_MAN, ST_CLERK - Operador NOT IN
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOB_ID "TRABAJO" 
FROM EMPLOYEES 
WHERE JOB_ID NOT IN ('IT_PROG', 'MK_MAN', 'ST_CLERK') 
ORDER BY JOB_ID;


-- 2) Mostrar los empleados cuyo ID sea 100, 110 o 120
SELECT EMPLOYEE_ID "ID EMPLEADO",
       FIRST_NAME || ' ' || LAST_NAME "EMPLEADO" 
FROM EMPLOYEES 
WHERE EMPLOYEE_ID IN (100, 110, 120) 
ORDER BY "ID EMPLEADO";


--------------------------------{  LIKE  }-----------------{  NOT LIKE  }-----------------------------


--> Sintaxis:

SELECT columna1,
       columna2
FROM Tabla
WHERE columna2 LIKE 'patrón_de_caracteres';


--> Permite evaluar si los valores en una columna tiene o no un determinado 'patrón' de caracters (condición textual)

-->      '%patrón'  : Indica que pueden haber 0, 1 o varios caracteres antes del patrón buscado (cualquier cosa antes del patrón)
-->      'patrón%'  : Indica que pueden haber 0, 1 o varios caracteres después del patrón buscado (cualquier cosa después del patrón)
-->      '_patrón'  : Indica que pueden haber 1 caracter antes del patrón buscado (si ponemos 2 guiones bajos son 2 caracteres, y asi sucesivamente...)
-->      'patrón_'  : Indica que pueden haber 1 caracter después del patrón buscado (si ponemos 2 guiones bajos son 2 caracteres, y asi sucesivamente...)

--> Ambos comodines ( % y _ ) se pueden combinar de muchas maneras
--> Se puede usar LIKE no solo con columnas VARCHAR2 o CHAR, también con DATE y NUMBER


-- 1.1) Mostrar el nombre de todos los empleados que comienzan con la letra 'A'
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME LIKE 'A%' -- Primera letra A mayúscula y después cualquier cosa
ORDER BY FIRST_NAME;


-- 1.2) Mostrar el nombre de todos los empleados que NO comienzan con la letra 'A'
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME NOT LIKE 'A%' 
ORDER BY FIRST_NAME;


-- 1.3) Mostrar el nombre de todos los empleados que terminen con la letra 'a'
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME LIKE '%a' 
ORDER BY FIRST_NAME;


-- 1.4) Mostrar el nombre de todos los empleados que tengan una 'a' en la segunda letra del nombre
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME LIKE '_a%' -- El primer caracter puede ser cualquiera y el segundo la 'a' y después cualquier cosa
ORDER BY FIRST_NAME;


-- 1.5) Mostrar el nombre de todos los empleados que tengan una 'a' en la cuarta letra del nombre
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME LIKE '___a%' -- Acá hay 3 guiones bajos antes de la letra 'a'
ORDER BY FIRST_NAME;


-- 1.6) Mostrar todos los empleados que contengan la letra A en su nombre
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME LIKE '%A%' OR FIRST_NAME LIKE '%a%' -- Usando UPPER() o LOWER() es más corto: UPPER(FIRST_NAME) LIKE '%A%'
ORDER BY FIRST_NAME;


-- 1.7) Mostrar todos los empleados cuyo nombre comience y termine con la letra 'A'
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME LIKE 'A%a' 
ORDER BY FIRST_NAME;


-- 1.8) Mostrar todos los empleados que NO tengan la letra 'B' en su nombre
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME NOT LIKE '%B%' AND FIRST_NAME NOT LIKE '%b%' 
ORDER BY FIRST_NAME;


-- 2) Mostrar todos los empleados cuyo JOB_ID termine en 'MAN' o en 'REP'
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOB_ID "TRABAJO"
FROM EMPLOYEES 
WHERE JOB_ID LIKE '%MAN' OR JOB_ID LIKE '%REP';


-- 3) Mostrar todos los empleados que tengan un 5 en el antepenúltimo dígito del teléfono
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       PHONE_NUMBER "TELEFONO"
FROM EMPLOYEES 
WHERE PHONE_NUMBER LIKE '%5__';


-- 4) Mostrar todos los empleados cuyo número de teléfono termine en 69
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       PHONE_NUMBER "TELEFONO" 
FROM EMPLOYEES WHERE PHONE_NUMBER LIKE '%69' 
ORDER BY PHONE_NUMBER;


-- 5.1) Mostrar todos los empleados contratados el año 2003
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO" 
FROM EMPLOYEES 
WHERE HIRE_DATE LIKE '%03';


-- 5.2) Mostrar todos los empleados contratados en marzo del 2005
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO"  
FROM EMPLOYEES 
WHERE HIRE_DATE LIKE '%03_05';


-- 6) Mostrar todos los empleados cuyo MANAGER_ID termine en 5
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       MANAGER_ID "ID JEFE"  
FROM EMPLOYEES 
WHERE MANAGER_ID LIKE '%5';


--------------------------------{  IS NULL  }--------------------{  IS NOT NULL  }-------------------------------

--> Sintaxis:

SELECT columna1,                        SELECT columna1,
       columna2                                columna2
FROM Tabla                              FROM Tabla
WHERE columna1 IS NULL;                 WHERE columna1 IS NOT NULL;


--> Permite filtrar filas por los valores nulos (NULL) que tengan las columnas
--> Como los valores NULL son valores 'no disponibles' o 'desconocidos' no se pueden evaluar usando el operador =
--> SALARY = NULL       // Incorrecto!    
--> SALARY IS NULL      // Correcto! 
--> SALARY != NULL      // Incorrecto!    
--> SALARY IS NOT NULL  // Correcto! 


-- 1.1) Mostrar todos los empleados que NO tienen comisión de venta
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       COMMISSION_PCT "PORCENTAJE DE COMISION" 
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NULL
ORDER BY "EMPLEADO";


-- 1.2) Mostrar todos los empleados que tienen comisión de venta
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       COMMISSION_PCT "PORCENTAJE DE COMISION" 
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL
ORDER BY FIRST_NAME || ' ' || LAST_NAME;


-- 2) Mostrar el nombre completo de la empleada que no tiene asignado departamento
SELECT FIRST_NAME || ' ' || LAST_NAME "NOMBRE_COMPLETO",
       DEPARTMENT_ID "DEPTO"
FROM EMPLOYEES 
WHERE DEPARTMENT_ID IS NULL;


----------------------------------------- [  FUNCIONES DE CARACTERES  ]------------------------------------------


-->         UPPER() : Convertir a mayúsculas               <VARCHAR2>
-->         LOWER() : Convertir a minúsculas               <VARCHAR2>
-->       INITCAP() : Formato Título                       <VARCHAR2>

-->         LTRIM() : Quitar espacios iniciales            <VARCHAR2>
-->         RTRIM() : Quitar espacios finales              <VARCHAR2>
-->          TRIM() : Quitar espacios iniciales y finales  <VARCHAR2>
-->    TRIM( FROM ) : Eliminar caracter inicial y/o final  <VARCHAR2>

-->       REPLACE() : Reemplazar caracter(es)              <VARCHAR2>
-->        CONCAT() : Concatenar caracteres                <VARCHAR2>
-->        SUBSTR() : Extraer subcadena                    <VARCHAR2>
-->          LPAD() : Agregar caracteres a la izquierda    <VARCHAR2>
-->          RPAD() : Agregar caracteres a la derecha      <VARCHAR2>
-->        LENGTH() : Largo de la cadena                   <NUMBER>
-->         INSTR() : Posición del caracter(es)            <NUMBER>


----------------------{  UPPER()  }---------------{  LOWER()  }-------------{  INITCAP()  }-----------------------


-->        UPPER( columna o texto ) :  Convierte un texto a MAYÚSCULAS                                           <VARCHAR2>
-->        LOWER( columna o texto ) :  Convierte un texto a minúsculas                                           <VARCHAR2>
-->      INITCAP( columna o texto ) :  Pone la primera letra de un texto en mayúscula y el resto en minúscula    <VARCHAR2>


-- 1) Convertir a mayúsculas, minúsculas y formato título
SELECT 'EL Consultas de SQL' "FRASE ORIGINAL",
       UPPER('EL Consultas de SQL') "EN MAYÚSCULAS",
       LOWER('EL Consultas de SQL') "EN MINÚSCULAS",
       INITCAP('EL Consultas de SQL') "FORMATO TÍTULO"
FROM DUAL;


-- 2.1) Mostrar todos los empleados con apellido 'King'
SELECT FIRST_NAME,
       LAST_NAME 
FROM EMPLOYEES 
WHERE UPPER(LAST_NAME) = 'KING' 
ORDER BY FIRST_NAME;


-- 2.2) Mostrar todos los empleados llamados 'John'
SELECT FIRST_NAME,
       LAST_NAME 
FROM EMPLOYEES 
WHERE LOWER(FIRST_NAME) = 'john';


-- 3.1) Mostrar todos los empleados que tengan la letra B en su nombre - Opción 1: Sin usar UPPER()
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE FIRST_NAME LIKE '%B%' OR FIRST_NAME LIKE '%b%' 
ORDER BY FIRST_NAME;


-- 3.2) Mostrar todos los empleados que tengan la letra B en su nombre - Opción 2: Usando UPPER()
SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE UPPER(FIRST_NAME) LIKE '%B%' 
ORDER BY FIRST_NAME;


-- 4) Convertir a minúsculas los email de los empleados y agregarles '@duoc.alumnos.cl'
SELECT LOWER(EMAIL) || '@duoc.alumnos.cl' "FORMATO CORREO DUOC" 
FROM EMPLOYEES;


-- 5) Mostrar los nombres en mayúsculas, los apellidos en minúsculas y los JOB_ID en formato titulo
SELECT UPPER(FIRST_NAME) "NOMBRE",
       LOWER(LAST_NAME) "APELLIDO",
       INITCAP(JOB_ID) "TRABAJO" 
FROM EMPLOYEES;


---------------------------------------{  SUBSTR()  }--------------------------------------------


--> Sintaxis:    SUBSTR( columna o texto, desdeCaracter, cantidadCaracteresExtraidos )   <VARCHAR2>

--> Se utiliza para 'extraer' uno o varios caracteres contenidos en un texto
--> Si no se coloca 'cantidadCaracteresExtraidos' (tercer argumento) extrae hasta el FINAL del texto
--> Si desdeCaracter es POSITIVO cuenta las posiciones de izquierda a derecha
--> Si desdeCaracter es NEGATIVO cuenta las posiciones de derecha a izquierda


-- 1.1) Extraer la palabra 'MUNDO'
SELECT SUBSTR('HOLA MUNDO EN SQL', 6,5) "PALABRA" -- Desde el caracter 6 (M) voy a extraer 5 caracteres (MUNDO)
FROM DUAL;


-- 1.2) Extraer la palabra 'SQL' (Extraer los últimos 3 caracteres)
SELECT SUBSTR('HOLA MUNDO EN SQL', -3) "PALABRA" -- Cuento 3 de derecha a izquierda y extraigo desde ahi hasta el final
FROM DUAL;


-- 1.3) Extraer la palabra 'EN'
SELECT SUBSTR('HOLA MUNDO EN SQL', -6, 2) "PALABRA" -- Cuento 6 caracteres de derecha a izquierda y extraigo 2 caracteres
FROM DUAL;


-- 1.4) Extraer la frase 'MUNDO EN SQL' - Sin el 3er argumento extrae hasta el final
SELECT SUBSTR('HOLA MUNDO EN SQL', 6) "FRASE" -- Extraigo desde el caracter 6 hasta el final
FROM DUAL;


-- 1.5) Extraer el caracter que está en la posición 6
SELECT SUBSTR('HOLA MUNDO EN SQL', 6, 1) "caracter" -- Extraigo desde el caracter 6, 1 solo caracter
FROM DUAL;


-- 2) Mostrar solo los 3 primeros caracteres del nombre y el Primer caracter del apellido y un punto final (Dan F.)
SELECT SUBSTR(FIRST_NAME, 1, 3) || ' ' || SUBSTR(LAST_NAME, 1, 1) || '.' "NOMBRE_ABREVIADO" 
FROM EMPLOYEES;


-- 3) Extraer los últimos 2 dígitos de la fecha de contratación
SELECT SUBSTR(HIRE_DATE, -2) "AÑO CONTRATO"
FROM EMPLOYEES;


---------------------{  LTRIM()  }-----------------{  TRIM()  }---------------{  RTRIM()  }-----------------------


-->   LTRIM( columna o texto ) :  Quita espacios en blanco al INICIO (izquierda) de la cadena de texto     <VARCHAR2>
-->    TRIM( columna o texto ) :  Quita espacios en blanco al principio y al final de la cadena de texto   <VARCHAR2>
-->   RTRIM( columna o texto ) :  Quita espacios en blanco al FINAL (derecha) de la cadena de texto        <VARCHAR2>


-- 1) Quitar espacios en blanco al INICIO de la frase
SELECT LTRIM('      EL CONSULTAS') "SALIDA"
FROM DUAL;


-- 2) Quitar espacios en blanco al FINAL de la frase
SELECT RTRIM('EL CONSULTAS        ') "SALIDA"
FROM DUAL;


-- 3) Quitar espacios en blanco al principio y al final
SELECT TRIM('    EL CONSULTAS ANIDADAS    ') "SALIDA" 
FROM DUAL;


---------------------------------------------{  TRIM ( FROM )  }--------------------------------------------


-->             TRIM( 'caracter' FROM columna ) : Eliminar caracter inicial y final         <VARCHAR2>
-->     TRIM( LEADING 'caracter' FROM columna ) : Eliminar caracter inicial                 <VARCHAR2>
-->    TRIM( TRAILING 'caracter' FROM columna ) : Eliminar caracter final                   <VARCHAR2>


-- 1.1) Eliminar todos los cero al principio y al final - TRIM( FROM )
SELECT TRIM('0' FROM '00012345000') SALIDA 
FROM dual;


-- 1.2) Eliminar todos los cero al principio - TRIM(LEADING FROM )
SELECT TRIM(LEADING '0' FROM  '0001234500') SALIDA 
FROM dual;


-- 1.3) Eliminar todos los cero al final - TRIM(TRAILING FROM )
SELECT TRIM(TRAILING '0' FROM  '0001234500') SALIDA 
FROM dual;


-- 2.1) Eliminar todos los # al principio y al final, solo al principio y solo al final
SELECT '###FRASE###' "ORIGINAL",
       TRIM('#' FROM '###FRASE###') "TRIM FROM",
       TRIM(LEADING '#' FROM '###FRASE###') "TRIM LEADING FROM",
       TRIM(TRAILING '#' FROM '###FRASE###') "TRIM TRAILING FROM"
FROM DUAL;


-----------------------------------------------{  LENGTH()  }------------------------------------------------


-->  LENGHT( columna o texto ) : Cuenta los caracteres que tiene un texto      <NUMBER>


-- 1) Mostrar el largo de 'Chimbarongo. '
SELECT LENGTH('Chimbarongo. ') "CANTIDAD CARACTERES"  -- También se cuenta el punto y el caracter espacio
FROM DUAL;


-- 2) Mostrar cuantos caracteres tiene la frase 'Se viene el 18'
SELECT 'La frase tiene ' || LENGTH('Se viene el 18') || ' caracteres' "LARGO FRASE" 
FROM DUAL;


-- 3) Mostrar cuantos caracteres tienen los números de teléfono
SELECT DISTINCT 'Los teléfonos tienen ' || LENGTH(PHONE_NUMBER) || ' caracteres' "LARGO_TELEFONO" 
FROM EMPLOYEES;


-- 4) Mostrar los empleados que tengan en su apellido menos de 5 letras
SELECT LAST_NAME "APELLIDOS CORTOS"
FROM EMPLOYEES
WHERE LENGTH(LAST_NAME) < 5;


-- 5) Mostrar el rut 15183909K con un guion antes del dv
SELECT SUBSTR('15183909K', 1, LENGTH('15183909K') - 1) || '-' || SUBSTR('15183909K', -1) AS RUT
FROM DUAL;  -- Esta fórmula funciona para para rut de distintos tamaños 


--------------------------------{  LPAD()  }--------------------{  RPAD()  }-------------------------------


-->   LPAD( columna o texto, largo, 'caracterRelleno') : Rellena con caracteres a la IZQUIERDA de un texto    <VARCHAR2>
-->   RPAD( columna o texto, largo, 'caracterRelleno') : Rellena con caracteres a la DERECHA de un texto      <VARCHAR2>


-- 1) Rellenar con caracteres a la izquierda - LPAD()
SELECT LPAD('OLIVER ATOM', 20, '*') "RELLENO IZQUIERDA" -- Como la frase tiene 11 caracteres rellena con 9 asteriscos
FROM DUAL;


-- 2) Rellenar con caracteres a la derecha - RPAD()
SELECT RPAD('BENJI SPRITE', 20, '#') "RELLENO DERECHA" -- Como la frase tiene 12 caracteres rellena con 8 #
FROM DUAL;


-- 3) Ocultar con * los últimos 3 dígitos de los teléfonos de los empleados
SELECT RPAD(SUBSTR(PHONE_NUMBER, 1, LENGTH(PHONE_NUMBER)-3), LENGTH(PHONE_NUMBER), '*')  "TELEFONO" 
FROM EMPLOYEES;  -- Extrae el número de telefono quitando los últimos 3 digitos y luego rellena esos 3 dígitos con asteriscos


-- 4) Mostrar solo la primera Letra del apellido y rellenar con '?' el resto
SELECT FIRST_NAME "NOMBRE",
       RPAD(SUBSTR(LAST_NAME, 1, 1), LENGTH(LAST_NAME), '?') "SALIDA" 
FROM EMPLOYEES;


-- 5) Mostrar los primeros 3 caracteres del apellido, el salario y un asterisco (*) por cada dígito del salario.
SELECT SUBSTR(LAST_NAME, 1, 3) || ' ' || salary || ' ' || LPAD('*', LENGTH(SALARY), '*') "SALIDA" 
FROM EMPLOYEES;


-- 6.1) Alinear a la derecha el salario formateado como precio - Usando LPAD()
SELECT LPAD(TO_CHAR(SALARY, 'FM$99G999'), 15, ' ') "SALARIO"
FROM EMPLOYEES
ORDER BY "SALARIO";


-- 6.2) Alinear a la derecha el salario formateado como precio - Usando 'L' (símbolo de moneda local)
SELECT TO_CHAR(SALARY, 'L99G999') "SALARIO" -- Al usar 'L' en vés de '$' genera alineación derecha
FROM EMPLOYEES
ORDER BY "SALARIO";


----------------------------------------------{  INSTR()  }-------------------------------------------------------


--> Sintaxis:   INSTR( columna o texto, 'caracterBuscado', posicionDesde, ocurrencia )      <NUMBER>

--> Indica en que posición está el caracter buscado (arroja el número de la posición)


-- 1.1) Buscar en que posición está el arroba - Parte buscando desde el principio (posición 1, valor por defecto)
SELECT INSTR('AL.MALTRAIN@ALUMNOS.DUOC.CL', '@') "POSICION" 
FROM DUAL;


-- 1.2) Buscar en que posición esta el arroba - Parte buscando desde el segundo caracter (pos. 2)
SELECT INSTR('AL.MALTRAIN@ALUMNOS.DUOC.CL', '@', 2) "POSICION" 
FROM DUAL;


-- 1.3) Si no encuentra el caracter devuelve 0 (cero) - busca desde la pos. 13
SELECT INSTR('AL.MALTRAIN@ALUMNOS.DUOC.CL', '@', 13) "POSICION" 
FROM DUAL;


-- 2.1) ¿En que posición está el PRIMER punto de los números de teléfono?
SELECT DISTINCT INSTR(PHONE_NUMBER, '.') "POSICION" 
FROM EMPLOYEES;


-- 2.2) ¿En que posición(es) esta el SEGUNDO punto de los números de teléfono?
SELECT DISTINCT INSTR(PHONE_NUMBER, '.', 1, 2) "POSICION"   -- Al poner 2 busca la segunda ocurrencia
FROM EMPLOYEES;


-- 3.1) Muestra la posición donde se encuentra la tercera letra “e” en el apellido 
SELECT LAST_NAME APELLIDO,
       INSTR(LAST_NAME,'e', 1, 3) "POSICION TERCERA E"   -- Al poner 3 busca la tercera ocurrencia
FROM EMPLOYEES 
ORDER BY 2 DESC;


-- 3.2) ¿Cómo saber si hay apellidos que tienen espacios?
SELECT DISTINCT INSTR(LAST_NAME, ' ') "POSICION_ESPACIO" -- Si no tienen espacios devuelve 0
FROM EMPLOYEES;


-- 4.1) ¿Quién tiene espacios en su apellido? - Usando INSTR()
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO"
FROM EMPLOYEES 
WHERE INSTR(LAST_NAME, ' ') <> 0;


-- 4.2) ¿Quién tiene espacios en su apellido? - Usando LIKE ' '
SELECT FIRST_NAME "NOMBRE",
       LAST_NAME "APELLIDO" 
FROM EMPLOYEES 
WHERE LAST_NAME LIKE '% %';


----------------------------------------------{  REPLACE ()  }--------------------------------------------


--> Sintaxis:     REPLACE( columna o texto, 'antiguaCadena', 'nuevaCadena' )

-->  Busca la 'cadenaAntigua' y la reemplaza por la 'nuevaCadena'     <VARCHAR2>
-->  Cuando se utiliza REPLACE(columna, 'caracter', '') elimina todas las ocurrencias de ese caracter


-- 1) Reemplazar 'NEU' por 'SUB'
SELECT 'PROFE NEUMARINO ' "PROFESOR",
        REPLACE('PROFE NEUMARINO', 'NEU', 'SUB') "REEMPLAZO" 
FROM DUAL;


-- 2) Reemplazar las barras crecientes de las fechas por guión
SELECT HIRE_DATE "FECHA CONTRATO",
       REPLACE(HIRE_DATE, '/', '-') "NUEVO FORMATO" 
FROM EMPLOYEES;


-- 3) También se puede usar para eliminar caracteres al reemplazar un caracter por vacio ('')
SELECT '15.183.909-6' "RUT NORMAL",
        TO_NUMBER(REPLACE(REPLACE('15.183.909-6', '.', ''), '-', '')) "RUT NUMERICO"
FROM DUAL;  -- Primero quito los puntos, luego el guión y queda con el formato válido para pasarlo a número


-- 4) Mostrar todos los números telefónicos sin punto
SELECT PHONE_NUMBER "TELEFONO",
       LPAD(REPLACE(PHONE_NUMBER, '.', ''), 15, ' ') "TELEFONO SIN PUNTOS" 
FROM EMPLOYEES; 


----------------------------------------- [  FUNCIONES DE NÚMEROS  ]------------------------------------------


-->     ROUND() : Redondear número                     <NUMBER>
-->     TRUNC() : Truncar número                       <NUMBER>
-->       MOD() : Devuelve el resto de la división     <NUMBER>


-------------------------------------------------{  ROUND()  }-------------------------------------------------


--> ROUND( columna o número, cantidadDecimales ) : Redondea un número con una cantidad de decimales especificado   <NUMBER>

--> Si no se especifica la cantidad de decimales o se pone 0, redondea al entero más cercano
--> Si ponemos -cantidadDecimales redondea a decenas, centenas, etc.


-- 1.1) Redondear al entero más cercano - Especificando 0 decimales
SELECT 1234.4678 "NUMERO ORIGINAL", 
       ROUND(1234.4678, 0) "NUMERO REDONDEADO" 
FROM DUAL;


-- 1.2) Redondear al entero más cercano - Omitiendo el 0 (por defecto es 0)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       ROUND(1234.4678) "NUMERO REDONDEADO" 
FROM DUAL;


-- 1.3) Redondear con solo 1 decimal
SELECT 1234.4678 "NUMERO ORIGINAL", 
       ROUND(1234.4678, 1) "NUMERO REDONDEADO" 
FROM DUAL;


-- 1.4) Redondear con 3 decimales
SELECT 1234.4678 "NUMERO ORIGINAL", 
       ROUND(1234.4678, 3) "NUMERO REDONDEADO" 
FROM DUAL;


-- 1.5) Redondear a las decenas (10)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       ROUND(1234.4678, -1) "NUMERO REDONDEADO" 
FROM DUAL;


-- 1.6) Redondear a las centenas (100)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       ROUND(1234.4678, -2) "NUMERO REDONDEADO" 
FROM DUAL;


-- 1.7) Redondear a la unidad de mil (1000)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       ROUND(1234.4678, -3) "NUMERO REDONDEADO" 
FROM DUAL;


-- 2) Mostrar el valor de la comisión redondeado a un solo decimal
SELECT DISTINCT COMMISSION_PCT "PORCENTAJE DE COMISION",
                ROUND(COMMISSION_PCT, 1) "COMISION REDONDEADA" 
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL;


----------------------------------------{  TRUNC()  }-------------------------------------------


--> TRUNC( columna o número, cantidadDecimales ) : Trunca un número con una cantidad de decimales especificado  <NUMBER>

--> Si no se especifica la cantidad de decimales, el valor por defecto es 0 decimales
--> Si ponemos -cantidadDecimales trunca el número a decenas, centenas, etc.


-- 1.1) Truncar número (cortar número) especificando 0 decimales
SELECT 1234.4678 "NUMERO ORIGINAL", 
       TRUNC(1234.4678, 0) "NUMERO TRUNCADO" 
FROM DUAL;


-- 1.2) Truncar número (cortar número) - Omitiendo el 0 (por defecto es 0)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       TRUNC(1234.4678) "NUMERO TRUNCADO" 
FROM DUAL;


-- 1.3) Truncar con solo 1 decimal (cortar número con un decimal)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       TRUNC(1234.4678, 1) "NUMERO TRUNCADO" 
FROM DUAL;


-- 1.4) Truncar con 3 decimales (cortar número con 3 decimales)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       TRUNC(1234.4678, 3) "NUMERO TRUNCADO" 
FROM DUAL;


-- 1.5) Truncar a las decenas (10)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       TRUNC(1234.4678, -1) "NUMERO TRUNCADO" 
FROM DUAL;


-- 1.6) Truncar a las centenas (100)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       TRUNC(1234.4678, -2) "NUMERO TRUNCADO" 
FROM DUAL;


-- 1.7) Truncar a la unidad de mil (1000)
SELECT 1234.4678 "NUMERO ORIGINAL", 
       TRUNC(1234.4678, -3) "NUMERO TRUNCADO" 
FROM DUAL;


-- 2) Mostrar el valor de la comisión truncado a un solo decimal
SELECT DISTINCT COMMISSION_PCT "PORCENTAJE DE COMISION",
                TRUNC(COMMISSION_PCT, 1) "COMISION TRUNCADA" 
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL;


-- 3) Redondear y truncar la nota 3,99
SELECT 3.99 "NOTA ORIGINAL",
       ROUND(3.99, 1) "NOTA REDONDEADA",
       TRUNC(3.99, 1) "NOTA TRUNCADA"
FROM DUAL;


-----------------------------------------{  MOD()  }------------------------------------------------


--> MOD ( dividendo, divisor ) : Devuelve el resto de la división de 2 números    <NUMBER>


-- 1.1) Conocer el resto de la división entre 5 y 3
SELECT MOD(5, 3) "RESTO" 
FROM DUAL;


-- 1.2) Conocer el resto de la división entre 11 y 7
SELECT MOD(11, 7) "RESTO" 
FROM DUAL;


-- 2.1) Mostrar todos los empleados cuyo ID sea par (Es par si el resto es 0)
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       EMPLOYEE_ID "ID EMPLEADO" 
FROM EMPLOYEES 
WHERE MOD(EMPLOYEE_ID, 2) = 0;


-- 2.2) Mostrar todos los empleados cuyo ID sea impar (Es impar si el resto es 1)
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       EMPLOYEE_ID "ID EMPLEADO" 
FROM EMPLOYEES 
WHERE MOD(EMPLOYEE_ID, 2) = 1;


-------------------------------------------{  OPERACIONES CON FECHAS  }------------------------------------------


-->     FECHA - días     :  Restar días a una fecha             <DATE>
-->     FECHA + días     :  Sumar días a una fecha              <DATE>
-->     FECHA - FECHA    :  Días transcurridos entre 2 fechas   <NUMBER>


--> Para sumar y restar días debemos pasar los literales de fecha 'DD/MM/YYYY' a tipo DATE con la función TO_DATE('DD/MM/YYYY')
--> No se pueden sumar 2 fechas (FECHA + FECHA), solo esta permitido restar 2 fechas (FECHA - FECHA)
--> Las BD almacenan internamente las fechas en un formato numérico: siglo, año, mes, día, hora, minuto, segundo
--> Como se almacenan en formato numérico se podría hacer operaciones como estas: SYSDATE + 15 (Sumar 15 días a la fecha actual de la BD)
--> Cuando se consulta por una fecha se debe poner entre comillas simples, por ejemplo: WHERE HIRE_DATE > '18/09/20'


-- 1.1) ¿Qué fecha era hace 100 días atrás? - Restar días a una fecha
SELECT SYSDATE "FECHA ACTUAL",
       SYSDATE - 100 "HACE 100 DÍAS ATRÁS" 
FROM DUAL;


-- 1.2) ¿Qué fecha era hace un año atrás? - Restar días a una fecha
SELECT SYSDATE "FECHA ACTUAL",
       SYSDATE - 365 "HACE UN AÑO" 
FROM DUAL;


-- 1.3) ¿Que fecha será en 5 días más? - Sumar días a una fecha
SELECT SYSDATE "FECHA ACTUAL",
       SYSDATE + 5 "EN 5 DÍAS MÁS" 
FROM DUAL;


-- 2) Agregar 30 días a la fecha de contrato - Sumar días a una fecha
SELECT HIRE_DATE "FECHA CONTRATO",
       HIRE_DATE + 30 "FECHA CONTRATO + 30 DÍAS" 
FROM EMPLOYEES;


-- 3) ¿Cuantos días han transcurrido desde el 14 de febrero? - Restar 2 fechas
SELECT SYSDATE "FECHA ACTUAL",
       'Han transcurrido ' || TRUNC(SYSDATE - TO_DATE('14/02/2020')) || ' días' "DIAS TRANSCURRIDOS" 
FROM DUAL;


----------------------------------------- [  FUNCIONES DE FECHAS  ]------------------------------------------


-->              SYSDATE : Fecha y hora actual de la BD              <DATE>
-->         CURRENT_DATE : Fecha y hora actual de la sesión (PC)     <DATE>
-->     MONTHS_BETWEEN() : Meses transcurridos entre 2 fechas        <NUMBER>
-->           NEXT_DAY() : Fecha del siguiente día de la semana      <DATE>
-->         ADD_MONTHS() : Agrega meses a una fecha                  <DATE>
-->           LAST_DAY() : Último día del mes de una fecha           <DATE>
-->              ROUND() : Redondea una fecha                        <DATE>
-->              TRUNC() : Trunca una fecha                          <DATE>
-->            EXTRACT() : Extraer día, mes o año de una fecha       <NUMBER>


------------------------------------------------{  ROUND( fecha )  }---------------------------------------------


-->  ROUND( fecha, 'YEAR' o 'MONTH' ) : Redondea una fecha por año o por mes   <DATE>

--> La fecha debe estar en formato DATE, no puede ser solo un literal de fecha (usar TO_DATE() para convertirla a DATE)


-- 1.1) Redondear fecha por año - Primera mitad del año(dentro de los primeros 6 meses)
SELECT '12/03/20 ' "FECHA",
       ROUND(TO_DATE('12/03/2020'), 'YEAR') "FECHA REDONDEADA POR AÑO" -- Se debe convertir a tipo DATE antes de redondear
FROM DUAL;  -- Arroja 01/01/20


-- 1.2) Redondear fecha por año - Segunda mitad del año(dentro de los últimos 6 meses)
SELECT '12/08/20 ' "FECHA",
       ROUND(TO_DATE('12/08/2020'), 'YEAR') "FECHA REDONDEADA POR AÑO" 
FROM DUAL;   -- Arroja 01/01/21


-- 1.3) Redondear una fecha por mes - Primera mitad del mes (primeros 15 días del mes aprox.)
SELECT '11/08/20 ' "FECHA",
       ROUND(TO_DATE('11/08/2020'), 'MONTH') "FECHA REDONDEADA POR MES" 
FROM DUAL;  -- Arroja 01/08/20


-- 1.4) Redondear una fecha por mes - Segunda mitad del mes (últimos 15 días del mes aprox.)
SELECT '23/08/20 ' "FECHA",
       ROUND(TO_DATE('23/08/2020'), 'MONTH') "FECHA REDONDEADA POR MES" 
FROM DUAL;  -- Arroja 01/09/20


-- 2) Redondear por mes y por año la fecha de contrato
SELECT HIRE_DATE "FECHA CONTRATO",
       ROUND(HIRE_DATE, 'MONTH') "REDONDEA POR MES",
       ROUND(HIRE_DATE, 'YEAR') "REDONDEA POR AÑO" 
FROM EMPLOYEES;


------------------------------------------------{  TRUNC( fecha )  }---------------------------------------------


-->  TRUNC( fecha, 'YEAR' o 'MONTH' ) : Trunca una fecha por año o por mes   <DATE>

--> La fecha debe estar en formato DATE, no puede ser solo un literal de texto (usar TO_DATE() para convertirla a DATE)


-- 1.1) Truncar fecha por año - Primera mitad del año(dentro de los primeros 6 meses)
SELECT '12/03/20 ' "FECHA",
       TRUNC(TO_DATE('12/03/2020'), 'YEAR') "FECHA TRUNCADA POR AÑO" 
FROM DUAL;  -- Arroja 01/01/20


-- 1.2) Truncar fecha por año - Segunda mitad del año(dentro de los últimos 6 meses)
SELECT '12/08/20 ' "FECHA",
       TRUNC(TO_DATE('12/08/2020'), 'YEAR') "FECHA TRUNCADA POR AÑO" 
FROM DUAL;  -- Arroja 01/01/20


-- 1.3) Truncar una fecha por mes - Primera mitad del mes (primeros 15 días del mes aprox.)
SELECT '11/08/20 ' "FECHA",
       TRUNC(TO_DATE('11/08/2020'), 'MONTH') "FECHA TRUNCADA POR MES" 
FROM DUAL;  -- Arroja 01/08/20


-- 1.4) Truncar una fecha por mes - Segunda mitad del mes (últimos 15 días del mes aprox.)
SELECT '23/08/20 ' "FECHA",
       TRUNC(TO_DATE('23/08/2020'), 'MONTH') "FECHA TRUNCADA POR MES" 
FROM DUAL;  -- Arroja 01/08/20


-- 2) Truncar por mes y por año la fecha de contrato
SELECT HIRE_DATE "FECHA CONTRATO",
       TRUNC(HIRE_DATE, 'MONTH') "TRUNCA POR MES",
       TRUNC(HIRE_DATE, 'YEAR') "TRUNCA POR AÑO" 
FROM EMPLOYEES;


----------------------------------------------{  MONTHS_BETWEEN()  }-----------------------------------


-->  MONTHS_BETWEEN( fechaMasReciente, fechaMasAntigua ) : Muestra la diferencia en MESES entre 2 fechas   <NUMBER>

--> Si el resultado da NEGATIVO significa que pusieron como primer argumento la fecha más antigua (la fecha menor)
--> La parte decimal del resultado corresponde a una porción del mes (por ejemplo si da 2,5 significa dos meses y medio)
--> Esta es la función más óptima para calcular AÑOS que han transcurridos entre 2 fechas: TRUNC(MONTHS_BETWEEN(fecha1, fecha2) / 12)
--> La fecha puede estar como literal de fecha 'DD/MM/YYYY' (Oracle se encarga de hacer la conversión implícita a DATE)
--> Los literale de fecha deben estar en un formato válido de fecha para que Oracle los pueda tratar como fechas (como tipo DATE)


-- 1.1) ¿Cuantos meses han pasado entre 2 fechas? - Formato 'DD/MM/YYYY'
SELECT '10/9/2020' "FECHA MAYOR",
       '7/8/2018' "FECHA MENOR",
       'Han pasado ' || TRUNC(MONTHS_BETWEEN('10/9/2020', '7/8/2018')) || ' meses' "MESES TRANSCURRIDOS" 
FROM DUAL;


-- 1.2) Cuantos meses han pasado entre 2 fechas - Formato 'DD/MM/YY'
SELECT '10/9/20' "FECHA MAYOR",
       '7/8/18' "FECHA MENOR",
       'Han pasado ' || TRUNC(MONTHS_BETWEEN('10/9/20', '7/8/18')) || ' meses' "MESES TRANSCURRIDOS" 
FROM DUAL;


-- 1.3) Cuantos meses han pasado entre 2 fechas - Formato 'DD MM YYYY'
SELECT '10 9 20' "FECHA MAYOR",
       '7 8 18' "FECHA MENOR",
       'Han pasado ' || TRUNC(MONTHS_BETWEEN('10 9 20', '7 8 18')) || ' meses' "MESES TRANSCURRIDOS" 
FROM DUAL;


-- 1.4) Cuantos meses han pasado entre 2 fechas - Formato 'DD-MM-YY'
SELECT '10-9-2020' "FECHA MAYOR",
       '7-8-2018' "FECHA MENOR",
       'Han pasado ' || TRUNC(MONTHS_BETWEEN('10-9-2020', '7-8-2018')) || ' meses' "MESES TRANSCURRIDOS" 
FROM DUAL;


-- 1.5) Cuantos meses han pasado entre 2 fechas - Formato 'DD/MON/YYYY'
SELECT '10/SEP/2020' "FECHA MAYOR",
       '7/AGO/2018' "FECHA MENOR",
       'Han pasado ' || TRUNC(MONTHS_BETWEEN('10/SEP/2020', '7/AGO/2018')) || ' meses' "MESES TRANSCURRIDOS" 
FROM DUAL;


-- 1.6) Cuantos meses han pasado entre 2 fechas - Formato 'DD/MONTH/YYYY'
SELECT '10/SEPTIEMBRE/2020' "FECHA MAYOR",
       '7/AGOSTO/2018' "FECHA MENOR",
       ' Han pasado ' || TRUNC(MONTHS_BETWEEN('10/SEPTIEMBRE/2020', '7/AGOSTO/2018')) || ' meses' "MESES TRANSCURRIDOS" 
FROM DUAL;


-- 2.1) Cuantos meses han pasado desde el terremoto del 2010
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, '27/02/2010')) || ' MESES' "MESES" 
FROM DUAL;


-- 2.2) Cuantos años han pasado desde el terremoto del 2010
SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, '27/02/2010') / 12) || ' AÑOS' "AÑOS TRANSCURRIDOS" 
FROM DUAL;


-- 3) Mostrar cuantos años llevan los empleados trabajando en la empresa y ordenar por antiguedad laboral descendente
SELECT FIRST_NAME || ' ' || LAST_NAME NOMBRE_COMPLETO,
       HIRE_DATE FECHA_CONTRATO,
       SYSDATE FECHA_ACTUAL,
       TRUNC((MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12)) "AÑOS TRABAJADOS"  -- Fórmula para calcular los años transcurridos
FROM EMPLOYEES 
ORDER BY AÑOS_TRABAJADOS DESC;


-----------------------------------------{  ADD_MONTHS()  }----------------------------------------------------


-->   ADD_MONTHS( fecha, numeroMeses ) : Añade (o quita) meses a una fecha   <DATE>

--> Si el numeroMeses del argumento es NEGATIVO entonces en vés de añadir QUITA meses a la fecha
--> La fecha puede estar como literal de fecha 'DD/MM/YYYY' (Oracle se encarga de hacer la conversión implícita a DATE)
--> Los literale de fecha deben estar en un formato válido de fecha para que Oracle los pueda tratar como fechas (como tipo DATE)


-- 1.1) Agregar 5 meses a la fecha actual
SELECT SYSDATE "FECHA ACTUAL",
       ADD_MONTHS(SYSDATE, 5) "EN 5 MESES MÁS" 
FROM DUAL;


-- 1.2) Restar 5 meses a la fecha actual
SELECT SYSDATE "FECHA ACTUAL",
       ADD_MONTHS(SYSDATE, -5) "HACE 5 MESES" 
FROM DUAL;


-- 2) Agregar y restar 3 meses a la fecha de contrato
SELECT HIRE_DATE "FECHA CONTRATO",
       ADD_MONTHS(HIRE_DATE, -3) "MENOS 3 MESES",
       ADD_MONTHS(HIRE_DATE, 3) "MÁS 3 MESES" 
FROM EMPLOYEES;


-- 3) Agregar 10 meses a un literal de fecha
SELECT '01/01/20 ' "FECHA",
       ADD_MONTHS('01/01/20', 10) "EN 10 MESES MÁS"
FROM DUAL;


-- 4.1) Forma INCORRECTA de sumar (o restar) meses a una fecha (número_mes + n )
SELECT LAST_NAME "APELLIDO",
       HIRE_DATE "FECHA CONTRATO"
FROM EMPLOYEES
WHERE EXTRACT(MONTH FROM HIRE_DATE) = EXTRACT(MONTH FROM SYSDATE) + 2;


-- 4.2) Forma CORRECTA de sumar (o restar) meses a una fecha - ADD_MONTHS(fecha, n)
SELECT LAST_NAME "APELLIDO",
       HIRE_DATE "FECHA CONTRATO"
FROM EMPLOYEES
WHERE EXTRACT(MONTH FROM HIRE_DATE) = EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, 2));


------------------------------------------{  NEXT_DAY()  }------------------------------------------------


-->    NEXT_DAY( fecha, 'dia' o numeroDiaSemana ) : Muestra la fecha del siguiente día de la semana    <DATE>

--> Preferir usar numeroDiaSemana, es menos propenso a errores escribir números del 1 al 7 que escribir el día en palabras
--> Si ponemos 'MIERCOLES' sin acento arroja error (ORA-01846: día de la semana no válido) por eso es preferible poner 3 como argumento
--> Si la BD estaba configurada en Inglés se deben escribir los días en inglés, o sino dará error (ahorrarse drama y poner el número del dia xD) 


-- 1.1) ¿Qué fecha es el próximo domingo? - Usando 'DOMINGO' como argumento
SELECT SYSDATE "FECHA ACTUAL",
       NEXT_DAY(SYSDATE, 'DOMINGO') "PRÓXIMO DOMINGO" 
FROM DUAL;


-- 1.2) ¿Qué fecha es el próximo domingo? - Usando 7 para representar el séptimo día de la semana
SELECT SYSDATE "FECHA ACTUAL",
       NEXT_DAY(SYSDATE, 7) "PRÓXIMO DOMINGO" 
FROM DUAL;


-- 1.3) ¿Qué fecha es el próximo miércoles? - Usando 'MIÉRCOLES' como argumento
SELECT SYSDATE "FECHA ACTUAL",
       NEXT_DAY(SYSDATE, 'MIÉRCOLES') "PRÓXIMO MIÉRCOLES" 
FROM DUAL;


-- 1.4) ¿Qué fecha es el próximo miércoles? - Usando 3 para representar el tercer día de la semana
SELECT SYSDATE "FECHA ACTUAL",
       NEXT_DAY(SYSDATE, 3) "PRÓXIMO MIÉRCOLES" 
FROM DUAL;


-- 2) Si el año nuevo cae un día Jueves, cuál es la fecha del primer Lunes del año 2021?
SELECT '31/DIC/2020' "ÚLTIMO DÍA DEL AÑO",
       NEXT_DAY('31/DIC/2020', 1) "PRIMER LUNES DEL AÑO 2021" 
FROM DUAL;


----------------------------------------------{  LAST_DAY()  }----------------------------------------------


-->  LAST_DAY() : Muestra el último día del mes de una fecha determinada    <DATE>

--> La función de fila LAST_DAY() puede arrojar 28, 29, 30 o 31 como valores de día (28/MM/YYYY - 29/MM/YYYY - 30/MM/YYYY - 31/MM/YYYY)


-- 1) ¿Cuál es el último día del mes actual?
SELECT SYSDATE "FECHA ACTUAL",
       LAST_DAY(SYSDATE) "ULTIMO DIA DEL MES" 
FROM DUAL;  -- Arroja 30/11/20


-- 2) ¿Este año fue bisiesto? (¿Febrero tuvo 29 días?)
SELECT LAST_DAY('01/FEB/2020') "FECHA" 
FROM DUAL;  -- Arroja 29/02/20


-- 3) Mostrar el último día del mes de la fecha de contratación
SELECT HIRE_DATE FECHA_CONTRATO,
       LAST_DAY(HIRE_DATE) "ULTIMO DIA" 
FROM EMPLOYEES;


-- 4) Mostrar los empleados que fueron contratados en un año bisiesto
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO"
FROM EMPLOYEES
WHERE LAST_DAY(HIRE_DATE) LIKE '29/02%';


------------------------------------{  EXTRACT()  }---------------------------------------------


-->                       EXTRACT (YEAR FROM fecha )   : Extraer año de una fecha      <NUMBER>
-->                      EXTRACT( MONTH FROM fecha )   : Extraer mes de una fecha      <NUMBER>
-->                        EXTRACT( DAY FROM fecha )   : Extraer día de una fecha      <NUMBER>

-->     EXTRACT(HOUR FROM CAST( fecha AS TIMESTAMP ))  : Extraer hora de una fecha      <NUMBER>
-->   EXTRACT(MINUTE FROM CAST( fecha AS TIMESTAMP ))  : Extraer minutos de una fecha   <NUMBER>
-->   EXTRACT(SECOND FROM CAST( fecha AS TIMESTAMP ))  : Extraer segundos de una fecha  <NUMBER>

--> EXTRACT(TIMEZONE_REGION FROM TO_TIMESTAMP_TZ( fecha, formato )) : Extraer el nombre la región de la zona horaria (Americas/Santiago)
-->   EXTRACT(TIMEZONE_HOUR FROM TO_TIMESTAMP_TZ( fecha, formato )) : Extraer el UTC (Tiempo Universal Coordinado, por ejemplo UTC -4) 


--> Para extraer horas, minutos y segundos se debe pasar de tipo DATE a TIMESTAMP (realizar casting)
--> Con la función TO_CHAR() se puede extraer más facilmente las horas, minutos y segundos: TO_CHAR(SYSDATE, 'HH24:MI:SS')
--> Como la función EXTRACT extrae números desde las fechas, al extraer el mes 03 lo muestra como 3 sin el cero a la izquierda


-- 1) Mostrar día, mes y año de la fecha actual
SELECT TO_CHAR(SYSDATE, 'FMDAY DD "de" MONTH "del" YYYY') "FECHA ACTUAL",
       EXTRACT(DAY FROM SYSDATE) "DIA",
       EXTRACT(MONTH FROM SYSDATE) "MES",
       EXTRACT(YEAR FROM SYSDATE) "AÑO"
FROM DUAL;


-- 2) Mostrar la hora, los minutos y los segundos de la fecha actual
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') "HORA ACTUAL",
       EXTRACT(HOUR FROM CAST(SYSDATE AS TIMESTAMP)) "HORA",
       EXTRACT(MINUTE FROM CAST(SYSDATE AS TIMESTAMP)) "MINUTOS",
       EXTRACT(SECOND FROM CAST(SYSDATE AS TIMESTAMP)) "SEGUNDOS" 
FROM DUAL;


-- 3) Extraer el día, el mes y el año de la fecha de contrato
SELECT HIRE_DATE "FECHA CONTRATO",
       EXTRACT(DAY FROM HIRE_DATE) "DIA",
       EXTRACT(MONTH FROM HIRE_DATE) "MES",
       EXTRACT(YEAR FROM HIRE_DATE) "AÑO" 
FROM EMPLOYEES
ORDER BY 4, 3, 2;  -- Ordenada por año, mes y día 


-- 4) Mostrar los empleados contratados el año 2004
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO" 
FROM EMPLOYEES
WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2004;


-- 5) Mostrar los empleados contratados en Enero o Febrero del 2008
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO" 
FROM EMPLOYEES
WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2008 AND EXTRACT(MONTH FROM HIRE_DATE) BETWEEN 1 AND 2
ORDER BY HIRE_DATE;


-- 6) Extraer nombre de la región de una zona horaria
SELECT EXTRACT(TIMEZONE_REGION FROM TO_TIMESTAMP_TZ( SYSDATE, 'DD/MM/YY' )) "NOMBRE REGION"
FROM EMPLOYEES;  -- Arroja "America/Santiago"


 -- 7) Extraer el UTC (Tiempo Universal Coordinado)
SELECT EXTRACT(TIMEZONE_HOUR FROM TO_TIMESTAMP_TZ( SYSDATE, 'DD/MM/YY' )) "UTC"
FROM EMPLOYEES;  -- Arroja -4


------------------------------------{  CONVERSIÓN IMPLÍCITA DE DATOS  }-----------------------------------------


--> En algunas ocasiones ORACLE se encarga de convertir automáticamente un tipo de dato en otro para poder realizar ciertas operaciones
--> El servidor Oracle puede convertir implícitamente (en forma automática) siempre que el valor a convertir tenga un FORMATO VÁLIDO
--> Su pueden convertir en forma implícita:

-->             VARCHAR2 (o CHAR)  ---->  NUMBER
-->             VARCHAR2 (o CHAR)  ---->  DATE
-->                        NUMBER  ---->  VARCHAR2
-->                          DATE  ---->  VARCHAR2


-- 1.1) Concatenar literales de texto
SELECT 'Tengo ' || '69' || ' años' "SALIDA" 
FROM DUAL;


-- 1.2) Concatenar literales de texto con número (el número 69 se pasa a texto de manera implícita)
SELECT 'Tengo ' || 69 || ' años' "SALIDA" 
FROM DUAL;


-- 2.1) Mostrar los empleados contratados despues del 2006 - Conversión explícita a DATE
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO"
FROM EMPLOYEES 
WHERE HIRE_DATE > TO_DATE('31/DIC/2006') 
ORDER BY HIRE_DATE;


-- 2.2) Mostrar los empleados contratados despues del 2006 - Conversión implícita a DATE (lo hace Oracle)
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO"
FROM EMPLOYEES 
WHERE HIRE_DATE > '31/DIC/2006'
ORDER BY HIRE_DATE;


-- 3.1) Mostrar los empleados que ganan más de 14 mil - Oracle pasa ese literal de texto '14000' a NUMBER
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO" 
FROM EMPLOYEES 
WHERE SALARY > '14000';  -- Si tuviese el signo $ no se podría convertir a NUMBER


-- 3.2) Si el texto no tiene un formato válido ORACLE no lo puede convertir implicitamente
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO" 
FROM EMPLOYEES 
WHERE SALARY > '$14000';  -- El signo $ no se puede convertir a NUMBER, solo acepta dígitos y signo -


---------------------------------{  FUNCIONES DE CONVERSIÓN EXPLÍCITA  }-----------------------------------------


-->        TO_CHAR() :  Convertir a texto     <VARCHAR2 o CHAR>
-->      TO_NUMBER() :  Convertir a número    <NUMBER>
-->        TO_DATE() :  Convertir a fecha     <DATE>


-----------------------------------------{  TO_CHAR() CON FECHAS }---------------------------------------------------


-->   TO_CHAR( fecha, 'formato' )  :  Convierte una fecha a texto    <VARCHAR2 o CHAR>

-->  Caracteres válidos como argumento:  /  -  .  ,  :  ;  "texto"  


-->                      FM :  Quita los espacios en blanco de relleno y los ceros a la izquierda

-->    * Formatos válidos de fechas:

-->                 DY o Dy :  Muestra el día de la semana abreviado en 3 letras   [ LUN - Lun ]
-->               DAY o Day :  Muestra el día de la semana en palabras             [ LUNES - Lunes ]
-->                      DD :  Muestra el día del mes en 2 dígitos (1-31)          [ 14 ]
-->                     DDD :  Muestra el día del año (1-366)                      [ 258 ]

-->                      MM :  Muestra el mes en 2 dígitos (01-12)                 [ 03 ]
-->               MON o Mon :  Muestra el mes abreviado en 3 letras                [ SEP - Sep ]
-->           MONTH o Month :  Muestra el mes en palabras                          [ SEPTIEMBRE - Septiembre ]

-->                    YYYY :  Muestra el año con los 4 dígitos                    [ 2020 ]
-->             YEAR o Year :  Muestra el año en palabras                          [ TWENTY TWENTY - Twenty Twenty ]
-->                   Q o q :  Muestra el trimestre de la fecha (1-4)              [ 3 ]

-->               HH o HH12 :  Muestra la hora (1-12)                              [ 02 ]
-->                    HH24 :  Muestra la hora (0-23)                              [ 14 ]
-->                      MI :  Muestra los minutos (1-60)                          [ 59 ]
-->                      SS :  Muestra los segundos (1-60)                         [ 51 ]
-->                 AM o PM :  Muestra el indicador del meridiano                  [ AM - PM ]

-->                      DL :  Muestra el formato de fecha LARGA                   [ LUNES 14 de SEPTIEMBRE de 2020 ]   
-->                      DS :  Muestra el formato de fecha CORTO                   [ 14-09-2020 ]
-->                      TS :  Muestra la hora en formato CORTO                    [ 18:54:49 ] 


--> FM debe ir "pegado" al formato que se especifica (sin espacios en blanco entre FM y el formato que se haya definido) 


-- 1.1) Formatos válidos para días
SELECT TO_CHAR(TO_DATE('01/08/2019'),'DD') "DIA CON CERO" ,               -- 01 
       TO_CHAR(TO_DATE('01/08/2019'),'FMDD') "DIA SIN 0",                 -- 1   
       TO_CHAR(TO_DATE('01/08/2019'),'DAY') "DIA DE LA SEMANA",           -- JUEVES
       TO_CHAR(TO_DATE('01/08/2019'),'DY') "DIA DE LA SEMANA ABREVIADO",  -- JUE
       TO_CHAR(TO_DATE('01/08/2019'),'DDD') "DIA DEL AÑO"                 -- 213 
FROM DUAL;


-- 1.2) Formatos válidos para meses
SELECT TO_CHAR(TO_DATE('23-SEP-20'), 'MM') "NUMERO DEL MES",          -- 09
       TO_CHAR(TO_DATE('23-SEP-20'), 'FMMM') "NUMERO DEL MES SIN 0",  -- 9
       TO_CHAR(TO_DATE('23-SEP-20'), 'MON') "MES ABREVIADO",          -- SEP 
       TO_CHAR(TO_DATE('23-SEP-20'), 'MONTH') "NOMBRE DEL MES"        -- SEPTIEMBRE
FROM DUAL;


-- 1.3) Formatos válidos para años
SELECT TO_CHAR(TO_DATE('23-SEP-20'), 'YYYY') "NUMERO DEL AÑO",    -- 2020
       TO_CHAR(TO_DATE('23-SEP-20'), 'YEAR') "AÑO EN PALABRAS",   -- TWENTY TWENTY
       TO_CHAR(TO_DATE('23-SEP-20'), 'Q') "TRIMESTRE DEL AÑO"     -- 3
FROM DUAL;


-- 2.1) Mostrar la fecha en formato largo  y en formato corto
SELECT TO_CHAR(SYSDATE, 'DL') || '  ' "FECHA LARGA",
       TO_CHAR(SYSDATE, 'DS') "FECHA CORTA"
FROM DUAL;


-- 2.2) Mostrar la hora actual
SELECT TO_CHAR(SYSDATE, 'TS') "HORA ACTUAL",
       TO_CHAR(SYSDATE, 'TS AM') "HORA ACTUAL CON MERIDIANO"
FROM DUAL;


-- 2.3) Extraer la hora, los minutos y los segundos de la fecha actual "del servidor de BD"
SELECT TO_CHAR(SYSDATE, 'HH24') "HORA",
       TO_CHAR(SYSDATE, 'MI') "MINUTOS",
       TO_CHAR(SYSDATE, 'SS') "SEGUNDOS"
FROM DUAL;

-- 2.4) Extraer la hora, los minutos y los segundos de la fecha actual "de la sesión (computador)"
SELECT TO_CHAR(CURRENT_DATE, 'HH24') "HORA",
       TO_CHAR(CURRENT_DATE, 'MI') "MINUTOS",
       TO_CHAR(CURRENT_DATE, 'SS') "SEGUNDOS"
FROM DUAL;


-- 3.1) Mostrar la fecha actual siguiendo el formato: Lunes 23 de Noviembre del 2020 
SELECT TO_CHAR(SYSDATE, 'FMDay DD "de" Month "del" YYYY') "FECHA ACTUAL" 
FROM DUAL;


--3.2) Mostrar la fecha actual siguiendo el formato: LUNES 23/MAR/2020
SELECT TO_CHAR(SYSDATE, 'FMDAY DD/MON/YYYY') "FECHA ACTUAL" 
FROM DUAL;


-- 3.3) Mostrar la fecha actual siguiendo el formato: 23-03-2020
SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY') "FECHA ACTUAL" 
FROM DUAL;


-- 3.4) Mostrar la fecha y hora actual con formato: 14/09/2020 - 18:14:53 PM
SELECT TO_CHAR(SYSDATE, 'DD/MM/YYYY - HH24:MI:SS AM') "FECHA HORA ACTUAL" 
FROM DUAL;


-- 3.5) Mostrar la hora actual con formato: 6:17:12 PM
SELECT TO_CHAR(SYSDATE, 'FMHH:MI:SS PM') "HORA ACTUAL" 
FROM DUAL;


-- 4.1) Mostrar todos los empleados contratados el año 2007
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO" 
FROM EMPLOYEES 
WHERE TO_CHAR(HIRE_DATE, 'YYYY') = '2007' 
ORDER BY HIRE_DATE;


-- 4.2) Mostrar todos los empleados contratados en Junio del 2007
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO" 
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'MM/YYYY') = '06/2007';


-- 4.3) Mostrar todos los empleados que entraron a trabajar un día Jueves 
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(HIRE_DATE, 'DL') "FECHA CONTRATO"  
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'FMDAY') = 'JUEVES';  -- Usar FM para quitar los espacios


-- 4.4) Mostrar todas las personas contratadas el 7 de Junio del 2002
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       HIRE_DATE "FECHA CONTRATO"
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE, 'FMDD/MM/YYYY') = '7/6/2002';  -- Usar FM para quitar los ceros iniciales


-- 5) Mostrar todos los empleados que hayan ingresado a trabajar un diá Miércoles entre Enero y Marzo
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(HIRE_DATE, 'DL') "FECHA CONTRATO" 
FROM EMPLOYEES 
WHERE TO_CHAR(HIRE_DATE, 'FMDAY') = 'MIÉRCOLES' AND (TO_CHAR(HIRE_DATE, 'FMMM') BETWEEN 1 AND 3)
ORDER BY HIRE_DATE; 


-- 6.1) Mostrar los empleados que esten de cumpleaños el próximo mes (tomar HIRE_DATE como fecha de nacimiento)
SELECT FIRST_NAME || ' ' || LAST_NAME "Empleado",
       TO_CHAR(HIRE_DATE, 'DD "de" Month') "Fecha Nacimiento"
FROM EMPLOYEES
WHERE EXTRACT(MONTH FROM HIRE_DATE) = EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, 1));


-- 6.2) Mostrar los empleados que estuvieron de cumpleaños el mes pasado (tomar HIRE_DATE como fecha de nacimiento)
SELECT FIRST_NAME || ' ' || LAST_NAME "Empleado",
       TO_CHAR(HIRE_DATE, 'DD "de" Month') "Fecha Nacimiento"
FROM EMPLOYEES
WHERE EXTRACT(MONTH FROM HIRE_DATE) = EXTRACT(MONTH FROM ADD_MONTHS(SYSDATE, -1));


-------------------------------------{  TO_CHAR() CON NÚMEROS  }--------------------------------------------


-->   TO_CHAR( numero, 'formato' )  :  Convierte un número a texto con un formato especificado   <VARCHAR2 o CHAR>

-->     * Formatos de números válidos: 

-->              9 : Representa un dígito del número
-->              0 : Fuerza a que se muestre un cero
-->              $ : Coloca un signo dólar
-->              L : Coloca el símbolo de moneda local ($, €, £, ¥, etc.)
-->              G : Muestra un punto como separador de miles
-->              D : Muestra el caracter decimal
-->              , : Coloca un separador de miles
-->              . : Coloca un punto decimal
-->              V : Multiplica por 10 n veces (n = número de nueves o ceros después de la V)


-- 1) Dar formato de precio : $1.250.000 - Con 'L' el valor queda alineado más a la derecha (rellena con espacios en blanco)
SELECT 1250000 "SIN FORMATO",
       TO_CHAR(1250000, '$9G999G999') "CON $",
       TO_CHAR(1250000, 'L9G999G999') "CON L"
FROM DUAL;


-- 2) Dar formato a los salarios de los empleados
SELECT SALARY SALARIO,
       TO_CHAR(SALARY, '$00000') "CON 0",                  -- '0' Completa el número agregando ceros
       TO_CHAR(SALARY, '$99,999.00') "CON COMA Y PUNTO ",  -- ',' '.' Formato gringo de precio
       TO_CHAR(SALARY, '$99G999D00') "CON G y D"           -- 'G' 'D' Formato chilensis
FROM EMPLOYEES 
ORDER BY SALARY;


-- 3) Agregar un cero a los rut que tengan menos de 8 digitos
SELECT '15183909' "RUT 8 DIGITOS",
       '9122345' "RUT 7 DIGITOS",
       TO_CHAR('15183909', '09G999G999') "RUT NORMAL", 
       TO_CHAR('9122345', '09G999G999') "RUT CON CERO",    -- Si el rut no tiene 8 dígitos rellena con 0
       TO_CHAR('9122345', '99G999G999') "RUT CON NUEVE"    -- Si el rut no tiene 8 dígitos no rellena
FROM DUAL;


-- 4) Multiplica la comisión por 100 ya que hay 2 dígitos después de la V (multiplica por 10^2)
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
    COMMISSION_PCT "COMISIÓN DECIMAL",
    TO_CHAR(COMMISSION_PCT, 'V00') "% COMISIÓN"  -- Muestra un número de 2 dígitos (hay 2 ceros)
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;


-- 5) Multiplica el salario por 1000 ya que hay 3 dígitos después de la V (multiplica por 10^3) 
SELECT SALARY "SALARIO",
       TO_CHAR(SALARY, '$99G999GV999') "SALARIO * 1000"  -- Muestra un número de hasta 8 dígitos (hay 8 nueves)
FROM EMPLOYEES
ORDER BY SALARY DESC;


--6 ) Si no especificamos los decimales en el formato, TO_CHAR() implicitamente redondea el valor
SELECT TO_CHAR(19900.5, 'L99G999') "VALOR REDONDEADO",        --  $19.901
       TO_CHAR(TRUNC(19900.5), 'L99G999') "VALOR TRUNCADO"    --  $19.900
FROM DUAL;


---------------------------------------------{  TO_NUMBER()  }------------------------------------------------------


-->  TO_NUMBER( texto, 'formato' ) : Convierte un texto a número   <NUMBER>

--> La cadena de texto debe contener un formáto válido para convertirlo a número (solo puede contener dígitos o el signo -)


-- 1) Convertir a número los siguientes VARCHAR2
SELECT TO_NUMBER('00000000000012') "NUMERO 1",
       TO_NUMBER('-0012') "NUMERO 2",
       TO_NUMBER(TRIM('  +  ') || '0101' || '1234') "NUMERO 3"
FROM DUAL;


-- 2) Convertir precios y rut a número
SELECT TO_NUMBER('$120.450.370', '$999G999G999') "PESOS A NÚMERO",
       TO_NUMBER('$37,450.62', '$99,999.99') "DOLAR A NÚMERO", 
       TO_NUMBER('15.183.909', '99G999G999') "RUT8 A NÚMERO",
       TO_NUMBER('9.183.909', '9G999G999') "RUT7 A NÚMERO"
FROM DUAL;


-- 3) Convertir a números los teléfonos de los empleados que tengan solo 10 dígitos
SELECT PHONE_NUMBER "TELEFONO VARCHAR2",
       TO_NUMBER(PHONE_NUMBER, '999G999G9999') "TELEFONO NUMBER"
FROM EMPLOYEES
WHERE LENGTH(PHONE_NUMBER) = 12;


----------------------------------------------{  TO_DATE()  }--------------------------------------------------


--> TO_DATE( texto, 'formato' ) : Convertir literal de texto a fecha    <DATE>

--> La cadena de texto debe tener un formato de fecha válido para convertirlo a DATE
--> Preferir la conversión explicita a la implícita, poner: SELECT TO_DATE('15/12/90', 'DD/MM/YY') antes que SELECT TO_DATE('15/12/90') FROM DUAL;


-- 1.1) Pasar fecha de formato gringo a Chileno
SELECT TO_DATE('2020-09-10', 'YYYY-MM-DD') "FECHA" 
FROM DUAL;


-- 1.2) Pasar fecha de formato gringo a Chileno
SELECT TO_DATE('08/25/94', 'MM/DD/YY') "FECHA" 
FROM DUAL;


-- 2.1) Pasar a fecha: 'Miércoles 12 de JULIO de 2017'
SELECT TO_DATE('Miércoles 12 de JULIO de 2017', 'DL') "FECHA" 
FROM DUAL;


-- 2.2) Pasar a fecha: 'Miércoles 12 de JULIO de 2017'
SELECT TO_DATE('Miércoles 12 de JULIO del 2017', 'Day DD "de" MONTH "del" YYYY') "FECHA" 
FROM DUAL;


--------------------------------------------{  FUNCIONES CON NULOS  }-----------------------------------------------


-->           NVL() : Reemplaza por el segundo argumento cuando encuentra valores nulos en el primero
-->          NVL2() : Siempre reemplaza el primer argumento, ya sea por el segundo o por el tercero si el primero era NULL
-->        NULLIF() : Si las 2 expresiones son iguales devuelve NULL, en caso contrario devuelve el valor del primer argumento
-->      COALESCE() : Devuelve el valor del primer argumento que no sea NULL


---------------------------------------------------{  NVL()  }-----------------------------------------------


--> NVL( argumento1, argumento2 ) : Reemplaza por el segundo argumento cuando el primero es NULL

--> Si el valor del primer argumento es NULL , devuelve el valor del segundo argumento. Si no es NULL retorna el valor de argumento1
--> NVL() Solamente reemplaza cuando encuentra un valor NULL, si no encuentra NO REEMPLAZA nada
--> Si los argumentos de la función no son NULL, deben ser EL MISMO TIPO DE DATO
--> Si queremos que el segundo argumento sea de un tipo de dato distinto, debemos cambiar el tipo de dato del primer argumento para que coincidan


-- 1.1) Si el primer argumento es null, lo reemplaza por el segundo argumento
SELECT NVL(NULL, 'VALOR REEMPLAZADO') "SALIDA" 
FROM DUAL;


-- 1.2) Notar que ambos argumentos deben ser del mismo tipo (en este caso ambos son VARCHAR2)
SELECT NVL('Hola', 'VALOR REEMPLAZADO') "SALIDA" 
FROM DUAL;


-- 2.1) Notar que ambos argumentos deben ser del mismo tipo (en este caso ambos son NUMBER)
SELECT NVL(5 * 5, 0) "SALIDA" 
FROM DUAL;


-- 2.2) Cualquier operación aritmética sobre NULL da siempre NULL
SELECT NVL(2 + NULL - 3 * 5, 0) "SALIDA" 
FROM DUAL;


-- 3.1) Mostrar la comisión de cada empleado reemplazando los null por cero
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       COMMISSION_PCT "COMISIÓN SIN NVL",
       NVL(COMMISSION_PCT, 0) "COMISION CON NVL" 
FROM EMPLOYEES;


-- 3.2) Mostrar la comisión de cada empleado reemplazando los null por 'No Tiene Comisión'
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       COMMISSION_PCT "COMISIÓN SIN NVL",
       NVL(TO_CHAR(COMMISSION_PCT, '0D99'), 'No Tiene Comisión') "COMISION CON NVL" 
FROM EMPLOYEES;


-- 4) Mostrar los distintos id de los jefes, si no hay asignado un id poner un cero
SELECT DISTINCT NVL(MANAGER_ID, 0) "ID DEL JEFE"
FROM EMPLOYEES
ORDER BY "ID DEL JEFE";


-- 5) Mostrar el salario anual de los empleados
SELECT LAST_NAME "APELLIDO",
       COMMISSION_PCT "% COMISION SIN NVL", 
       TO_CHAR((SALARY * 12) + (SALARY * 12 * COMMISSION_PCT), '$999G999') "SALARIO ANUAL SIN NVL" ,
       NVL(COMMISSION_PCT, 0) "% COMISION CON NVL",
       TO_CHAR((SALARY * 12) + (SALARY * 12 * NVL(COMMISSION_PCT,0)), '$999G999') "SALARIO ANUAL CON NVL"
FROM EMPLOYEES
ORDER BY LAST_NAME;


-------------------------------------------------{  NVL2()  }--------------------------------------------------------------


--> NVL2( argumento1, argumento2, argumento3) : Reemplaza el primer argumento, ya sea por el segundo o por el tercero si el primero es NULL

--> Si argumento1 es NULL se reemplaza por argumento3, en caso contrario, por argumento2
--> NVL2() SIEMPRE REEMPLAZA el primer argumento, ya sea por el argumento2 o por el argumento3
--> Si argumento2 y argumento3 no son NULL, deben ser EL MISMO TIPO DE DATO


-- 1.1) Como el primer argumento no es NULL se reemplaza por el segundo
SELECT NVL2('Argumento 1', 'Argumento 2', 'Argumento 3') "SALIDA"
FROM DUAL;  -- Arroja "Argumento 2"


-- 1.2)Como el primer argumento es NULL se reemplaza por el tercero
SELECT NVL2(NULL, 'Argumento 2', 'Argumento 3') "SALIDA" 
FROM DUAL;  -- Arroja "Argumento 3"


-- 2.1) Si los empleados tienen comisión poner 'Salario + Comisión', en caso contrario poner 'Solo Salario'
SELECT DEPARTMENT_ID " ID DEPARTAMENTO",
       TO_CHAR(SALARY, '$99G999') "SALARIO",
       COMMISSION_PCT "COMISION",
       NVL2(COMMISSION_PCT, 'Salario + Comisión', 'Solo Salario') "MENSAJE"
FROM EMPLOYEES 
WHERE DEPARTMENT_ID IN(20, 40, 60, 80, 90, 100) -- Para los empleados que pertenezcan a esos deptos
ORDER BY DEPARTMENT_ID;


-- 2.2) Si los empleados tienen comisión, mostrar el sueldo más la comisión
SELECT DEPARTMENT_ID " ID DEPARTAMENTO",
       TO_CHAR(SALARY, '$99G999') "SALARIO",
       COMMISSION_PCT "COMISION",
       TO_CHAR(NVL2(COMMISSION_PCT, (1 + COMMISSION_PCT) * SALARY, SALARY), '$99G999') "SALARIO + COMISION"
FROM EMPLOYEES 
WHERE DEPARTMENT_ID IN(20, 40, 60, 80, 90, 100) -- Para los empleados que pertenezcan a esos deptos
ORDER BY DEPARTMENT_ID;


--------------------------------------------------{  NULLIF()  }------------------------------------------------------------


--> NULLIF( argumento, argumento ) : Si las 2 expresiones son iguales devuelve NULL, en caso contrario devuelve el valor del primer argumento

--> Si los argumentos de la función no son NULL, deben ser EL MISMO TIPO DE DATO
--> Esta función no se utiliza casi nunca, es muy raro encontrar un contexto donde se pueda utilizar


-- 1.1) Cuando encuentra 2 valores iguales los reemplaza por un NULL
SELECT NULLIF(7 * 0, 5 * 0) "SALIDA" 
FROM DUAL;


-- 1.2) Si los valores son distintos, devuelve el valor del primer argumento
SELECT NULLIF(7 * 2, 5 * 3) "SALIDA" 
FROM DUAL;


-- 2) Devolver null si la Ciudad y la Provincia del Estado tienen el mismo nombre
SELECT CITY "CIUDAD",
       STATE_PROVINCE "PROVINCIA DEL ESTADO",
       NULLIF(CITY,STATE_PROVINCE) "NULLIF"
FROM LOCATIONS
ORDER BY CITY DESC;  -- Utrecht, Sao Paulo y Oxford se repiten (devuelven null)


------------------------------------------------{  COALESCE()  }------------------------------------------------------------


-->  COALESCE( argumento1, argumento2, argumento3, ...) : Devuelve el valor del primer argumento que no sea NULL

--> Si los argumentos de la función no son NULL, deben ser EL MISMO TIPO DE DATO
--> COALESCE() es la función más estándar para operar con valores nulos ya que se usa también en MySql (las otras son propias de Oracle)
 

-- 1) Devuelve el primer argumento que NO sea NULL - Operar sobre NULL siempre da NULL
SELECT COALESCE(5 + NULL, 4 * NULL, 8 - NULL, 3 / NULL, 3 * 3) "SALIDA" 
FROM DUAL;  -- Arroja 9


-- 2) Los empleados sin comisión mostrarán el DEPARTMENT_ID y el resto COMMISSION_PCT
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
COALESCE(COMMISSION_PCT, COMMISSION_PCT * SALARY, DEPARTMENT_ID) "SALIDA" 
FROM EMPLOYEES;


-- 3) Si tienen comisión muestra la comisión, sino tiene comisión muestra el MANAGER_ID, y si no tiene nada muestra 0
SELECT LAST_NAME "APELLIDO",
       COMMISSION_PCT "COMISIÓN",
       MANAGER_ID "ID JEFE",
       COALESCE(COMMISSION_PCT, MANAGER_ID, 0) "CON COALESCE"
FROM EMPLOYEES
WHERE UPPER(LAST_NAME) LIKE '%K%'; -- Para los que tengan una 'K' en el apellido


-------------------------------------------------{  FUNCIONES ASCII  }---------------------------------------------------------


--     ASCII(caracter) : Retorna el número de código ASCII de un caracter ingresado como parámetro    Ej: ASCII('A') Retorna 65

--   CHR(codigo_ascii) : Convierte un código ASCII (número entero entre 0 y 255) en un caracter       Ej: CHR(65) Retorna la letra A 


-------------------------------------------------{  FUNCIONES ANIDADAS  }---------------------------------------------------------


--> Para las funciones de fila no hay límite en cuanto a la cantidad de funciones anidadas (las funciones de grupo solo permiten anidar 1 nivel)

-- 1) Las funciones anidadas en SQL se evaluan de adentro hacia afuera: TRIM >> REPLACE >> CONCAT >> LPAD >> RPAD
SELECT RPAD(LPAD(CONCAT(REPLACE(TRIM('  EL CONSULTAS ANIDADAS  '), 'ANIDADAS' , 'DE BD'), ' 2020'), 30, '*'), 35, '#') "SALIDA" 
FROM DUAL;  

-- Primero se quitan los espacios con TRIM, luego se reemplaza "ANIDADAS" por "DE BD", se concatena con "2020", se agregan asteriscos a la izquierda y
--  finalmente se agregan gatos a la derecha


-------------------------------------------------{  EXPRESIONES CONDICIONALES  }-------------------------------------------------------------


--> Permiten implementar una estructura condicional tipo "IF-THEN-ELSE" en una sentencia SQL

-->    CASE TRADICIONAL : Similar al "switch-case-default" de JAVA, ya que evalua valores 'concretos' y no rangos o intervalos
-->            DECODE() : Función muy similar al "switch-case-default" de JAVA, ya que evalua valores 'concretos' y no rangos o intervalos
-->       CASE SEARCHED : Similar al "if-elif-else" de Python, ya que permite evaluar condiciones lógicas (>, <, <>, =, BETWEEN, IN, etc)


-----------------------------------------------------{  CASE TRADICIONAL  }---------------------------------------------------------

-->                CASE TRADICIONAL 
-->                ----------------

       --> Similar al "switch-case-default" de JAVA, ya que evalua valores 'concretos' y no rangos o intervalos
       --> Cuando en un WHEN encuentra una coincidencia con el valor del CASE entonces ejecuta ese WHEN-THEN  
       --> Si en los WHEN no hay coincidencias ejecuta el ELSE
       --> Los WHEN pueden tener distinto tipo de dato que los THEN, pero cada THEN debe tener el mismo tipo de dato entre ellos (mismo tipo de salida)
       --> Si un THEN arroja un tipo NUMBER, todo el resto debe arrojar tipo NUMBER, lo mismo para VARCHAR2, DATE, etc.

-- Sintaxis del CASE tradicional:
SELECT COLUMNA1,
       COLUMNA2,
       CASE COLUMNA -- Columna o expresión a evaluar
            WHEN valor_1  THEN hace_1
            WHEN valor_2  THEN hace_2
            WHEN valor_3  THEN hace_3
            WHEN valor_4  THEN hace_4
            WHEN valor_5  THEN hace_5
            ELSE valor_por_defecto
       END "alias de columna"
       COLUMNA4
FROM TABLA;


-- 1) Este code ejecuta el THEN que tenga el valor 'HOLA'
SELECT
       CASE 'HOLA' 
            WHEN 'OLI'      THEN 1 * 1
            WHEN 'HOLANDA'  THEN 2 * 2
            WHEN 'HELLO'    THEN 3 * 3
            WHEN 'HI'       THEN 4 * 4
            WHEN 'HOLA'     THEN 5 * 5  -- Ejecuta este THEN (Arroja 25)
            ELSE 6 * 6
       END "MENSAJE"
FROM DUAL;


-- 2.1) Aumentar un 15% a los de 'PR_REP' y 20% a los de 'MK_MAN', solo considerar los que trabajen en los depto 20, 70 y 110
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOB_ID "TRABAJO",
       DEPARTMENT_ID "DEPTO",
       TO_CHAR(SALARY, '$99G999') "SALARIO", 
       CASE JOB_ID
           WHEN 'MK_MAN'  THEN SALARY * 1.2
           WHEN 'PR_REP'  THEN SALARY * 1.15
           ELSE SALARY
       END "NUEVO SALARIO"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN(20, 70 , 110);


-- 2.2) Se puede aplicar una función de fila al case completo
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOB_ID "TRABAJO",
       DEPARTMENT_ID "DEPTO",
       TO_CHAR(SALARY, '$99G999') "SALARIO", 
       TO_CHAR(CASE JOB_ID
                   WHEN 'MK_MAN'  THEN SALARY * 1.2
                   WHEN 'PR_REP'  THEN SALARY * 1.15
                   ELSE SALARY
               END, '$99G999') "NUEVO SALARIO"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN(20, 70 , 110);


------------------------------------------{  DECODE ()  }---------------------------------------------------------


--> La función DECODE() es específica de ORACLE (SQL es un lenguaje estandarizado pero cada motor de BD provee algunas funciones propias)
--> La función DECODE() es muy similar al CASE tradicional


-- Sintaxis del DECODE:
SELECT COLUMNA1,
       COLUMNA2,
       DECODE(COLUMNA, valor_1, hace_1,
                       valor_2, hace_2,
                       valor_3, hace_3, 
                       valor_4, hace_4, 
                       valor_por_defecto) "alias de columna"
       COLUMNA4
FROM TABLA;


-- 1) Al encontrar una coincidencia realiza la primera acción que encuentra después de la coma
SELECT
       DECODE(5 * 4, 10, 'ES 10',
                     15, 'ES 15',
                     20, 'ES 20',       -- Arroja 'ES 20' 
                     25, 'ES 25', 
                    'VALOR POR DEFECTO') "SALIDA"
FROM DUAL;


-- 2.1) Aumento del salario de forma diferencial (dependiendo de a que JOB_ID pertenezcan)
SELECT EMPLOYEE_ID "ID EMPLEADO",
       JOB_ID "ID TRABAJO",
       SALARY "SALARIO",
       DECODE(JOB_ID, 'IT_PROG', SALARY * 1.1,
                      'MK_MAN',  SALARY * 1.15,
                      'SA_REP',  SALARY * 1.2, 
                      'PR_REP',  SALARY * 1.25,
                       SALARY) "NUEVO SALARIO"
FROM EMPLOYEES
WHERE JOB_ID IN('IT_PROG', 'MK_MAN', 'SA_REP', 'PR_REP');


-- 2.2) La función DECODE() también se puede anidar
SELECT EMPLOYEE_ID "ID EMPLEADO",
       JOB_ID "ID TRABAJO",
       TO_CHAR(SALARY, '$99G999') "SALARIO",
       TO_CHAR(DECODE(JOB_ID, 'IT_PROG', SALARY * 1.1,
                              'MK_MAN',  SALARY * 1.15,
                              'SA_REP',  SALARY * 1.2, 
                              'PR_REP',  SALARY * 1.25,
                              SALARY), '$99G999') "NUEVO SALARIO"
FROM EMPLOYEES
WHERE JOB_ID IN('IT_PROG', 'MK_MAN', 'SA_REP', 'PR_REP');


------------------------------------------------{  CASE SEARCHED  }---------------------------------------------------------


-->                CASE SEARCHED 
-->                ----------------

       --> Similar al "if-elif-else" de Python, ya que permite evaluar rangos o intervalos
       --> Se ejecuta el WHEN-THEN que primero cumpla con la condición lógica
       --> La condición lógica puede ser CUALQUIER expresión que retorne Verdadero o Falso
       --> Si no se ejecuta ningún WHEN-THEN, entonces se ejecuta el ELSE (el ELSE es opcional ponerlo)

-- Sintaxis del CASE searched:
SELECT COLUMNA1,
       COLUMNA2,
       CASE
           WHEN condición_lógica_1  THEN hace_1
           WHEN condición_lógica_2  THEN hace_2
           WHEN condición_lógica_3  THEN hace_3
           WHEN condición_lógica_4  THEN hace_4
           WHEN condición_lógica_5  THEN hace_5
           ELSE valor_por_defecto
       END "alias de columna",
       COLUMNA4
FROM TABLA;


-- 1) Ejecuta el WHEN-THEN cuyo valor este dentro del intervalo
SELECT CASE
           WHEN 7 * 8 BETWEEN  1 AND  25  THEN 'HACE ALGO 1'
           WHEN 7 * 8 BETWEEN 26 AND  50  THEN 'HACE ALGO 2'
           WHEN 7 * 8 BETWEEN 51 AND  75  THEN 'HACE ALGO 3'   -- Ejecuta este THEN
           WHEN 7 * 8 BETWEEN 76 AND 100  THEN 'HACE ALGO 4'
           ELSE 'HACE ALGO 5'
       END "SALIDA"
FROM DUAL;


-- 2) Categorizar los sueldos de los empleados
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(SALARY, '$999G999') "SALARIO",
       CASE
           WHEN SALARY BETWEEN  5000 AND 10000  THEN '"IGUAL ME ALCANZA"'
           WHEN SALARY BETWEEN 10001 AND 15000  THEN '"SUELDO REGULEQUE"'
           WHEN SALARY BETWEEN 15001 AND 20000  THEN '"ESTAI GANANDO WENO"'
           WHEN SALARY BETWEEN 20001 AND 25000  THEN '"A LO FARKAS"'
           ELSE '"NO TE ALCANZA NI PAL SUSHI"'
       END "DESCRIPCION SALARIO"
FROM EMPLOYEES
ORDER BY SALARY DESC;


-- 3) CASE es mucho más potente y flexible que DECODE
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOB_ID "ID TRABAJO",
       TO_CHAR(SALARY, '$99G999') "SALARIO",
       LPAD(CASE
               WHEN SALARY < 5000 AND JOB_ID IN('IT_PROG')  THEN 'POCO'
               WHEN SALARY BETWEEN 5000 AND 10000           THEN 'MAOMA'
               WHEN SALARY > 10000 AND SALARY <= 13000      THEN 'PULENTO'
               WHEN SALARY IN(14000)                        THEN 'WENA LUKSIC'
               ELSE 'NI FU NI FA'
            END, 15, ' ') "COLUMNA CALCULADA"
FROM EMPLOYEES
WHERE MOD(EMPLOYEE_ID, 2) = 1  -- Para que muestre solo para los empleados con ID impar
ORDER BY "COLUMNA CALCULADA" DESC;


-----------------------------------------{  VARIABLES DE SUSTITUCIÓN  & - &&  }--------------------------------------------------


--> Sintaxis:   &nombre_variable  o  &&nombre_variable 

-->  & : Se antepone al nombre de la variable cuyo valor se pedirá por teclado al usuario a través de una ventana emergente
--> && : Se utiliza el doble ampersand cuando se desea que el valor ingresado sea permanente (solo se le pedira una vez al usuario)

--> Las variables de sustitución permiten ingresar valores en tiempo de ejecución (ingreso de valores por teclado)
--> Las variables de sustitución se pueden utilizar en TODA la sentencia SELECT (columnas, tablas, condiciones lógicas, literales, etc.)
--> Cuando se pide que se ingrese "en forma paramétrica" o "dinamicamente" se refiere a utilizar variables de sustitución
--> Las variables de sustitución solo se pueden usar con el Developer, si el código SQL está dentro de otro lenguaje como Java, no funciona el &


-- 1) Solicitar por pantalla el número de empleado que se desea consultar
SELECT EMPLOYEE_ID "ID EMPLEADO",
       FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       PHONE_NUMBER "TELEFONO",
       HIRE_DATE "FECHA CONTRATO",
       DEPARTMENT_ID "DEPARTAMENTO",
       JOB_ID "TRABAJO"
FROM EMPLOYEES 
WHERE EMPLOYEE_ID = &numero_empleado;  -- Se pedira a través de una ventana que se ingrese el valor para 'numero_empleado'


-- 2.1) Para ingresar textos o fechas se deben ingresar con comillas simples ''
SELECT EMPLOYEE_ID "ID EMPLEADO",
       FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       PHONE_NUMBER "TELEFONO",
       HIRE_DATE "FECHA CONTRATO",
       DEPARTMENT_ID "DEPARTAMENTO",
       JOB_ID "TRABAJO"
FROM EMPLOYEES 
WHERE JOB_ID = UPPER(&nombre_trabajo);    -- Sin comillas simples (el usaurio debe ingresarlas)


-- 2.2) Si ponemos las comillas simples en el código, ya no será necesario que se ingresen por teclado
SELECT EMPLOYEE_ID "ID EMPLEADO",
       FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       PHONE_NUMBER "TELEFONO",
       HIRE_DATE "FECHA CONTRATO",
       DEPARTMENT_ID "DEPARTAMENTO",
       JOB_ID "TRABAJO"
FROM EMPLOYEES 
WHERE JOB_ID = UPPER('&nombreTrabajo');  -- El & debe ir DENTRO de las comillas: '&nombre_variable'


-- 3) Las variables de sustitución pueden reemplazar nombres de columnas, tablas, condiciones lógicas, etc.
SELECT &columna
FROM &tabla 
WHERE &condicion 
ORDER BY &columna;


-- 4) Dejar permanentemente almacenado el valor de la variable usando && (ya no vuelve a preguntar)
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(SALARY, '$999G999') "SALARIO",
       TO_CHAR(&&valor_bonificacion, '$999G999') "BONIFICACION",
       TO_CHAR(SALARY + &valor_bonificacion, '$99G9999') "SALARIO + BONO"  -- No la vuelve a pedir(valor ya guardado)
FROM EMPLOYEES;

-- Eliminar de la memoria el valor asignado a la variable "valor_bonificacion"
UNDEFINE valor_bonificacion;


-------------------------------------{  Funciones de Grupo  }------------------------------------------------------


--> Existen 5 funciones de grupo básicas:

-->               MAX() : Valor máximo                         <NUMBER>  <DATE>  <CHAR>  <VARCHAR2>
-->               MIN() : Valor mínimo                         <NUMBER>  <DATE>  <CHAR>  <VARCHAR2>
-->               SUM() : Sumatoria de valores                 <NUMBER> 
-->               AVG() : Calcular promedio                    <NUMBER> 
-->             COUNT() : Contar número de filas               <NUMBER>


-- Una Función de fila retorna un resultado por cada fila: 

--                     SALARY                                                        SALARIO
--         (Fila 1)    6000000    ---->                                       ----> $6.000.000    (Fila 1)                  
--         (Fila 2)    5000000    ---->                                       ----> $5.000.000    (Fila 2) 
--         (Fila 3)    9000000    ---->     TO_CHAR(SALARY, '$9G999G999')     ----> $9.000.000    (Fila 3)
--         (Fila 4)    7000000    ---->                                       ----> $7.000.000    (Fila 4) 
--         (Fila 5)    6000000    ---->                                       ----> $6.000.000    (Fila 5)


-- En cambio, una función de grupo retorna un resultado por cada 'grupo de filas':

--                         SALARY
--           (Fila 1)      6000000    ----> 
--           (Fila 2)      5000000    ---->                          SAL_MAX
--           (Fila 3)      9000000    ---->     MAX(Salario)  ---->  9000000    (Fila 1)
--           (Fila 4)      7000000    ----> 
--           (Fila 5)      6000000    ----> 


--> Funciones SQL de Grupo = Funciones Agregadas = Funciones de Múltiples Filas (FG)
--> Podrían actuar sobre TODAS las filas de una tabla o actuar sobre filas AGRUPADAS por la cláusula GROUP BY
--> Estas funciones reciben 1 solo argumento que puede ser NUMBER, DATE, CHAR, VARCHAR2 u otra función de grupo:  AVG(Argumento1, Argumento2) ERROR!!!
--> Ignoran los valores nulos (para que consideren los nulos se pueden sustituir usando las funciones de fila: NVL, NVL2 o COALESCE)
--> Si NO se agrupa con GROUP BY, la consulta solo puede tener funciones de grupo en la selección de columnas, no puede tener columnas solas (sin FG)
--> Si se selecciona una columna que no tenga FG, como por ejemplo SELECT HIRE_DATE, entonces esa columna debe estar obligatoriamente agrupada en el GROUP BY
--> Solo pueden haber FG en las cláusulas SELECT, HAVING y ORDER BY


----------------------------{  MAX()  }----------------------------{  MIN()  }-------------------------------------


-->         MAX() : Obtener el valor máximo de una columna o expresión        <NUMBER>  <DATE>  <CHAR>  <VARCHAR2>
-->         MIN() : Obtener el valor mínimo de una columna o expresión        <NUMBER>  <DATE>  <CHAR>  <VARCHAR2>


--> Sintaxis:   SELECT MAX( Columna o expresión ) FROM Tabla;
--> Sintaxis:   SELECT MIN( Columna o expresión ) FROM Tabla;


--> Estas funciones pueden recibir como argumentos: valores numéricos, fechas y texto (NUMBER, DATE, CHAR, VARCHAR2)
--> Cuando reciben una columna de tipo NUMBER, el resultado puede ser el número menor: MIN(valor) o el número mayor MAX(valor)
--> Cuando reciben una columna de tipo DATE, el resultado puede ser la fecha más antigua: MIN(fecha) o la fecha más actual: MAX(fecha)
--> Cuando reciben una columna de tipo VARCHAR2, el resultado puede ser la palabra menor: MIN(texto) o la palabra mayor: Max(texto)
--> Si hubiese una columna llamada abecedario la letra menor sería MIN(abecedario) = 'A' y la letra mayor MAX(abecedario) = 'Z' 


-- 1.1) Mostrar el salario más alto usando funciones de grupo - Muestra el MAYOR valor de la columna SALARY
SELECT TO_CHAR(MAX(SALARY), '$99G999') || ' Dolares' "SALARIO MAYOR"   
FROM EMPLOYEES;


-- 1.2) Mostrar el salario más bajo - Muestra el número MENOR de la columna SALARY
SELECT TO_CHAR(MIN(SALARY), '$99G999') || ' Dolares' "SALARIO MAYOR"   
FROM EMPLOYEES;


-- 2) ¿Cual es el menor y el mayor % de comisión? (Si la comisión es nula, reemplazar por 0)
SELECT MIN(NVL(COMMISSION_PCT, 0)) "COMISION MENOR",
       MAX(NVL(COMMISSION_PCT, 0)) "COMISION MAYOR"
FROM EMPLOYEES;


-- 3) Mostrar la fecha de contratación más antigua y la más reciente - 'DL' Muestra la fecha en formato largo
SELECT TO_CHAR(MIN(HIRE_DATE), 'DL') "FECHA MAS ANTIGUA",
       TO_CHAR(MAX(HIRE_DATE), 'DL') "FECHA MAS RECIENTE"
FROM EMPLOYEES;


-- 4) Si ordenamos los apellidos alfabeticamente (de la A a la Z), ¿cual será el primero y cual el último?
SELECT MIN(LAST_NAME) "PRIMER APELLIDO",
       MAX(LAST_NAME) "ÚLTIMO APELLIDO"
FROM EMPLOYEES;


------------------------------------------------{  SUM()  }----------------------------------------------------


-->            SUM() : Sumatoria de lo valores de columna o expresión       <NUMBER>

--> Sintaxis:     SELECT SUM( [DISTINCT o ALL] Columna o expresión ) FROM Tabla;


--> La opción DISTINCT hace que la función SUM() calcule la suma solo de los valores distintos (solo suma los valores diferentes)
--> La opción ALL (valor por defecto) hace que la función sume TODOS los valores


-- 1.1) Sumar los salarios de todos los empleados
SELECT TO_CHAR(SUM(SALARY), '$999G999') || ' Dolares' "SALARIOS SUMADOS"
FROM EMPLOYEES;


-- 1.2) Sumar solo los salarios que sean distintos (DISTINCT)
SELECT TO_CHAR(SUM(DISTINCT SALARY), '$999G999') || ' Dolares' "SUMA SALARIOS DISTINTOS"
FROM EMPLOYEES;


-- 2) Sumar el % de comisión de todos los empleados que tengan % de comisión - Las FG no consideran los NULL
SELECT SUM(COMMISSION_PCT) "SUMA DE % DE COMISION" 
FROM EMPLOYEES;


-- 3) Sumar todos los teléfonos - Se deben quitar los puntos con REPLACE() y Oracle convierte implicitamenta a NUMBER
SELECT TO_CHAR(SUM(REPLACE(PHONE_NUMBER, '.', '')), '999G999G999G999G999') "SUMA TOTAL TELEFONOS"
FROM EMPLOYEES;


--------------------------------------------------------{  AVG()  }----------------------------------------------------


-->           AVG() : Calcula el promedio de la columna o expresión    <NUMBER>

--> Sintaxis:     SELECT AVG( [DISTINCT o ALL] Columna o expresión ) FROM Tabla;


--> La opción DISTINCT hace que la función AVG() calcule el promedio solo considerando los valores distintos (excluye valores repetidos)
--> La opción ALL (valor por defecto) hace que la función considere todos los valores incluyendo los duplicados
--> Si se desea calcular el promedio de un campo que tenga valores nulos es importante usar la función NVL() para reemplazar null por un 0


-- 1.1) Mostrar el promedio de las comisiones redondeadas con 2 decimales de los empleados con comisión
SELECT ROUND(AVG(COMMISSION_PCT), 2) "PROMEDIO COMISION"
FROM EMPLOYEES;


-- 1.2) Mostrar el promedio de las comisiones incluyendo a TODOS los empleados - con NVL() se incluyen los NULL
SELECT ROUND(AVG(NVL(COMMISSION_PCT, 0)), 2) "PROMEDIO COMISION"
FROM EMPLOYEES;


-- 2.1) Mostrar el salario promedio
SELECT TO_CHAR(ROUND(AVG(SALARY)), '$9G999') || ' dolares' "SALARIO PROMEDIO" 
FROM EMPLOYEES;


-- 2.2) Mostrar el salario promedio de los empleados que tengan salarios distintos (DISTINCT)
SELECT TO_CHAR(ROUND(AVG(DISTINCT SALARY)), '$9G999') || ' dolares' "SALARIO PROMEDIO DISTINCT" 
FROM EMPLOYEES;


--------------------------------------------------------{  COUNT()  }----------------------------------------------------


-->           COUNT() : Cuenta el número de filas ignorando valores nulos      <NUMBER>

--> Sintaxis:     SELECT COUNT( [DISTINCT o ALL] Columna o expresión ) FROM Tabla;


--> La opción DISTINCT hace que la función cuente solo las filas que NO esten duplicadas (cuenta las filas que tengan valores diferentes)
--> La opción ALL (valor por defecto) hace que la función considere todos los valores incluyendo los duplicados
--> La opción COUNT(*) cuenta TODAS las filas de la tabla (ya que considera TODAS las columnas) (Es como contar por la clave primaria)
--> COUNT(COMMISSION_PCT) cuenta solo las filas de la columna COMMISSION_PCT (da 35 porque no cuenta las filas con valor NULL)


-- 1) Contar cuantos empleados tienen % de comisión y cuantos no tienen
SELECT 'Hay ' || COUNT(*) || ' empleados' "TOTAL DE EMPLEADOS", -- Cuenta TODAS las filas de la tabla EMPLOYEES
       COUNT(COMMISSION_PCT) || ' empleados tienen comisión' "EMPLEADOS CON COMISION", -- Cuenta filas no nulas de COMMISSION_PCT
       COUNT(*) - COUNT(COMMISSION_PCT) || ' Empleados no tienen comisión' "EMPLEADOS SIN COMISION"
FROM EMPLOYEES;


-- 2) ¿Cuantos empleados trabajan en 'IT_PROG'? - Con WHERE primero filtra la consulta y después de filtrar cuenta las filas
SELECT 'Hay ' || COUNT(*) || ' empleados que trabajan en IT_PROG' "TOTAL EMPLEADOS"
FROM EMPLOYEES
WHERE JOB_ID = 'IT_PROG';


-- 3) ¿Cuantos empleados ganan más de 12 mil dolares?
SELECT 'Hay ' || COUNT(*) || ' empleados que ganan más de 12 mil dolares' "TOTAL EMPLEADOS"
FROM EMPLOYEES
WHERE SALARY > 12000;   


-- 4.1) ¿Cuantos empleados tienen jefe? - Si en la columna MANAGER_ID hay valores nulos, COUNT() no los cuenta
SELECT COUNT(MANAGER_ID) "EMPLEADOS CON JEFE",
       COUNT(*) - COUNT(MANAGER_ID) "EMPLEADOS SIN JEFE"
FROM EMPLOYEES;


-- 4.2) Para obligar a que cuente nulos se puede usar NVL() reemplazando el valor nulo por otra cosa
SELECT 'Hay ' || COUNT(NVL(MANAGER_ID, 0)) || ' empleados' "TOTAL EMPLEADOS"
FROM EMPLOYEES;


-- 5) ¿Cuantos departamentos distintos hay? 
SELECT COUNT(DISTINCT DEPARTMENT_ID) "DEPTOS DISTINTOS",  -- Al usar DISTINCT no considera los valores repetidos
       COUNT(ALL DEPARTMENT_ID) "CON ALL EXPLÍCITO",      -- Cuenta filas con valores repetidos
       COUNT(DEPARTMENT_ID) "CON ALL IMPLÍCITO"           -- Se puede omitir la palabra 'ALL' (por defecto es ALL)
FROM EMPLOYEES;


------------------------------------------{  GROUP BY  }----------------------------------------------


--> Sintaxis:
SELECT columna, FG( columna o expresión )
FROM tabla
WHERE condición
GROUP BY columna
HAVING condición_de_grupo
ORDER BY columna;


--> Se puede usar la cláusula GROUP BY para agrupar filas de una tabla y asi poder obtener valores distintos para cada grupo de filas
--> Si hay en el SELECT una columna individual que no sea FG, debe aparecer obligadamente en el GROUP BY "igual" a como aparece en el SELECT
--> Si hay una columna en el SELECT cuya expresión tenga una FG junto con un campo individual, el campo que no este dentro de la FG debe estar en el GROUP BY
--> SUM(SALARY) + BONO : El campo BONO debe estar en el GROUP BY ya que no está dentro de una FG, si fuese SUM(SALARY + BONO), BONO no necesitaría estar en un GROUP BY
--> Con la cláusula WHERE se pueden excluir o filtrar filas ANTES de "dividir en grupos" con GROUP BY
--> Las columnas que esten agrupadas en la cláusula GROUP BY no es necesario que esten en el SELECT (si se ponen la información se entiende mejor)
--> Las funciones de grupo pueden estar anidadas solo un nivel (máximo 1 función de grupo como argumento de otra función de grupo)
--> Si se anida una función de grupo debe estar solita, no se puede agregar otra columna al SELECT (la consulta solo puede tener la FG anidada)
--> Si se anida una función de grupo la cláusula GROUP BY es OBLIGATORIA
--> Si se usa GROUP BY y queremos ordenar por una columna que NO está en el SELECT ni en el GROUP BY, debemos incluirla en el GROUP BY
--> Si tenemos en el SELECT una columna concatenada con otra columna: FIRST_NAME || ' ' || LAST_NAME, para ordenar por LAST_NAME debemos poner LAST_NAME en el GROUP BY 


-- 1) Mostrar el salario promedio por depto. (Al agrupar muestra los valores distintos que tiene la columna DEPARTMENT_ID)
SELECT DEPARTMENT_ID "ID DEPTO",
       TO_CHAR(AVG(SALARY), 'L99G999') "SALARIO PROMEDIO"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL -- Para evitar que muestre el DEPARTMENT_ID nulo
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;


-- 2) Mostrar el salario mayor de cada JOB_ID que termine con 'MAN'
SELECT JOB_ID "ID TRABAJO",
       TO_CHAR(MAX(SALARY), '$99G999') "SALARIO MAYOR"
FROM EMPLOYEES
WHERE JOB_ID LIKE '%MAN'
GROUP BY JOB_ID
ORDER BY "SALARIO MAYOR";


-- 3) Cuantos empleados trabajan en cada depto
SELECT 'En el depto ' || TO_CHAR(DEPARTMENT_ID) || ' trabaja(n) ' || COUNT(EMPLOYEE_ID) 
        || ' empleado(s)' "TOTAL DE EMPLEADOS POR DEPTO"
FROM EMPLOYEES
WHERE DEPARTMENT_ID IS NOT NULL
GROUP BY DEPARTMENT_ID
ORDER BY COUNT(EMPLOYEE_ID); -- Se ordena por cantidad de empleados (por el número)


-- 4) Obtener el salario total de cada trabajo por departamento
SELECT DEPARTMENT_ID "DEPTO",
       JOB_ID "TRABAJO",
       TO_CHAR(SUM(SALARY), '$999G999') || ' Dolares' "SALARIO TOTAL"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID, JOB_ID
ORDER BY SUM(SALARY) DESC; -- Ordenado por salario desc (por el valor numérico)


-- 5) Calcular el máximo promedio de salarios de cada depto - si se anida la columna debe estar SOLA
SELECT TO_CHAR(MAX(AVG(SALARY)), '$99G999') || ' Dolares' "PROMEDIO MAXIMO"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID; -- El GROUP BY es obligatorio ponerlo si hay una función de grupo anidada


------------------------------------------{  HAVING  }----------------------------------------------


--> Sintaxis:
SELECT columna, FG( columna o expresión )
FROM tabla
WHERE condición
GROUP BY columna
HAVING condición_de_grupo
ORDER BY columna;


--> No se puede usar una función de grupo en la cláusula WHERE, si queremos filtrar usando funcion de grupo debemos usar HAVING
--> HAVING va después de GROUP BY (por convención, ya que primero se agrupa y luego se filtra con HAVING)


-- 1) Obtener el salario máximo mayor a 8 mil dolares, por cada depto
SELECT DEPARTMENT_ID "DEPTO",
       TO_CHAR(MAX(SALARY), '$999G999') "SALARIO MAYOR"
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING MAX(SALARY) > 8000 -- Como la condición tiene FG no puede ir en la cláusula WHERE
ORDER BY DEPARTMENT_ID;


-- 2) Mostrar el depto y el salario promedio (redondeado) de los deptos que posean un salario máximo mayor a 10000
SELECT DEPARTMENT_ID "DEPTO",
       TO_CHAR(AVG(SALARY), '$99G999') "SALARIO PROMEDIO"  -- Con ese formato TO_CHAR() redondea el valor
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING MAX(SALARY) > 10000
ORDER BY AVG(SALARY); -- Así se ordena por el valor numérico y no como VARCHAR2


-- 3) Mostrar el depto y el salario mínimo y máximo de los deptos mayores a 50 que posean un salario min > 2500 y max > 5000
SELECT DEPARTMENT_ID "DEPTO",
       TO_CHAR(MIN(SALARY), '$99G999') "SALARIO MINIMO",
       TO_CHAR(MAX(SALARY), '$99G999') "SALARIO MAXIMO" 
FROM EMPLOYEES
WHERE DEPARTMENT_ID > 50
GROUP BY DEPARTMENT_ID
HAVING MIN(SALARY) > 2500 AND MAX(SALARY) > 5000
ORDER BY DEPARTMENT_ID;


----------------------------------------------------{  UNIÓN DE TABLAS  }-------------------------------------------------------------------------


--> Hasta ahora hemos estado trabajado con 1 sola tabla en cada consulta (SELECT columnas FROM Tabla)
--> Para poder trabajar con más de 1 tabla en la consulta se debe usar la cláusula JOIN
--> JOIN de tablas = Unir tablas = Asociar tablas
--> El JOIN se basa en una columna(o columnas) que sirve de nexo entre las tablas (generalmente es PK en una tabla y FK en la otra)


-->                          TIPOS DE JOIN:
-->                          --------------

-->    INNER JOIN   -> También llamado 'JOIN de unión INTERNA' (En teoría de conjuntos sería: A ∩ B, donde A y B son 2 tablas de la BD)
-->                 -> Es un EQUIJOIN o "JOIN de igualdad" y significa que los valores de la columna de unión de ambas tablas deben ser iguales
-->                 -> Los INNER JOIN no muestran las filas donde existan valores nulos en la columna de unión ya que no cumplen la condición de igualdad

-->     SELF JOIN   -> Es un EQUIJOIN O JOIN de igualdad sobre la misma tabla (se utiliza cuando existe una relación recursiva)

-->   NONEQUIJOIN   -> Es un "JOIN de NO igualdad", utiliza un operador de comparación distinto al signo igual para unir las 2 tablas (BETWEEN, >, <, <>, >=, <=)
-->                 -> En un NONEQUIJOIN las tablas NO se unen por las columnas que son PK y FK (como generalmente ocurre con los INNER JOIN)

-->    OUTER JOIN   -> Es un 'JOIN de unión EXTERNA'
-->                 -> Un OUTER JOIN retorna las filas de una tabla aunque éstas no tengan correspondencia de valor en la columna de comparación con la otra tabla
-->                 -> A diferencia de los INNER JOIN, los OUTER JOIN si nos permite trabajar con los valores nulos de las columnas de unión 

-->    CROSS JOIN   -> El CROSS JOIN o 'combinación cruzada' retorna el "Producto Cartesiano", es decir, TODAS las filas de TODAS las tablas implicadas en la unión


-------------------------------{  PREFIJO DE COLUMNAS }------------------------{  ALIAS DE TABLAS  }--------------------------------------------------


--> "Cualificar nombres de columna" es usar un prefijo en las columnas para especificar de que tabla son, por ejemplo JOBS.JOB_ID es de la tabla JOBS
--> Como las tablas pueden tener nombres muy largos, usar el nombre completo no es eficiente, es por eso que se prefiere utilizar un "alias de tabla"
--> Si 'E' es el alias de la tabla EMPLOYEES (FROM EMPLOYEES E) se pueden escribir las columnas de esa tabla como: E.JOB_ID, E.HIRE_DATE, E.DEPARTMENT_ID, etc.
--> Para diferenciar las columnas que tienen el mismo nombre en las tablas de unión, es necesario hacerlo con el prefijo de columna (E.JOB_ID = J.JOB_ID)
--> Es recomendable siempre usar prefijos de columna, ya que además de solucionar la ambiguedad en los JOIN, mejora el rendimiento de la consulta
--> Es recomendable usar siempre alias de tablas para mejorar el rendimiento de la consulta, y no solo cuando se hagan JOINS
--> Los alias de tabla deben ser lo más corto posibles (para ahorrar memoria), por ejemplo EMPLOYEES E, JOBS J, CREDITO C, CREDITO_CLIENTE CC, etc.


------------------------------------------------------{  INNER JOIN  }---------------------------------------------------------------


-->    El INNER JOIN se basa en una columna que sirve de nexo entre las tablas, una columna que es PK en una tabla y FK en la otra (generalmente)
-->    La condición de unión es donde los valores de la PK son los mismos que en la FK (los valores de la PK existen en la FK de la otra tabla)
-->    Retorna solo las filas que tienen valores idénticos en las columnas que se comparan para unir ambas tablas (por eso no considera nulos)
-->    Este es el JOIN más utilizado (el más común de los JOIN)
-->    No es necesario escribir 'INNER JOIN' se puede escribir solamente 'JOIN' (omitiendo la palabra 'INNER')


-->           TIPOS DE INNER JOIN (ON - NATURAL - USING)
-->           ------------------------------------------

-->        JOIN - ON : Realiza una unión de igualdad basada en la condición de la cláusula ON :  ON (T1.columna = T2.columna )
-->     NATURAL JOIN : Realiza una unión de igualdad basada en las columnas que tengan 'los mismos nombres' en las 2 tablas
-->     JOIN - USING : Realiza una unión de igualdad basada en el nombre de la columna:  USING (columna)


----------------------------------------------------{  NATURAL JOIN  }--------------------------------------------------------------


--Sintaxis

SELECT columna1,
       columna2,
       columna3
FROM Tabla1 
NATURAL JOIN Tabla2;


--> Establece una relación de igualdad basada en TODAS las columnas de 2 tablas que posean el mismo nombre
--> Permite seleccionar filas desde dos tablas que tengan los mismos valores en TODAS las columnas del mismo nombre
--> Si las columnas tienen el mismo nombre pero diferentes tipos de datos el servidor Oracle retorna un error
--> El NATURAL JOIN no se utiliza mucho, se usa mmucho más el JOIN ON
--> NATURAL JOIN no necesita poner alias de tabla o prefijo de columna (aunque se podría poner prefijos a las columnas NO coincidentes)
--> En el NATURAL JOIN las columnas coincidentes (que están en las 2 tablas) NO pueden llevar 'prefijo de columna'
--> Para agregar una condición se debe usar la cláusula WHERE


-- 1) Mostrar en que ciudad estan los deptos cuyo ID sea menor a 100
SELECT DEPARTMENT_ID "ID DEPTO",
       DEPARTMENT_NAME "NOMBRE DEPTO",
       LOCATION_ID "ID UBICACION",      -- Se relaciona esta columna ya que tiene el mismo nombre en las 2 tablas
       CITY "CIUDAD"
FROM DEPARTMENTS
NATURAL JOIN LOCATIONS
WHERE DEPARTMENT_ID < 100  -- Muestra los deptos cuyo ID sea menor a 100
ORDER BY DEPARTMENT_ID; 


-- 2) Mostrar en que depto trabajan los empleados cuyos jefes tengan un id de 108, 121 O 145 
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       DEPARTMENT_ID "ID DEPTO",     -- No puede llevar prefijo ya que es una 'columna relacionada' (está en las 2 tablas)
       MANAGER_ID "ID JEFE",         -- No puede llevar prefijo ya que es una 'columna relacionada' (está en las 2 tablas)
       D.DEPARTMENT_NAME "NOMBRE DEPTO"
FROM EMPLOYEES E
NATURAL JOIN DEPARTMENTS D           -- Relaciona 2 columnas que tienen el mismo nombre en ambas tablas
WHERE MANAGER_ID IN (108, 121, 145)
ORDER BY "ID JEFE";   -- Retorna solo 32 filas porque deben coincidir el mismo 'par de valores' en las 2 tablas


----------------------------------------------------{  JOIN USING  }--------------------------------------------------------------


--Sintaxis

SELECT columna1,
       columna2,
       columna3,         
FROM Tabla1 
JOIN Tabla2 USING (columna2);


--> Si en las tablas relacionadas hay varias columnas que tienen los mismos nombres, con USING se puede especificar que columna usar para la unión
--> USING permite hacer coincidir solamente una columna cuando en ambas tablas existen varias columnas con el mismo nombre
--> Si se desea efectuar la unión por más de una columna, éstas deben ir separadas por una coma:  USING (columna1, columna2, columna3)
--> La o las columnas relacionadas NO deben llevar prefijo de columna (lo mismo que en el NATURAL JOIN)
--> Para agregar una condición a la cláusula USING se debe usar la cláusula WHERE
--> Al igual que NATURAL JOIN no se utiliza mucho el JOIN USING, lo que más se utiliza es el JOIN ON


-- 1.1) Mostrar en que ciudad estan los deptos cuyo ID este entre 30 y 90
SELECT DEPARTMENT_ID "ID DEPTO",
       DEPARTMENT_NAME "NOMBRE DEPTO",
       LOCATION_ID "ID UBICACION",  -- Relaciona esta columna en la condición del USING
       CITY "CIUDAD"
FROM DEPARTMENTS
JOIN LOCATIONS USING (LOCATION_ID)
WHERE DEPARTMENT_ID BETWEEN 30 AND 90
ORDER BY DEPARTMENT_ID; 


-- 1.2) También se puede usar alias de tabla y prefijos de columnas (menos en la columna relacionada con USING)
SELECT D.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPTO",
       LOCATION_ID "ID UBICACION",       -- Relaciona esta columna en la condición del USING
       L.CITY "CIUDAD"
FROM DEPARTMENTS D
JOIN LOCATIONS L USING (LOCATION_ID)
WHERE D.DEPARTMENT_ID BETWEEN 30 AND 90
ORDER BY D.DEPARTMENT_ID; 


-- 2.1) Mostrar el id del jefe y del depto, de los empleados que trabajen en un depto que termine en ING
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       DEPARTMENT_ID "ID DEPTO",   -- No puede llevar prefijo ya que es una 'columna relacionada' por USING
       D.MANAGER_ID "ID JEFE",
       D.DEPARTMENT_NAME "NOMBRE DEPTO"
FROM EMPLOYEES E
JOIN DEPARTMENTS D USING (DEPARTMENT_ID)  -- Relaciona solo por DEPARTMENT_ID
WHERE D.DEPARTMENT_NAME LIKE '%ing'
ORDER BY E.EMPLOYEE_ID;                   -- Arroja 55 filas


-- 2.2) Mostrar el ID del empleado, el ID del depto, el ID del jefe y el nombre del depto
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       D.DEPARTMENT_ID "ID DEPTO",   
       MANAGER_ID "ID JEFE",              -- No puede llevar prefijo ya que es una 'columna relacionada' por USING
       D.DEPARTMENT_NAME "NOMBRE DEPTO"
FROM EMPLOYEES E
JOIN DEPARTMENTS D USING (MANAGER_ID)     -- Relaciona solo por MANAGER_ID
WHERE D.DEPARTMENT_NAME LIKE '%ing'
ORDER BY E.EMPLOYEE_ID;                   -- Arroja 15 filas


-- 2.3) Mostrar el ID del empleado, el ID del depto, el ID del jefe y el nombre del depto
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       DEPARTMENT_ID "ID DEPTO",          -- No puede llevar prefijo ya que es una 'columna relacionada' por USING 
       MANAGER_ID "ID JEFE",              -- No puede llevar prefijo ya que es una 'columna relacionada' por USING
       D.DEPARTMENT_NAME "NOMBRE DEPTO"
FROM EMPLOYEES E
JOIN DEPARTMENTS D USING (DEPARTMENT_ID, MANAGER_ID)     -- Relaciona por MANAGER_ID y por DEPARTMENT_ID
WHERE D.DEPARTMENT_NAME LIKE '%ing'
ORDER BY E.EMPLOYEE_ID;                   -- Arroja 15 filas


----------------------------------------------------{  JOIN ON  }--------------------------------------------------------------


--Sintaxis

SELECT T1.columna1,
       T1.columna2,
       T2.columna1,
       T2.columna2 
FROM Tabla1 T1
JOIN Tabla2 T2 ON (T1.columa = T2.columna);


--> Para especificar las columnas por las cuales se quiere unir las dos tablas, se utiliza la cláusula ON
--> También se puede usar la cláusula ON para unir columnas que tengan nombres distintos pero contienen el mismo dato en la misma tabla o en tablas diferentes
--> En la tabla EMPLOYEES, la columna EMPLOYEE_ID y MANAGER_ID almacenan el mismo dato pero tienen nombres distintos de columna
--> No olvidar que el nombre de la FK no tiene que ser obligatoriamente el mismo que la PK, puede que le hayan cambiado el nombre (igual almacena el mismo dato) 
--> Si hay un valor NULL en la llave foránea (la PK no puede tener NULL), esa fila no se considera en el JOIN ON (se excluyen los nulos)
--> Cuando se unen tablas no importa a cual tabla se acceda primero (FROM Tabla) y a cual después (JOIN Tabla) y la condición de igualdad del ON es conmutativa
--> Para ir saltando de una tabla a otra se debe hacer a través de las FK de las tablas (se aconseja revisar el modelo relacional de la BD)
--> Mientrás más saltos de tabla se hagan (más JOINS) más se degrada el rendimiento de la consulta, tratar de hacer los menos saltos posibles
--> Para agregar una condición a la cláusula ON se puede usar WHERE o el operador lógico AND (para seguir agregando más condiciones usar AND y OR)
--> En los JOIN ON, usar WHERE o agregar más condiciones con el AND es equivalente, pero en los OUTER JOIN puede arrojar distintos resultados (tener cuidado)
--> Usar WHERE aumenta el rendimiento de la consulta (en milisegundos) preferir usar WHERE antes que AND


-- 1.1) Mostrar el ID del empleado, nombre completo, el ID del trabajo y el nombre del trabajo
SELECT EMPLOYEE_ID "ID EMPLEADO",
       FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOBS.JOB_ID "ID TRABAJO",        -- Columna ambigua, necesita tener prefijo para saber de que tabla se extrae
       JOB_TITLE "NOMBRE DEL TRABAJO"
FROM EMPLOYEES
INNER JOIN JOBS ON (JOBS.JOB_ID = EMPLOYEES.JOB_ID) -- ON (Condición de igualdad del JOIN)
ORDER BY EMPLOYEE_ID;


-- 1.2) Para mejorar el rendimiento de la consulta se aconseja poner prefijo a todas las columnas
SELECT EMPLOYEES.EMPLOYEE_ID "ID EMPLEADO",
       EMPLOYEES.FIRST_NAME || ' ' || EMPLOYEES.LAST_NAME "EMPLEADO",
       JOBS.JOB_ID "ID TRABAJO",
       JOBS.JOB_TITLE "NOMBRE DEL TRABAJO"
FROM EMPLOYEES
INNER JOIN JOBS ON (JOBS.JOB_ID = EMPLOYEES.JOB_ID)
ORDER BY EMPLOYEES.EMPLOYEE_ID;


-- 1.3) Para evitar poner el nombre completo de la tabla como prefijo se pueden usar 'ALIAS DE TABLA'
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.FIRST_NAME || ' ' || E.LAST_NAME "EMPLEADO",
       J.JOB_ID "ID TRABAJO",
       J.JOB_TITLE "NOMBRE DEL TRABAJO"
FROM EMPLOYEES E
JOIN JOBS J ON (J.JOB_ID = E.JOB_ID) -- Se puede omitir la palabra 'INNER'
ORDER BY E.EMPLOYEE_ID;


-- 2) Mostrar el ID del empleado, nombre completo, el ID del depto y el nombre del depto
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.FIRST_NAME || ' ' || E.LAST_NAME "EMPLEADO",
       E.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPTO"
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID) 
ORDER BY E.EMPLOYEE_ID;   -- Devuelve 106 filas, hay una empleada sin depto(null)


-- 3.1) Mostrar ID empleado, salario, ID jefe, ID y nombre del depto para los jefes cuyo ID sea 149 o 100 (y ganen < 10000)
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.SALARY "SALARIO",
       E.MANAGER_ID "ID JEFE",
       E.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPTO"
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
AND E.MANAGER_ID IN(100, 149) AND E.SALARY < 10000; -- Usando AND para agregar condiciones


-- 3.2) Además de poder agregar condiciones con la cláusula ON, también se puede hacer con la cláusula WHERE
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.SALARY "SALARIO",
       E.MANAGER_ID "ID JEFE",
       E.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPTO"
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
WHERE E.MANAGER_ID IN(100, 149) AND E.SALARY < 10000; -- Usando WHERE para agregar condiciones (mejora el rendimiento)


-- 4) Mostrar nombre depto y el total de empleados cuyo jefe sea 149 o 100 y en los que trabajen menos de 5 empleados
SELECT D.DEPARTMENT_NAME "NOMBRE DEPTO",
       COUNT(E.EMPLOYEE_ID) "TOTAL EMPLEADOS"
FROM DEPARTMENTS D
JOIN EMPLOYEES E ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
WHERE E.MANAGER_ID IN(100, 149)
GROUP BY D.DEPARTMENT_NAME
HAVING COUNT(E.EMPLOYEE_ID) < 5 -- Para establecer condiciones con FG se debe usar HAVING y no WHERE
ORDER BY D.DEPARTMENT_NAME;


-- 5) Mostrar los empleados que han finalizado contrato y mostrar el tiempo que trabajaron en la empresa
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME "EMPLEADO",
       JH.START_DATE "INICIO CONTRATO",
       JH.END_DATE "FIN CONTRATO",
       CASE
           WHEN TRUNC(MONTHS_BETWEEN(JH.END_DATE, JH.START_DATE) / 12) = 0 
               THEN 'Trabajo ' || TRUNC(MOD(MONTHS_BETWEEN(JH.END_DATE, JH.START_DATE), 12)) || ' mes(es)'
           ELSE 'Trabajo ' || TRUNC(MONTHS_BETWEEN(JH.END_DATE, JH.START_DATE) / 12) || ' años y ' || 
                TRUNC(MOD(MONTHS_BETWEEN(JH.END_DATE, JH.START_DATE), 12)) || ' mes(es)'
       END "TIEMPO TRABAJADO"
FROM EMPLOYEES E
JOIN JOB_HISTORY JH ON (JH.EMPLOYEE_ID = E.EMPLOYEE_ID)
ORDER BY MONTHS_BETWEEN(JH.END_DATE, JH.START_DATE) / 12;  -- Ordenar por tiempo trabajado


----------------------------------------------------{  SELF JOIN  }--------------------------------------------------------------


--> Sintaxis:

SELECT T1.columna1,
       T1.columna2,
       T2.columna3
FROM tabla1 T1
JOIN tabla1 T2
ON (T1.columaFK = T2.columnaPK);


--> Un SELF JOIN es un JOIN sobre la misma tabla (se dá cuando hay una relación unaria o recursiva)
--> Un SELF JOIN es un EQUIJOIN (JOIN de igualdad) sobre la misma tabla y se debe usar la cláusula ON para establecer la condición de igualdad
--> Se deben unir las columnas de la tabla que tienen EL MISMO DATO. Por ejemplo en la tabla EMPLOYEES serían: EMPLOYEE_ID(PK) y MANAGER_ID(FK)
--> Las columnas EMPLOYEE_ID y MANAGER_ID almacenan el mismo valor(un ID de empleado) en la tabla EMPLOYEES ya que un jefe también es un empleado
--> En la cláusula FROM y en la cláusula JOIN se debe poner la misma tabla pero con "alias distintos" para poder realizar la comparación de igualdad


-- 1.1) Cuál es el nombre del jefe de cada empleado?
SELECT E.EMPLOYEE_ID "ID EMPLEADO",                    
       E.FIRST_NAME || ' ' || E.LAST_NAME "EMPLEADO",  
       E.MANAGER_ID "ID JEFE",                        -- También se podría poner "M.EMPLOYEE_ID"            
       M.FIRST_NAME || ' ' || M.LAST_NAME "JEFE"      
FROM EMPLOYEES E JOIN EMPLOYEES M ON (E.MANAGER_ID = M.EMPLOYEE_ID) -- (TablaIzquierda.FK = TablaDerecha.PK)  
ORDER BY E.EMPLOYEE_ID;     -- Arroja 106 filas porque hay un empleado sin jefe (manager_id = null)                          


-- 1.2) Notar que la tabla 'EMPLOYEES M' de la derecha del JOIN es la que se usa para obtener los datos del jefe
SELECT E.EMPLOYEE_ID "ID EMPLEADO",                    -- ID Empleado (E.) - Izquierda del JOIN
       E.FIRST_NAME || ' ' || E.LAST_NAME "EMPLEADO",  -- Nombre empleado (E.)- Izquierda del JOIN
       M.EMPLOYEE_ID "ID JEFE",                        -- ID Jefe (M.) - Derecha del JOIN  
       M.FIRST_NAME || ' ' || M.LAST_NAME "JEFE"       -- Nombre Jefe (M.) - Derecha del JOIN
FROM EMPLOYEES E JOIN EMPLOYEES M ON (E.MANAGER_ID = M.EMPLOYEE_ID)
ORDER BY E.EMPLOYEE_ID;


-- 2) ¿Cuantos empleados tiene a su cargo cada jefe?
SELECT M.FIRST_NAME || ' ' || M.LAST_NAME "NOMBRE JEFE",
       COUNT(E.EMPLOYEE_ID) "EMPLEADOS A SU CARGO"
FROM EMPLOYEES E JOIN EMPLOYEES M ON (E.MANAGER_ID = M.EMPLOYEE_ID)
GROUP BY M.FIRST_NAME || ' ' || M.LAST_NAME,  -- Al no tener FG está obligada a estar en el GROUP BY
         M.LAST_NAME -- Es obligatorio ponerla en el GROUP BY porque en el SELECT está concatenada con otra columna (no está sola)
ORDER BY "EMPLEADOS A SU CARGO" DESC, M.LAST_NAME;


----------------------------------------------------{  NONEQUIJOIN  }--------------------------------------------------------------


--Sintaxis:

SELECT T1.columna1,
       T1.columna2,
       T2.columna1,
       T2.columna2 
FROM tabla1 T1 
JOIN tabla2 T2 ON (T1.columa BETWEEN T2.columna1 AND T2.columna2);


--> Un NONEQUIJOIN (JOIN de no igualdad) es un INNER JOIN pero utiliza un operador de comparación distinto al signo igual para unir las dos tablas
--> Se utiliza cuando se quiere hacer la unión de 2 tablas que no tienen una columna en común (es por eso que no se puede usar el signo = )
--> En un NONEQUIJOIN no existe una relacion de igualdad entre una clave foránea(FK) y una clave primaria(PK)
--> Un NONEQUIJOIN Puede utilizar como operador de comparación: BETWEEN, >, <, >=, <=, <> (el más simple y usado es BETWEEN)
--> En un NONEQUIJOIN solo se puede utilizar la cláusula ON para establecer la condición de no igualdad


-- 1.0) Ejecutar el script para crear la tabla del ejemplo (Agregarla al esquema HR)

-- Crear la tabla PORC_BONO_ANNOS con 3 columnas numéricas
CREATE TABLE PORC_BONO_ANNOS (  
    ANNO_INI            NUMBER,
    ANNO_TER            NUMBER,
    PORCENTAJE_BONO     NUMBER);       

-- Poblar la tabla (ingresar datos en las respectivas columnas)
INSERT INTO PORC_BONO_ANNOS VALUES (1, 5, 5);
INSERT INTO PORC_BONO_ANNOS VALUES (6, 10, 7);
INSERT INTO PORC_BONO_ANNOS VALUES (11, 15, 10);
INSERT INTO PORC_BONO_ANNOS VALUES (16, 20, 12);
INSERT INTO PORC_BONO_ANNOS VALUES (21, 25, 15);
INSERT INTO PORC_BONO_ANNOS VALUES (26, 30, 20);
INSERT INTO PORC_BONO_ANNOS VALUES (31, 40, 30);

SELECT * FROM PORC_BONO_ANNOS;  -- Revisar que la tabla creada tenga todos sus datos

-- 1.1) Obtener el % de bonificación por los años trabajados de los empleados
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       TO_CHAR(E.SALARY, '$99G999') "SALARIO",
       TRUNC(MONTHS_BETWEEN(SYSDATE, E.HIRE_DATE) / 12) "AÑOS TRABAJADOS",
       TO_CHAR(ROUND(E.SALARY * (PBA.PORCENTAJE_BONO / 100)), '$99G999') "BONO POR AÑOS" 
FROM EMPLOYEES E
JOIN PORC_BONO_ANNOS PBA ON (TRUNC(MONTHS_BETWEEN(SYSDATE, E.HIRE_DATE) / 12) BETWEEN PBA.ANNO_INI AND PBA.ANNO_TER)
ORDER BY "ID EMPLEADO";

-- Borrar la tabla creada para el ejemplo
DROP TABLE PORC_BONO_ANNOS;


-- 2.0) Ejecutar el script para crear la tabla del ejemplo (Agregarla al esquema HR)

-- Crear la tabla AUMENTO_SUELDO con 3 columnas numéricas
CREATE TABLE AUMENTO_SUELDO (  
    LIMITE_INFERIOR      NUMBER,
    LIMITE_SUPERIOR      NUMBER,
    PORCENTAJE_AUMENTO   NUMBER);       

-- Poblar la tabla (ingresar datos en las respectivas columnas)
INSERT INTO AUMENTO_SUELDO VALUES (1000, 5000, 1.3);     -- Aumenta el salario un 30%
INSERT INTO AUMENTO_SUELDO VALUES (5001, 10000, 1.2);    -- Aumenta el salario un 20%
INSERT INTO AUMENTO_SUELDO VALUES (10001, 20000, 1.1);   -- Aumenta el salario un 10%
INSERT INTO AUMENTO_SUELDO VALUES (20001, 30000, 1.05);  -- Aumenta el salario un 5%

SELECT * FROM AUMENTO_SUELDO;  -- Revisar que la tabla creada tenga todos sus datos

-- 2.1) Aumentar el salario de los empleados de acuerdo a los rangos establecidos en la tabla AUMENTO_SUELDO
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME "EMPLEADO",
       TO_CHAR(E.SALARY, '$99G999') "SALARIO ACTUAL",
       TO_CHAR(E.SALARY * AU.PORCENTAJE_AUMENTO, '$99G999') "NUEVO SALARIO"
FROM EMPLOYEES E
JOIN AUMENTO_SUELDO AU ON (E.SALARY BETWEEN AU.LIMITE_INFERIOR AND AU.LIMITE_SUPERIOR) -- Aumenta el salario en un % que depende del rango en que se encuentre
ORDER BY E.SALARY * PORCENTAJE_AUMENTO;

-- Eliminar la tabla creada para realizar el ejemplo
DROP TABLE AUMENTO_SUELDO;


----------------------------------------------------{  OUTER JOIN  }--------------------------------------------------------------


--> JOIN de unión externa (combinación externa)
--> Un OUTER JOIN retorna las filas de una tabla aunque éstas no tengan correspondencia de valor en la columna de comparación con la otra tabla
--> A diferencia de los INNER JOIN, los OUTER JOIN si nos permite trabajar con los valores nulos de las columnas de unión 
--> En los OUTER JOIN preferir usar WHERE para filtrar, ya que si agregamos más condiciones en los ON (usando AND) puede arrojar resultados extraños
--> Preferir usar WHERE con los OUTER JOIN (porque primero une y después filtra, con los ON filtra una tabla y después une provocando muchos nulos)


-->           TIPOS DE OUTER JOIN:
-->           --------------------

-->  LEFT OUTER JOIN : Retorna el resultado de la 'unión de igualdad' y también las filas de la tabla de la izquierda del JOIN que no existen en la tabla de la derecha
--> RIGHT OUTER JOIN : Retorna el resultado de la 'unión de igualdad' y también las filas de la tabla de la derecha del JOIN que no existen en la tabla de la izquierda
-->  FULL OUTER JOIN : Retorna LEFT OUTER JOIN + INNER JOIN + RIGHT OUTER JOIN (o sea retorna TODO, incluyendo valores nulos de las columnas de comparación)


----------------------------------------------------{  LEFT OUTER JOIN  }--------------------------------------------------------------


--Sintaxis

SELECT T1.columna1,
       T1.columna2,
       T2.columna1,
       T2.columna2 
FROM Tabla1 T1
LEFT JOIN Tabla2 T2 ON (T1.columa = T2.columna);


--> El LEFT JOIN retorna el resultado de la 'unión de igualdad' y también las filas de la tabla de la izquierda del JOIN que no existen en la tabla de la derecha
--> No es necesario escribir 'LEFT OUTER JOIN' ya que la palabra 'OUTER' es opcional (se puede omitir)


-- 1.1) Mostrar el nombre del depto en que trabajan los empleados cuyo ID este entre 170 y 180 - Sin usar LEFT JOIN
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPTO"
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
WHERE E.EMPLOYEE_ID BETWEEN 170 AND 180
ORDER BY "ID EMPLEADO";   -- No aparece la empleada 178 porque no tiene asignado depto(null)


-- 1.2) Se debe usar LEFT JOIN para retornar todos los empleados (exista o no su departamento en la tabla EMPLOYEES) 
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.DEPARTMENT_ID "ID DEPTO",
       NVL(D.DEPARTMENT_NAME, 'SIN DEPTO') "NOMBRE DEPARTAMENTO" -- Sin NVL() el DEPARTMENT_NAME de la 178 da null
FROM EMPLOYEES E
LEFT JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID) 
WHERE E.EMPLOYEE_ID BETWEEN 170 AND 180
ORDER BY "ID EMPLEADO";


-- 2.1) Mostrar el jefe de los empleados cuyo ID sea menor o igual a 110 - Sin usar LEFT JOIN
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.FIRST_NAME || ' ' || E.LAST_NAME "NOMBRE EMPLEADO",
       M.FIRST_NAME || ' ' || M.LAST_NAME "NOMBRE JEFE"
FROM EMPLOYEES E
JOIN EMPLOYEES M ON (E.MANAGER_ID = M.EMPLOYEE_ID)
WHERE E.EMPLOYEE_ID <= 110
ORDER BY "ID EMPLEADO"; -- No muestra el empleado 100, Steven King no tiene asignado jefe(null)


-- 2.2) Usando LEFT JOIN muestra el empleado 100 aunque no tenga asignado jefe 
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.FIRST_NAME || ' ' || E.LAST_NAME "NOMBRE EMPLEADO",
       M.FIRST_NAME || ' ' || M.LAST_NAME "NOMBRE JEFE"
FROM EMPLOYEES E LEFT
JOIN EMPLOYEES M ON (E.MANAGER_ID = M.EMPLOYEE_ID)
WHERE E.EMPLOYEE_ID <= 110
ORDER BY "ID EMPLEADO"; -- Concatenar con NULL no tiene efecto, por eso solo muestra el caracter espacio en blanco


-- 2.3) Se puede usar un CASE para que muestre el mensaje 'NO TIENE JEFE' cuando el valor de MANAGER_ID sea NULL 
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.FIRST_NAME || ' ' || E.LAST_NAME "NOMBRE EMPLEADO",
       CASE
            WHEN E.MANAGER_ID IS NULL   THEN 'NO TIENE JEFE'
            ELSE M.FIRST_NAME || ' ' || M.LAST_NAME
       END "NOMBRE JEFE"
FROM EMPLOYEES E LEFT JOIN EMPLOYEES M ON (E.MANAGER_ID = M.EMPLOYEE_ID)
WHERE E.EMPLOYEE_ID <= 110
ORDER BY "ID EMPLEADO";


-- 2.4) También se puede usar NVL2() - "Si argumento 1 es null, hace argumento 3, sino hace argumento 2"
SELECT  E.EMPLOYEE_ID "ID EMPLEADO",
        E.FIRST_NAME || ' ' || E.LAST_NAME "NOMBRE EMPLEADO",
        NVL2(M.FIRST_NAME, M.FIRST_NAME || ' '  || M.LAST_NAME, 'NO TIENE JEFE') "NOMBRE JEFE"
FROM EMPLOYEES E
LEFT JOIN  EMPLOYEES M ON (E.MANAGER_ID = M.EMPLOYEE_ID)
WHERE E.EMPLOYEE_ID <= 110
ORDER BY "ID EMPLEADO";


----------------------------------------------------{  RIGHT OUTER JOIN  }--------------------------------------------------------------

--Sintaxis

SELECT T1.columna1,
       T1.columna2,
       T2.columna1,
       T2.columna2 
FROM Tabla1 T1
RIGHT JOIN Tabla2 T2 ON (T1.columa = T2.columna);


--> El RIGHT JOIN retorna el resultado de la 'unión de igualdad' y también las filas de la tabla de la derecha del JOIN que no existen en la tabla de la izquierda
--> No es necesario escribir 'RIGHT OUTER JOIN' ya que la palabra 'OUTER' es opcional (se puede omitir)


-- 1.1) Mostrar el nombre de los departamentos y los empleados que trabajan en ellos - Sin usar RIGTH JOIN
SELECT D.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPARTAMENTO",
       E.EMPLOYEE_ID "ID EMPLEADO"
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
ORDER BY "ID DEPTO" DESC; -- Muestra solo 106 filas (la empleada 178 no tiene asignado depto)


-- 1.2) Mostrar el nombre de los departamentos y los empleados que trabajan en ellos - Usando RIGTH JOIN
SELECT D.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPARTAMENTO",
       E.EMPLOYEE_ID "ID EMPLEADO"
FROM EMPLOYEES E 
RIGHT JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
ORDER BY "ID DEPTO" DESC; -- Muestra 122 filas (incluye los deptos sin empleados)


-- 1.3) Se puede usar la función NVL() para mostrar un mensaje cuando ID_EMPLEADO sea nulo
SELECT D.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPARTAMENTO",
       NVL(TO_CHAR(E.EMPLOYEE_ID), 'NO TIENE EMPLEADOS') "ID EMPLEADO"
FROM EMPLOYEES E
RIGHT JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
ORDER BY "ID DEPTO" DESC; -- Muestra 122 filas (incluye los deptos sin empleados)


-- 2) Mostrar cuantos empleados tiene cada departamento, solo mostrar los que tengan menos de 6 empleados
SELECT D.DEPARTMENT_NAME "NOMBRE DEPTO",
       COUNT(E.EMPLOYEE_ID) "TOTAL EMPLEADOS"  -- Si no hay empleados el COUNT() arroja 0 (cuenta que hay 0 filas asociadas)
FROM EMPLOYEES E
RIGHT JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
GROUP BY D.DEPARTMENT_NAME
HAVING COUNT(E.EMPLOYEE_ID) < 6
ORDER BY "TOTAL EMPLEADOS" DESC;


----------------------------------------------------{  FULL OUTER JOIN  }--------------------------------------------------------------


--Sintaxis

SELECT T1.columna1,
       T1.columna2,
       T2.columna1,
       T2.columna2 
FROM Tabla1 T1
FULL JOIN Tabla2 T2 ON (T1.columa = T2.columna);


--> eL FULL OUTER JOIN retorna: LEFT OUTER JOIN + INNER JOIN + RIGHT OUTER JOIN (o sea TODO, incluyendo valores nulos de las columnas de comparación)
--> No es necesario escribir 'FULL OUTER JOIN' ya que la palabra 'OUTER' es opcional (se puede omitir)


-- 1) Con FULL OUTER JOIN se obtienen los empleados que no tienen depto y los deptos que no tienen empleados
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPARTAMENTO"   -- Sin NVL el DEPARTMENT_NAME de la 178 da NULL
FROM EMPLOYEES E
FULL JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID) 
ORDER BY "ID EMPLEADO";


-- 2) Mostrar el total de empleados de cada depto aunque no exista empleados trabajando
SELECT D.DEPARTMENT_ID "ID DEPTO",
       D.DEPARTMENT_NAME "NOMBRE DEPTO", 
       COUNT(E.EMPLOYEE_ID) "TOTAL EMPLEADOS"
FROM EMPLOYEES E
FULL JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
ORDER BY "TOTAL EMPLEADOS" DESC, "NOMBRE DEPTO";


----------------------------------------------------{  CROSS JOIN  }--------------------------------------------------------------


--Sintaxis

SELECT T1.columna1,
       T1.columna2,
       T2.columna1,
       T2.columna2 
FROM Tabla1 T1
CROSS JOIN Tabla2 T2;


--> El CROSS JOIN o 'combinación cruzada', retorna TODAS las filas de TODAS las tablas implicadas en la unión
--> Cada fila en la primera tabla se empareja con todas las filas en la segunda tabla
--> Retorna el total de filas de la primera tabla multiplicadas por el total de filas de la segunda tabla (Producto Cartesiano)
--> Es el tipo de JOIN menos usado ya que la información que retorna no tiene mucha lógica (casi no se usa)


--1) Como la tabla LOCATIONS tiene 23 filas y REGIONS tiene 4 filas, la consulta retorna 92 filas (23 * 4)  
SELECT L.CITY "CIUDAD",
       R.REGION_NAME "NOMBRE DE LA REGIÓN"
FROM LOCATIONS L CROSS JOIN REGIONS R; -- La información se muestra sin sentido ya que solo es un producto cartesiano 


-- 2) Muestra un producto cartesiano entre los empleados con id multiplos de 10 y los paises que comiencen con A o con B
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.FIRST_NAME || ' ' || E.LAST_NAME "EMPLEADO",
       C.COUNTRY_NAME "PAIS"
FROM EMPLOYEES E
CROSS JOIN COUNTRIES C
WHERE (C.COUNTRY_NAME LIKE 'A%' OR C.COUNTRY_NAME LIKE 'B%')
AND MOD(E.EMPLOYEE_ID, 10) = 0;


----------------------------------------------------{  JOIN DE MÚLTIPLES TABLAS  }--------------------------------------------------------------

--Sintaxis

SELECT T1.columna1,
       T1.columna2,
       T2.columna1,
       T2.columna2,
       T4.columna2 
FROM Tabla1 T1
JOIN Tabla2 T2 ON (T2.columa = T1.columna)
JOIN Tabla3 T3 ON (T3.columa = T2.columna)
JOIN Tabla4 T4 ON (T4.columa = T3.columna);


--> En una sentencia SELECT puede haber una cantidad ilimitada de JOINS (no hay límite para la cantidad de JOINS)
--> Los JOIN entre varias tablas se ejecutan de izquierda a derecha (o de arriba a abajo)
--> Para realizar este tipo de JOIN es recomendable revisar el MR de la BD para saber como ir "saltando" de tabla en tabla hasta llegar a la que se necesita
--> Recordar que cada "salto de tabla" produce que el tiempo de la consulta se degrade, hay que tratar de realizar la menor cantidad de saltos posibles
--> Las columnas que estan en la condición de igualdad de cada join (ON A.Columna = B.Columna) no pueden referenciar tablas de JOINS posteriores
--> Podemos usar LEFT o RIGHT JOIN cuando veamos que al hacer un JOIN vamos perdiendo filas (las que no van cumpliendo las condiciones de igualdad)


-- 1) Usando columnas de 3 tablas distintas (EMPLOYEES, DEPARTMENTS y JOBS)
SELECT E.EMPLOYEE_ID "ID EMPLEADO",
       E.FIRST_NAME || ' ' || E.LAST_NAME "NOMBRE EMPLEADO",
       D.DEPARTMENT_NAME "NOMBRE DEPARTAMENTO",
       J.JOB_TITLE "NOMBRE DEL TRABAJO"
FROM EMPLOYEES E                                           -- Tabla EMPLOYEES
JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)  -- Unir con tabla DEPARTMENTS
JOIN JOBS J ON (J.JOB_ID = E.JOB_ID)                       -- Unir con tabla JOBS
ORDER BY "ID EMPLEADO";


-- 2) ¿Cuantos empleados hay por Ciudad, país, depto y trabajo - Funciones de grupo + INNER JOIN (uniendo 5 tablas)
SELECT C.COUNTRY_NAME "PAÍS",
       L.CITY "CIUDAD",
       D.DEPARTMENT_NAME "NOMBRE DEPTO",
       J.JOB_TITLE "NOMBRE DEL TRABAJO",
       COUNT(E.EMPLOYEE_ID) "TOTAL EMPLEADOS"
FROM EMPLOYEES E                                                 -- Tabla EMPLOYEES
JOIN JOBS J        ON (E.JOB_ID = J.JOB_ID)                      -- Unir con JOBS
JOIN DEPARTMENTS D ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)        -- Unir con DEPARTMENTS
JOIN LOCATIONS L   ON (L.LOCATION_ID = D.LOCATION_ID)            -- Unir con LOCATIONS
JOIN COUNTRIES C   ON (L.COUNTRY_ID = C.COUNTRY_ID)              -- Unir con COUNTRIES
GROUP BY C.COUNTRY_NAME, L.CITY, D.DEPARTMENT_NAME, J.JOB_TITLE
HAVING COUNT(E.EMPLOYEE_ID) > 1
ORDER BY L.CITY;


-- 3) Mostrar en que región trabaja cada empleado (Hay que realizar 4 saltos de tabla)
SELECT E.FIRST_NAME || ' ' || E.LAST_NAME "EMPLEADO",
       R.REGION_NAME "NOMBRE REGION"
FROM EMPLOYEES E                                                  -- Tabla EMPLOYEES 
LEFT JOIN DEPARTMENTS D ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)    -- Unir con DEPARTMENTS
LEFT JOIN LOCATIONS L ON (L.LOCATION_ID = D.LOCATION_ID)          -- Unir con LOCATIONS
LEFT JOIN COUNTRIES C ON (C.COUNTRY_ID = L.COUNTRY_ID)            -- Unir con COUNTRIES
LEFT JOIN REGIONS R ON (R.REGION_ID = C.REGION_ID);               -- Unir con REGIONS
-- Sin LEFT JOIN solo muestra 106 empleados (se pierde uno)


-------------------------------------------------{  SUBCONSULTAS  }----------------------------------------------------------
 

--Sintaxis:

SELECT columna1,
       columna2,
       columna3
FROM Tabla 
WHERE expresión operador_de_comparación (subconsulta);


--> Las Subconsultas son la combinación de 2 consultas, es decir, colocar una consulta dentro de otra consulta (es como hacer consultas anidadas)
--> Primero se ejecuta la consulta interna (subconsulta) y luego se ejecuta la consulta externa o principal
--> Una subconsulta es una "sentencia SELECT" que está en la cláusula de otra sentencia SQL
--> Una subconsulta puede ser usada en diferentes SENTENCIAS SQL: SELECT, INSERT, UPDATE, DELETE, CREATE VIEW, CREATE TABLE
--> En una sentencia SELECT se pueden colocar subconsultas en las cláusulas: SELECT, FROM, WHERE, GROUP BY, HAVING. (NO en ORDER BY)
--> No es necesario poner la cláusula ORDER BY en la subconsulta (no tiene sentido)
--> Pueden ser muy útil cuando se necesita seleccionar filas de una tabla con una condición que depende de los datos de la misma tabla
--> La subconsulta se debe escribir entre paréntesis '(subconsulta)' excepto en las sentencias: INSERT, CREATE TABLE y CREATE VIEW
--> Por convención deben ir a la derecha de la condición de comparación:   SALARY > (subconsulta)
--> Existen 2 tipos de subconsultas básicas: de una fila y de múltiples filas
--> También existen subconsultas que retornan múltiples columnas, pero son usadas para sentencias SQL más avanzadas (nosotros veremos con una sola columna)


--------------------------------------{  SUBCONSULTAS DE UNA FILA  }-------------------------------------------


--> Si la subconsulta retorna una sola fila (y una sola columna) se deben usar 'operadores de una fila' ( <   <=   >   >=   =   <> )


-- 1) ¿Qué empleados ganan más que Abel? 

-- Paso 1) ¿Cuanto gana Abel?
SELECT SALARY 
FROM EMPLOYEES 
WHERE UPPER(LAST_NAME) = 'ABEL';  -- Retorna un único valor (11000)

-- * Mostrar los empleados que ganen más que Abel - Sin usar subconsultas
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO" 
FROM EMPLOYEES
WHERE SALARY > 11000
ORDER BY SALARY DESC;

-- Paso 2) Mostrar los empleados que ganen más que Abel - Usando subconsultas (Reemplazar 11000 por la subconsulta)
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO"
FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY 
                FROM EMPLOYEES
                WHERE UPPER(LAST_NAME) = 'ABEL')
ORDER BY SALARY DESC;


-- 2) ¿Quienes son los empleados que ganan el salario máximo?

-- Paso 1) ¿Cual es el salario máximo?
SELECT MAX(SALARY) 
FROM EMPLOYEES;   -- Devuelve 24000

-- Paso 2) Mostrar los empleados que ganan el salario máximo
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO"
FROM EMPLOYEES
WHERE SALARY = (SELECT MAX(SALARY) 
                FROM EMPLOYEES);


-- 3) ¿Quienes son los empleados que ganan lo mismo que el salario mínimo?

-- Paso 1) ¿Cual es el salario mínimo?
SELECT MIN(SALARY) 
FROM EMPLOYEES; 

-- Paso 2) Mostrar los empleados que ganan lo mismo que el salario mínimo
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       SALARY "SALARIO"
FROM EMPLOYEES
WHERE SALARY = (SELECT MIN(SALARY) 
                FROM EMPLOYEES);


-- 4) Mostrar los empleados cuyo trabajo sea igual al del empleado 141 y sus salarios sean mayores que el empleado 143

-- Paso 1) ¿Cuál es el trabajo del empleado 141?
SELECT JOB_ID
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 141;

-- Paso 2) ¿Cuál es el salario del empleado 143?
SELECT SALARY
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 143;

-- Paso 3) Incorporar las 2 subconsultas a la consulta principal
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       JOB_ID "ID TRABAJO", 
       SALARY "SALARIO"
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID
                FROM EMPLOYEES
                WHERE EMPLOYEE_ID = 141)
AND SALARY > (SELECT SALARY
              FROM EMPLOYEES
              WHERE EMPLOYEE_ID = 143)
ORDER BY SALARY DESC;


--4) Mostrar los deptos en los cuales existen empleados que poseen un salario mínimo mayor al salario mínimo del depto 80

-- Paso 1) ¿Cuál es el salario mínimo del depto 80?
SELECT MIN(SALARY)
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 80;

-- Paso 2) Incorporar la subconsulta a la consulta principal
SELECT NVL(TO_CHAR(DEPARTMENT_ID), 'NO ASIGNADO') "ID DEPTO",
       MIN(SALARY) "SALARIO MÍNIMO"
FROM EMPLOYEES
GROUP BY NVL(TO_CHAR(DEPARTMENT_ID), 'NO ASIGNADO')
HAVING MIN(SALARY) > (SELECT MIN(SALARY)
                      FROM EMPLOYEES
                      WHERE DEPARTMENT_ID = 80)
ORDER BY MIN(SALARY);


-----------------------------------{  SUBCONSULTAS DE MÚLTIPLES FILAS  }-------------------------------------------


--> Si la subconsulta retorna varias filas se deben usar 'Operadores de varias filas' ( IN   ANY   ALL   EXISTS)
--> Un error común con subconsultas se produce cuando la subconsulta retorna más de una fila y el operador de comparación es de una sola fila (=, <, >, etc.)

-->     IN : Igual a cualquier miembro o elemento de la lista (NOT IN no puede evaluar valores NULOS o da falso y las filas no se muestran)
-->    ANY : Compara el valor con CADA valor devuelto por la subconsulta
-->    ALL : Compara el valor con TODOS los valores devueltos por la subconsulta
--> EXISTS : Verifica la existencia de las filas de la consulta principal en el conjunto de resultados de la subconsulta


-- 1)  ¿Cuál es el salario de los empleados del depto 30?
SELECT SALARY 
FROM EMPLOYEES 
WHERE DEPARTMENT_ID = 30;

-- 1.1) Mostrar los empleados que ganan más que TODOS(ALL) los del depto 30
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(SALARY, '$99G999') "SALARIO"
FROM EMPLOYEES
WHERE SALARY > ALL (SELECT SALARY 
                    FROM EMPLOYEES 
                    WHERE DEPARTMENT_ID = 30)
ORDER BY SALARY DESC;

-- 1.2) Mostrar los empleados que ganan más que ALGUNO(ANY) de los del depto 30
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(SALARY, '$99G999') "SALARIO"
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY 
                    FROM EMPLOYEES 
                    WHERE DEPARTMENT_ID = 30)
ORDER BY SALARY DESC;

-- 1.3) Mostrar los empleados que ganan LO MISMO(IN) que los del depto 30
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(SALARY, '$99G999') "SALARIO"
FROM EMPLOYEES
WHERE SALARY IN (SELECT SALARY 
                 FROM EMPLOYEES 
                 WHERE DEPARTMENT_ID = 30)
ORDER BY SALARY DESC;


-- 2) Mostrar los empleados cuyo salario sea igual al salario mínimo de los deptos

-- SUB
SELECT MIN(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID;

-- CONSULTA
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(SALARY, '$99G999') "SALARIO"
FROM EMPLOYEES
WHERE SALARY IN (SELECT MIN(SALARY)
                 FROM EMPLOYEES
                 GROUP BY DEPARTMENT_ID)
ORDER BY LAST_NAME;


--3.1) Mostrar los empleados que posean un salario menor a CUALQUIERA de los salarios de IT_PROG

-- SUB
SELECT DISTINCT SALARY
FROM EMPLOYEES
WHERE JOB_ID = 'IT_PROG';

-- CONSULTA
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(SALARY, '$99G999') "SALARIO"
FROM EMPLOYEES
WHERE SALARY < ANY (SELECT DISTINCT SALARY
                    FROM EMPLOYEES
                    WHERE JOB_ID = 'IT_PROG')
AND JOB_ID <> 'IT_PROG' -- Para que no muestre los mismos que están en IT_PROG
ORDER BY SALARY DESC;


--3.2) Mostrar los empleados que posean un salario menor a TODOS los salarios de IT_PROG

-- SUB
SELECT DISTINCT SALARY
FROM EMPLOYEES
WHERE JOB_ID = 'IT_PROG';

-- CONSULTA
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(SALARY, '$99G999') "SALARIO"
FROM EMPLOYEES
WHERE SALARY < ALL (SELECT DISTINCT SALARY
                    FROM EMPLOYEES
                    WHERE JOB_ID = 'IT_PROG')
AND JOB_ID <> 'IT_PROG' -- Para que no muestre los mismos que están en IT_PROG
ORDER BY SALARY DESC;


-- 4.1) Mostrar los deptos donde no hay empleados trabajando

-- SUB
SELECT DISTINCT DEPARTMENT_ID -- Muestra los distintos deptos de la tabla EMPLOYEES
FROM EMPLEADOS;

-- CONSULTA
SELECT DEPARTMENT_ID "ID DEPTO",
       DEPARTMENT_NAME "NOMBRE DEPTO"
FROM DEPARTMENTS
WHERE DEPARTMENT_ID NOT IN (SELECT DISTINCT DEPARTMENT_ID
                            FROM EMPLEADOS
                            WHERE DEPARTMENT_ID IS NOT NULL);  -- Se debe quitar los NULL o no mostrará ninguna fila
                            
                            
-- Si la subconsulta retorna algún null da falso y no se muestra ninguna fila - cuidado con el NOT IN
SELECT DEPARTMENT_ID "ID DEPTO",
       DEPARTMENT_NAME "NOMBRE DEPTO"
FROM DEPARTMENTS
WHERE DEPARTMENT_ID NOT IN (SELECT DISTINCT DEPARTMENT_ID
                            FROM EMPLEADOS); 


-------------------------------------------{  SUBCONSULTA CON EXISTS  }--------------------------------------


--> El operador EXISTS se utiliza con frecuencia con subconsultas correlacionadas (la CP y la SUB obtienen datos de la misma tabla)
--> Si la subconsulta retorna al menos una fila, el operador devuelve TRUE, y si el valor no existe devuelve FALSE
--> EXISTS se considera un "test de existencia" (la CP retorna las filas cuando por lo menos 1 fila cumple la condición WHERE de la SUB)
--> NO EXISTS verifica si un valor recuperado por la consulta principal NO es una parte de los valores recuperados por la subconsulta
--> se recomienda que al usar el operador EXISTS la subconsulta también use la tabla de la consulta principal


-- 1.1) Mostrar todos los deptos donde hayan empleados trabajando (EXISTS)
SELECT DEPARTMENT_ID "ID DEPTO",
       DEPARTMENT_NAME "NOMBRE DEPTO"
FROM DEPARTMENTS D
WHERE EXISTS (SELECT DEPARTMENT_ID
              FROM EMPLOYEES E
              WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) -- Se "engancha" la columna DEPARTMENT_ID que está en la CP
ORDER BY DEPARTMENT_NAME;


-- 1.2) Mostrar todos los deptos donde NO hayan empleados trabajando (NO EXISTS)
SELECT DEPARTMENT_ID "ID DEPTO",
       DEPARTMENT_NAME "NOMBRE DEPTO"
FROM DEPARTMENTS D
WHERE NOT EXISTS (SELECT DEPARTMENT_ID
                  FROM EMPLOYEES E
                  WHERE D.DEPARTMENT_ID = E.DEPARTMENT_ID) -- Se "engancha" la columna DEPARTMENT_ID que está en la CP
ORDER BY DEPARTMENT_NAME;


-- 1.3) Si no enganchamos una columna devuelve toda la consulta principal ya que la subconsulta retorna true 
SELECT DEPARTMENT_ID "ID DEPTO",
       DEPARTMENT_NAME "NOMBRE DEPTO"
FROM DEPARTMENTS  D
WHERE EXISTS (SELECT DEPARTMENT_ID
              FROM EMPLOYEES E
              WHERE EMPLOYEE_ID = 100)
ORDER BY DEPARTMENT_ID;


-----------------------------------------{  SUBCONSULTA EN EL SELECT  }--------------------------------------------------


-- Sintaxis:

SELECT Col1,
       Col2,
       (SELECT Columna1, Columna2, ...  
        FROM Tabla2 T2
        WHERE T2.columna = T1.columna)
FROM Tabla1 T1;


--> La subconsulta debe tener alguna condición (WHERE) que incluya columna(s) de la subconsulta con columna(s) de la tabla de la sentencia principal
--> Son como una especie de JOIN simulado (un JOIN escondido)


-- 1.1) Mostrar cuantos empleados trabajan en cada depto - Sin usar subconsultas
SELECT D.DEPARTMENT_NAME "NOMBRE DEPTO",
       COUNT(E.EMPLOYEE_ID) "TOTAL EMPLEADOS"
FROM EMPLOYEES E
RIGHT JOIN DEPARTMENTS D ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID) -- Se necesita hacer un RIGHT JOIN para no perder deptos
GROUP BY D.DEPARTMENT_NAME                                      -- Se necesita agrupar por el nombre del depto 
ORDER BY D.DEPARTMENT_NAME;


-- 1.2) Mostrar cuantos empleados trabajan en cada depto - Usando subconsultas en el SELECT
SELECT D.DEPARTMENT_NAME "NOMBRE DEPTO",
       (SELECT COUNT(E.EMPLOYEE_ID)       -- Subconsulta en el SELECT
        FROM EMPLOYEES E
        WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID) "TOTAL EMPLEADOS"   -- Es como un JOIN simulado
FROM DEPARTMENTS D
ORDER BY D.DEPARTMENT_NAME;


-- 2.1) Mostrar cuantos empleados hay trabajando en cada trabajo - Sin usar subconsultas
SELECT J.JOB_TITLE "NOMBRE TRABAJO",
       COUNT(E.EMPLOYEE_ID) "TOTAL EMPLEADOS"
FROM JOBS J
JOIN EMPLOYEES E ON (E.JOB_ID = J.JOB_ID)    -- Se necesita hacer un JOIN con EMPLOYEES
GROUP BY J.JOB_TITLE                         -- Se necesita agrupar por el nombre del trabajo  
ORDER BY "NOMBRE TRABAJO";


-- 2.2) Mostrar cuantos empleados hay trabajando en cada trabajo - Usando subconsultas
SELECT J.JOB_TITLE "NOMBRE TRABAJO",
       (SELECT COUNT(E.EMPLOYEE_ID)     -- Subconsulta en el SELECT
        FROM EMPLOYEES E
        WHERE E.JOB_ID = J.JOB_ID) "TOTAL EMPLEADOS"   -- Es como un JOIN simulado
FROM JOBS J
ORDER BY "NOMBRE TRABAJO";


-- 3) Mostrar el salario máximo y el salario mínimo de cada depto, sino tiene empleados trabajando poner 'Sin Empleados'
SELECT D.DEPARTMENT_NAME "NOMBRE DEPTO",
       NVL(TO_CHAR((SELECT MAX(SALARY)       -- Subconsulta en el SELECT
                    FROM EMPLOYEES E
                    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID), '$99G999'), 'Sin Empleados') "SALARIO MÁXIMO",
       NVL(TO_CHAR((SELECT MIN(SALARY)        -- Subconsulta en el SELECT
                    FROM EMPLOYEES E
                    WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID), '$99G999'), 'Sin Empleados') "SALARIO MÍNIMO"
FROM DEPARTMENTS D
ORDER BY D.DEPARTMENT_NAME;


-----------------------------------------{  SUBCONSULTA EN CLÁUSULA FROM  }--------------------------------------------------


-- Sintaxis SUB en FROM:

SELECT Tabla_Alias.alias_1,
       Tabla_Alias.alias_2
FROM (SELECT Columna1 alias_1,
             Columna2 alias_2 
      FROM Tabla) Tabla_Alias



-- Sintaxis SUB en JOIN:

SELECT Col1,
       Col2, 
       Tabla_Alias.alias_1,
       Tabla_Alias.alias_2
FROM Tabla1 T1 
JOIN (SELECT Columna1 alias_1,
             Columna2 alias_2, ..  
      FROM Tabla2 T2) Tabla_Alias


--> Se genera una tabla en memoria con el resultado de la SUB para que las columnas de esa tabla puedan ser usadas en las cláusulas de la sentencia principal
--> Este tipo de subconsultas son menos comunes (no se usan tanto como las subconsultas en los WHERE)


-- 1) Mostrar columnas de tablas creadas en tiempo de ejecución - SUB en los FROM
SELECT DEPTOS.ID_DEPTO,
       DEPTOS.TOTAL_EMPLEADOS
FROM (SELECT DEPARTMENT_ID ID_DEPTO, COUNT(EMPLOYEE_ID) TOTAL_EMPLEADOS
      FROM EMPLOYEES
      GROUP BY DEPARTMENT_ID
      HAVING COUNT(EMPLOYEE_ID) > 3) DEPTOS    -- Nombre de la tabla creada
ORDER BY DEPTOS.ID_DEPTO;


-- 2) Mostrar los nombres de deptos, total de empleados y ciudad cuando los deptos existan en la tabla EMP - SUB en los JOIN
SELECT DEP.DEPARTMENT_NAME "NOMBRE DEPARTAMENTO",   -- Se saca de la tabla DEPARTMENTS DEP
       EMP.TOTAL_EMP "TOTAL EMPLEADOS",             -- Se saca de la tabla EMP creada en la subconsulta
       LOC.CITY "CIUDAD"                            -- Se saca de la tabla LOCATIONS LOC
FROM  DEPARTMENTS DEP 
JOIN (SELECT E.DEPARTMENT_ID,                     -- Columna DEPARTMENT_ID de la tabla EMP creada en la subconsulta
      COUNT(E.EMPLOYEE_ID) TOTAL_EMP              -- Columna TOTAL_EMP de la tabla EMP creada en la subconsulta
      FROM EMPLOYEES E 
      GROUP BY E.DEPARTMENT_ID
      HAVING COUNT(E.EMPLOYEE_ID) > 5) EMP ON(DEP.DEPARTMENT_ID = EMP.DEPARTMENT_ID)
JOIN LOCATIONS LOC ON(DEP.LOCATION_ID = LOC.LOCATION_ID)
ORDER BY "TOTAL EMPLEADOS" DESC, DEP.DEPARTMENT_NAME;


---------------------------------------------{  SUBCONSULTAS PARA CREAR TABLAS  }----------------------------------------------


-- Sintaxis:

CREATE TABLE nombreTabla (columna1, columna2, ...)
AS SELECT Columna(s)
   FROM Tabla
   WHERE Condicion;


--> Crea una tabla en la BD e inserta filas mediante la combinación de la sentencia CREATE y la opción AS Subconsulta...
--> Debe coincidir el número de columnas especificadas con el número de columnas que arroja la Subconsulta
--> Se creará con los nombres y tipos de datos de las columnas seleccionadas 
--> Lo que muestra el resulset se almacena en la nueva tabla (cuidado con los nombres de columnas, deben ser identificadores válidos)
--> Al crear una tabla, los nombres de columna solo pueden tener: letras (A-Z), dígitos (0-9), underscore( _ ), sigo dolar ( $ ) o numeral ( # )
--> Para crear la nueva tabla, los nombres de columnas no pueden tener espacios en blanco ni ser expresiones tipo: SALARY * 1.2
--> También podemos especificar los nombres de columnas que deseamos (y no lo que arroja el resulset)
--> La tabla creada no hereda las constraint PRIMARY KEY, FOREIGN KEY, UNIQUE y CHECK. (solo hereda la constraint NULL)


-- 1.1) Crear un respaldo de la tabla COUNTRIES y nombrarla 'PAISES'
CREATE TABLE PAISES
AS SELECT * FROM COUNTRIES;

-- Consultar la tabla creada - Se puede observar que los nombres de columnas son los mismos que los de la tabla COUNTRIES
SELECT * FROM PAISES;

-- Borrar la tabla PAISES de la BD
DROP TABLE PAISES;


-- 1.2) Crear un respaldo de COUNTRIES especificando los nombres de columnas
CREATE TABLE PAISES (ID_Pais, Nombre_Pais, ID_Region)
AS SELECT * FROM COUNTRIES;

-- Consultar la tabla creada - Se puede observar que los nombres de columnas son los definidos en la sentencia CREATE
SELECT * FROM PAISES;

-- Borrar la tabla PAISES de la BD
DROP TABLE PAISES;


-- 2) Guardar en una nueva tabla el ID y el nombre completo de todos los empleados que trabajen en 'IT_PROG'
CREATE TABLE EMPLEADO_TRABAJO
AS SELECT J.JOB_ID ID_TRABAJO,
          J.JOB_TITLE NOMBRE_TRABAJO,
          E.EMPLOYEE_ID NUMERO_EMPLEADO,
          E.FIRST_NAME || ' ' || E.LAST_NAME NOMBRE_COMPLETO
   FROM EMPLOYEES E
   JOIN JOBS J ON (J.JOB_ID = E.JOB_ID)
   WHERE J.JOB_ID = 'IT_PROG';

-- Ver la tabla creada
SELECT * FROM EMPLEADO_TRABAJO; 

-- Borrar  la tabla EMPLEADO_TRABAJO de la BD
DROP TABLE EMPLEADO_TRABAJO;    


-- 3) Guardar en una tabla el salario anual de todos los trabajadores que ganen más de 100 mil dolares al año
CREATE TABLE SALARIO_ANUAL
AS SELECT EMPLOYEE_ID NUMERO_EMPLEADO,
          FIRST_NAME || ' ' || LAST_NAME NOMBRE_COMPLETO,
          SALARY * 12 SALARIO_ANUAL
   FROM EMPLOYEES 
   WHERE (SALARY * 12) > 100000 
   ORDER BY SALARIO_ANUAL ASC;

-- Ver la tabla creada
SELECT *
FROM SALARIO_ANUAL; 

-- Borrar de la BD la tabla creada
DROP TABLE SALARIO_ANUAL;    


-- 4) Guardar en una tabla el ID, el salario anual y la fecha de contrato de los empleados que trabajan en el depto 30
CREATE TABLE DEPTO30 
(COD_EMPLEADO   NOT NULL CONSTRAINT PK_DEPTO30 PRIMARY KEY,  -- Se agrego una constraint de clave primaria
 SALARIO_ANUAL  NOT NULL,
 FECHA_CONTRATO NOT NULL)
AS SELECT EMPLOYEE_ID,
          SALARY * 12,
          HIRE_DATE 
FROM EMPLOYEES
WHERE DEPARTMENT_ID = 30;

-- Ver la tabla creada
SELECT *
FROM DEPTO30; 

-- Borrar de la BD la tabla creada
DROP TABLE DEPTO30;    


----------------------------------------------{  OPERADORES SET  }----------------------------------------------------------


--> Los operadores SET o "de conjunto" combinan el resultado de 2 o más consultas en un solo resultado (Se les llaman CONSULTAS COMPUESTAS)
--> Todos los operadores SET tienen igual precedencia. Se evalúan de izquierda a derecha (de arriba a abajo)
--> Se pueden usar los paréntesis para especificar un orden explícito de evaluación (para cambiar el orden de precedencia)
--> Las expresiones y/o columnas en todas las sentencias SELECT deben coincidir en número (si no coinciden se pueden hacer ciertos "trucos")
--> El tipo de dato de las columnas de todas las consultas deben coincidir con las columnas de la primera sentencia (la primera sentencia es la referencia)
--> La cláusula ORDER BY solo puede aparecer una vez al final de la sentencia compuesta (no puede haber más de un ORDER BY en toda la consulta compuesta)
--> La cláusula ORDER BY solo reconoce las columnas de la primera sentencia SELECT (la primera consulta)
--> Cuando se utiliza ORDER BY en una consulta compuesta lo común es usar los números de columna para el ordenamiento (ORDER BY 2 DESC, 1, 3 DESC)
--> En las consultas compuestas no se pueden utilizar los ALIAS DE TABLA cuando se ordena con ORDER BY (ORDER BY E.SALARY) ERROR!!!
--> No se puede ordenar con ORDER BY usando el nombre de la columna si la columna lleva un ALIAS DE COLUMNA (si lleva ALIAS se ordena por alias o número)
--> El resultado es ordenado por defecto en orden ascendente, excepto cuando se usa UNION ALL
--> Los operadores SET pueden ser usados en subconsultas
--> Las filas duplicadas son eliminadas automáticamente EXCEPTO cuando se utiliza UNION ALL
--> Los nombres de columna de la primera consulta aparecen en el resultado (la primera consulta es siempre la referencia)


-->              Operadores SET
-->              --------------

-->           UNION : Retorna TODAS las filas DIFERENTES seleccionadas por cada consulta    
-->       UNION ALL : Retorna TODAS las filas seleccionadas por ambas consultas, incluyendo las duplicadas   
-->       INTERSECT : Retorna TODAS LAS FILAS IGUALES seleccionadas por ambas consultas       
-->           MINUS : Retorna TODAS LAS FILAS DIFERENTES seleccionadas por la primera sentencia SELECT y que NO se seleccionaron en la segunda sentencia SELECT 



--> Creación de tablas para ejemplarizar el uso de operadores SET:

-- Crea la tabla EMP_SAL_12000 en la subconsulta (almacena datos de los empleados que ganan más de 12 mil dolares)
CREATE TABLE EMP_SAL_12000
AS SELECT EMPLOYEE_ID, 
          FIRST_NAME,
          LAST_NAME, 
          SALARY,
          DEPARTMENT_ID
   FROM EMPLOYEES
   WHERE SALARY > 12000;


-- Crea la tabla EMP_DEPTO_90 en la subconsulta (almacena datos de los empleados que trabajan en el depto 90)
CREATE TABLE EMP_DEPTO_90 
AS SELECT EMPLOYEE_ID,
          FIRST_NAME,
          LAST_NAME, 
          SALARY,
          DEPARTMENT_ID 
   FROM EMPLOYEES
   WHERE DEPARTMENT_ID = 90;


-- Crea la tabla EMP_DEPTO_100 en la subconsulta (almacena datos de los empleados que trabajan en el depto 100)
CREATE TABLE EMP_DEPTO_100
AS SELECT EMPLOYEE_ID, 
          FIRST_NAME,
          LAST_NAME, 
          SALARY,
          DEPARTMENT_ID 
   FROM EMPLOYEES
   WHERE DEPARTMENT_ID = 100;


------------------------------------------------{  OPERADOR UNION  }-----------------------------------------


--> Retorna las filas de ambas consultas después de eliminar las filas duplicadas (Retorna TODAS las filas DIFERENTES)
--> Obtiene todas las filas seleccionadas por todas las sentencias SELECT (Si las filas están repetidas aparecerán una sola vez)
--> Los valores nulos NO son ignorados durante la verificación de duplicados
--> El número de columnas y tipo de datos deben ser idénticos en todas las sentencias SELECT usadas en las consultas
--> Por defecto, el resultado es ordenado ascendentemente (ASC) por todas las columnas de la PRIMERA consulta (ORDER BY Col1, Col2, Col3, ...)


-- 1) Muestra el ID del empleado, su salario y depto de los empleados que existen en las 2 tablas (no repite filas) 
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID   -- Por defecto se ordena por estos campos en forma ASC y en este mismo orden (EMPLOYEE_ID, SALARY, DEPARTMENT_ID)
FROM EMP_SAL_12000
UNION                  -- El operador SET va "entremedio" de ambas consultas
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90;     -- El ; se debe poner en la ÚLTIMA consulta (no antes)


-- 2) El resultado se muestra con los nombres de columnas de la PRIMERA consulta (el primer SELECT) 
SELECT EMPLOYEE_ID,
       SALARY
FROM EMP_DEPTO_100
UNION 
SELECT EMPLOYEE_ID ID_EMPLEADO,
       SALARY SALARIO
FROM EMP_SAL_12000
ORDER BY 2 DESC;     -- Se ordena por el salario en forma descendente


-- 3) Primero se realiza la UNION de la consulta 1 con la 2 y el resultado se UNE con la consulta 3
SELECT EMPLOYEE_ID, 
       FIRST_NAME || ' ' || LAST_NAME NOMBRE_EMPLEADO  -- Este es el nombre de columna que prevalece (manda el primer SELECT)
FROM EMP_SAL_12000
UNION 
SELECT EMPLOYEE_ID,
       FIRST_NAME || ' ' || LAST_NAME NOMBRE
FROM EMP_DEPTO_90
UNION
SELECT EMPLOYEE_ID,
       FIRST_NAME || ' ' || LAST_NAME EMPLEADO
FROM EMP_DEPTO_100;


----------------------------------------------{  OPERADOR UNION ALL  }-----------------------------------------


--> Obtiene TODAS las filas seleccionadas por todas las consultas INCLUYENDO todas la duplicadas (no elimina las filas duplicadas como UNION)
--> El número de columnas y tipo de datos deben ser idénticos en todas las sentencias SELECT usadas en las consultas
--> A diferencia del operador UNION, el resultado no se ordena por defecto
--> La palabra reservada DISTINCT no puede ser usada cuando se utiliza el operador UNION ALL


-- 1.1) Muestra en el resulset: tabla EMP_SAL_12000 + tabla EMP_DEPTO_90 (y en ese mismo orden todas las filas)
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
UNION ALL
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90;   -- Notar que NO HAY un ordenamiento por defecto como con el operador UNION


-- 1.2) Para ordenar el resultado debemos agregar la cláusula ORDER BY al final de toda la sentencia
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
UNION ALL
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90
ORDER BY 1, 2, 3;  -- Notar que las filas duplicadas no fueron eliminadas   


-- 2) Primero se muestra la tabla emp_depto_100 y después la tabla emp_sal_12000 (se unen todas las filas en ese orden)
SELECT EMPLOYEE_ID,
       SALARY
FROM EMP_DEPTO_100
UNION ALL
SELECT EMPLOYEE_ID ID_EMPLEADO,  
       SALARY SALARIO  -- En el resultado los nombres de columna que prevalecen son los de la primera consulta
FROM EMP_SAL_12000;


-- 3) Primero se une la tabla EMP_SAL_12000 con la tabla EMP_DEPTO_90 y luego a ese resultado se une la tabla EMP_DEPTO_100
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
UNION ALL
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90
UNION ALL
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_100;  -- Arroja 17 filas (8 de la tabla EMP_SAL_12000 + 6 de la tabla EMP_DEPTO_90 + 3 de la última tabla)


----------------------------------------------{  OPERADOR INTERSECT  }-----------------------------------------


--> Retorna todas las filas que se repiten en ambas consultas (retorna todas las filas de la consulta 1 que esten en la consulta 2)
--> El operador INTERSECT permite obtener todas las filas que se repiten en todas las consultas
--> El número de columnas y tipo de datos deben ser idénticos en todas las sentencias SELECT usadas en las consultas
--> INTERSECT no ignora los valores NULOS
--> Por defecto, el resultado es ordenado ascendentemente (ASC) por todas las columnas de la PRIMERA consulta (ORDER BY Col1, Col2, Col3, ...)


-- 1) Esta consulta compuesta muestra las 3 filas que se repiten en ambas tablas
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
INTERSECT
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90;   -- El resultado se ordena por cada columna del primer SELECT en forma ASC


-- 2) En este caso hay una sola fila que está en ambas tablas y esa fila es el resultado del INTERSECT
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
INTERSECT
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_100;


-- 3) Como no hay ninguna fila que este en las 3 tablas no arroja ningún resultado
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
INTERSECT
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90
INTERSECT
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_100;


----------------------------------------------{  OPERADOR MINUS  }-----------------------------------------


--> Permite obtener las filas de la primera consulta que NO se encuentran en la segunda consulta (incluyendo los valores nulos) 
--> Por defecto, el resultado es ordenado ascendentemente (ASC) por todas las columnas de la PRIMERA consulta (ORDER BY Col1, Col2, Col3, ...)
--> El número de columnas y tipo de datos deben ser idénticos en todas las sentencias SELECT usadas en las consultas
--> Invertir el orden de las tablas modifica el resultado (el operador MINUS no es conmutativo)


-- 1.1) Muestra los empleados que existen en la tabla EMP_SAL_12000 y que NO existen en la tabla EMP_DEPTO_90  
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
MINUS
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90;   -- Arroja 5 filas 


-- 1.2) Como todos los empleados de la consulta 1 existen en la consulta 2, al aplicar MINUS no arroja ninguna fila
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90
MINUS                 -- Podemos ver que cambiar el orden de las consultas altera el resultado
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000;   -- Arroja 0 filas


-- 2) Muestra todos los empleados que existen en la tabla EMP_SAL_12000 y que NO existen en las otras tablas
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
MINUS
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90
MINUS
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_100
ORDER BY 1;        -- Se ordena por ID de empleado ASC


----------------------------------------------{  COMBINANDO OPERADORES SET  }-----------------------------------------


--> Cuando se unen más de 2 sentencias usando operadores SET, éstas se ejecutan secuencialmente (el resultado de las 2 primeras se compara con la tercera y asi...)
--> Para cambiar o forzar a que dos sentencias se ejecuten en un orden definido se debe usar paréntesis (cambia el orden de ejecución)


-- 1.1) ¿Que empleados ganan más de 10 mil dolares y NO están en la tabla JOB_HISTORY y además ganan más que el salario máximo?
SELECT EMPLOYEE_ID
FROM EMPLOYEES
WHERE SALARY > 10000
MINUS
SELECT EMPLOYEE_ID
FROM JOB_HISTORY
INTERSECT 
SELECT EMPLOYEE_ID
FROM EMPLOYEES
WHERE SALARY > (SELECT MAX(SALARY)
                FROM EMPLOYEES);    -- Arroja solo 1 fila (el empleado 100)


 -- 1.2) Si cambiamos el orden de ejecución con paréntesis el resultado también cambia
SELECT EMPLOYEE_ID
FROM EMPLOYEES
WHERE SALARY > 10000
MINUS
(SELECT EMPLOYEE_ID
FROM JOB_HISTORY
INTERSECT 
SELECT EMPLOYEE_ID
FROM EMPLOYEES
WHERE SALARY > (SELECT MAX(SALARY)
                FROM EMPLOYEES));      -- Arroja 15 filas


-- 2) Muestra los empleados de  EMP_SAL_12000 que también esten en EMP_DEPTO_90, y los une a los de la tabla EMP_DEPTO_100
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_SAL_12000
INTERSECT
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_90
UNION
SELECT EMPLOYEE_ID,
       SALARY,
       DEPARTMENT_ID
FROM EMP_DEPTO_100;  -- Arroja 3 filas


----------------------------------------{  CANTIDAD DE COLUMNAS Y TIPO DE DATOS  }-----------------------------------------


--> Cuando se usan operadores SET, las expresiones en la lista de la cláusula SELECT deben coincidir en número (misma cantidad de columnas)
--> Las columnas de cada consulta deben ser del mismo TIPO DE DATO que las columnas de la primera consulta (la primera consulta manda)
--> Se pueden usar columnas ficticias y funciones de conversión de tipo de datos para poder cumplir con estas reglas


-- 1) Se agregó un 0 para cumplir con la regla del "mismo número de columnas y mismo tipo de dato"
SELECT EMPLOYEE_ID, -- Columna 1
       JOB_ID,      -- Columna 2
       SALARY       -- Columna 3
FROM   EMPLOYEES 
UNION
SELECT EMPLOYEE_ID, -- Columna 1
       JOB_ID,      -- Columna 2
       0            -- Columna 3 ficticia
FROM   JOB_HISTORY;


-- 2) Se creó una columna ficticia en ambas consultas para que coincidan la cantidad de columnas y tipo de datos
SELECT 'Tabla EMPLOYEES' "NOMBRE TABLA", 
        E.EMPLOYEE_ID, 
        D.DEPARTMENT_NAME
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON(E.DEPARTMENT_ID = D.DEPARTMENT_ID)
UNION
SELECT 'Tabla EMP_SAL_12000' "NOMBRE TABLA", 
        ES.EMPLOYEE_ID, 
        D.DEPARTMENT_NAME
FROM EMP_SAL_12000 ES
JOIN DEPARTMENTS D ON(ES.DEPARTMENT_ID = D.DEPARTMENT_ID);


-- 3) Para que la segunda columna tuviese el mismo tipo de dato se tuvo que transformar a VARCHAR2 usando TO_CHAR()
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       NVL(TO_CHAR(COMMISSION_PCT, '0D00'), 'NO TIENE') "COMISIÓN"
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NULL  -- Muestra todos los empleados SIN comisión
UNION
SELECT FIRST_NAME || ' ' || LAST_NAME "EMPLEADO",
       TO_CHAR(COMMISSION_PCT, '0D00')  -- Se convirtió a VARCHAR2 para hacer coincidir el tipo de dato
FROM EMPLOYEES
WHERE COMMISSION_PCT IS NOT NULL;  -- Muestra todos los empleados CON comisión


-------------------------------------------------{  LENGUAJE DML  }----------------------------------------------------------


-->                                COMANDOS DML
-->                                ------------ 

-->                       SELECT : Consultar datos de la BD
-->                       INSERT : Insertar filas en las tablas
-->                       UPDATE : Actualizar o modificar filas en las tablas
-->                       DELETE : Eliminar filas de las tablas


--> DML: Lenguaje de Manipulación de Datos (Data Manipulation Language)
--> Está compuesto de comandos SQL que permiten modificar filas de las tablas de la BD (salvo SELECT que se usa solo para consultar la información)
--> INSERT, UPDATE y DELETE no muestran un resultado como la sentencia SELECT, sólo retornan el número de filas afectadas por la modificación que se efectuó
--> Todas las modificaciones de los datos se realizan en la memoria de la BD (quedan temporalmente en la instancia de BD, no se graban inmediatamente en disco)
--> Para que las modificaciones se realicen FÍSICAMENTE en las tablas de la BD, se deben confirmar los cambios con el comando COMMIT (hay que comitear)
--> La "confirmación" significa hacer permanentes esos cambios temporales en las tablas de la BD (grabar los cambios en disco)
--> Mientrás los cambios no sean confirmados con COMMIT, solo serán visibles para el usuario que los realizó (sólo se ven en su instancia de BD)
--> Para que no se realicen los cambios en las tablas de la BD se debe usar el comando ROLLBACK (permite deshacer los cambios efectuados)
--> El ROLLBACK(deshacer los cambios) solo es posible si antes no se ha realizado un COMMIT(una vez confirmado los cambios ya no se puede volver atrás)


-------------------------------------------------{  LENGUAJE TCL  }----------------------------------------------------------


-->                                COMANDOS TCL
-->                                ------------ 

-->                       ROLLBACK : Deshacer los cambios realizados por las sentencias DML
-->                         COMMIT : Confirmar los cambios realizados por las sentencias DML
-->                      SAVEPOINT : Crea un punto de recuperación en la transacción


--> TCL: Lenguaje de Control de Transacciones (Transaction Control Language)
--> Permiten administrar los cambios (manejar las transacciones) realizados en las tablas a través de sentencias DML
--> La sentencia COMMIT finaliza la transacción actual, haciendo que TODOS los cambios de datos pendientes sean PERMANENTES en la BD (no hay vuelta atrás)
--> La sentencia ROLLBACK finaliza la transacción actual desechando todos los cambios de datos pendientes (no se efectúan los cambios en la BD) 
--> El Rollback afecta solo a los cambios que esten en memoria, una vez ya comiteados quedan confirmados en disco y no hay vuelta atrás
--> Las "transacciones" consisten en sentencias SQL (INSERT, UPDATE y DELETE) que realizan "un cambio" consistente en los datos
--> SELECT es la única sentencia DML que NO genera una transacción de BD (como solo consulta datos no es necesario realizarle ni COMMIT ni ROLLBACK)
--> Una transacción comienza cuando se ejecuta la primera sentencia DML y finaliza cuando se ejecuta un COMMIT o ROLLBACK o se ejecutan sentencias DDL o DCL
--> Todas las sentencias DDL o DCL tienen un COMMIT implícito (ejecutar un ROLLBACK después de una de estas sentencias no tiene efecto)


--------------------------------------------{  SAVEPOINT - ROLLBACK - COMMIT  }----------------------------------------------------------


--> Un SAVEPOINT es una marca que permite efectuar un ROLLBACK parcial en la Transacción
--> Se pueden marcar diferentes puntos dentro de la transacción y efectuar ROLLBACK a un SAVEPOINT o a la transacción completa
--> Para crear un punto de recuperación en la transacción, se debe usar el comando SAVEPOINT seguido de un nombre (SAVEPOINT A, SAVEPOINT B, SAVEPOINT C,...)


-- 1.0) Crear tablas a través de subconsultas (para realizar los siguientes ejemplos)

-- Tabla respaldo de EMPLOYEES
CREATE TABLE EMPLEADOS             
AS SELECT * FROM EMPLOYEES;
   
-- Tabla respaldo de JOB_HISTORY
CREATE TABLE HISTORIAL_TRABAJO      
AS SELECT * FROM JOB_HISTORY;

-- Consultar la tabla EMPLEADOS (Tiene los 107 empleados de EMPLOYEES)
SELECT * FROM EMPLEADOS;

-- Consultar la tabla HISTORIAL_TRABAJO (Tiene los 10 empleados JOB_HISTORY)
SELECT * FROM HISTORIAL_TRABAJO;

-- 1.1) En este ejemplo solo se confirman las 2 primeras transacciones (se deshace la última transacción)

-- Elimina el empleado que no tiene asignado depto (elimina 1 fila)
DELETE FROM EMPLEADOS          
WHERE DEPARTMENT_ID IS NULL;  

-- Crea un punto de recuperación llamado "A"
SAVEPOINT A;                  

-- Actualiza el salario de todos los empleados aumentandolo un 50% (actualiza 106 filas)
UPDATE EMPLEADOS
SET SALARY = SALARY * 1.50;   

-- Crea un punto de recuperación llamado "B"
SAVEPOINT B;                  

-- Elimina el empleado que no tiene asignado jefe (elimina al jefe, el empleado 100)
DELETE FROM EMPLEADOS           
WHERE MANAGER_ID IS NULL; 

-- Deshace la eliminación del jefe volviendo al punto B
ROLLBACK TO B;                

-- Confirma la eliminación del empleado sin depto y el aumento de salario
COMMIT;                       

-- Se puede ver que se eliminó el empleado sin depto y el salario aumento, y el jefe no se eliminó (empleado 100)
SELECT * FROM EMPLEADOS;


-- 1.2) En este ejemplo se confirman las 3 transacciones (TRUNCATE tiene un COMMIT implícito)

-- Elimina el empleado sin depto (Dirá "0 filas eliminadas" ya que se eliminó en la transacción anterior)
DELETE FROM EMPLEADOS
WHERE DEPARTMENT_ID IS NULL;

-- Crea un punto de recuperación llamado "X1"
SAVEPOINT X1;

-- Volverá a subir el sueldo un 50% a todos los empleados (actualiza las 106 filas)
UPDATE EMPLEADOS
SET SALARY = SALARY * 1.50;  

-- Crea un punto de recuperación llamado "X2"
SAVEPOINT X2;

-- Elimina el empleado que no tiene asignado jefe (elimina el empleado 100)
DELETE FROM EMPLEADOS
WHERE MANAGER_ID IS NULL;          

-- Elimina TODAS las filas de la tabla HISTORIAL_TRABAJO (la deja vacia)
TRUNCATE TABLE HISTORIAL_TRABAJO;  

-- Arroja error ya que no es posible volver al punto X2, los cambios ya se confirmaron al ejecutar TRUNCATE
ROLLBACK TO X2;   
                 
-- No tiene sentido realizar COMMIT ya que el TRUNCATE ya lo ejecutó implícitamente (no arroja error)
COMMIT;         

-- Borrar las tablas creadas para el ejemplo
DROP TABLE EMPLEADOS;
DROP TABLE HISTORIAL_TRABAJO;


---------------------------------------------------{  INSERT  }----------------------------------------------------------


--> Sintaxis Corta:

INSERT INTO Tabla VALUES (valor1, valor2, valor3,...);


--> Sintaxis Larga:

INSERT INTO Tabla (columna1, columna2, columna3, ...)
VALUES (valor1, valor2, valor3,...);


--> La sentencia DML INSERT se utiliza para insertar o agregar filas en las tablas
--> Al insertar una fila se le deben asignar valores a cada columna de la tabla (salvo que se realize un INSERT implícito de valores nulos)
--> Si se desea listar las columnas en el INSERT no es necesario que sea en el mismo orden en que aparecen en la tabla
--> Al insertar datos de tipo fecha y caracter, se deben escribir entre comillas simples ('Carlos', '18234567-k', '12-09-2020', etc.)
--> Por cada fila que se desee insertar se debe escribir una nueva sentencia INSERT (para insertar 10 filas -> 10 INSERT)


-->       ERRORES FRECUENTES CON INSERT
-->       -----------------------------

--> No insertar un valor a una columna definida como *obligatoria (si la columna está definida "NOT NULL" se le debe insertar algún valor válido)
--> Valores duplicados para las CONSTRAINT PK o UNIQUE (no se puede insertar un valor que ya exista en esas columnas, no pueden tener valores repetidos)
--> Valores de FK que NO existen (el valor de la FK debe existir en la tabla donde es PK, salvo que la FK sea opcional, en ese caso puede ser null)
--> Tipos de datos inconsistentes (si una columna es de tipo NUMBER no le podemos pasar como valor un texto, se debe insertar el mismo tipo de dato)
--> Valores demasiado largos o fuera de rango (si tenemos una columna VARCHAR2(5) no le podemos ingresar un texto con más de 5 caracteres)


-- 1.0) Crear tablas a través de subconsultas (para realizar los siguientes ejemplos)

-- Crear una tabla de respaldo de DEPARTMENTS en la subconsulta
CREATE TABLE DEPTOS
AS SELECT * FROM DEPARTMENTS;

-- Consultar la tabla creada (fijarse en que orden aparecen las columnas)
SELECT * FROM DEPTOS;

-- 1.1) Insertar una fila en la tabla DEPTOS
INSERT INTO DEPTOS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES (280, 'De Solteros', 100, 1700);

-- Consultar la tabla - Verificar que el depto 280 se haya ingresado
SELECT * FROM DEPTOS;


-- 1.2) Al insertar no es obligación mantener el mismo orden de las columnas tal como salen en la tabla - Sintaxis Larga
INSERT INTO DEPTOS (DEPARTMENT_NAME, DEPARTMENT_ID, LOCATION_ID, MANAGER_ID)
VALUES ('De Casados', 290, 1700, 100);

-- Consultar la tabla - Verificar que el depto 290 se haya ingresado
SELECT *
FROM DEPTOS;


-- 1.3) Al realizar un INSERT se puede omitir listar las columnas de la tabla (basta con especificar los valores) - Sintaxis Corta
INSERT INTO DEPTOS VALUES (300, 'De Viudos', 100, 1700); -- Se insertan en el mismo orden en que aparecen las columnas

-- Consultar la tabla - Verificar que el depto 300 se haya ingresado
SELECT *
FROM DEPTOS;

-- Borrar la tabla DEPTOS (como DROP es un comando DDL tiene un COMMIT implícito y los cambios quedan confirmados)
DROP TABLE DEPTOS;


-- 2.0) Crear un punto de restauración (para poder deshacer los cambios que hagamos a las tablas del esquema HR)
SAVEPOINT EVITAR_CAGAZO; 

-- Consultar la tabla DEPARTMENTS - Verificar que llega solo hasta el depto 270
SELECT *
FROM DEPARTMENTS
ORDER BY DEPARTMENT_ID;


-- 2.1) Se pueden insertar valores nulos de forma explícita (se pueden omitir las columnas)
INSERT INTO DEPARTMENTS
VALUES (280, 'De Solteros', NULL, NULL);

-- Verificar que se haya insertado la fila del depto 280
SELECT *
FROM DEPARTMENTS
ORDER BY DEPARTMENT_ID;


-- 2.2) También se pueden insertar valores nulos de forma implícita (se deben listar las columnas que reciben los valores)
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME)  -- En ambiente de desarrollo se ocupa este tipo de INSERT
VALUES (290, 'De Solterones');  

-- Como son columnas opcionales ORACLE se encarga de rellenar con null en caso que no se ingrese valor
SELECT *
FROM DEPARTMENTS
ORDER BY DEPARTMENT_ID;


-- 3.1) Se puede utilizar la función SYSDATE para que se ingrese la fecha y hora actual de la BD en la columna HIRE_DATE
INSERT INTO EMPLOYEES 
(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (300, 'Carlitos', 'Caszely', 'PENALAZO@YAHOO.CL', '96754321', SYSDATE, 'MK_MAN', 6900,  NULL, 205, 100); 

-- Verificar que se haya insertado la fila del empleado 300
SELECT *
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID;


-- 3.2) También se puede usar la función USER que retorna el nombre del usuario que está conectado a la BD (Usuario HR)
INSERT INTO EMPLOYEES 
(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES(301, 'Armando', 'Meza', USER || '@gmail.com',  '515.124.4567', SYSDATE, 'AC_ACCOUNT', 6900, NULL, 205, 100);

-- Verificar que se haya insertado la fila del empleado 301
SELECT *
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID;


-- 4.1) En la sentencia INSERT, se pueden usar Subconsultas para asignar un valor a alguna columna
INSERT INTO EMPLOYEES 
(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (302, 'Jebus', 'Quechua', 'elyisus@duoc.cl', '515.124.4567', SYSDATE, 'AC_ACCOUNT', 6900, NULL, 205, (SELECT DEPARTMENT_ID
                                                                                                             FROM EMPLOYEES
                                                                                                             WHERE EMPLOYEE_ID = 100));

-- Verificar que se haya insertado la fila del empleado 302
SELECT *
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID;


-- 4.2) El valor que arroje la subconsulta debe ser de un tipo de dato válido para esa columna
INSERT INTO EMPLOYEES 
(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
VALUES (303, 'Rosa', 'Espinoza', 'tantoTimporta', '245.412.4567', SYSDATE, 'AC_ACCOUNT', (SELECT MAX(SALARY)FROM EMPLOYEES), NULL, 
205, (SELECT DEPARTMENT_ID
      FROM EMPLOYEES
      WHERE EMPLOYEE_ID = 100));
      
-- Verificar que se haya insertado la fila del empleado 303
SELECT *
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID;

-- Deshacer los cambios realizados a la tablas del esquema HR
ROLLBACK TO EVITAR_CAGAZO; 

-- Verificar que la tabla EMPLOYEES nuevamente tenga los 107 empleados
SELECT *
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID;


---------------------------------------------------{  INSERT MÚLTIPLE  }----------------------------------------------------------


--> Podemos insertar múltiples filas en una tabla o en múltiples tablas a través de sentencias de inserción de múltiples filas (Incondicional y Condicional)


--> Sintaxis Inserción Incondicional:

INSERT ALL
    INTO Tabla1 (columna1, columna2, columna3, ...) VALUES (valor1, valor2, valor3,...)
    INTO Tabla2 (columna1, columna2, columna3, ...) VALUES (valor1, valor2, valor3,...)
    INTO Tabla3 (columna1, columna2, columna3, ...) VALUES (valor1, valor2, valor3,...)
    INTO Tabla4 (columna1, columna2, columna3, ...) VALUES (valor1, valor2, valor3,...)
Subconsulta;


--> Sintaxis Inserción Condicional:

INSERT ALL
    WHEN Condición1 THEN   
        INTO Tabla1 (columna1, columna2, columna3, ...) VALUES (valor1, valor2, valor3,...)
    WHEN Condición2 THEN     
        INTO Tabla2 (columna1, columna2, columna3, ...) VALUES (valor1, valor2, valor3,...)
    WHEN Condición3 THEN     
        INTO Tabla3 (columna1, columna2, columna3, ...) VALUES (valor1, valor2, valor3,...)
    ELSE    
        INTO Tabla4 (columna1, columna2, columna3, ...) VALUES (valor1, valor2, valor3,...)
Subconsulta;


-- 1.0) Vamos a crear 2 tablas para los ejemplos de inserción de múltiple de filas - Inserción Incondicional

-- Se crea con 3 columnas, la primera de ellas autoincremental (parte en 1 y se va incrementando en 1) (1, 2, 3, 4, ...)
CREATE TABLE TABLA_PRUEBA1
(ID               NUMBER(10)    GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1,
 NOMBRE_DEPTO     VARCHAR2(30)  NOT NULL,
 TOTAL_EMPLEADOS  NUMBER(4));
  
  
-- Se crea con 3 columnas, la primera de ellas autoincremental (parte en 10 y se va incrementando en 10) (10, 20, 30, 40, ...)
CREATE TABLE TABLA_PRUEBA2
(ID               NUMBER(10)    GENERATED ALWAYS AS IDENTITY MINVALUE 10 MAXVALUE 9999999999 INCREMENT BY 10 START WITH 10,
 NOMBRE_DEPTO     VARCHAR2(30)  NOT NULL,
 TOTAL_EMPLEADOS  NUMBER(4));
 
-- Consultar que las tablas creadas esten vacias
SELECT * FROM TABLA_PRUEBA1;
SELECT * FROM TABLA_PRUEBA2;


-- 1.1) Se inserta en ambas tablas el resultado de la subconsulta (se insertan 27 filas en cada tabla, 54 en total)
INSERT ALL -- Inserción Incondicional
  INTO TABLA_PRUEBA1 (NOMBRE_DEPTO, TOTAL_EMPLEADOS) VALUES(DEPARTMENT_NAME, TOTAL_EMP)
  INTO TABLA_PRUEBA2 (NOMBRE_DEPTO, TOTAL_EMPLEADOS) VALUES(DEPARTMENT_NAME, TOTAL_EMP)
SELECT D.DEPARTMENT_NAME, 
       COUNT(E.EMPLOYEE_ID) TOTAL_EMP
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
GROUP BY D.DEPARTMENT_NAME
ORDER BY D.DEPARTMENT_NAME; -- Se inserta la cantidad de empleados que hay en cada depto

-- Verificar que se hayan ingresado las 27 filas a cada tabla
SELECT * FROM TABLA_PRUEBA1;
SELECT * FROM TABLA_PRUEBA2;

--Eliminar las tablas creadas en el ejemplo
DROP TABLE TABLA_PRUEBA1;
DROP TABLE TABLA_PRUEBA2;


-- 2.0) Vamos a crear 2 tablas para los ejemplos de inserción de múltiple de filas - Inserción Condicional
CREATE TABLE DEPTOS_SIN_EMPLEADOS -- Se crea con solo 2 columnas
(ID           NUMBER(10)   GENERATED ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1,
 NOMBRE_DEPTO VARCHAR2(30) NOT NULL);
  
CREATE TABLE DEPTOS_CON_EMPLEADOS -- Se crea con 3 columnas
(ID              NUMBER(10)   GENERATED ALWAYS AS IDENTITY MINVALUE 10 MAXVALUE 9999999999 INCREMENT BY 10 START WITH 10,
 NOMBRE_DEPTO    VARCHAR2(30) NOT NULL,
 TOTAL_EMPLEADOS NUMBER(4));
 
-- Verificar que las tablas creadas esten vacias
SELECT * FROM DEPTOS_SIN_EMPLEADOS;
SELECT * FROM DEPTOS_CON_EMPLEADOS;

 
-- 2.1) Se insertan 27 filas (16 filas en la tabla DEPTOS_SIN_EMPLEADOS y 11 filas en la tabla DEPTOS_CON_EMPLEADOS)
INSERT ALL 
WHEN TOTAL_EMP = 0 THEN -- Si el conteo de empleados da 0 se insertan las filas en la tabla DEPTOS_SIN_EMPLEADOS
    INTO DEPTOS_SIN_EMPLEADOS (NOMBRE_DEPTO) VALUES (DEPARTMENT_NAME)
ELSE -- Si el conteo de empleados NO da 0 se insertan las filas en la tabla DEPTOS_CON_EMPLEADOS
    INTO DEPTOS_CON_EMPLEADOS (NOMBRE_DEPTO, TOTAL_EMPLEADOS) VALUES (DEPARTMENT_NAME, TOTAL_EMP)
SELECT D.DEPARTMENT_NAME, 
       COUNT(E.EMPLOYEE_ID) TOTAL_EMP
FROM DEPARTMENTS D
LEFT JOIN EMPLOYEES E ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
GROUP BY D.DEPARTMENT_NAME
ORDER BY D.DEPARTMENT_NAME;

-- Los ID no quedan correlativos, debido a que cada INSERT que se realice en cualquier tabla incrementa el ID de las 2
SELECT * FROM DEPTOS_SIN_EMPLEADOS;
SELECT * FROM DEPTOS_CON_EMPLEADOS;

--Eliminar las tablas creadas en el ejemplo
DROP TABLE DEPTOS_SIN_EMPLEADOS;
DROP TABLE DEPTOS_CON_EMPLEADOS;


---------------------------------------------------{  INSERT CON SUBCONSULTAS  }----------------------------------------------------------


--> Sintaxis:

INSERT INTO Tabla
Subconsulta;


--> Se pueden usar SUB para insertar filas a una tabla (debe coincidir el número de columnas y el tipo de dato que retorne la SUB con las de la tabla)
--> Para insertar filas a partir de una SUB, no se incluye la cláusula VALUES ya que ésta es reemplazada por la sentencia SELECT de la Subconsulta


-- 1.0) Crear respaldo de la tabla EMPLOYEES y dejarla vacia

-- Crea la tabla EMPLEADOS en la subconsulta
CREATE TABLE EMPLEADOS  
AS SELECT * FROM EMPLOYEES;
   
-- Dejar la tabla EMPLEADOS vacia (eliminar TODAS las filas)
TRUNCATE TABLE EMPLEADOS;

-- Consultar la tabla EMPLEADOS (notar que no tiene ningún registro)
SELECT * FROM EMPLEADOS;
   

-- 1.1) Insertar el resultado de la subconsulta en la tabla EMPLEADOS
INSERT INTO EMPLEADOS
SELECT * FROM EMPLOYEES;  -- Inserta las 107 filas en la tabla EMPLEADOS (ejecutar la consulta para ver la tabla)

-- Verificar que las 107 filas se hayan ingresado en la tabla
SELECT * FROM EMPLEADOS;


-- 2.0) Crear respaldo de la tabla DEPARTMENTS y dejarla vacia

-- Crea la tabla DEPTOS en la subconsulta
CREATE TABLE DEPTOS   
AS SELECT * FROM DEPARTMENTS;
   
-- Dejar la tabla DEPTOS vacia (eliminar TODAS las filas)
TRUNCATE TABLE DEPTOS;   
   
-- Consultar la tabla DEPTOS (Notar que esta completamente vacia)  
SELECT * FROM DEPTOS;


-- 2.1) Insertar el resultado de la subconsulta en la tabla DEPTOS
INSERT INTO DEPTOS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
SELECT EMPLOYEE_ID,    -- Tipo NUMBER al igual que DEPARTMENT_ID
       LAST_NAME,      -- Tipo VARCHAR2 al igual que DEPARTMENT_NAME
       SALARY,         -- Tipo NUMBER al igual que MANAGER_ID 
       COMMISSION_PCT  -- Tipo NUMBER al igual que LOCATION_ID
FROM EMPLOYEES
WHERE JOB_ID LIKE '%REP%';  

-- Al consultar la tabla se aprecia que se insertaron 33 filas
SELECT * FROM DEPTOS;


-- 3.0) Crear respaldo de la tabla LOCATIONS y dejarla vacia

-- Crea la tabla UBICACIONES en la subconsulta
CREATE TABLE UBICACIONES   
AS SELECT * FROM LOCATIONS;
   
-- Dejar la tabla UBICACIONES vacia (eliminar TODAS las filas)
TRUNCATE TABLE UBICACIONES;   
   
-- Consultar la tabla UBICACIONES (Notar que esta completamente vacia)  
SELECT * FROM UBICACIONES;


-- 3.1) Guardar el resultado de la consulta en la tabla UBICACIONES
INSERT INTO UBICACIONES
SELECT E.EMPLOYEE_ID,
       E.FIRST_NAME || ' ' || E.LAST_NAME,
       TO_CHAR(E.DEPARTMENT_ID),  -- La pasamos a VARCHAR2 para que coincida el tipo de dato
       D.DEPARTMENT_NAME,
       E.JOB_ID,
       SUBSTR(J.JOB_TITLE, 1, 2)  -- La recortamos a 2 caracteres para que coincida con el largo - VARCHAR(2)
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON(E.DEPARTMENT_ID = D.DEPARTMENT_ID)
JOIN JOBS J ON(E.JOB_ID = J.JOB_ID)
MINUS         -- Operador SET que muestra las filas de la primera consulta que no esten en la segunda consulta
SELECT E.EMPLOYEE_ID,
       E.FIRST_NAME || ' ' || E.LAST_NAME,
       TO_CHAR(E.DEPARTMENT_ID), 
       D.DEPARTMENT_NAME,
       E.JOB_ID,
       SUBSTR(J.JOB_TITLE, 1, 2) -- La recortamos a 2 caracteres para que coincida con el largo - VARCHAR(2)
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON(E.DEPARTMENT_ID = D.DEPARTMENT_ID)
JOIN JOBS J ON(E.JOB_ID = J.JOB_ID)
WHERE SALARY < ALL (SELECT ROUND(AVG(SALARY))
                    FROM EMPLOYEES
                    GROUP BY DEPARTMENT_ID);  -- Inserta 69 filas en la tabla UBICACIONES


-- Se insertaron los datos de los empleados que NO poseen un salario menor a todos los salarios promedios de los departamentos 
SELECT * FROM UBICACIONES;

-- Eliminamos las tablas creadas para los ejemplos
DROP TABLE EMPLEADOS;
DROP TABLE DEPTOS;
DROP TABLE UBICACIONES;


---------------------------------------------------{  UPDATE  }----------------------------------------------------------


--> Sintaxis:

UPDATE Tabla
    SET Columna1 = Valor1, 
        Columna2 = Valor2,
        Columna3 = Valor3
WHERE condición;


--> La sentencia DML UPDATE se utiliza para modificar datos o actualizar filas en las tablas
--> Con UPDATE se puede actualizar más de una fila y/o columna al mismo tiempo
--> La condición en el WHERE permite establecer que fila o grupo de filas vamos a actualizar (Si se omite la cláusula WHERE se actualizan todas las filas)
--> Hay que tener MUCHO CUIDADO!, si se nos olvida poner el WHERE nos va a modificar las filas de TODA la tabla (mucho ojo con eso)


-->        ERRORES FRECUENTES CON UPDATE
-->        -----------------------------

--> Violación por valores duplicados para columnas definidas como únicas, es decir para columnas PRIMARY KEY(PK) o UNIQUE(UK)
--> Violación de Integridad Referencial o de Claves Foráneas (dar valores a las FK que no existen en las PK)
--> El tipo de dato del nuevo valor no coincide con el tipo de dato definido para la columna de la tabla correspondiente
--> El nuevo valor asignando es demasiado largo para la columna sobre la cual se desea insertar el valor


-- 1) ¿Cómo poder asignarle a los empleados 103 y 104 el depto 110?

-- Consultar cúal es el depto actual de los empleados 103 y 104
SELECT EMPLOYEE_ID,    
       DEPARTMENT_ID
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (103, 104);  -- Tienen asignado el depto 60

-- Modificar el valor de la columna DEPARTMENT_ID utilizando la sentencia UPDATE
UPDATE EMPLOYEES
    SET DEPARTMENT_ID = 110
WHERE EMPLOYEE_ID IN (103, 104);  -- Se actualizan 2 filas

-- Se puede observar que ahora los empleados 103 y 104 tiene asignado el depto 110
SELECT EMPLOYEE_ID,    
       DEPARTMENT_ID
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (103, 104);

-- Deshacer los cambios a la tabla EMPLOYEES 
ROLLBACK; 

-- El ROLLBACK deshizo la actualización de los deptos (nuevamente tienen el depto 60)
SELECT EMPLOYEE_ID,    
       DEPARTMENT_ID
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (103, 104);


-- 2) Actualizar la fecha de contrato (restarle un mes) y el salario de todos los empleados (aumentar un 25%)

-- Consultar el salario y la fecha de contrato
SELECT EMPLOYEE_ID,
       SALARY,
       HIRE_DATE
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID; -- El empleado 100 gana 24 mil dolares y su fecha de contrato es del 17 de Junio
       
-- Actualizar las columnas HIRE_DATE y SALARY   
UPDATE EMPLOYEES
    SET HIRE_DATE = ADD_MONTHS(HIRE_DATE, -1),
        SALARY = SALARY * 1.25;   -- Actualiza las fechas de contrato y los salarios de los 107 empleados
        
-- Al volver a ejecutar la consulta, el empleado 100 ahora gana 30 mil dolares y su fecha cambio a 17 de Mayo
SELECT EMPLOYEE_ID,
       SALARY,
       HIRE_DATE
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID;

-- Deshacer los cambios a la tabla EMPLOYEES ()
ROLLBACK; 

-- Nuevamente el empleado 100 gana 24 mil y su contrato es de Junio
SELECT EMPLOYEE_ID,
       SALARY,
       HIRE_DATE
FROM EMPLOYEES
ORDER BY EMPLOYEE_ID;


-- 3) Actualizar el salario de los empleados de acuerdo a su antiguedad laboral (2005->15%, 2006->10%, resto 5%)

-- Consultar el salario y el año de contrato de los empleados cuyo jefe sea el 145 o el 147
SELECT MANAGER_ID,
       SALARY,
       TO_CHAR(HIRE_DATE, 'YYYY') "AÑO"
FROM EMPLOYEES
WHERE MANAGER_ID IN(145, 147)
ORDER BY EMPLOYEE_ID;          -- El salario más alto es 10 mil dolares
       
-- Se actualiza el salario solo a los empleados cuyo jefe tenga id 145 o 147 (12 filas)       
UPDATE EMPLOYEES  
    SET SALARY = CASE
                     WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2005 THEN ROUND(SALARY * 1.15)
                     WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2006 THEN ROUND(SALARY * 1.10)
                     ELSE ROUND(SALARY * 1.05)
                 END
WHERE MANAGER_ID IN(145, 147); 

-- Ahora el salario más alto es de 11.500 dolares (aumento 15% al ser del año 2005)
SELECT MANAGER_ID,
       SALARY,
       TO_CHAR(HIRE_DATE, 'YYYY') "AÑO"
FROM EMPLOYEES
WHERE MANAGER_ID IN(145, 147)
ORDER BY EMPLOYEE_ID; 

-- Deshacer los cambios a la tabla EMPLOYEES
ROLLBACK; 

-- Nuevamente el salario más alto es 10 mil dolares
SELECT MANAGER_ID,
       SALARY,
       TO_CHAR(HIRE_DATE, 'YYYY') "AÑO"
FROM EMPLOYEES
WHERE MANAGER_ID IN(145, 147)
ORDER BY EMPLOYEE_ID; 


---------------------------------------------------{  UPDATE CON SUBCONSULTAS  }-------------------------------------------


--> Sintaxis:

UPDATE Tabla
    SET Columna1 = (Subconsulta1), 
        Columna2 = (Subconsulta2)
WHERE condición;


--> Se puede usar subconsultas para asignar el nuevo valor que tendrá la columna o para establecer condiciones en la cláusula WHERE
--> El resultado de la subconsulta debe coincidir con el tipo de dato que almacena la columna (si arroja un texto y la columna era numérica dará error)


-- 1) Actualizar el id del trabajo y salario del empleado 114 con el id de trabajo y salario del empleado 205

-- Ver cuales son los id de trabajo y salario del empleado 114 y del empleado 205
SELECT EMPLOYEE_ID,
       JOB_ID,
       SALARY
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (114, 205);

-- Realizar el UPDATE asignando el valor a cada columna a través de subconsultas
UPDATE EMPLOYEES
       SET  JOB_ID = (SELECT  JOB_ID
                      FROM  EMPLOYEES
                      WHERE EMPLOYEE_ID = 205),
            SALARY = (SELECT SALARY
                      FROM EMPLOYEES
                      WHERE EMPLOYEE_ID = 205)
WHERE EMPLOYEE_ID = 114;

-- Revisar el nuevo JOB_ID y Salario del empleado 114 (verificar que sean los mismos del 205)
SELECT EMPLOYEE_ID,
       JOB_ID,
       SALARY
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (114, 205);

-- Al aplicar ROLLBACK de deshacen los cambios realizados al salario
ROLLBACK;  

-- Notar que se revierten los cambios al empleado 114
SELECT EMPLOYEE_ID,
       JOB_ID,
       SALARY
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (114, 205);


-- 2) Aumentar el salario de los empleados que ganan el salario mínimo y asignarles un salario promedio

-- Consultar los empleados que ganan el salario mínimo
SELECT EMPLOYEE_ID,
       SALARY 
FROM EMPLOYEES
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEES);  -- El empleado 132 gana 2100 dolares (es el que menos gana)

-- Se actualiza el salario de los empleados que ganan el menor salario
UPDATE EMPLOYEES 
    SET SALARY = (SELECT ROUND(AVG(SALARY))
                  FROM EMPLOYEES)
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEES);  

-- Ahora los que menos ganan son el empleado 128 y el 136                
SELECT EMPLOYEE_ID,
       SALARY 
FROM EMPLOYEES
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEES);

-- Al aplicar ROLLBACK de deshacen los cambios realizados al salario
ROLLBACK;  

-- Nuevamente el empleado 132 gana 2100 dolares (volvió a la pobreza)
SELECT EMPLOYEE_ID,
       SALARY 
FROM EMPLOYEES
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEES);


-- 3) Aumentar el salario un 12,5% a los empleados cuyos deptos poseen salarios menores al salario promedio

-- Consultar el salario de los empleados
SELECT EMPLOYEE_ID,
       TO_CHAR(SALARY, '$99G999') SALARIO 
FROM EMPLOYEES
ORDER BY SALARY;

-- Actualizar el salario un 12.5%
UPDATE EMPLOYEES 
        SET SALARY = ROUND(SALARY * 1.125)
 WHERE DEPARTMENT_ID IN (SELECT DISTINCT DEPARTMENT_ID
                         FROM EMPLOYEES
                         WHERE SALARY < (SELECT ROUND(AVG(SALARY))
                                         FROM EMPLOYEES));

-- Se actualizó el salario a 93 empleados
SELECT EMPLOYEE_ID,
       TO_CHAR(SALARY, '$99G999') SALARIO 
FROM EMPLOYEES
ORDER BY SALARY;

-- Deshacer los cambios del salario
ROLLBACK;

-- Vuelven a tener sus sueldos miserables
SELECT EMPLOYEE_ID,
       TO_CHAR(SALARY, '$99G999') SALARIO 
FROM EMPLOYEES
ORDER BY SALARY;


------------------------------------------------------{  DELETE  }----------------------------------------------------------


--> Sintaxis:

DELETE Tabla
WHERE Condición;


--> La sentencia DML DELETE se utiliza para eliminar filas de las tablas
--> La sintaxis: DELETE FROM Tabla WHERE Condición, también es válida, pero la palabra FROM se puede omitir (no es necesaria)
--> Para eliminar sólo algunas filas de la tabla se debe incluir la cláusula WHERE (Si no se usa WHERE se eliminan TODAS las filas de la tabla)
--> Si se trata de eliminar filas que tengan valores que sean referencia de llave foránea (FK), Oracle genera el error "Restricción de Integridad"
--> Hay que tener MUCHO CUIDADO!, si se nos olvida poner el WHERE nos va a eliminar las filas de TODA la tabla (mucho ojo con eso)


-- 1.0) Crear respaldo de la tabla EMPLOYEES y DEPARTMENTS

-- Crea la tabla EMPLEADOS en la subconsulta
CREATE TABLE EMPLEADOS        
AS SELECT * FROM EMPLOYEES;
   
-- Crea la tabla DEPTOS en la subconsulta
CREATE TABLE DEPTOS           
AS SELECT * FROM DEPARTMENTS;
   
-- Consultar la tabla EMPLEADOS   
SELECT * FROM EMPLEADOS;     

-- Consultar la tabla DEPTOS
SELECT * FROM DEPTOS;        

-- Creamos un punto de recuperación, ya que en este punto las tablas estan sin modificar
SAVEPOINT DEPTOS_EMPLEADOS_LLENOS;  


-- 1) Eliminar todas las filas de la tabla EMPLEADOS
DELETE EMPLEADOS;  

-- Se eliminaron las 107 filas (queda la tabla vacia)   
SELECT * FROM EMPLEADOS;


-- 2) Eliminar todas las filas de la tabla DEPTOS cuyo nombre de depto sea 'Finance'
DELETE DEPTOS
WHERE DEPARTMENT_NAME = 'Finance';     

-- Se eliminó 1 fila
SELECT * FROM DEPTOS;        

-- Volvemos al punto en donde las tablas estaban completas
ROLLBACK TO DEPTOS_EMPLEADOS_LLENOS;   

-- Consultar la tabla EMPLEADOS (Tiene sus 107 filas)  
SELECT * FROM EMPLEADOS;     

-- Consultar la tabla DEPTOS (Tiene sus 27 filas) 
SELECT * FROM DEPTOS;  


-- 3) Eliminar los deptos cuyo ID sea 30 o 40
DELETE DEPTOS
WHERE DEPARTMENT_ID IN(30, 40);  

-- Se elimina los deptos 'Purchasing' y 'Human Resources' (elimina 2 filas)
SELECT * FROM DEPTOS;  


-- 4) Eliminar los empleados cuyo salario este entre 2 mil y 5 mil dolares
DELETE EMPLEADOS
WHERE SALARY BETWEEN 2000 AND 5000;  

-- Se eliminan 49 empleados de la tabla EMPLEADOS (Se eliminaron 49 filas)
SELECT * FROM EMPLEADOS;

-- Eliminamos las tablas creadas para los ejemplos
DROP TABLE EMPLEADOS;
DROP TABLE DEPTOS;


--------------------------------------------{  DELETE CON SUBCONSULTAS  }-------------------------------------------


--> Sintaxis:

DELETE Tabla
WHERE Columna Operador_Comparación (Subconsulta);


--> Se puede usar subconsultas para establecer que filas serán eliminadas dependiendo del valor o valores que retorne la subconsulta


-- 1.0) Crear respaldo de la tabla EMPLOYEES y DEPARTMENTS

-- Crea la tabla EMPLEADOS en la subconsulta
CREATE TABLE EMPLEADOS        
AS SELECT * FROM EMPLOYEES;
   
-- Crea la tabla DEPTOS en la subconsulta
CREATE TABLE DEPTOS           
AS SELECT * FROM DEPARTMENTS;
   
-- Consultar la tabla EMPLEADOS   
SELECT * FROM EMPLEADOS;     

-- Consultar la tabla DEPTOS
SELECT * FROM DEPTOS;  


-- 1) Elimina todos los deptos donde no trabajen empleados
DELETE DEPTOS
WHERE DEPARTMENT_ID NOT IN (SELECT DISTINCT DEPARTMENT_ID  -- NOT IN no puede evaluar nulos o dará siempre FALSO
                            FROM EMPLEADOS
                            WHERE DEPARTMENT_ID IS NOT NULL);  -- Si no se quitan los null da falso y no elimina nada
--  Se eliminan 16 filas
SELECT * FROM DEPTOS;

-- Deshacer la eliminación
ROLLBACK;


-- 2) Eliminar todos los empleados cuyo salario sea igual al salario promedio
DELETE FROM EMPLEADOS 
WHERE SALARY = (SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEES);

-- Como el salario promedio es 6462 y no hay ningún empleado con ese salario, no se elimina ninguna fila
SELECT EMPLOYEE_ID
FROM EMPLEADOS
WHERE SALARY = 6462; 


-- 3) Eliminar los empleados cuyo DEPARTMENT_ID sea igual a alguno de los deptos que poseen más de 10 empleados

-- Se puede observar que en el depto 50 hay 45 empleados y en el depto 80 hay 34 empleados
SELECT DEPARTMENT_ID,
       COUNT(EMPLOYEE_ID) TOTAL_EMPLE
FROM EMPLEADOS
GROUP BY DEPARTMENT_ID
HAVING COUNT(EMPLOYEE_ID) > 10;

-- A través de la subconsulta vamos a eliminar a los empleados de los depto 50 y 80
DELETE FROM EMPLEADOS
WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID
                       FROM EMPLOYEES
                       GROUP BY DEPARTMENT_ID
                       HAVING COUNT(EMPLOYEE_ID) > 10);  -- Elimina 79 filas

-- Mostrar los empleados de los depto 50 y 80 (se puede ver que fueron eliminados)
SELECT DEPARTMENT_ID,
       EMPLOYEE_ID 
FROM EMPLEADOS
WHERE DEPARTMENT_ID IN (50, 80);

-- Eliminamos las tablas creadas para los ejemplos
DROP TABLE EMPLEADOS;
DROP TABLE DEPTOS;


---------------------------------------------{  TRUNCATE  }-------------------------------------------------------------


--> Sintaxis:

TRUNCATE TABLE Tabla;


--> La sentencia DDL TRUNCATE se utiliza para eliminar TODAS las filas de una tabla (elimina todo el contenido de la tabla, la deja vacía)
--> La diferencia con DELETE es que TRUNCATE es una sentencia DDL y por ende posee un COMMIT implícito (ya no se puede hacer ROLLBACK)
--> La otra diferencia con DELETE es que TRUNCATE no tiene WHERE, no se puede eliminar filas específicas, si se ejecuta lo borra TODO
--> Es la forma más eficiente de borrar TODAS las filas de una tabla (es más rápida que DELETE)
--> Truncar una tabla es más eficiente que borrar una tabla y crearla de nuevo, ya que TRUNCATE mantiene las FK, los índices, triggers, privilegios, etc.
--> Truncar una tabla no activa los triggers de eliminación de la tabla
--> Si la tabla posee CONSTRAINT de restricción de integridad referencial, se debe desactivar antes de ejecutar la sentencia TRUNCATE y después volver a activarla


-- 1.0) Crear respaldo de la tabla EMPLOYEES y DEPARTMENTS

-- Crea la tabla EMPLEADOS en la subconsulta
CREATE TABLE EMPLEADOS  
AS SELECT *
   FROM EMPLOYEES;

-- Crea la tabla DEPTOS en la subconsulta   
CREATE TABLE DEPTOS         
AS SELECT * FROM DEPARTMENTS;
   
-- Consultar la tabla EMPLEADOS   
SELECT * FROM EMPLEADOS;    

-- Consultar la tabla DEPTOS
SELECT * FROM DEPTOS;       

-- Creamos un punto de recuperación, en este punto las tablas estan completas
SAVEPOINT DEPTOS_EMPLEADOS_LLENOS;  


-- 1.1) Truncar la tabla EMPLEADOS
TRUNCATE TABLE EMPLEADOS;

-- Se eliminaron todas las filas de la tabla EMPLEADOS
SELECT * FROM EMPLEADOS; 


-- 1.2) Truncar la tabla DEPTOS 
TRUNCATE TABLE DEPTOS;

-- Se eliminaron todas las filas de la tabla DEPTOS
SELECT * FROM DEPTOS; 

-- Da error pues TRUNCATE ya tiene un COMMIT y no podemos volver a cuando las tablas estaban llenas
ROLLBACK TO DEPTOS_EMPLEADOS_LLENOS;  

-- Al ejecutar este ROLLBACK no da error, pero no tiene ningun efecto pues lo que ya esta comiteado ya no se puede deshacer
ROLLBACK;   


------------------------------------------------{  OBJETO VISTA  }----------------------------------------------------------


--> Una vista o VIEW es una "representación lógica" (no física como una tabla) basada en una o varias tablas o en otra vista
--> Es un 'objeto de BD' que NO contiene datos, pero es similar a una “ventana” o a una "tabla virtual" que a través de ella se pueden ver o modificar datos
--> Las tablas sobre las cuales está basada la vista se llaman "Tablas Base" 
--> Por ejemplo: COUNTRIES, DEPARTMENTS, EMPLOYEES, JOB_HISTORY, JOBS, LOCATIONS y REGIONS son tablas base del esquema HR
--> Las vistas se almacenan como una sentencia SELECT en el diccionario de datos de la BD (se puede ver su definición en: Vistas >> nombreVista >> SQL)


-->          VENTAJAS DE LAS VISTAS
-->          ----------------------

--> Las vistas restringen el acceso a los datos porque permiten mostrar solo las columnas que interese mostrar (podemos seleccionar que columnas de la tabla mostrar)
--> Una vista puede ser usada para construir una consulta simple que recupere datos desde otra consulta compleja (realizar consultas complejas en forma fácil)
--> Las vistas proporcionan independencia de los datos entre el usuario y la aplicación
--> Una vista se puede usar para recuperar datos de varias tablas (las vistas no "almacenan" datos, solo visualizan datos almacenados en las tablas)
--> Las vistas proporcionan a los grupos de usuarios acceso a los datos de acuerdo a criterios en particular y las labores que efectúan (control de acceso)

--> La principal diferencia entre las vistas 'simples' y 'complejas' está relacionada con las operaciones DML (INSERT, UPDATE y DELETE) que pueden realizar


-->                            VISTAS SIMPLES    |     VISTAS COMPLEJAS
-->                            --------------    |     ----------------
-->                                              | 
-->        Número de Tablas:         1           |        1 o más
-->      Contiene Funciones:         NO          |          SI
-->         Contiene Grupos:         NO          |          SI
-->         Operaciones DML:         SI          |        NO Siempre    


------------------------------------------------{  CREATE VIEW  }----------------------------------------------------------


--> Sintaxis:
CREATE VIEW
AS Subconsulta;


--> Para crear una vista debemos utilizar la sentencia CREATE VIEW e incorporar una subconsulta (que puede contener sentencias SELECT complejas)
--> Para que un usuario de la BD pueda crear una vista debe tener asignado el privilegio CREATE VIEW (GRANT CREATE VIEW TO nombreUsuario;)



-------------------------------------------------------{  VISTAS - VIEW  }-------------------------------------------------------------------------



CREATE VIEW V_Nombre_Vista AS                -- CREATE OR REPLACE VIEW (Si la vista ya existe la recrea)
(SUBCONSULTA)
WITH CHECK OPTION CONSTRAINT ctrl_v_nombre   -- solo a las filas que muestra la vista se les puede hacer INSERT y DELETE a traves de la vista
WITH READ ONLY                               -- Para que no puedan hacer operaciones DML usando la vista


UPDATE V_Nombre_Vista       -- Se pueden realizar UPDATE con vistas
SET COLUMNA = valor
WHERE COLUMNA condicion;


INSERT INTO V_Nombre_Vista (col1, col2, col3, ...)       -- Se pueden INSERTAR filas con vistas
VALUES (val1, val2, val3, .....)

-- Las vistas se almacenan como una sentencia SELECT en el diccionario de la BD
-- Para crear una vista el usuario debe tener asignado el privilegio CREATE VIEW y los privilegios sobres las tablas bases de la vista
-- Solo el usuario que creo la vista o el que tenga el privilegio DROP ANY VIEW puede eliminar la vista


-------------------------------------------------------{  SECUENCIAS - SEQUENCE  }-----------------------------------------------------------------------


CREATE SEQUENCE SEQ_Nombre_Secuencia
INCREMENT BY 10                             -- Por defecto se incrementa de 1 en 1 (Si es un número negativo, decrementa)
START WITH 10                               -- El valor inicial de la secuencia por defecto es 1
MAXVALUE 9990                               -- Máximo valor que puede tomar la secuencia (por defecto esta en NOMAXVALUE)
MINVALUE 10                                 -- Mínimo valor que puede tomar la secuencia (por defecto esta en NOMINVALUE, que pone 1 como valor mínimo)                                    -- 
CYCLE                                       -- Hace que la secuencia sea cíclica (que vuelva a empezar al llegar a su máximo valor) por defecto está en NOCYCLE  
ORDER;                                      -- Genera los números de secuencia en orden de solicitud (por defecto esta en NOORDER)


SEQ_Nombre_Secuencia.CURRVAL       -- Retorna el valor actual que tiene la secuencia (en que número va) 
SEQ_Nombre_Secuencia.NEXTVAL       -- Retorna el siguiente número de la secuencia


-- Es un objeto de BD que genera en forma automática números diferentes
-- Se usa mucho en las PK que necesitan tener un número único y correlativo (el número puede incrementar o ir en decremento)
-- Como las secuencias son objetos independientes de las tablas se puede usar una misma secuencia en varias tablas
-- NO se pueden usar secuencias en los SELECT cuando está el ORDER BY
-- Para modificar una secuencia debe ser el dueño de la secuencia (creador) o tener los privilegios ALTER SEQUENCE o DROP ANY SEQUENCE


-- Ejemplo de creación de secuencia
CREATE SEQUENCE SEQ_INCREMENTO
MINVALUE 1 
MAXVALUE 9999999999999999999999999999
INCREMENT BY 1 START WITH 1 CACHE 20 NOCYCLE;


-- Ejemplo de columna Auto-incrementable (columna ID de tipo IDENTITY)
CREATE TABLE  TEST_TABLA_INCREMENTAL
(ID   NUMBER(10) GENERATED  ALWAYS AS IDENTITY MINVALUE 1 MAXVALUE 9999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOCYCLE  NOT NULL ENABLE,
 NAME VARCHAR2(15),
CONSTRAINT PK_TST_INCREMENTAL PRIMARY KEY(id));


-------------------------------------------------------{  SINÓNIMOS - SYNONYM  }-------------------------------------------------------------------------


CREATE [OR REPLACE] [PUBLIC] SYNONYM [esquema1.] nombre_sinónimo   
FOR [esquema2.] objeto_referenciado [@dblink];


CREATE SYNONYM SYN_Nombre_Sinonimo                     -- Crea un sinónimo privado (solo se accede al sinónimo dentro del esquema que lo creo) 
FOR Nombre_Objeto;


DROP [PUBLIC] SYNONYM [esquema.] nombre_sinónimo;       -- Para eliminar sinónimos


-- Si se indica un nombre de esquema1 significa que el sinónimo es PRIVADO (Solo se puede acceder a el dentro de ese esquema)
-- El nombre de esquema2 es el nombre del esquema que contendrá el sinónimo (si no se especifica, por defecto el esquema que lo contiene es donde se crea)
-- Un sinónimo es un nombre alternativo para los objetos de la BD
-- Salvo SYSTEM o SYS todos los usuarios deben tener los privilegios necesarios para crear o usar sinónimos
-- Pueden ser usados por cualquier usuario de la BD (PUBLIC SYNONYM) o solo por 1 usuario específico (sinónimo privado - SYNONYM)
-- Para que un usuario pueda usar un sinónimo debe tener previamente el privilegio sobre el objeto al que hace referencia el sinónimo


--------------------------------------------{  PRIVILEGIOS  }----------------------------------------------------------


--> Un PRIVILEGIO es el derecho a ejecutar sentencias SQL particulares en la BD
--> Privilegios de sistema : Nombres de usuarios y contraseñas, espacio en disco asignado, operaciones sobre el sistema
--> Privilegios de objetos : Uso y acceso sobre los objetos de la BD (Que operaciones pueden realizar sobre los objetos)
--> Se debe seguir el principio del MENOR PRIVILEGIO
--> Los DBA pueden otorgar y revisar los privilegios otorgados (los DBA se conectan como SYSTEM o SYS)
--> Los esquemas({} de objetos) son propiedad de un usuario de la BD y tienen el mismo nombre del usuario (HR - hr)
--> Los privilegios otorgados con la opción ANY se pueden usar sobre cualquier esquema


-- 0) Mostrar todos los privilegios de sistema
SELECT * FROM SYSTEM_PRIVILEGE_MAP;


-- 1) Dar permiso o privilegio para conectarse a la BD
GRANT CREATE SESSION TO JUANITO;


-- 2) Dar permiso a un usuario para realizar crud sobre una tabla
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLA_VENTAS TO JUANITO;


-- 3) Dar permisos de solo lectura a la tabla TABLA_VENTAS para todos los usuarios
GRANT SELECT ON TABLA_VENTAS TO PUBLIC;


----------------------------------------{  CONOCER PRIVILEGIOS DE UN USUARIO O ROL  }-----------------------------------------------------


--> La tabla DBA_SYS_PRIVS contiene los privilegios de sistema otorgados a usuarios y roles
--> Debemos conectarnos como SYSTEM o ADMIN para poder hacer SELECT a la tabla DBA_SYS_PRIVS


-- 1.0) Mostrar el contenido de la tabla DBA_SYS_PRIVS
SELECT * FROM DBA_SYS_PRIVS;


-- 1.1) Saber que privilegios tiene el Usuario SYS
SELECT PRIVILEGE
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'SYS';


-- 1.2) Saber que privilegios tiene el Usuario SYSTEM
SELECT PRIVILEGE
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'SYSTEM';


-- 1.3) Saber que privilegios tiene el rol CONNECT
SELECT PRIVILEGE
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'CONNECT';


-- 1.4) Saber que privilegios tiene el rol RESOURCE
SELECT PRIVILEGE
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'RESOURCE';


-- 2.1) Saber que privilegios tiene el usuario HR
SELECT PRIVILEGE
FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'HR'; 


--> La tabla USER_SYS_PRIVS muestra los privilegios otorgados al usuario de la sesión actual


-- 1) Mostrar los privilegios de HR (Conectados como HR)
SELECT * FROM USER_SYS_PRIVS;


--> Para saber que rol tiene otorgado un usuario podemos usar la tabla USER_ROLE_PRIVS;


-- 1) Conectados a la sesión del usuario
SELECT * FROM USER_ROLE_PRIVS;


-- 2) Que rol tiene asignado el usuario SYSTEM (conectados como SYSTEM)
SELECT * FROM USER_ROLE_PRIVS; -- AQ_ADMINISTRATOR_ROLE, DBA, ROL_DESARROLLADOR, ROL_CONSULTOR




/************************************************************************************************************************************************
*                                                PROGRAMACIÓN DE BASES DE DATOS - PL/SQL                                                        *
*************************************************************************************************************************************************/



--------------------------------------------------------{  BLOQUE PL/SQL  }--------------------------------------------------------------


-- Estructura de un Bloque PL/SQL:

DECLARE
       /* Sección de declaración: variables, constantes, cursores, registros y excepciones definidas por el usuario */
BEGIN
       /* Sección de Ejecución: Conjunto de sentencias ejecutables de SQL y PL/SQL */
EXCEPTION
       /* Sección de Excepciones: Manejo de excepciones o errores */
END;


--> Un bloque PL/SQL tiene 3 secciones bien definidas: Sección de Declaración, Sección de Ejecución y dentro de esta una Sección de Excepciones
--> BEGIN y END son obligatorias en todo bloque PL/SQL (DECLARE y EXCEPTION son opcionales)
--> Todas las sentencias PL/SQL y SQL deben finalizar con un ; (Declaración de variables, sentencias DML, estructuras de control, iteración, etc.)
--> Para realizar comentarios de una línea se usa el -- y para comentarios multilínea se utiliza /* */
--> Tener cuidado al usar comentarios en la misma línea del código afuera del bloque PL/SQL (a veces generan errores de compilación al ejecutar el script)
--> En las sentencias PL/SQL se pueden usar todas las funciones y operadores vistos en SQL (salvo DECODE y Funciones de Grupo que solo sirven en Sentencias SQL)
--> A los operadores matematicos de SQL (*, /, +, -) se agrega el operador PL/SQL de exponenciación **  


-->                    Tipos de Bloques PL/SQL
-->                    -----------------------    

-->    1) Bloques Anónimos (ANONYMOUS BLOCKS) --> Sin nombre, no se almacenan en la BD y se compilan cada vez que son ejecutados

-->    2) Subprogramas --> Bloques PL/SQL Con nombre y Si se almacenan en la BD como objetos
-->
-->           2.1) Procedimientos (PROCEDURE)  --> Bloques PL/SQL que ejecutan una secuencia de acciones (NO retornan un valor) (Prefijo SP_ )
-->           2.2) Funciones (FUNCTION)        --> Bloques PL/SQL que ejecutan una secuencia de acciones y retornan un valor (Prefijo FN_ )
-->           2.3) Paquetes (PACKAGE)          --> Estructura PL/SQL que permite almacenar en forma conjunta una serie de objetos relacionados (Prefijo PKG_ )
-->           2.4) Disparadores (TRIGGER)      --> Bloque PL/SQL que se ejecuta cuando ocurre un evento particular sobre la tabla al que está asociado (Prefijo TRG_ )


--> Dentro de un PACKAGE se pueden incluir: procedimientos, funciones, cursores, tipos y variables
--> Se puede usar el PACKAGE 'DBMS_OUTPUT' y su PROCEDURE 'PUT_LINE' en el bloque PL/SQL para mostrar la salida de la ejecución del bloque PL/SQL
--> También se puede usar el comando SET SERVEROUTPUT ON para mostrar el resultado de la ejecución del bloque PL/SQL a través de la 'Salida de Script'
--> El comando SET SERVEROUTPUT ON se ejecuta solo una vez para dejar habilitada la salida, no es necesario ejecutarlo con cada bloque PL/SQL
--> Si queremos desactivar la salida podemos ejecutar: SET SERVEROUTPUT OFF


------------------------------------------------{  BLOQUE ANÓNIMO  }----------------------------------------------------------------


--> Para recuperar datos de la BD se debe usar la sentencia SELECT y la cláusula INTO

-- Ejecutar 1 vez para activar la salida
SET SERVEROUTPUT ON

-- 1.1) Mostrar el mensaje "Hola Steven King" usando los datos del empleado 100
DECLARE
    V_NOMBRE   VARCHAR2(20);   -- Variable que almacena el primer nombre del empleado 100
    V_APELLIDO VARCHAR2(20);   -- Variable que almacena el apellido del empleado 100
BEGIN
    SELECT FIRST_NAME,             -- Consulta que retorna los datos requeridos del empleado 
           LAST_NAME
    INTO V_NOMBRE, V_APELLIDO  -- Los valores que retorna la consulta se almacenan en las variables creadas
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    DBMS_OUTPUT.PUT_LINE('Hola ' || V_NOMBRE || ' ' || V_APELLIDO); -- Salida del programa: Hola Steven King
END;

/

-- 1.2) En la sección de declaración se pueden declarar e inicializar las variables
DECLARE
    V_NOMBRE   VARCHAR2(20);
    V_APELLIDO VARCHAR2(20);
    V_ID_EMP   NUMBER(3) := 100;   -- Se declara y se inicializa la variable V_ID_EMP
BEGIN
    SELECT FIRST_NAME,
           LAST_NAME
    INTO V_NOMBRE, V_APELLIDO
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = V_ID_EMP;
    DBMS_OUTPUT.PUT_LINE('Hola ' || V_NOMBRE || ' ' || V_APELLIDO); -- Muestra: Hola Steven King
END;

/

-- 1.3) También se pueden inicializar en la sección de ejecución del bloque PL/SQL
DECLARE
    V_NOMBRE    VARCHAR2(20);
    V_APELLIDO  VARCHAR2(20);
    V_ID_EMP    NUMBER(3);     -- Declaración de la variable V_ID_EMP
BEGIN
    V_ID_EMP := 100;           -- Inicialización de la variable V_ID_EMP
    SELECT FIRST_NAME,
           LAST_NAME
    INTO V_NOMBRE, V_APELLIDO
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = V_ID_EMP;
    DBMS_OUTPUT.PUT_LINE('Hola ' || V_NOMBRE || ' ' || V_APELLIDO); -- Muestra: Hola Steven King
END;


-------------------------------------------------------{  VARIABLES  }------------------------------------------------------------


--> Existen 5 categorias de 'TIPOS DE DATOS' para declarar variables, constantes y punteros:

--     [1] Tipo de Datos Escalares : Pueden almacenar 1 solo valor (NUMBER, VARCHAR2, DATE, CHAR, BOOLEAN, etc.)
--     [2] Tipo de Datos Compuestos : Tienen elementos internos que son escalar o compuesto (Registros y Tablas PL/SQL)
--     [3] Tipo de Datos de Referencia : Almacenan "punteros" que apuntan a un lugar de almacenamiento
--     [4] Tipo de Datos LOB : Contienen "localizadores" que especifican la ubicación de los objetos grandes (BLOB, CLOB, BFILE) 
--     [5] Variables Bind : Variables de "enlace" que se declaran en el entorno del servidor y pueden ser usadas por distintos bloques PL/SQL


--> Escalar, compuesta, referencia y LOB son variables PL/SQL (Las variables Bind no son PL/SQL, no se definen en un DECLARE, debe ser fuera del bloque PL/SQL)
--> No puede existir una columna de una tabla que sea de tipo BOOLEAN, pero si puede existir una variable de tipo BOOLEAN en un bloque PL/SQL
--> Las variables BOOLEAN pueden almacenar solo 3 posibles valores: TRUE, FALSE, NULL (en un bloque condicional el NULL se interpreta como Falso)
--> Los registros (RECORD) pueden contener una fila completa de una tabla (con columnas de un mismo tipo de dato o de distintos tipos) 
--> Los BLOB se almacenan en la misma tabla, en cambio los BFILE se almacenan en directorios (DIRECTORY) fuera de la tabla (se debe indicar la ruta del directorio)
--> Los objetos DIRECTORY se deben crear como SYSTEM y se les debe otorgar un permiso de lectura (GRANT READ) para el usuario que los va a leer


--> Sintaxis para declarar variables:
Identificador [CONSTANT] tipo_de_dato [NOT NULL]  [:= | DEFAULT expr ];


--> 'expr' se refiere a cualquier expresión, ya sea un valor literal, una expresión aritmética, otra variable definida anteriormente, etc.
--> Los identificadores pueden contener letras, números, y los símbolos $, #, _ (Deben comenzar con una letra)
--> Por convención las variables comienzan con 'V_', las constantes con un 'C_', las Bind con 'B_' y registros con 'REG_' (V_PROMEDIO, C_PI, B_NOMBRE, REG_EMPLEADOS)
--> Por defecto ORACLE inicializa todas las variables en NULL (hay que tener cuidado si es una variable numérica que participa de una operación, mejor asignarle 0)
--> Las variables definidas como CONSTANT o NOT NULL siempre deben ser inicializadas (asignarles un valor inicial) 
--> Para inicializar variables se puede usar := o DEFAULT (para asignar un valor en la sección de ejecución solo se puede usar := )
--> 2 variables pueden tener el mismo nombre solo si están declaradas en bloques diferentes (solo existen en el bloque donde fueron declaradas)
--> El nombre de una variable no puede ser el mismo que el de una columna de una tabla utilizada en el bloque PL/SQL (usar 'V_' para nombrar variables)
--> Las variables se pueden usar como parámetros en subprogramas PL/SQL o almacenar el valor que devuelve una FUNCTION
--> Por convención, en el DECLARE se debe declarar 1 sola variable por cada línea
--> Inicializar en 0 las variables numéricas, si se declaran y no se inicializan, su valor inicial es NULL y un NULL en cualquiera operación dará siempre NULL


-- Ejecutar 1 vez para activar la salida
SET SERVEROUTPUT ON 

-- 1) 
DECLARE
    C_FCONVERSION CONSTANT NUMBER(3,2) := 2.54;                   -- Si es CONSTANT debe ser inicializada
    V_CM_PLG               NUMBER(3,2) NOT NULL := C_FCONVERSION; -- Al declararla NOT NULL debe ser inicializada
    V_CM_PULGADA           VARCHAR2(20) DEFAULT ' ';              -- Se puede inicializar con DEFAULT o con :=
BEGIN
    SELECT 'cm a pulgada'
    INTO V_CM_PULGADA
    FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('El factor de conversión de ' || V_CM_PULGADA || ' es ' || V_CM_PLG);
END;

/

-- 2) 
DECLARE
    V_COMM          NUMBER(3) DEFAULT 200;
    C_COMM CONSTANT NUMBER(4) := 1400; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Valor inicial de variable v_comm es : ' || V_COMM);
    DBMS_OUTPUT.PUT_LINE('Valor inicial de variable c_comm es : ' || C_COMM);
   -- A la variable V_COMM se le modifica el valor asignado inicialmente
   V_COMM := 50;
   DBMS_OUTPUT.PUT_LINE('Nuevo valor de variable v_comm es : ' || V_COMM);
END;

/ 

-- 3)
DECLARE
    V_MINOMBRE VARCHAR2(20);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Mi nombre es: ' || V_MINOMBRE); -- Como V_MINOMBRE no tiene valor asignado por defecto es NULL (no muestra nada)
    V_MINOMBRE := 'Juan';
    DBMS_OUTPUT.PUT_LINE('Mi nombre es: ' || V_MINOMBRE);
END;

/

-- 4.1) Si el bono no se inicializa en 0, al no tener asignado bono toma el valor NULL
DECLARE
    V_PORC_AUMENTO      NUMBER(2,1) := 0.2; -- Si el NUMBER guarda un valor decimal se debe especificar la escala
    V_BONO              NUMBER(10);  -- Si la variable numérica se usa para realizar calculos debemos inicializarla en 0
    V_SALARIO_AUMENTADO NUMBER(10);
    V_SALARIO_ACTUAL    EMPLOYEES.SALARY%TYPE;

BEGIN
    SELECT SALARY
    INTO V_SALARIO_ACTUAL
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    -- Cualquier operación sobre valores nulos da siempre NULL 
    V_SALARIO_AUMENTADO := V_SALARIO_ACTUAL * (1 + V_PORC_AUMENTO) + V_BONO;
    DBMS_OUTPUT.PUT_LINE('Salario Actual: ' || V_SALARIO_ACTUAL || ' dolares');
    -- Al dar NULL la operación en el resultado no se muestra nada
    DBMS_OUTPUT.PUT_LINE('Salario Aumentado: ' || V_SALARIO_AUMENTADO || ' dolares');
END;

/

-- 4.2) Al inicializar en 0 la variable V_BONO la operación matemática ya no da NULL y se muestra un resultado
DECLARE
    V_PORC_AUMENTO      NUMBER(2,1) := 0.2;
    V_BONO              NUMBER(10) := 0;    -- Variable numérica inicializada correctamente en 0
    V_SALARIO_AUMENTADO NUMBER(10);
    V_SALARIO_ACTUAL    EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT SALARY
    INTO V_SALARIO_ACTUAL
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
    V_SALARIO_AUMENTADO := V_SALARIO_ACTUAL * (1 + V_PORC_AUMENTO) + V_BONO;
    DBMS_OUTPUT.PUT_LINE('Salario Actual: ' || V_SALARIO_ACTUAL || ' dolares');
    DBMS_OUTPUT.PUT_LINE('Salario Aumentado: ' || V_SALARIO_AUMENTADO || ' dolares');
END;


--------------------------------------------------------{  VARIABLES ESCALARES  }-------------------------------------------------------------------


--              Tipo de Datos Escalares
--              -----------------------   

--       --> Caracter (VARCHAR2, CHAR,...)
--       --> Número (NUMBER, PLS_INTEGER, BINARY_INTEGER, BINARY_FLOAT, BINARY_DOUBLE,...)
--       --> Fecha (DATE, TIMESTAMP,...) 
--       --> Booleano (TRUE, FALSE, NULL)


--> Las varibles escalares solo pueden almacenar un valor, si se intenta almacenar más de un valor en una variable escalar erroja error
--> Para el tipo de dato NUMBER se aconseja especificar la precisión, de lo contrario la BD le asigna el valor máximo (38 digitos)
--> El tipo de dato CHAR si no se le especifica un largo implicitamente es un CHAR de largo 1  CHAR <=> CHAR(1)
--> Pese a que CHAR es más rápido que VARCHAR2, no se recomienda su uso ya que podría generar una serie de problemas debido a su LARGO FIJO
--> A diferencia de NUMBER, PLS_INTEGER y BINARY_INTEGER no se les especifica un largo (PLS_INTEGER es más eficiente, pero NUMBER es más universal)
--> Las fechas deben ir entre comillas simples y poseer en formato válido de dia, mes y año (se muestran con el formato configurado en la BD Oracle)


-- Ejecutar 1 vez para activar la salida
SET SERVEROUTPUT ON

-- 1) 
DECLARE
    V_RUT       VARCHAR(8) := '12345678';  -- El VARCHAR2 no tiene un largo por defecto, por eso se debe especificar algun largo
    V_DV        CHAR := 'K';               -- Si al CHAR no se le especifica un largo su largo por defecto es 1
    V_FECHA_NAC DATE := '20 Abr 1972';     -- Debe tener un formato válido de día, mes y año
    V_SOLTERO   BOOLEAN := NULL;           -- NULL se interpreta como FALSE cuando se evalua una condición
    V_EDAD      NUMBER(38) := 18 * 2;      -- El largo máximo para un NUMBER es 38 (La escala por defecto es 38 y 0 para la precisión por defecto)
    V_CONTADOR  PLS_INTEGER := 1;          -- PLS_INTEGER no se le especifica largo
    V_SUMA      BINARY_INTEGER;            -- BINARY_INTEGER no se le especifica largo
BEGIN    
    DBMS_OUTPUT.PUT_LINE('RUT: ' || V_RUT || '-' || V_DV || CHR(10));

    -- Muestra 20/04/1972 porque es el formato de fecha configurado en la BD (Herramientas >> Preferencia >> BD >> NLS)
    DBMS_OUTPUT.PUT_LINE('Fecha de Nacimiento 1: ' || V_FECHA_NAC); 

    -- Se puede formatear la salida de la fecha con TO_CHAR - DL(Fecha Larga - Date Long)
    DBMS_OUTPUT.PUT_LINE('Fecha de Nacimiento 2: ' || TO_CHAR(V_FECHA_NAC, 'DL'));  -- Jueves 20 de Abril de 1972

    -- Se puede formatear la salida de la fecha con TO_CHAR - DS(Fecha Corta - Date Short)
    DBMS_OUTPUT.PUT_LINE('Fecha de Nacimiento 3: ' || TO_CHAR(V_FECHA_NAC, 'DS'));  -- 20-04-1972
    
    -- Si las variables numéricas no se inicializan pueden provocar que un cálculo sea NULL
    V_SUMA := V_SUMA + V_CONTADOR;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'El valor de la suma es: ' || V_SUMA);
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Edad: ' || V_EDAD);

    IF V_SOLTERO THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Estado: ' || 'Forever Alone!');
    ELSE
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Estado: ' || 'Con la tóxica!');
    END IF;
END;


--------------------------------------------------------{  ATRIBUTO %TYPE  }-----------------------------------------------------------------------------


--> Sintaxis:
DECLARE
    identificador   tabla.columna%TYPE;
    Identifcador    variable%TYPE;


--> Se utiliza para declarar variables escalares "tomando el mismo tipo de dato y largo" que el de la columna de la tabla de la BD o de otra variable
--> %TYPE debe tener como 'prefijo' el nombre de la tabla.columna de la BD o el nombre de otra variable declarada
--> %TYPE permite evitar errores de ejecución ya que la variable almacenará siempre el tipo de datos y largo correcto al guardar el valor de una columna
--> Si la definición de la columna cambia, %TYPE se "adapta al cambio" y toma ese nuevo tipo de dato y largo (es otra ventaja de %TYPE)
--> Cuando se usa %TYPE es el compilador PL/SQL de la BD el que determina el tipo y tamaño de la variable (lo consulta del diccionario de datos de la BD)
--> %TYPE no hereda la CONSTRAINT 'NOT NULL' de la columna a la cual hace referencia, por lo tanto la variable si puede almacenar NULL
--> Las posibles desventajas de %TYPE son que se necesita conocer el nombre de la tabla.columna y otra es que podría provocar una perdida de rendimiento en la query
--> En grandes procesos el uso de %TYPE podría provocar tiempos de respuesta mayores (podría degradar notablemente el tiempo de respuesta de la consulta)
--> Usualmente se utiliza %TYPE para almacenar en una variable escalar el valor rescatado de una columna trás la ejecuciión de una sentencia SELECT


-- Ejecutar 1 vez para activar la salida
SET SERVEROUTPUT ON

--1)
DECLARE
    V_FNAME  EMPLOYEES.FIRST_NAME%TYPE;          -- Toma el tipo de dato y largo de la columna FIRST_NAME
    V_LNAME  V_FNAME%TYPE;                       -- Toma el tipo de dato y largo de la variable V_FNAME
    V_EMPID  EMPLOYEES.EMPLOYEE_ID%TYPE := 100;  -- Toma el tipo de dato y largo de la columna EMPLOYEE_ID
BEGIN
    SELECT FIRST_NAME, LAST_NAME
    INTO V_FNAME, V_LNAME
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = V_EMPID;
    DBMS_OUTPUT.PUT_LINE('Hola ' || V_FNAME || ' ' || V_LNAME); -- Muestra: Hola Steven King
END;


--------------------------------------------------------{  VARIABLES BIND  }-------------------------------------------------------------------


--> Sintaxis para declararla (crearla):
VAR|VARIABLE IDENTIFICADOR TIPO_DE_DATO


--> Sintaxis para asignarle valor fuera del bloque PL/SQL:
EXEC|EXECUTE :IDENTIFICADOR := VALOR;


--> Sintaxis para asignarle valor en el bloque PL/SQL:
BEGIN
    :IDENTIFICADOR := VALOR;
END;


--> Sintaxis para imprimir el valor de la variable Bind fuera del bloque PL/SQL:
PRINT IDENTIFICADR


--> Sintaxis para imprimir el valor TODAS las variable Bind:
PRINT


--> Los tipos de datos que se pueden asignar a una variable Bind son: CHAR, VARCHAR2, NUMBER (Sin precisión), BINARY_FLOAT, BINARY_DOUBLE, BLOB, CLOB y BFILE
--> Como NO se puede definir una variable Bind de tipo DATE, para trabajar con fechas es necesario usar literales de texto, como por ejemplo: '03/11/2019'
--> Las variables Bind nos ofrecen SEGURIDAD (previenen de inyecciones SQL) y RENDIMIENTO (la BD puede reutilizar el Plan de Ejecución)
--> Son variables que se crean en un entorno de host (a veces se llaman "variables Host")
--> Se crean en el ambiente donde se está trabajando (en la sesión) y no en la sección declarativa de un bloque PL/SQL (no dentro del DECLARE)
--> Las Bind pueden ser utilizadas por múltiples subprogramas, en cambio, las variables locales (del DECLARE) dejan de existir al finalizar la ejecución del bloque
--> Para imprimir el resultado de una Bind se debe utilizar el comando 'PRINT :B_NOMBRE_VARIABLE' (si se ejecuta solo PRINT muestra todas las Bind existentes)
--> Las variables Bind se referencian anteponiendo dos puntos (:) (Ej. :B_PORCENTAJE := 0.25 )
--> En SQL Dinámico las Bind se definen y usan en 'tiempo de ejecución' (esto permite evitar las inyecciones de código SQL)
--> En SQL Dinámico las Bind se definen sin la palabra VAR y tampoco se especifica el Tipo de Dato
--> Las variables Bind se pueden considerar como una especie de "variables globales" ya que la misma variable se puede usar en distintos bloques PL/SQL
--> Las variables Bind suelen ser utiles cuando se sabe que su valor lo pueden usar varios bloques PL/SQL (Valor del IVA, UF, Dollar, Carga Familiar, etc.)
--> En la realidad lo más eficiente es que esos valores como UF, IVA, etc. esten almacenados en una tabla referencial y no en variables Bind


-- Ejecutar 1 vez para activar la salida
SET SERVEROUTPUT ON

-- 1.1) NUMBER no debe especificar precisíon o escala
VAR B_RESULTADO  NUMBER    

EXEC :B_PORC_BONO := 0.25;     

DECLARE
    V_VALOR NUMBER(5) := 1500;
BEGIN
    :B_RESULTADO := V_VALOR * :B_PORC_BONO;
END;

/

PRINT B_RESULTADO

/

-- 1.2) Mostrar el valor de la variable Bind usando 'DBMS_OUTPUT.PUT_LINE'
VARIABLE B_PORC_BONO  NUMBER    
VAR      B_RESULTADO  NUMBER    

EXECUTE :B_PORC_BONO := 0.25;
EXEC    :B_PORC_BONO := 0.25;

DECLARE
    V_VALOR NUMBER(5) := 1500;
BEGIN
    :B_RESULTADO := V_VALOR * :B_PORC_BONO;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'El valor de la variable Bind es:' || :B_RESULTADO);
END; -- CHR(10) Genera un 'Salto de línea' (El caracter 10 es nueva línea en ASCII)

/

-- 2) Cuando se trabajan fechas con variables Bind se deben definir como literales de texto (VARCHAR2)
VAR B_FECHA_PROC VARCHAR2(7)
VAR B_ID_EMP     NUMBER

EXEC :B_FECHA_PROC := '01/2021'
EXEC :B_ID_EMP := 150

DECLARE
    V_SALARIO  EMPLOYEES.SALARY%TYPE;
    V_PNOMBRE  VARCHAR2(20);
    V_APELLIDO EMPLOYEES.LAST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME, LAST_NAME, SALARY
    INTO V_PNOMBRE, V_APELLIDO , V_SALARIO
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = :B_ID_EMP;
    DBMS_OUTPUT.PUT_LINE('En el proceso de remuneraciones del ' || :B_FECHA_PROC || ' el salario del empleado '
                          || V_PNOMBRE || ' ' || V_APELLIDO || ' ' || 'fue de $' || V_SALARIO || ' dolares');
END;

/

-- 3) La consulta del bloque PL/SQL puede tener JOIN, funciones de fila, de grupo, subconsultas, operadores SET, etc.
VAR B_ID_EMP NUMBER

EXEC :B_ID_EMP := 200

DECLARE
    V_NOMBRE_EMP    VARCHAR2(40);
    V_SALARIO       NUMBER(6);
    V_NOMBRE_DEPTO  VARCHAR2(30);
BEGIN
    SELECT E.FIRST_NAME || ' ' || E.LAST_NAME,
         E.SALARY,
         D.DEPARTMENT_NAME
    INTO V_NOMBRE_EMP, V_SALARIO, V_NOMBRE_DEPTO
    FROM EMPLOYEES E
    JOIN DEPARTMENTS D ON (E.DEPARTMENT_ID = D.DEPARTMENT_ID)
    WHERE EMPLOYEE_ID = :B_ID_EMP;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'LOS DATOS DEL EMPLEADO ' || :B_ID_EMP || ' SON LOS SIGUIENTES:');
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || V_NOMBRE_EMP);
    DBMS_OUTPUT.PUT_LINE('Salario: ' || V_SALARIO || ' dolares');
    DBMS_OUTPUT.PUT_LINE('Trabaja en el Depto.: ' || V_NOMBRE_DEPTO);
END;

/

-- 4)
VAR B_PORC_SALUD NUMBER
VAR B_ID_EMP     NUMBER

EXEC :B_PORC_SALUD := 0.07
EXEC :B_ID_EMP := 150

DECLARE
    V_SALARIO VARCHAR2(10);
    V_DCTO_SALUD  EMPLOYEES.SALARY%TYPE;
    V_ANNOS_TRAB  EMPLOYEES.EMPLOYEE_ID%TYPE := 0;
BEGIN
    SELECT TO_CHAR(SALARY,'FM$999G999'),
           ROUND(SALARY * :B_PORC_SALUD),
           ROUND(MONTHS_BETWEEN(SYSDATE,E.HIRE_DATE) / 12)
    INTO V_SALARIO, V_DCTO_SALUD, V_ANNOS_TRAB
    FROM EMPLOYEES E 
    WHERE EMPLOYEE_ID = :B_ID_EMP;
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'El empleado ' || :B_ID_EMP || ' lleva trabajando ' || V_ANNOS_TRAB ||
                          ' años en la empresa');
    DBMS_OUTPUT.PUT_LINE('Posee un salario de ' || V_SALARIO);
    DBMS_OUTPUT.PUT_LINE('Su descuento de salud es de ' || V_DCTO_SALUD);
END;

/

-- 5) Mostrar nombre empleado, salario, nombre depto donde trabaja, su salario aumentado en 15% y asignar un bono especial de 5 mil dolares
VAR B_PORC_AUMENTO NUMBER
VAR B_BONO         NUMBER 

EXEC :B_PORC_AUMENTO := 15
EXEC :B_BONO := 5000

DECLARE
    V_EMPLEADO VARCHAR(30);
    V_SALARIO EMPLOYEES.SALARY%TYPE;
    V_DEPTO DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    V_ID_EMP EMPLOYEES.EMPLOYEE_ID%TYPE;
    V_SALARIO_AUMENTADO NUMBER(10);
BEGIN
    SELECT E.FIRST_NAME || ' ' || E.LAST_NAME,
           E.SALARY,
           D.DEPARTMENT_NAME
    INTO V_EMPLEADO, V_SALARIO, V_DEPTO
    FROM EMPLOYEES E
    JOIN DEPARTMENTS D ON (D.DEPARTMENT_ID = E.DEPARTMENT_ID)
    WHERE E.EMPLOYEE_ID = &ID_EMPLEADO;
    V_SALARIO_AUMENTADO := V_SALARIO * (1 + :B_PORC_AUMENTO / 100) + :B_BONO;
    DBMS_OUTPUT.PUT_LINE('************************************************************');
    DBMS_OUTPUT.PUT_LINE('Empleado: ' || V_EMPLEADO);
    DBMS_OUTPUT.PUT_LINE('Salario Actual: ' || TO_CHAR(V_SALARIO, 'FM$99G999') || ' dolares');
    DBMS_OUTPUT.PUT_LINE('Departamento: ' || V_DEPTO);
    DBMS_OUTPUT.PUT_LINE('Salario Aumentado: ' || TO_CHAR(V_SALARIO_AUMENTADO, 'FM$99G999') || ' dolares');
    DBMS_OUTPUT.PUT_LINE('************************************************************');
END;


--------------------------------------------------------{  CLÁUSULA INTO  }-------------------------------------------------------------------


--> Sintaxis:
BEGIN
    SELECT col1, col2, col3, ...
        INTO V_var1, V_Var2, V_Var3, ... [REG_Nombre_Registro]
    FROM Tabla
    WHERE Condicion;
END;


--> La cláusula INTO permite almacenar en variables los valores recuperados de la BD a tráves de una sentencia SELECT en un bloque PL/SQL
--> Deben haber el mismo número de variables en la cláusula INTO que columnas en la sentencia SELECT (además el tipo de dato y largo debe ser compatible)
--> SELECT con la cláusula INTO puede recuperar solo 1 fila (una variable escalar solo puede recibir un valor, y un registro solo 1 fila de la tabla)
--> En el caso que se requiera almacenar múltiples filas que se obtengan de una sentencia SELECT se deben utilizar "cursores explicitos"
--> En la cláusula INTO también podría ir un Registro (RECORD) que almacene la 'fila completa' recuperada
--> Cuando se usa la cláusula INTO generalmente se acompaña de la cláusula WHERE para condicionar a que la consulta retorne 1 sola fila
--> Si la sentencia SELECT no retorna filas se genera el error NO_DATA_FOUND y si retorna más de una fila genera el error TOO_MANY_ROWS


-- Ejecutar 1 vez para activar la salida
SET SERVEROUTPUT ON

-- 1) Mostrar ID, nombre completo y salario del empleado 100
DECLARE
    V_ID_EMP      NUMBER(4) := 100;
    V_NOMBRE_EMP  VARCHAR2(30);
    V_SALARIO_EMP NUMBER(10);
BEGIN
    SELECT EMPLOYEE_ID,
           FIRST_NAME || ' ' || LAST_NAME,
           SALARY                                     -- 3 columnas en el SELECT
    INTO V_ID_EMP, V_NOMBRE_EMP, V_SALARIO_EMP    -- 3 Variables en el INTO
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = V_ID_EMP;  -- Se filtra con WHERE para que devuelva solo una fila por columna
    DBMS_OUTPUT.PUT_LINE('El empleado ' || V_ID_EMP || ' ' || V_NOMBRE_EMP || ' posee un salario de $'
                          || V_SALARIO_EMP || ' dolares.');
END;


---------------------------------------------------{  EXCEPCIONES PREDEFINIDAS  }-------------------------------------------------------------------


-- OTHERS : Atrapa cualquier error que se pudiese generar, atrapa cualquier error posible 

--  NO_DATA_FOUND: Una sentencia SELECT INTO no devolvió valores o el programa referenció un elemento no inicializado en una tabla indexada (ORA-100)

--  TOO_MANY_ROWS : Una sentencia SELECT INTO devuelve más de una fila (ORA-1422)

--  VALUE_ERROR : Ocurrió un error aritmético, de conversión o truncamiento, o se intento introducir un valor mayor que el soportado por la variable (ORA-6502)

--  ZERO_DIVIDE : El programa intentó efectuar una división por cero (ORA-1476)


---------------------------------------------------{  UNIDADES LÉXICAS  }-------------------------------------------------------------------


-- 1) Identificadores -> Palabras Reservadas (Keywords):  ALTER, ANY, HAVING, DROP, LENGTH, EXCEPTION, EXECUTE, ON, PROCEDURE, etc.
--                    -> Identificadores Predefinidos del Package STANDARD:   BFILE, CHAR, DATE, TABLE, TIMESTAMP, VARCHAR2, etc.
--                    -> Identificadores definidos por el Usuario:  V_SUELDO, C_FACTOR_CONVERSION, REG_CLIENTES, DV_RUN, etc.

--   2) Delimitadores -> Simples:  +, -, *, /, ; (Termino de sentencia), '' (Delimitador de caracteres), : (variable Bind), % (atributo), @ (acceso remoto), etc.
--                    -> Compuestos:  := (Asignación), || (concatenación), --, /* */, ..(Operador de Rango), !=, <>, >=, <=, => (Asociación), etc.

--       3) Literales -> De Caracter:  'Chile', 'Casa Amoblada', 'k', 'Soltero', 'IT_PROG', 'SA_REP', 'ELCONSULTAS@DUOCUC.CL', etc.  
--                    -> De Fecha:  '26/05/1999', '3 Abr 1978', '01-11-88', '23 Septiembre 2020', etc.
--                    -> Numéricos:  35800, 0.25, 19234577, 969016368, 33568.568, etc.
--                    -> Booleanos:  TRUE, FALSE, NULL

--     4) Comentarios -> De línea:  --
--                    -> Multilínea:  /* */ 


--> PL/SQL no distingue entre mayúsculas y minúsculas para los identificadores (lastname, LastName y LASTNAME son los mismos)
--> Los literales de caracter y fecha deben ir entre comillas simples (son CASE SENSITIVE: 'Ana' y 'ANA' son 2 literales distintos)
--> Es una buena practica incluir comentarios para ir explicando (documentando) lo que intenta realizar el código que se escribe (Hacerlo más legible)
--> A los operadores ya conocidos en SQL (Lógicos, Aritméticos, Comparación, Concatenación) se une el Operador PL/SQL de exponenciación **


---------------------------------------------------{  BLOQUES ANIDADOS  }-------------------------------------------------------------------


--> Las variables locales (definidas en el DECLARE) son válidas solo en los bloques donde fueron definidas
--> La sección ejecutable de un bloque PL/SQL puede contener bloques PL/SQL anidados (La sección de EXCEPTION también)
--> El "ámbito de una variable" es aquella parte del programa PL/SQL en la cual la variable es declarada y es accesible
--> La "visibilidad de la variable" es la parte del programa donde la variable puede ser accedida sin utilizar un identificador o etiqueta (calificador)
--> Las variables declaradas en un bloque principal se consideran "locales" a ese bloque y "globales" para todos sus sub-bloques
--> Las variables declaradas en un bloque externo son visibles en el bloque interno, pero las declaradas en el bloque interno no son visibles en el externo


SER SERVEROUTPUT ON

-- 1) Se pueden anidar bloques para permitir controlar las excepciones de forma independiente para cada bloque 
DECLARE
    V_NOM_EMP   EMPLOYEES.FIRST_NAME%TYPE;
    V_NOM_PAIS  VARCHAR2(30);
BEGIN
    SELECT FIRST_NAME
    INTO V_NOM_EMP
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;
        BEGIN
            SELECT COUNTRY_NAME
            INTO V_NOM_PAIS
            FROM COUNTRIES
            WHERE COUNTRY_ID = 'ZZ';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('No hay fila en tabla COUNTRIES');
        END;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay fila en tabla EMPLOYEES');
END;

/

-- 2) Un calificador es un nombre que se le da a un bloque para la visibilidad de una variable con el mismo nombre en diferentes bloques
<<BLOQUE_PADRE>>
DECLARE
    V_NOM_PADRE     VARCHAR2(20) := 'Patricio';
    V_FECHA_CUMPLE  DATE := '20-Abr-1972';
BEGIN
   DECLARE
       V_NOM_HIJO      VARCHAR2(20) := 'Miguel';
       V_FECHA_CUMPLE  DATE := '13-May-1992';
   BEGIN 
        DBMS_OUTPUT.PUT_LINE('El hijo ' || V_NOM_HIJO || ' nació el ' || V_FECHA_CUMPLE);
        DBMS_OUTPUT.PUT_LINE('El papá de ' || V_NOM_HIJO || ' se llama ' || V_NOM_PADRE);
        DBMS_OUTPUT.PUT_LINE('Don ' || V_NOM_PADRE || ' nació el ' ||BLOQUE_PADRE.V_FECHA_CUMPLE);
   END; 
END;


----------------------------------------------{  SENTENCIAS SQL EN BLOQUES PL/SQL  }-----------------------------------------------


--> PL/SQL soporta sentencias DML (SELECT, INSERT, UPDATE, DELETE, MERGE) y sentencias TCL (COMMIT, ROLLBACK, SAVEPOINT)
--> A las sentencias DML (INSERT, UPDATE, DELETE) se les debe aplicar un COMMIT para confirmar los cambios en la BD (para que se graben en disco)
--> Si no se realiza un COMMIT, la ejecución de las sentencias DML solo queda en memoria, con lo cual, los cambios no quedan permanentes (se puede hacer Rollback)
--> PL/SQL No soporta directamente el uso de sentencias DDL ni sentencias DCL, para ejecutar este tipo de sentencias se usa SQL Dinámico
--> Son sentencias DDL: CREATE, ALTER, DROP, RENAME, TRUNCATE, COMMENT y las sentencias DCL son: GRANT, REVOKE


-- Crear respaldo de la tabla EMPLOYEES
CREATE TABLE EMPLEADOS AS
SELECT * FROM EMPLOYEES;


-- 1.1) Insertar una fila a la tabla empleados (las columnas no consideradas se completan con NULL)
BEGIN
    INSERT INTO EMPLEADOS (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, HIRE_DATE, JOB_ID, SALARY)
    VALUES(EMPLOYEES_SEQ.NEXTVAL, 'Rosa', 'Espinoza','larosa', SYSDATE, 'AD_ASST', 4000);
    COMMIT;
END;

/
-- 1.2) Consultar la fila insertada
SELECT *
FROM EMPLEADOS
WHERE LAST_NAME = 'Espinoza';

/

-- 2.1) Actualizar el salario de los empleados que trabajen en 'ST_CLERK'
DECLARE					
    V_SAL_INCREMENTADO  EMPLEADOS.SALARY%TYPE := 666;   
BEGIN
    UPDATE EMPLEADOS
    SET SALARY = SALARY + V_SAL_INCREMENTADO
    WHERE JOB_ID = 'ST_CLERK';
    COMMIT;
END;

/

-- 2.2) Consultar el nuevo salario
SELECT SALARY
FROM EMPLEADOS
WHERE JOB_ID = 'ST_CLERK';

/

-- 3.1) Eliminar todos los empleados que NO posean comisión
BEGIN
    DELETE FROM EMPLEADOS
    WHERE COMMISSION_PCT IS NULL;
    COMMIT;
END;

/

-- 3.2) Consultar que no existan empleados sin comisión
SELECT EMPLOYEE_ID, COMMISSION_PCT
FROM EMPLEADOS;


---------------------------------------------------------{  CURSORES  }--------------------------------------------------------------------


--> Un Cursor es un "puntero" a la zona de memoria privada (llamada Área de Contexto) asignada por el servidor Oracle para procesar sentencias SQL
--> Un "Cursor Implícito" es creado y administrado internamente por el servidor Oracle para procesar sentencias SQL
--> Un "Cursor Explícito" es declarado explicitamente por el programador (en el DECLARE) para recuperar varias filas de una tabla de la BD
--> Se pueden usar "atributos" de cursores SQL para cursores implícitos para probar los resultados de las sentencias SQL
--> Los atributos de cursor de SQL permiten evaluar lo que sucedió cuando un "cursor implícito" se ha utilizado por última vez
--> Estos atributos se deben utilizar en el bloque de ejecución y en las sentencias PL/SQL, pero NO en las sentencias SQL
--> Los atributos de cursor SQL son utiles en sentencias UPDATE y DELETE cuando no se modifica ninguna fila ya que en estos casos no se retornan excepciones


--           ATRIBUTOS DE CURSOR SQL PARA CURSORES IMPLÍCITOS
--           ------------------------------------------------ 

-- SQL%ROWCOUNT : Retorna el NUMERO de filas afectadas por la última sentencia SQL ejecutada (devuelve un número entero)
--    SQL%FOUND : Retorna TRUE si la última sentencia SQL ejecutada retorna al menos 1 fila (sólo para sentencias DML salvo SELECT)
-- SQL%NOTFOUND : Retorna TRUE si la última sentencia SQL ejecutada NO retorna filas (sólo para sentencias DML salvo SELECT)


SET SERVEROUTPUT ON

-- 1) Cuenta las filas eliminadas por la sentencia DELETE
DECLARE
    V_FILAS_ELIM  NUMBER(4);
BEGIN
    DELETE FROM  EMPLEADOS 
    WHERE SALARY > 5000;
    V_FILAS_ELIM := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE ('Se eliminaron: ' || V_FILAS_ELIM || ' fila(s)');
    COMMIT;
END;

/

-- 2)
BEGIN
    -- Actualizar el salario de los empleados que ganen menos de mil dolares
    UPDATE EMPLEADOS
    SET SALARY = SALARY + (SALARY * NVL(COMMISSION_PCT, 0))
    WHERE SALARY < 1000;
    
    IF SQL%FOUND THEN
       DBMS_OUTPUT.PUT_LINE ('Se actualizaron ' || SQL%ROWCOUNT || ' filas');
    ELSE
       DBMS_OUTPUT.PUT_LINE('No se actualizaron filas');
    END IF;
    
    -- Eliminar los empleados que ganan menos de 3 mil dolares
    DELETE FROM EMPLEADOS
    WHERE SALARY < 3000;
    
    IF SQL%NOTFOUND THEN
       DBMS_OUTPUT.PUT_LINE('No se eliminaron filas');
    ELSE
       DBMS_OUTPUT.PUT_LINE ('Se eliminaron ' || SQL%ROWCOUNT || ' filas');
    END IF;
    
    COMMIT;
END;


---------------------------------------------------------{  ESTRUCTURAS DE CONTROL  }--------------------------------------------------------------------


--                           --> Estructuras de Selección : IF , IF/ELSE, IF/ELSIF/ELSE 

-- ESTRUCTURAS DE CONTROL:   --> CASE   -->  Expresiones CASE (CASE/END)       --> Retornan un Valor 
--                                      -->  Sentencias CASE (CASE/END CASE)

--                           --> Estructuras de Iteración: LOOP,  WHILE/LOOP,  FOR/LOOP

-- Sintaxis IF/ELSIF/ELSE:
IF condición THEN
  sentencias;
[ELSIF condición THEN 
  sentencias;]
[ELSE 
  sentencias;]
END IF;


--> En la condición del IF, cuando se realizan comparaciones que involucren valores nulos, el resultado siempre será NULL(FALSE) (IF V_VALOR > NULL THEN...)
--> Si se quiere preguntar que una variable "contenga un valor" se debe usar IS NOT NULL (IF V_BONO IS NOT NULL THEN...)
--> Si se quiere preguntar si una variable "contiene un valor nulo" se debe usar IS NULL (IF V_BONO IS NULL THEN...)


-- Sintaxis Expresión CASE:
CASE [ selector ]
   WHEN expresión1 THEN resultado1
   WHEN expresión2 THEN resultado2
   ...
   WHEN expresiónN THEN resultadoN
  [ ELSE resultadoN + 1 ]
END;


--> Las cláusulas WHEN contienen condiciones de búsqueda que devuelven un valor Booelano (TRUE o FALSE)
--> Si el valor del selector es igual al valor de la expresión de la cláusula WHEN ésta es ejecutada y el resultado correspondiente es retornado
--> Si el CASE no tiene selector funciona como un IF/ELSIF/ELSE evaluando cada condición del WHEN hasta que cae en una TRUE y ejecuta el THEN (o cae en el ELSE)
--> El valor que retorna la expresión CASE se puede almacenar en una variable (V_VALOR := CASE...) o concatenar en una expresión (V_RUN || CASE... || V_NOM)


-- Sintaxis Sentencia CASE:
CASE [ selector ]
   WHEN expresión1 THEN sentencia(s)1
   WHEN expresión2 THEN sentencia(s)2
   ...
   WHEN expresiónN THEN sentencia(s)N
   ELSE sentencia(s)
END CASE;


--> Las sentencias pueden ser un Bloque completo PL/SQL, Sentencias SELECT, INSERT, UPDATE, etc.
--> Siempre debe haber una opción de ELSE final (OBLIGATORIO) ya que si ninguna de las condiciones se cumple y no existe un ELSE final se produce un error


-- Sintáxis del LOOP:
LOOP                      
    sentencias;
EXIT [WHEN condición];
END LOOP;


--> El comando EXIT se puede utilizar para terminar loops. Un loop básico debe tener alguna condición de salida
--> El LOOP simple debe tener una condición de salida usando la cláusula EXIT (Ej: EXIT WHEN V_CONTADOR > V_VALOR; )


-- Sintaxis del WHILE LOOP:
WHILE condición LOOP
    sentencias;
END LOOP;


--> Si la variable de la condición de entrada No se inicializa, el loop no se ejecutará ni 1 sola vez
--> En el WHILE LOOP el programador solo debe administrar el valor de la variable de la condición, ya que la salida del loop se realiza automáticamente


-- Sintaxis del FOR LOOP:
FOR contador IN [REVERSE] límite_inferior .. límite_superior LOOP  
        sentencias;
END LOOP


--> El índice declarado (implícitamente) sólo se puede usar en las sentencias declaradas dentro del loop


---------------------------------------------------------{  TIPO DE DATOS COMPUESTOS  }--------------------------------------------------------------------


--> Los tipos de datos compuestos son agrupaciones de datos relacionados. Existen 2 tipos de datos compuestos:

--      [1] Registros (RECORD) : Estan compuestos por una agrupación de datos de igual o distinto tipo (como las listas en Python)

--      [2] Colecciones (VARRAY, TABLE) : Estan compuestos por una agrupación de datos "del mismo tipo" (todos NUMBER, o todos VARCHAR2, etc.)

--> Los datos compuestos tienen componentes internos o campos que pueden ser manipulados individualmente (reg_empleado.fecha_nac, reg_empleado.apaterno, etc.)
--> Cuando queremos almacenar un grupo de datos relacionados del mismo tipo usar VARRAY, y para distinto tipo usar RECORD
--> En el SELECT INTO no podemos mezclar registros con variables escalares (INTO reg_empleados, v_porc, v_comision   Incorrecto!!!)
--> Las TABLE casi no se utilizan, los más usados son los registros (RECORD)


---------------------------------------------------------{  REGISTROS  }--------------------------------------------------------------------


--> Tratan una colección de campos como 1 sola unidad lógica
--> En un registro podemos almacenar una fila completa de una tabla (%ROWTYPE) o solo un subconjunto de campos de esa fila (Definiendo sus campos explicitamente)
--> Se utilizan mucho para almacenar filas completas de tablas (o vistas, o cursores) para ser procesadas (en esos casos VARRAY no sirve)
--> En una clausula INTO podemos poner el registro para almacenar toda la fila que devuelva el SELECT pero no se puede poner un VARRAY en el INTO
--> 

































