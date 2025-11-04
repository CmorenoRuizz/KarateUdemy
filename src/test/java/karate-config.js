function fn() {

  karate.configure('ssl', true); //<-- para solicitud ssl

  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {    
    apiUrl: 'https://conduit-api.bondaracademy.com/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'zanahorio@karate.com'
    config.userPassword = 'vf3hUL@fMpL6U3N'
  } if (env == 'qa') {
    config.userEmail = 'zanahorioqa@karate.com'
    config.userPassword = 'contraseñaqa'
  }

  // Llama al feature 'CreateToken.feature' UNA SOLA VEZ al inicio de la ejecución.
  // Le pasa el objeto 'config' (que contiene email/password según el entorno) como argumento.
  // Ejecuta el 'Scenario' dentro de CreateToken.feature.
  // Guarda el valor de la variable 'authToken' (definida en CreateToken.feature) en la variable 'accessToken' de este archivo.
  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken

  // Configura las cabeceras HTTP que se enviarán AUTOMÁTICAMENTE en TODAS las peticiones
  // realizadas por Karate a partir de este punto.
  // En este caso, establece la cabecera 'Authorization' con el valor 'Token ' seguido del token obtenido en la línea anterior.
  karate.configure('headers', {Authorization: 'Token ' + accessToken})
  
  return config;
}