from nb_log import LogManager
class NbLog:
     def __init__(self):
         self.logger=LogManager('simple').get_logger_and_add_handlers(log_path="zngjng_log",log_filename="zjlog")
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
