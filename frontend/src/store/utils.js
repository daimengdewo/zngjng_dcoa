export default {
  urlToBase64(url, callback) {
    var Img = new Image(),
      dataURL = '';
    Img.src = url;
    Img.setAttribute('crossOrigin', 'Anonymous');
    Img.onload = function () {
      var canvas = document.createElement('canvas'),
        width = Img.width,
        height = Img.height;
      canvas.width = width;
      canvas.height = height;
      canvas.getContext('2d').drawImage(Img, 0, 0, width, height);
      dataURL = canvas.toDataURL('image/jpeg');
      return callback ? callback(dataURL) : null;
    };
  }
};
