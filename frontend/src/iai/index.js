const crypto = require("crypto");

function sha256(message, secret = "", encoding) {
  const hmac = crypto.createHmac("sha256", secret);
  return hmac.update(message).digest(encoding);
}
function getHash(message, encoding = "hex") {
  const hash = crypto.createHash("sha256");
  return hash.update(message).digest(encoding);
}

function getDate(timestamp) {
  const date = new Date(timestamp * 1000);
  const year = date.getUTCFullYear();
  const month = ("0" + (date.getUTCMonth() + 1)).slice(-2);
  const day = ("0" + date.getUTCDate()).slice(-2);
  return `${year}-${month}-${day}`;
}

export default {
  getHeaders(action = "",payload="{}") {
    let now = new Date();
    let timestamp = Date.parse(now) / 1000;
    let date = getDate(timestamp);
    // 1. 拼接规范请求串
    const HTTPRequestMethod = `POST`;
    const CanonicalURI = `/`;
    const CanonicalQueryString = ``;
    const CanonicalHeaders = `content-type:application/json;charset=utf-8\nhost:iai.tencentcloudapi.com\n`;
    const SignedHeaders = `content-type;host`;
    let HashedRequestPayload;
    if(payload=="{}"){
      HashedRequestPayload = getHash("{}");
    }else{
      HashedRequestPayload = getHash(JSON.stringify(payload));
    }   
    let CanonicalRequest =
      HTTPRequestMethod +
      "\n" +
      CanonicalURI +
      "\n" +
      CanonicalQueryString +
      "\n" +
      CanonicalHeaders +
      "\n" +
      SignedHeaders +
      "\n" +
      HashedRequestPayload;

    // 2. 拼接待签名字符串
    const Algorithm = `TC3-HMAC-SHA256`;
    const RequestTimestamp = timestamp;
    const CredentialScope = `${date}/iai/tc3_request`;
    const HashedCanonicalRequest = getHash(CanonicalRequest);
    let StringToSign =
      Algorithm +
      "\n" +
      RequestTimestamp +
      "\n" +
      CredentialScope +
      "\n" +
      HashedCanonicalRequest;

    // 3. 计算签名
    const SecretKey = "Y05wXu2vZ7QUJtDJAmBMK5e1YxAB4mIa";
    const SecretDate = sha256(date, "TC3" + SecretKey);
    const SecretService = sha256(`iai`, SecretDate);
    const SecretSigning = sha256(`tc3_request`, SecretService);
    const Signature = sha256(StringToSign, SecretSigning, "hex");

    // 4. 拼接 Authorization
    const SecretId = `AKIDlKgohNp21kETTDiyznPp7B3h6HEwPdcN`;
    const Authorization =
      Algorithm +
      " " +
      "Credential=" +
      SecretId +
      "/" +
      CredentialScope +
      ", " +
      "SignedHeaders=" +
      SignedHeaders +
      ", " +
      "Signature=" +
      Signature;

    // 5.拼接headers
    const headers = {
      "X-TC-Action": action,
      "X-TC-Version": "2020-03-03",
      "X-TC-Timestamp": timestamp,
      "X-TC-Region": "ap-guangzhou",
      Authorization: Authorization
    };
    return headers;
  }
};
