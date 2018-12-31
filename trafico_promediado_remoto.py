import mysql.connector
import time

def get_datos():
	fid=open('datos.txt','r')
	datos=fid.readlines()
	for i in range(len(datos)):
		datos[i]=datos[i].replace("\n",'')
		#print(datos[i])
	fid.close()
	return datos

datos=get_datos()

conn = mysql.connector.connect(
	host=datos[0],
	user=datos[1],
	password=datos[2],
	#database=datos[3],
	database='TRAFICO'
) 
rs=conn.cursor()

sql="""
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
"""

for i in range(9):
	rs.execute(sql)
	print(i,time.asctime( time.localtime(time.time()) ))
	conn.commit()

conn.close()
a=input('Pulsa enter para cerrar')