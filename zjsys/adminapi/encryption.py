#coding=utf-8
import base64,hashlib
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad

class encrypt(object):
    
    
    def __init__(self,text,keys='zgjgsoft20210508'):  
        self.text = text
        self.keys = keys
    
    def encryp_add(self):
        vi = '0200020100050008'
        aes = AES.new(self.keys.encode('utf-8'), AES.MODE_CBC, vi.encode('utf8'))
        pad_pkcs7 = pad(self.text.encode('utf-8'), AES.block_size, style='pkcs7')  # 选择pkcs7补全
        encrypt_aes = aes.encrypt(pad_pkcs7)
        # 加密结果
        encrypted_text = str(base64.encodebytes(encrypt_aes), encoding='utf-8')  # 解码
        encrypted_text_str = encrypted_text.replace("\n", "")
        # 此处我的输出结果老有换行符，所以用了临时方法将它剔除
        return encrypted_text_str

    # def md5_encrypt(self):
    #     # 生成MD5对象
    #     md5 = hashlib.md5(str(self.text).encode("utf-8"))
    #     # 获取密文
    #     pwd = str(md5.hexdigest())
    #     print(pwd)
    #     result =  encrypt(pwd,self.keys).encryp_add()
    #     return result

# str不是16的倍数那就补足为16的倍数
def add_to_16(value):
    while len(value) % 16 != 0:
        value += '\0'
    return str.encode(value)  # 返回bytes