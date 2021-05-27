import pbkdf2 from "pbkdf2-sha256"


export default {
  same(key,string) {
    var parts = string.split('$');
    var iterations = parts[1];
    var salt = parts[2];
    return pbkdf2(key, new Buffer(salt), iterations, 32).toString('base64') === parts[3];
  }
}
