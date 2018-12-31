DROP TABLE espiras_loc;
SELECT latitud FROM espiras_loc WHERE espira=1001;
SELECT * FROM espiras_loc;

TRUNCATE lecturas_espiras;
SELECT MIN(fecha),MAX(fecha),COUNT(*) FROM lecturas_espiras;
SELECT COUNT(*) FROM lecturas_espiras;

SELECT espira,MAX(intensidad) intensidad FROM lecturas_espiras GROUP BY 1;

SELECT espira,intensidad,min(fecha) ini,max(fecha) fin,COUNT(*) maximos FROM lecturas_espiras JOIN (
    SELECT espira,MAX(intensidad) intensidad FROM lecturas_espiras GROUP BY 1
  ) c1 USING(espira,intensidad) GROUP BY 1;

SELECT * FROM (
    SELECT espira,intensidad,min(fecha) ini,max(fecha) fin,COUNT(*) maximos FROM lecturas_espiras JOIN (
        SELECT espira,MAX(intensidad) intensidad FROM lecturas_espiras GROUP BY 1
      ) c1 USING(espira,intensidad) GROUP BY 1
  ) c2 JOIN espiras_loc USING(espira);

SELECT *,ROUND(siniestros/intensidad/(24*365*3)*1e6,2)
  ratio_accidentes_por_millon_vehiculos FROM POLI_ATESTADOS.clusters JOIN (
    SELECT espira,intensidad,min(fecha) traf_max_ini,
      max(fecha) traf_max_fin,COUNT(*) trf_picos FROM lecturas_espiras JOIN (
        SELECT espira,MAX(intensidad) intensidad FROM lecturas_espiras GROUP BY 1
      ) c1 USING(espira,intensidad) GROUP BY 1  
  ) c2 USING(espira) JOIN (
    SELECT cluster,COUNT(*) siniestros FROM POLI_ATESTADOS.puntos_negros GROUP BY  1  
  ) c3 USING(cluster) JOIN (
    SELECT cluster,LUGAR_INTERV FROM POLI_ATESTADOS.puntos_negros GROUP BY  1
  ) c4 USING(cluster)
  ORDER BY ratio_accidentes_por_millon_vehiculos DESC,siniestros DESC;