TRUNCATE lecturas_espiras;
SELECT COUNT(*) FROM lecturas_espiras;
SELECT MIN(fecha),MAX(fecha) FROM lecturas_espiras;
SELECT * FROM lecturas_espiras;
SELECT MAX(id_lectura) id_lectura,espira,MAX(intensidad) intensidad,MAX(ocupacion) ocupacion,fecha FROM lecturas_espiras GROUP BY espira,fecha;

