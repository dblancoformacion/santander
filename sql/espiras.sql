CREATE TABLE clusters AS 
SELECT DISTINCT cluster,Latitud,Longitud FROM puntos_negros;
SELECT * FROM clusters;
ALTER TABLE clusters ADD espira int;

SELECT e.espira,cluster,POW(e.latitud-c.Latitud,2)+POW(e.longitud-c.Longitud,2) d 
  FROM TRAFICO.espiras_loc e,clusters c;

SELECT cluster,MIN(d) d FROM (
    SELECT e.espira,cluster,POW(e.latitud-c.Latitud,2)+POW(e.longitud-c.Longitud,2) d 
      FROM TRAFICO.espiras_loc e,clusters c  
  ) c1 GROUP BY 1;

SELECT cluster,espira FROM (
    SELECT e.espira,cluster,POW(e.latitud-c.Latitud,2)+POW(e.longitud-c.Longitud,2) d 
      FROM TRAFICO.espiras_loc e,clusters c  
  ) c1 JOIN (
    SELECT cluster,MIN(d) d FROM (
        SELECT e.espira,cluster,POW(e.latitud-c.Latitud,2)+POW(e.longitud-c.Longitud,2) d 
          FROM TRAFICO.espiras_loc e,clusters c  
      ) c1 GROUP BY 1  
  ) c2 USING(cluster,d);

UPDATE clusters JOIN (
    SELECT cluster,espira FROM (
        SELECT e.espira,cluster,POW(e.latitud-c.Latitud,2)+POW(e.longitud-c.Longitud,2) d 
          FROM TRAFICO.espiras_loc e,clusters c  
      ) c1 JOIN (
        SELECT cluster,MIN(d) d FROM (
            SELECT e.espira,cluster,POW(e.latitud-c.Latitud,2)+POW(e.longitud-c.Longitud,2) d 
              FROM TRAFICO.espiras_loc e,clusters c  
          ) c1 GROUP BY 1  
      ) c2 USING(cluster,d)  
  ) c3 USING(cluster) SET clusters.espira=c3.espira;

SELECT * FROM clusters;