import  requests,pprint

# 构建添加 客户信息的 消息体，是json格式
payload = {
	"username": "admin",
	"password": "admin"
}

# 发送请求给web服务
response = requests.post('http://127.0.0.1:8000/getlog')

pprint.pprint(response)

