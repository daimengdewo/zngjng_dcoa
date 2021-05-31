from django.http.response import JsonResponse
from nb_log import LogManager
class NbLog:
    def __init__(self):
        self.logger=LogManager('logs').get_logger_and_add_handlers(
            log_path="zngjng_log",log_filename="zjlog",
            mongo_url='127.0.0.1'
        )
        #self.logger=LogManager('simple').get_logger_and_add_handlers(log_path="zngjng_log",log_filename="zjlog")
    def error(self,msg):
        return self.logger.error(msg)
    def debug(self,msg):
        return self.logger.debug(msg)
    def info(self,msg):
        return self.logger.info(msg)
    def warning(self,msg):
        return self.logger.warning(msg)
    def exception(self,msg,exc_info=True):
        return self.logger.exception(msg,exc_info)

from rest_framework.decorators import api_view
import pymongo



dolog = NbLog() 

@api_view(['GET'])
def get_logs(request):
    try:
        if request.user.is_authenticated: 
            if request.user.is_superuser:
                client = pymongo.MongoClient(host='127.0.0.1', port=27017)
                db = client['logs']['logs']
                res = db.find({},{"_id":0}).sort("time",pymongo.DESCENDING).limit(5)
                data_array = []
                for data in res:
                    data_array.append(data)
                return JsonResponse({'ret':0,'data':data_array})
    except Exception as e:
        msg = dolog.error("该路由发生异常:{}".format(e))  
        return JsonResponse({'ret': 9 , 'msg':msg}) 
