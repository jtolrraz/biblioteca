-- Database: biblioteca

-- DROP DATABASE IF EXISTS biblioteca;

--Parte 2
--1. Crear el modelo en una base de datos llamada biblioteca, considerando las tablas definidas y sus atributos. (2 puntos).

CREATE DATABASE biblioteca
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Spain.1252'
    LC_CTYPE = 'Spanish_Spain.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- creación de tablas

CREATE TABLE socio( 
rut VARCHAR(10) , 
nombre VARCHAR(25), 
apellido VARCHAR(25), 
direccion VARCHAR(255), 
telefono VARCHAR(12),
PRIMARY KEY(rut)
);

CREATE TABLE libro(
isbn VARCHAR(20),
titulo VARCHAR(255),
paginas INT,
PRIMARY KEY(isbn)
);


CREATE TABLE prestamo(
id_prestamo SERIAL,
rut_socio VARCHAR(10),
isbn VARCHAR(20),
fecha_inicio DATE,
fecha_real_devolucion DATE,
PRIMARY KEY(id_prestamo),
FOREIGN KEY(rut_socio) REFERENCES socio(rut),
FOREIGN KEY(isbn) REFERENCES libro(isbn)
);


CREATE TABLE autor(
cod_autor SERIAL,
nombre_autor VARCHAR(50),
apellido_autor VARCHAR(50),
fecha_nacimiento INT,
fecha_muerte INT,
tipo_autor VARCHAR(10),
PRIMARY KEY(cod_autor)
);


CREATE TABLE libro_autor(
cod_autor INT,
isbn VARCHAR(20),
FOREIGN KEY(cod_autor) REFERENCES autor(cod_autor),
FOREIGN KEY(isbn) REFERENCES libro(isbn)
);

--2. Se deben insertar los registros en las tablas correspondientes (1 punto).

INSERT INTO socio (rut, nombre, apellido, direccion, telefono) VALUES ('1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1, SANTIAGO', '911111111');
INSERT INTO socio (rut, nombre, apellido, direccion, telefono) VALUES ('2222222-2', 'ANA', 'PEREZ', 'PASAJE 2, SANTIAGO', '922222222');
INSERT INTO socio (rut, nombre, apellido, direccion, telefono) VALUES ('3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2, SANTIAGO', '933333333');
INSERT INTO socio (rut, nombre, apellido, direccion, telefono) VALUES ('4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3, SANTIAGO', '944444444');
INSERT INTO socio (rut, nombre, apellido, direccion, telefono) VALUES ('5555555-5', 'SILVANA', 'MUÑOZ', 'PASAJE 3, SANTIAGO', '955555555');

INSERT INTO libro (isbn, titulo, paginas) VALUES (1111111111111,'CUENTOS DE TERROR',344);
INSERT INTO libro (isbn, titulo, paginas) VALUES (2222222222222,'POESIAS CONTEMPORA',167);
INSERT INTO libro (isbn, titulo, paginas) VALUES (3333333333333,'HISTORIA DE ASIA',511);
INSERT INTO libro (isbn, titulo, paginas) VALUES (4444444444444,'MANUAL DE MECÁNICA',298);

INSERT INTO prestamo (id_prestamo, rut_socio, isbn, fecha_inicio, fecha_real_devolucion) VALUES (1,'1111111-1',1111111111111,'20-01-2020','27-01-2020');
INSERT INTO prestamo (id_prestamo, rut_socio, isbn, fecha_inicio, fecha_real_devolucion) VALUES (2,'5555555-5',2222222222222,'20-01-2020','30-01-2020');
INSERT INTO prestamo (id_prestamo, rut_socio, isbn, fecha_inicio, fecha_real_devolucion) VALUES (3,'3333333-3',3333333333333,'22-01-2020','30-01-2020');
INSERT INTO prestamo (id_prestamo, rut_socio, isbn, fecha_inicio, fecha_real_devolucion) VALUES (4,'4444444-4',4444444444444,'23-01-2020','30-01-2020');
INSERT INTO prestamo (id_prestamo, rut_socio, isbn, fecha_inicio, fecha_real_devolucion) VALUES (5,'2222222-2',1111111111111,'27-01-2020','04-02-2020');
INSERT INTO prestamo (id_prestamo, rut_socio, isbn, fecha_inicio, fecha_real_devolucion) VALUES (6,'1111111-1',4444444444444,'31-01-2020','12-02-2020');
INSERT INTO prestamo (id_prestamo, rut_socio, isbn, fecha_inicio, fecha_real_devolucion) VALUES (7,'3333333-3',2222222222222,'31-01-2020','12-02-2020');

INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, tipo_autor, fecha_nacimiento, fecha_muerte) VALUES (3, 'JOSE', 'SALGADO', 'PRINCIPAL',1968,2020);
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, tipo_autor, fecha_nacimiento) VALUES (4, 'ANA', 'SALGADO', 'COAUTOR',1972);
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, tipo_autor, fecha_nacimiento) VALUES (1, 'ANDRES', 'ULLOA', 'PRINCIPAL',1982);
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, tipo_autor, fecha_nacimiento, fecha_muerte) VALUES (2, 'SERGIO', 'MARDONES','PRINCIPAL',1950,2012);
INSERT INTO autor (cod_autor, nombre_autor, apellido_autor, tipo_autor, fecha_nacimiento) VALUES (5, 'MARTIN', 'PORTA', 'PRINCIPAL',1976);

INSERT INTO libro_autor (cod_autor, isbn) VALUES (3,1111111111111);
INSERT INTO libro_autor (cod_autor, isbn) VALUES (4,1111111111111);
INSERT INTO libro_autor (cod_autor, isbn) VALUES (1,2222222222222);
INSERT INTO libro_autor (cod_autor, isbn) VALUES (2,3333333333333);
INSERT INTO libro_autor (cod_autor, isbn) VALUES (5,4444444444444);

--3. Realizar las siguientes consultas:

--a. Mostrar todos los libros que posean menos de 300 páginas. (0.5 puntos)
SELECT * FROM libro WHERE paginas <300;

--b. Mostrar todos los autores que hayan nacido después del 01-01-1970. (0.5 puntos)
SELECT * FROM autor WHERE fecha_nacimiento > 1970;

--c. ¿Cuál es el libro más solicitado? (0.5 puntos).
SELECT COUNT (prestamo.isbn), prestamo.isbn, libro.titulo
FROM prestamo
INNER JOIN libro ON prestamo.isbn = libro.isbn
GROUP BY prestamo.isbn, libro.titulo
ORDER BY count (*)
DESC LIMIT 1;

--d. Si se cobrara una multa de $100 por cada día de atraso, mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días. (0.5 puntos)
SELECT rut_socio, ((fecha_real_devolucion - fecha_inicio)-7)*100 AS MULTA FROM prestamo
WHERE (fecha_real_devolucion - fecha_inicio) > 7;