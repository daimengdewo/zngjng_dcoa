# -*- coding: utf-8 -*-

from copy import Error
import  requests,json,time,os,sys
import datetime,MySQLdb
import MySQLdb.cursors

db = MySQLdb.connect(host='localhost', user='apitest', passwd='apitest', db='apitest',
                     cursorclass=MySQLdb.cursors.DictCursor)

token_data = {"client_id" : "3a3660ab145c499b98cbc776f461b559",
			"client_secret": '1c40b846c4584974abb590be9c6a00b0',
			"grant_type" : "client_credentials"}
# 获取token
response = requests.post('https://api2.hik-cloud.com/oauth/token', data=token_data)
res = response.json()
token = res['access_token']

form_header = {"Authorization": "Bearer {}".format(token)}

consumerId = '2d7c724cece24424bb6b982001ef5950'

#构建data
form_data = {"consumerId": "{}".format(consumerId),"autoCommit":"true"}

#关闭多余连接
s = requests.session()
s.keep_alive = False

# 获取实时事件
# try:
while True:
		response = requests.post('https://api2.hik-cloud.com/api/v1/mq/consumer/messages', data=form_data, headers=form_header)
		if response is not None:
			try:
				res = response.json()
			except:
				pass

		
		if 'code' in res:
			if res['code'] == 514004:
				#获取consumerId
				response = requests.post('https://api2.hik-cloud.com/api/v1/mq/consumer/group1', headers=form_header)
				code = response.json()
				if code is not None:
					if 'consumerId' in code['data']:
						consumerId = code['data']['consumerId']
						form_data = {"consumerId": "{}".format(consumerId),"autoCommit":"true"}
						print(form_data)

			if res['code'] == 514002:
				#获取consumerId
				response = requests.post('https://api2.hik-cloud.com/api/v1/mq/consumer/group1', headers=form_header)
				code = response.json()
				if code is not None:
					if 'consumerId' in code['data']:
						consumerId = code['data']['consumerId']
						form_data = {"consumerId": "{}".format(consumerId),"autoCommit":"true"}
						print(form_data)

		time.sleep(5)
		if 'data' in res:
			if res['data'] != [] and res['data'] != None:
				resdata = list(res['data'])

				if len(resdata) > 0 :
					for i in range(len(resdata)):
						if json.loads(resdata[i]['content'])['eventCode'] == '10114':
							content = json.loads(resdata[i]['content'])

							t = content["dateTime"]
							now_datetime_str = datetime.datetime.strptime(t,f"%Y-%m-%dT%H:%M:%S+08:00").strftime(f"%Y-%m-%d%H:%M:%S")
							now_datetime = datetime.datetime.strptime(now_datetime_str,f"%Y-%m-%d%H:%M:%S")
							new_date = datetime.datetime.strptime(t,f"%Y-%m-%dT%H:%M:%S+08:00").strftime(f"%Y-%m-%d")
							new_time = datetime.datetime.strptime(t,f"%Y-%m-%dT%H:%M:%S+08:00").strftime(f"%H:%M:%S")

							db.ping(True)
							cursor = db.cursor()
							cursor.execute("select BM,QJ from face where ID = '{}'".format(content["employeeNo"]))
							rs = cursor.fetchall()

							if rs[0]['QJ'] == '0':

								cursor.execute("select BM,QJ,QJdate1,QJdate2 from face where ID = '{}'".format(content["employeeNo"]))
								rs = cursor.fetchall()

								QJdate1 = datetime.datetime.strptime(rs[0]['QJdate1'],f"%Y-%m-%d %H:%M:%S")
								QJdate2 = datetime.datetime.strptime(rs[0]['QJdate2'],f"%Y-%m-%d %H:%M:%S")

								if now_datetime > QJdate1 and now_datetime < QJdate2 :
									db.commit()
									cursor.close()

								elif now_datetime < QJdate1:
									cursor.execute("insert into kaoqin(ID,name,date,time,BM) values('{}','{}','{}','{}','{}')".format(content["employeeNo"],content["name"],new_date,new_time,rs[0]['BM']))
									db.commit()
									cursor.close()
									
								elif now_datetime > QJdate2:
									cursor.execute(" UPDATE face SET QJ = '1' WHERE ID = '{}' ".format(content["employeeNo"]))
									cursor.execute("insert into kaoqin(ID,name,date,time,BM) values('{}','{}','{}','{}','{}')".format(content["employeeNo"],content["name"],new_date,new_time,rs[0]['BM']))
									db.commit()
									cursor.close()

							else:
								cursor.execute("insert into kaoqin(ID,name,date,time,BM) values('{}','{}','{}','{}','{}')".format(content["employeeNo"],content["name"],new_date,new_time,rs[0]['BM']))
								db.commit()
								cursor.close()

								data = {"id" : "{}".format(content["employeeNo"]),
										"name" : "{}".format(content["name"]),
										"date" : "{}".format(new_date),
										"time" : "{}".format(new_time),
										"bm" : "{}".format(rs[0]['BM'])

								}
								print(data)

# except Exception as e:
# 	print(e)
# 	python = sys.executable
# 	os.execl(python, python, * sys.argv)

