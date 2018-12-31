import requests
import urllib.request
import json
import mysql.connector
import untangle

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
	database=datos[3]
) 
rs=conn.cursor()

'''
rs.execute("SELECT * FROM aemet_historico;")
r=rs.fetchall()
print(r[0][1])
conn.commit()
conn.close()
input()
'''

# predicción
r = untangle.parse('http://www.aemet.es/xml/municipios/localidad_39075.xml')

print('Fecha elaboración de la predicción: ',r.root.elaborado.cdata)
#print(r.root.elaborado.prediccion.dia[0]['fecha'])

for i in r.root.prediccion.dia:
	print('--- ',i['fecha'],' ---')
	for j in i.prob_precipitacion:
		if len(j.cdata):
			#if int(j.cdata)>0:
				print(str(j['periodo'])+'h',j.cdata)


#input()

#for i in range(2010,2019):
#	for j in range(1,13):
for i in (2018,):
	for j in (11,):

		# inserción mensual
		f1=str(i)+'-'+str(j)+'-01'
		f2=str(i)+'-'+str(j)+'-31'
		estacion=1111
		url = "https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/{}T00:00:00UTC/fechafin/{}T23:59:00UTC/estacion/{}".format(f1,f2,estacion)
		querystring = {"api_key":datos[4]}
		headers = {
		    'cache-control': "no-cache",
		    }
		response = requests.request("GET", url, headers=headers, params=querystring)
		aemet = eval(response.text)
		response = urllib.request.urlopen(aemet['datos'])
		content = response.read()
		data = json.loads(content)

		for k in data:
			sql='INSERT INTO aemet_historico ('
			for l in k.keys():
				sql+=l+","
			sql+=') VALUES ('
			for l in k.values():
				l=l.replace(',','.')
				sql+="'"+l+"',"
			sql+=');'
			sql=sql.replace(",)",")")
			sql=sql.replace(",;",";")
			#print(sql)
			try:
				rs.execute(sql)
				print('ok')
			except:
				#print('error')
				print(sql)
			conn.commit()
		
		print(i,'-',j)
		
conn.close()

a=input('Pulsa enter para cerrar')