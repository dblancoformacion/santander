# hacer instrucción que elimine datos del día siguiente en cada fichero
# calcular horas por día o algo así para encontrar el día a eliminar

import mysql.connector

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

import glob
csvs=glob.glob('datos/trafico_2016/*.csv')

'''
CREATE TABLE lecturas(
  id_lectura int AUTO_INCREMENT,
  espira int,
  intensidad float,
  fecha datetime,
  PRIMARY KEY(id_lectura),
  UNIQUE(espira,fecha)
  );
'''

for j in csvs:
	fid=open(j,'r')
	dato=fid.readline()
	sql0="INSERT INTO lecturas_espiras (id_lectura,espira, intensidad, ocupacion, fecha) VALUES"
	sql=""
	i=0
	rs.execute("TRUNCATE lecturas_espiras")
	while dato:
		i+=1
		dato=fid.readline()
		if not dato: break
		dato=dato.replace('\n','')
		d=dato.split(',')
		sql+=",('{}','{}','{}','{}','{}')".format(
			d[0],d[1],d[2],d[3],d[4]
			)
		#print(d[0],' ',d[1],' ',d[4])
		#print('.',end='')
		if i>1000:
			print(d[4])
			sql=sql0+sql+';'
			sql=sql.replace('VALUES,','VALUES ')
			#print(sql)
			rs.execute(sql)
			'''
			try:
				rs.execute(sql)
			except:
				print(d[4],end='')
			'''
			conn.commit()
			sql=""
			i=1
	fid.close()
	sql="""
		INSERT INTO lecturas (espira, fecha,intensidad)
		  SELECT espira,CONCAT(DATE(fecha),' ',HOUR(fecha),':00:00') fecha,
		   ROUND(AVG(intensidad)) intensidad  FROM lecturas_espiras
		   GROUP BY espira,DATE(fecha),HOUR(fecha);	
	"""
	rs.execute(sql)
	conn.commit()
conn.close()
a=input('Pulsa enter para cerrar')