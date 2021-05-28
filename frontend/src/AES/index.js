import CryptoJS from "crypto-js";

export default {
  // 加密
  encrypt(word, keyStr, ivStr) {
    keyStr = keyStr ? keyStr : "zgjgsoft20210508";
    ivStr = ivStr ? ivStr : "0200020100050008";
    let key = CryptoJS.enc.Utf8.parse(keyStr);
    let iv = CryptoJS.enc.Utf8.parse(ivStr);
    let srcs = CryptoJS.enc.Utf8.parse(word);

    let encrypted = CryptoJS.AES.encrypt(srcs, key, {
      iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.Pkcs7
    });
    return encrypted.toString();
  },

  // 解密
  decrypt(word, keyStr, ivStr) {
    keyStr = keyStr ? keyStr : "zgjgsoft20210508";
    ivStr = ivStr ? ivStr : "0200020100050008";
    var key = CryptoJS.enc.Utf8.parse(keyStr);
    let iv = CryptoJS.enc.Utf8.parse(ivStr);

    var decrypt = CryptoJS.AES.decrypt(word, key, {
      iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.Pkcs7
    });
    return CryptoJS.enc.Utf8.stringify(decrypt).toString();
  }
};
