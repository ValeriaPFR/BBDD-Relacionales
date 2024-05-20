
--psql -U postgres 
-- Creo la base de datos Cine
CREATE DATABASE cine;

-- \c cine

-- Creo dos tablas para ingresar datos
CREATE TABLE peliculas
(
    peliculas_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    anio INT NOT NULL
);

--terminal (T)
cine=#
SELECT * FROM peliculas;
peliculas_id | nombre | anio
--------------+--------+------
(0 rows)


CREATE TABLE tags
(
    tag_id SERIAL PRIMARY KEY,
    tag VARCHAR(100)
);

--T
cine=# SELECT * FROM tags;

tag_id | tag
--------+-----
(0 rows)


CREATE TABLE peliculas_tags
(
    peliculas_id INT,
    tag_id INT,
    peliculas_tags_id SERIAL PRIMARY KEY,
    FOREIGN KEY (peliculas_id) REFERENCES peliculas(peliculas_id),
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id)
);
--T
cine=# SELECT * FROM peliculas_tags;
peliculas_id | tag_id | peliculas_tags_id
--------------+--------+--------------
(0 rows)

-- Inserta 5 peliculas y 5 tags.
-- Inserto datos en la primera tabla
INSERT INTO peliculas
    (nombre, anio)
VALUES
    ('La La Land', 2016),
    ('Inception', 2010),
    ('The Shawshank Redemption', 1994),
    ('Forrest Gump', 1994),
    ('The Godfather', 1972)
;
--T
cine=# SELECT * FROM peliculas;
 peliculas_id |          nombre          | anio
--------------+--------------------------+------
            1 | La La Land               | 2016
            2 | Inception                | 2010
            3 | The Shawshank Redemption | 1994
            4 | Forrest Gump             | 1994
            5 | The Godfather            | 1972
(5 rows)

-- Inserto datos en la segunda tabla
INSERT INTO tags
    (tag)
VALUES
    ('romance'),
    ('drama'),
    ('suspenso'),
    ('crimen'),
    ('clasico')
;
--T
cine=# SELECT * FROM tags;
tag_id |   tag
--------+----------
    1 | romance
    2 | drama
    3 | suspenso
    4 | crimen
    5 | clasico
(5 rows)

--La primera pelicula tiene que tener 3 tags asociados, la segunda pelicula debe tener dos tags asociados.
INSERT INTO peliculas_tags
    (peliculas_id, tag_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 4),
    (2, 5)
;

--T
cine=# SELECT * FROM peliculas_tags;
 peliculas_id | tag_id | peliculas_tags_id
--------------+--------+--------------
            1 |      1 |            1
            1 |      2 |            2
            1 |      3 |            3
            2 |      4 |            4
            2 |      5 |            5
(5 rows)

-- Cuenta la cantidad de tags que tiene cada pelicula. Si no tiene tags debe mostrar 0.
SELECT nombre AS nombre_pelicula, COALESCE(COUNT(pelicula_tags.tag_id), 0) AS cantidad_tags
FROM peliculas
    LEFT JOIN pelicula_tags ON peliculas.peliculas_id = peliculas_tags.peliculas_id
GROUP BY nombre
ORDER BY cantidad_tags DESC;

    nombre_pelicula      | cantidad_tags
--------------------------+---------------
La La Land               |             3
Inception                |             2
The Shawshank Redemption |             0
Forrest Gump             |             0
The Godfather            |             0
(5 rows)


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

-- SEGUNDA PARTE
-- psql -U postgres 
-- Creo otra base de datos, encuestas
CREATE DATABASE encuestas;

-- \c encuestas

-- Creo 3 tablas: preguntas, usuarios y respuestas.
CREATE TABLE preguntas
(
    preguntas_id SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR
);

CREATE TABLE usuarios
(
    usuarios_id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    edad INT
);


