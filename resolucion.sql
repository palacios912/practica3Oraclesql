--En la Tabla Libro agregar dos columnas: Fecha_Alta cuyo valor predeterminado sea ‘01/04/2010
--punto 2

alter table LIBRO add (fecha_alta2 date default TO_DATE('01/04/2010','DD/MM/YYYY'));
alter table libro add (cantidad number(4));

--punto 3 identificar codigo repetido para eliminar registro en funcion del codigo
select * from carrera where NOMBRE = 'INGENIERIA QUIMICA';
DELETE FROM carrera WHERE ID = 6;

--punto 4 Eliminar de la tabla de materias la que lleva como nombre ‘INGLES III’ por no existir.
select * from materia;
DELETE FROM materia WHERE ID = 18;

--punto 5 La carrera ingeniería Civil lleva por error el nombre de ingeniería CIVICA, realizar el cambio de nombre
select * from carrera;
update carrera set NOMBRE = 'INGENIERIA CIVIL' where ID = 4;

--punto 6 Indicar cuántos alumnos hay inscriptos en cada uno de los cursos activos
select count(*) from matricula;

select * from matricula;

select curso, count(*) as cantidad from matricula group by curso order by curso asc;

select * from matricula
where curso = 11;

--punto 7
select a.legajo, a.apellido, c.nombre  from alumno a, carrera c
where a.carrera = c.id;

--punto 8

select nombre , carrera from alumno 
where carrera = null;

--punto 9 Listar los nombres de las materias que no tienen alumnos inscriptos.
select m.id,m.nombre from materia m
left join curso c on m.id = c.materia
left join matricula ml on ml.curso = c.id
where ml.curso is null
order by m.id;

--punto 10 Armar un listado de cada curso mostrando el nombre de la materia y los alumnos con su apellido, nombre, legajo,
--y condición ante la materia: P – ‘PROMOCIONADO’, R – ‘REGULAR’, L – ‘LIBRE’, A – ‘ABANDONO’
select al.apellido,al.nombre,al.legajo ,mt.nombre as materia, 
case ml.promociona 
when 'P' then 'promocionado'
when 'R' then 'regular'
when 'L' then 'libre'
when 'A' then 'abandono'
else ml.promociona
end
promocion from alumno al
left join matricula ml on al.legajo = ml.alumno
left join curso c on ml.curso = c.id
left join materia mt on mt.id = c.materia;


--11. No debe existir ningún libro cuyo precio supere los $13500. Controlarlos y si es necesario modificar esos registros.
update libro
set precio = case
    when precio > 13500 then 13500
    else precio
end;

--12 
update libro set precio = precio + 1000;

update libro 
set precio = precio +1200
where precio < (select avg(precio) from libro);

--13 armar listado de docentes indicando antiguedad
select apellido,nombre, floor((sysdate -(fecha_alta))/365) as antiguedad from profesor;

--14 lista de cada docente la cantidad de cursos que esta dictando 

select  pr.nombre , count(c.id) as cursos , c.profesor from profesor pr
left join curso c on pr.id = c.profesor
group by pr.nombre,c.profesor;

--15 Listar los nombres de todos los profesores de cada curso, indicando el cargo que cada uno ejerce allí ordenado por
--curso y dentro de cada curso por profesor.

select curso.id, materia.nombre, profesor.nombre,profesor.id as codigoProfe,categoria.descripcion from curso 
left join materia on materia.id = curso.materia
left join cat_doc on curso.id = cat_doc.curso
left join profesor on profesor.id = cat_doc.docente
left join categoria on categoria.codigo = cat_doc.categoria
order by curso.id,profesor.nombre;

-- 16 Armar un listado de profesores en los que figuren los sueldos de cada docente existente, ordenados por
--Apellido. Tener en cuenta que el sueldo estará dado por el básico de cada categoría y la cantidad de
--cargos que cada profesor tenga asignados en la actualidad

select profesor.nombre,profesor.id, sum(categoria.sueldo) from cat_doc
left join profesor on profesor.id = cat_doc.docente
left join categoria  on categoria.codigo = cat_doc.categoria
group by profesor.nombre, profesor.id
