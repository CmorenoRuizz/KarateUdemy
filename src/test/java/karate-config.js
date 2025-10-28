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

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token ' + accessToken})
  
  return config;
}