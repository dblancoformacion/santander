SELECT MIN(fecha),MAX(fecha) FROM lecturas_espiras;
SELECT COUNT(*) FROM lecturas_espiras;

SELECT 
    table_schema 'Database Name',
    SUM(data_length + index_length) 'Size in Bytes',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) 'Size in MiB'
FROM information_schema.tables 
GROUP BY table_schema;

SELECT espira,DATE(fecha),HOUR(fecha),AVG(intensidad)
  FROM lecturas_espiras
  GROUP BY 1,2,3;

EXPLAIN lecturas_espiras;

SELECT * FROM lecturas_espiras;


CREATE TABLE lecturas(
  id_lectura int AUTO_INCREMENT,
  espira int,
  intensidad float,
  fecha datetime,
  PRIMARY KEY(id_lectura),
  UNIQUE(espira,fecha)
  );

ALTER TABLE lecturas_espiras ADD promediado bool;

INSERT INTO lecturas (espira, fecha,intensidad)
  SELECT espira,CONCAT(DATE(fecha),' ',HOUR(fecha),':00:00') fecha,
   AVG(intensidad) intensidad  FROM lecturas_espiras
   WHERE fecha>(
      SELECT DATE(MAX(fecha)+INTERVAL 1 DAY)  FROM lecturas
    ) AND
    fecha<(
      SELECT DATE(MAX(fecha)+INTERVAL 2 DAY)  FROM lecturas
    )
   GROUP BY espira,DATE(fecha),HOUR(fecha);

SELECT espira,COUNT(*) FROM lecturas GROUP BY 1;
SELECT DISTINCT DATE(fecha) FROM lecturas;
SELECT DISTINCT fecha FROM lecturas;
SELECT MAX(fecha) FROM lecturas_espiras;
SELECT MAX(fecha) FROM lecturas;

SELECT MAX(fecha) FROM lecturas_espiras
  WHERE fecha>'2017-02-09'
  AND fecha<'2017-03-15';


SELECT DISTINCT DATE(fecha) FROM lecturas_espiras
  WHERE fecha>'2017-02-08'
  AND fecha<'2017-02-25';