CREATE TABLE respuestas
(
    respuestas_id SERIAL PRIMARY KEY,
    respuesta VARCHAR(255),
    usuarios_id INT,
    preguntas_id INT,
    FOREIGN KEY (usuarios_id) REFERENCES usuarios(usuarios_id) ON DELETE CASCADE,
    FOREIGN KEY (preguntas_id) REFERENCES preguntas(preguntas_id)
);
--T
encuestas=# SELECT * FROM respuestas;
respuestas_id | respuesta | usuarios_id | preguntas_id
-----------------------+-----------+-------------+--------------
(0 rows)

-- Agrega 5 registros a la tabla preguntas, de los cuales:
-- a. La primera pregunta debe ser contestada correctamente por dos usuarios distintos
-- b. La pregunta 2 debe ser contestada correctamente por un usuario.
-- c. Los otros dos registros deben ser respuestas incorrectas.

INSERT INTO preguntas
    (pregunta, respuesta_correcta)
VALUES
    ('¿Cual es la capital de Australia?', 'Canberra'),
    ('¿Pluton es un planeta?', 'No'),
    ('¿Quien pinto la famosa obra La noche estrellada?', 'Vincent van Gogh'),
    ('¿Cual es el rio mas largo del mundo?', 'El rio Amazonas'),
    ('¿Quien escribio El principito?', 'Antoine de Saint-Exupery')
;
--T
encuestas=# SELECT * FROM preguntas;
 preguntas_id |                     pregunta                     |    respuesta_correcta
--------------+--------------------------------------------------+--------------------------
            1 | ¿Cual es la capital de Australia?                | Canberra
            2 | ¿Pluton es un planeta?                           | No
            3 | ¿Quien pinto la famosa obra La noche estrellada? | Vincent van Gogh
            4 | ¿Cual es el rio mas largo del mundo?             | El rio Amazonas
            5 | ¿Quien escribio El principito?                   | Antoine de Saint-Exupery
(5 rows)

-- Inserto datos en la tabla usuarios
INSERT INTO usuarios
    (nombre, edad)
VALUES
    ('Jose', 23),
    ('Rosa', 16),
    ('Maria', 19),
    ('Fernanda', 27),
    ('Juan', 21)
;

--T
encuestas=# SELECT * FROM usuarios;
 usuarios_id |  nombre  | edad
-------------+----------+------
    1       | Jose     |   23
    2       | Rosa     |   16
    3       | Maria    |   19
    4       | Fernanda |   27
    5       | Juan     |   21
(5 rows)


-- Inserto datos a la tabla respuestas
INSERT INTO respuestas
    (respuesta, usuarios_id, preguntas_id)
VALUES
    ('Canberra', 1, 1),
    ('Canberra', 2, 1),
    ('No', 3, 2),
    ('Rio Cachapoal', 4, 4),
    ('El perro Chocolo', 5, 3)
;

--T
encuestas=# SELECT * FROM respuestas;
respuestas_id_id|    respuesta     | usuarios_id | preguntas_id
---------------+------------------+-------------+--------------
        1       | Canberra         |           1 |            1
        2       | Canberra         |           2 |            1
        3       | No               |           3 |            2
        4       | Rio Cachapoal    |           4 |            4 --respuestas erroneas.
        5       | El perro Chocolo |           5 |            3 --respuestas erroneas.
(5 rows)

-- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta)
SELECT nombre, COUNT(respuestas.respuestas_id) AS respuestas_correctas_totales
FROM usuarios
    LEFT JOIN respuestas ON usuarios.usuarios_id = respuestas.usuarios_id
    LEFT JOIN preguntas ON respuestas.preguntas_id = preguntas.preguntas_id
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY usuarios.usuarios_id, usuarios.nombre
;

nombre | respuestas_correctas_totales
-------+------------------------------
Jose   |                            1
Rosa   |                            1
Maria  |                            1
(3 rows)

-- Por cada pregunta, en la tabla preguntas, cuenta cuantos usuarios tuvieron la respuesta correcta
SELECT 
    preguntas.preguntas_id,
    preguntas.pregunta,
    preguntas.respuesta_correcta,
    COALESCE(respuestas_conteo_tabla.respuestas_conteo, 0) AS usuarios_con_respuesta_correcta
