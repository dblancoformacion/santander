SELECT MIN(fecha),MAX(fecha) FROM lecturas_espiras;
SELECT MIN(fecha),MAX(fecha) FROM lecturas;
SELECT DISTINCT DATE(fecha) FROM lecturas;
SELECT DISTINCT fecha FROM lecturas;
-- comprobación de horas por fecha
SELECT DATE(fecha),COUNT(*) FROM (
    SELECT DISTINCT fecha FROM lecturas WHERE fecha>'2016-01-19 23:00'
  ) c1 GROUP BY 1;-- HAVING COUNT(*)<24;
SELECT * FROM lecturas_espiras;

SELECT * FROM lecturas_espiras WHERE DATE(fecha)='2016-02-24';

SELECT MAX(fecha) FROM lecturas_espiras;
SELECT * FROM lecturas_espiras WHERE fecha=(
    SELECT MAX(fecha) FROM lecturas_espiras
  ) 
  AND espira=1040
  ORDER BY id_lectura DESC;