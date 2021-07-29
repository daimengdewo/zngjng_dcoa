from django.http import JsonResponse
import requests,json
from rest_framework.decorators import api_view

# Create your views here.
@api_view(['POST'])
def newface(request):

        data = json.loads(request.body)  
        face = data['face']
        id = data['id']
        name = data['name']

        token_data = {"client_id" : "3a3660ab145c499b98cbc776f461b559",
                                "client_secret": '1c40b846c4584974abb590be9c6a00b0',
                                "grant_type" : "client_credentials"}
        # 获取token
        response = requests.post('https://api2.hik-cloud.com/oauth/token', data=token_data)
        res = response.json()
        token = res['access_token']
        #构建header
        form_header = {"Authorization": "Bearer {}".format(token),"Content-Type": "application/json"}
        #构建data
        form_data = {"employeeNo": "{}".format(id), 
                        "personName": "{}".format(name),
                        "validBeginTime": "2020-01-11T00:00:59+08:00",
                        "validEndTime": "2030-12-30T00:00:59+08:00",
                        "faceImageBase64": "{}".format(face)}

        #新增人员
        requests.post('https://api2.hik-cloud.com/api/v1/open/basic/persons/create', data=json.dumps(form_data),headers=form_header)
        #根据实际情况修改groupid
        groupid = 'ee8aa742c1ab41738d0fef2e45d0a48f'
        group_data = {
                "groupId": "{}".format(groupid), 
                "employeeNos": ["{}".format(id)]}
        #人员绑定权限组
        requests.post('https://api2.hik-cloud.com/api/v1/open/accessControl/permissionGroups/actions/addPersons', data=json.dumps(group_data),headers=form_header)
        data = {"groupId": "{}".format(groupid)}
        #人员下发
        index = requests.post('https://api2.hik-cloud.com/api/v1/open/accessControl/allots/actions/issuedByGroup', data=json.dumps(data),headers=form_header)
        return JsonResponse(index.json())


@api_view(['POST'])
def delface(request):
        data = json.loads(request.body)  
        id = data['id']

        token_data = {"client_id" : "3a3660ab145c499b98cbc776f461b559",
                                "client_secret": '1c40b846c4584974abb590be9c6a00b0',
                                "grant_type" : "client_credentials"}
        # 获取token
        response = requests.post('https://api2.hik-cloud.com/oauth/token', data=token_data)
        res = response.json()
        token = res['access_token']
        #构建header
        form_header = {"Authorization": "Bearer {}".format(token)}

        index = requests.post('https://api2.hik-cloud.com/api/v1/open/basic/persons/delete?employeeNo={}'.format(id),headers=form_header)
        return JsonResponse(index.json())