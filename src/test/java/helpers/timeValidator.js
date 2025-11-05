//Extraido de "https://github.com/karatelabs/karate/blob/master/karate-core/src/test/java/com/intuit/karate/core/schema-like-time-validator.js"
//Cambiado simpledateformat para que coincida con la respuesta de la API

function fn(s) {
  var SimpleDateFormat = Java.type("java.text.SimpleDateFormat");
  var sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.ms'Z'");
  try {
    sdf.parse(s).time;
    return true;
  } catch(e) {
    karate.log('*** invalid date string:', s);
    return false;
  }
}