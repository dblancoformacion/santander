SHOW TABLES;
SELECT * FROM TBL_OIPAC_GRAL_DILIGENCIAS;
SELECT LUGAR_INTERV,NUM_LUGAR_INTERV,COUNT(*) n FROM TBL_OIPAC_GRAL_DILIGENCIAS
  GROUP BY 1,2 ORDER BY n DESC;

-- 43.452618, -3.823980
SELECT * FROM TBL_OIPAC_GRAL_DILIGENCIAS WHERE LUGAR_INTERV LIKE '%marq%' AND NUM_LUGAR_INTERV=72;

SELECT GPS_X,GPS_Y FROM TBL_OIPAC_GRAL_DILIGENCIAS WHERE GPS_X>0 AND GPS_Y>0;

SELECT GPS_X/1000000-0.428 x,GPS_Y/10000000-0.4808 y
  FROM TBL_OIPAC_GRAL_DILIGENCIAS WHERE GPS_X>0 AND GPS_Y>0


  LIMIT 50;

SELECT COUNT(*) FROM (
    SELECT GPS_X/1000000-0.428 x,GPS_Y/10000000-0.4808 y
      FROM TBL_OIPAC_GRAL_DILIGENCIAS WHERE GPS_X>0 AND GPS_Y>0
  ) c1 WHERE x<.5;

-- 

SELECT NUM_ATESTADO,FECHA,LUGAR_INTERV,NUM_LUGAR_INTERV,
  ROUND((GPS_Y-4810000)/1000*0.011066788+43.431863936,6) Latitud,
  ROUND((GPS_X-430000)/1000*0.011729564-3.863990727,6) Longitud
  FROM TBL_OIPAC_GRAL_DILIGENCIAS;

SELECT * FROM coordenadas;