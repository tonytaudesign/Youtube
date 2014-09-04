angular.module('angular', ['ngRoute', 'angular-main', 'templates']).config(function($routeProvider) {
  return $routeProvider.otherwise({
    redirectTo: '/'
  });
});

'app controller goes here';


'common service goes here';


angular.module('angular-main', ['ngRoute', 'ui.bootstrap', 'firebase']).value('railsServer', 'http://1de64313.ngrok.com').config(function($httpProvider) {
  return $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
}).config(function($routeProvider) {
  return $routeProvider.when('/', {
    templateUrl: 'main/home.html',
    controller: 'HomeCtrl'
  }).when('/responses', {
    templateUrl: 'main/main.html',
    controller: 'MainCtrl',
    controllerAs: 'Main'
  }).when('/messages', {
    templateUrl: 'main/messages.html',
    controller: 'MessagesCtrl',
    controllerAs: 'Messages'
  }).when('/uploads', {
    templateUrl: 'main/uploads.html',
    controller: 'UploadsCtrl',
    controllerAs: 'Uploads'
  });
}).controller('HomeCtrl', function($scope, $http, $firebase) {}).controller('MessagesCtrl', function($scope, $http, $firebase, railsServer) {
  var Messages, admin, ref, saveToDatabase, sync, user;
  admin = {
    email: 'TONYTAUDESIGN@gmail.com'
  };
  user = {
    name: "Matt",
    email: 'mattcowski@gmail.com'
  };
  this.resetEmail = {
    to: user.email,
    subject: 'Reset your password',
    body: 'heres ur pass reset link',
    template: 'reset pass'
  };
  this.uploadNotificationEmail = {
    to: admin.email,
    subject: user.name + " uploaded a file",
    body: user.name + " uploaded a file",
    template: 'notification'
  };
  this.contactUsEmail = {
    to: admin.email,
    subject: 'new contact form submission',
    body: "users: ",
    template: 'contact'
  };
  this.register = function() {
    var notifyNewUserEmail, welcomeEmail;
    this.sendEmail(welcomeEmail = {
      to: user.email,
      subject: 'Welcome to our site',
      body: "Welcome, thanks for registering",
      template: 'welcome'
    });
    return this.sendEmail(notifyNewUserEmail = {
      to: admin.email,
      subject: 'new user registered',
      body: "new user",
      template: 'registration'
    });
  };
  Messages = this;
  ref = new Firebase("https://kts032014.firebaseio.com/messages");
  sync = $firebase(ref);
  $scope.messages = sync.$asArray();
  $scope.addMessage = function(text) {
    return $scope.messages.$add({
      text: text
    });
  };
  this.gmailer = [];
  this.sendEmail = function(data) {
    console.log('sending email');
    console.log(data);
    return $http.post(railsServer + '/api/v1/gmailers', data).success(function(response) {
      data.response = response;
      Messages.gmailer.push(data);
      return saveToDatabase(data);
    });
  };
  saveToDatabase = function(data) {
    return console.log(data);
  };
}).controller('MainCtrl', function($scope, $http) {
  var Main;
  Main = this;
}).controller('UploadsCtrl', function($scope, $http, railsServer) {
  var Main, saveToDatabase;
  Main = this;
  this.uploadId = 4;
  $http.get(railsServer + '/api/v1/uploads/' + this.uploadId).success(function(data) {
    return Main.upload = data;
  });
  $http.get(railsServer + '/api/v1/emails').success(function(data) {
    return Main.emails = data;
  });
  this.signature = 'waiting...';
  $http.get(railsServer + '/api/v1/transloadit/signature').success(function(data) {
    return Main.signature = data;
  });
  this.sendSms = function(body) {
    var data;
    console.log('sending SMS');
    data = {
      from: '+18478689303',
      to: '+12246398453',
      body: body,
      status_callback: 'url here'
    };
    return $http.post(railsServer + '/api/v1/twilio/text', data).success(function(response) {
      Main.twilio.push(response);
      return saveToDatabase(response);
    });
  };
  saveToDatabase = function(data) {
    return console.log(data);
  };
});
