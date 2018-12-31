DROP TABLE distancias;
CREATE TABLE distancias(
  id_distancia int AUTO_INCREMENT,
  at_a int,
  at_b int,
  distancia int,
  n_at int,
  cluster int,
  PRIMARY KEY(id_distancia),
  INDEX(distancia)
  );

INSERT INTO distancias (at_a, at_b, distancia)
  SELECT * FROM (
      SELECT NUM_ATESTADO,n_at,
        ROUND(SQRT(POW(Latitud-lat,2)+POW((Longitud-lon)*COS(lat),2))*111000) distancia
        FROM coord,(
          SELECT NUM_ATESTADO n_at,Latitud lat,Longitud lon FROM coord
        ) c1
    ) c2 WHERE distancia>0 AND distancia<20;

-- (no forma parte del procesado) comprobación de cercanía
SELECT coordenadas.LUGAR_INTERV at_a,coord.LUGAR_INTERV at_b,distancia FROM distancias
  JOIN coordenadas ON at_a=coordenadas.NUM_ATESTADO
  JOIN coord ON at_b=coord.NUM_ATESTADO
  ORDER BY distancia DESC;

-- anota el número de vecinos por atestado
UPDATE distancias JOIN (
    SELECT at_a,COUNT(*) n FROM distancias GROUP BY at_a
  ) c1 USING(at_a) set n_at=n;

-- elimina los que tienen menos de tres vecinos
DELETE FROM distancias WHERE n_at<3;

-- identifica los diferentes clusters (falla, hacer procedimiento almacenado con cursor)
UPDATE distancias JOIN (
  SELECT DISTINCT at_a atestado FROM distancias ORDER BY n_at
  ) c1 ON atestado=at_a
  SET cluster=atestado;

-- llama al procedimiento que clusteriza
CALL clusterizador();

-- comprueba la lista obtenida
SELECT * FROM (
    SELECT cluster,COUNT(*) n
      FROM distancias GROUP BY 1 HAVING n>100
  ) c1 JOIN coordenadas ON cluster=NUM_ATESTADO
  ORDER BY n DESC;