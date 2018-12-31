import mysql.connector
import numpy as np
import matplotlib.pyplot as plt


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
	database='POLI_ATESTADOS'
) 
rs=conn.cursor()

sql="""
		SELECT * FROM (
		    SELECT GPS_X/1000-428 x,GPS_Y/1000-4808 y
		      FROM TBL_OIPAC_GRAL_DILIGENCIAS WHERE GPS_X>0 AND GPS_Y>0
		  ) c1 WHERE x<15 and x>0 and y>0 and y<7
		 -- LIMIT 50;
"""

sql="""
		SELECT * FROM (
		    SELECT (GPS_X-430000)/1000 x,(GPS_Y-4810000)/1000 y
		      FROM TBL_OIPAC_GRAL_DILIGENCIAS WHERE GPS_X>0 AND GPS_Y>0
		  ) c1 WHERE x>0 and x<8 and y>0  and y<5
		 -- LIMIT 50;
"""

rs.execute(sql)
r=rs.fetchall()
conn.close()

# Fixing random state for reproducibility

x=[]
y=[]

for i in r:
	x.append(float(i[0]))
	y.append(float(i[1]))

x=tuple(x)
y=tuple(y)

xmin = min(x)
xmax = max(x)
ymin = min(y)
ymax = max(y)


'''
fig, axs = plt.subplots(ncols=2, sharey=True, figsize=(7, 4))
fig.subplots_adjust(hspace=0.5, left=0.07, right=0.93)

ax = axs[0]
hb = ax.hexbin(x, y, gridsize=50, cmap='inferno')
ax.axis([xmin, xmax, ymin, ymax])
ax.set_title("Hexagon binning")
cb = fig.colorbar(hb, ax=ax)
cb.set_label('counts')

ax = axs[1]
'''

fig, ax = plt.subplots()

hb = ax.hexbin(x, y, gridsize=300, bins='log', cmap='inferno')
ax.axis([xmin, xmax, ymin, ymax])
ax.set_title("Mapa de calor de atestados de la ciudad de Santander")
cb = fig.colorbar(hb, ax=ax)
cb.set_label('log10(N)')

plt.show()