FROM preguntas
LEFT JOIN LATERAL (
    SELECT COUNT(usuarios_id) AS respuestas_conteo
    FROM respuestas
    WHERE respuestas.preguntas_id = preguntas.preguntas_id
    AND respuesta = preguntas.respuesta_correcta
) AS respuestas_conteo_tabla ON true; --Para asegurar que el LEFT JOIN se realice para todas las filas de la tabla preguntas, incluso si no hay coincidencias en la subconsulta.


 preguntas_id |                     pregunta                     |    respuesta_correcta    | usuarios_con_respuesta_correcta
--------------+--------------------------------------------------+--------------------------+---------------------------------
            1 | ¿Cual es la capital de Australia?                | Canberra                 |                               2
            2 | ¿Pluton es un planeta?                           | No                       |                               1 
            3 | ¿Quien pinto la famosa obra La noche estrellada? | Vincent van Gogh         |                               0
            4 | ¿Cual es el rio mas largo del mundo?             | El rio Amazonas          |                               0
            5 | ¿Quien escribio El principito?                   | Antoine de Saint-Exupery |                               0
(5 rows)

-- Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementacion

ALTER TABLE respuestas -- Modificar la tabla "respuestas".
DROP CONSTRAINT IF EXISTS respuestas_usuarios_id_fkey, -- Eliminar la restriccion "respuestas_usuarios_id_fkey" si existe.
ADD CONSTRAINT respuestas_usuarios_id_fkey -- Agregar una nueva restriccion llamada "respuestas_usuarios_id_fkey".
    FOREIGN KEY (usuarios_id) -- La clave externa en la tabla "respuestas" es la columna "usuarios_id".
    REFERENCES usuarios (usuarios_id) -- La clave externa hace referencia a la tabla "usuarios" y su columna "usuarios_id".
    ON DELETE CASCADE -- Si se borra un registro de la tabla "usuarios", tambien los registros relacionados en la tabla "respuestas". 
; 

-- Probamos la nueva restriccion agregada.
DELETE FROM usuarios WHERE usuarios_id = 1;

--T 
encuestas=# SELECT * FROM usuarios;
 usuarios_id |  nombre  | edad
-------------+----------+------
        2    | Rosa     |   16 -- Eliminado usuarios_id= 1
        3    | Maria    |   19
        4    | Fernanda |   27
        5    | Juan     |   21
(4 rows)

-- Crea una restriccion que impida insertar usuarios menores de 18 anios en la base de datos.
ALTER TABLE usuarios ADD CONSTRAINT check_edad_minima CHECK (edad >= 18);
--ERROR:  check constraint "check_edad_minima" of relation "usuarios" is violated by some row

--T 
encuestas=# SELECT * FROM usuarios WHERE edad <= 18; 
 usuarios_id | nombre | edad
-------------+--------+------
        2    | Rosa   |   16
(1 row)

-----------------------------------------------------------------------------------------
    --EXTRA: eliminar los usuarios que no cumplen la restricción de
-----------------------------------------------------------------------------------------

DELETE FROM usuarios WHERE edad < 18 -- Eliminar usuarios con edad < 18. 
ALTER TABLE usuarios 
DROP CONSTRAINT IF EXISTS check_edad_minima -- Eliminar la restriccion si existe. 
ALTER TABLE usuarios
ADD CONSTRAINT check_edad_minima CHECK (edad >= 18);-- Agregar la restriccion de nuevo

-----------------------------------------------------------------------------------------
    --EXTRA: eliminar los usuarios que no cumplen la restriccion de edad.
-----------------------------------------------------------------------------------------

-- Altera la tabla existente de usuarios agregando el campo email con la restriccion de unico.
ALTER TABLE usuarios
ADD COLUMN email VARCHAR(100) UNIQUE;

--T
encuestas=# SELECT * FROM usuarios;
usuarios_id |  nombre  | edad | email
-------------+----------+------+-------
        2    | Rosa     |   16 |
        3    | Maria    |   19 |
        4    | Fernanda |   27 |
        5    | Juan     |   21 |
(4 rows)
