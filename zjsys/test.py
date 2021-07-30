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

consumerId = '5bef4093287f4c9392f865fc437003e4'

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
				# print(res)
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

			if res['code'] == 514002:
				#获取consumerId
				response = requests.post('https://api2.hik-cloud.com/api/v1/mq/consumer/group1', headers=form_header)
				code = response.json()
				if code is not None:
					if 'consumerId' in code['data']:
						consumerId = code['data']['consumerId']
						form_data = {"consumerId": "{}".format(consumerId),"autoCommit":"true"}

		time.sleep(4)
		if 'data' in res:
			if res['data'] != [] and res['data'] != None:
				resdata = list(res['data'])

				if len(resdata) > 1 :
					for i in range(len(resdata)):
						if json.loads(resdata[i]['content'])['eventCode'] == '10114':
							content = json.loads(resdata[i]['content'])
							t = content["dateTime"]
							new_date = datetime.datetime.strptime(t,f"%Y-%m-%dT%H:%M:%S+08:00").strftime(f"%Y-%m-%d")
							new_time = datetime.datetime.strptime(t,f"%Y-%m-%dT%H:%M:%S+08:00").strftime(f"%H:%M:%S")
							
							db.ping(True)
							cursor = db.cursor()
							cursor.execute("select BM from face where ID = '{}'".format(content["employeeNo"]))
							rs = cursor.fetchall()
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

