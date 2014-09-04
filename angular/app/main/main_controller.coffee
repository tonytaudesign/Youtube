railsServer = "http://7c704286.ngrok.com/"

angular.module 'angular-main',['ngRoute', 'firebase', 'ngCookies', 'ng-token-auth', 'ui.bootstrap']
  .value 'railsServer', railsServer #'http://48e7da36.ngrok.com/' #'http://3a51c2b4.ngrok.com/' 

  .config ($authProvider) ->
    # the following shows the default values. values passed to this method
    # will extend the defaults using angular.extend
    $authProvider.configure
      apiUrl: railsServer
      tokenValidationPath: "/auth/validate_token"
      signOutUrl: "/auth/sign_out"
      emailRegistrationPath: "/auth"
      confirmationSuccessUrl: railsServer
      passwordResetPath: "/auth/password"
      passwordUpdatePath: "/auth/password"
      passwordResetSuccessUrl: railsServer #window.location.href
      emailSignInPath: "/auth/sign_in"
      storage: "cookies"
      proxyIf: ->
        false

      proxyUrl: "/proxy"
      authProviderPaths:
        twitter: "/auth/twitter"
        facebook: "/auth/facebook"
        google: "/auth/google"
        github: "/auth/github"

      tokenFormat:
        "access-token": "{{ token }}"
        "token-type": "Bearer"
        client: "{{ clientId }}"
        expiry: "{{ expiry }}"
        uid: "{{ uid }}"

      parseExpiry: (headers) ->
        
        # convert from UTC ruby (seconds) to UTC js (milliseconds)
        (parseInt(headers["expiry"]) * 1000) or null

      handleLoginResponse: (response) ->
        response.data

      handleTokenValidationResponse: (response) ->
        response.data

    return



  .config ($httpProvider) ->
    $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

  .config ($routeProvider) ->
    $routeProvider
      .when '/home',
        templateUrl: 'main/home.html'
        controller: 'HomeCtrl'
        # controllerAs: 'Home'
      .when '/sign_in',
        templateUrl: 'main/sign_in.html'
        controller: 'MainCtrl'
      .when '/sign_out',
        templateUrl: 'main/sign_out.html'
        controller: 'MainCtrl'
      .when '/register',
        templateUrl: 'main/register.html'
        controller: 'MainCtrl'
      .when '/',
        templateUrl: 'main/main.html'
        controller: 'MainCtrl'
        controllerAs: 'Main'
      .when '/messages',
        templateUrl: 'main/messages.html'
        controller: 'MessagesCtrl'
        controllerAs: 'Messages'
      .when '/uploads',
        templateUrl: 'main/uploads.html'
        controller: 'UploadsCtrl'
        controllerAs: 'Uploads'


  .controller 'HomeCtrl', ($scope, $http, $firebase, $auth) ->
    return
    
  .controller 'AuthCtrl', ($scope, $auth) ->
    $rootScope.$on 'auth:login-success', (ev, user) ->
      alert 'Welcome ', user.email
    $scope.handleBtnClick = ->
      $auth.authenticate 'github'
    return

  .controller 'MessagesCtrl', ($scope, $http, $firebase, railsServer) ->
    admin =
      email: 'TONYTAUDESIGN@gmail.com'
    user = 
      name: "Matt"
      email: 'mattcowski@gmail.com'

    @resetEmail = 
      to: user.email
      subject: 'Reset your password'
      body: 'heres ur pass reset link'
      template: 'reset pass'

    @uploadNotificationEmail =
      to: admin.email
      subject: user.name+" uploaded a file"
      body: user.name+" uploaded a file"
      template: 'notification'

    @contactUsEmail = 
      to: admin.email
      subject: 'new contact form submission'
      body: "users: "
      template: 'contact'

    @register = ()->
      # validate @ .com
      # register user... using devise, rails db, then ...

      # send welcome
      @sendEmail welcomeEmail = 
        to: user.email

        subject: 'Welcome to our site'
        body: "Welcome, thanks for registering"
        template: 'welcome'

      # send user reg email to admin
      @sendEmail notifyNewUserEmail = 
        to: admin.email

        subject: 'new user registered'
        body: "new user"
        template: 'registration'

    Messages = this
    # $http.get(railsServer+'/api/v1/gmailers').success (data) -> return Messages.allEmails = data

    ref = new Firebase("https://kts032014.firebaseio.com/messages")
    sync = $firebase(ref)
    # $scope.data = sync.$asObject()
    $scope.messages = sync.$asArray()

    $scope.addMessage = (text) ->
      $scope.messages.$add({text: text})
    # -------------- gmailer -----------
    # POST {to: 'user@gmail.com', subject: 'SUBJECT', body: 'BODY'} 
    @gmailer = []
    @sendEmail = (data)->  
      console.log 'sending email'
      console.log data
      $http.post(railsServer+'/api/v1/gmailers', data).success (response) ->        
        data.response = response
        Messages.gmailer.push data
        saveToDatabase(data)

    # -------------- twilio -----------
    # POST {to: '+12245551234', body: 'BODY'} 
    @sendSms = (body)->  
      console.log 'sending SMS'
      data = {from:'+18478689303', to:'+12246398453', body: body, status_callback: 'url here'}
      $http.post(railsServer+'/api/v1/twilio/text', data).success (response) ->          
        Main.twilio.push response
        saveToDatabase(response)

    saveToDatabase = (data) ->
      #for now just log
      console.log data

    return


  .controller 'MainCtrl', ($scope, $http, railsServer, $rootScope) ->
    Main = this
    @sendSms = (body)->  
      console.log 'sending SMS'
      data = {from:'+18478689303', to:'+12246398453', body: body, status_callback: 'url here'}
      $http.post(railsServer+'/api/v1/twilio/text', data).success (response) ->          
        Main.twilio.push response
    return

  .controller 'UploadsCtrl', ($scope, $http, railsServer) ->
    # alternative to $scope
    Uploads = this

    # -------------- our database -----------
    # POST {url: 'http://amazon.com/fdslakjf'}
    @uploadId = 4
    $http.get(railsServer+'/api/v1/uploads/'+@uploadId).success (data) -> return Uploads.upload = data
    # POST {subject: 'SUBJECT', body: 'BODY'}
    $http.get(railsServer+'/api/v1/emails').success (data) -> return Uploads.emails = data

    # -------------- transloadit -----------
    @signature = 'waiting...'
    $http.get(railsServer+'/api/v1/transloadit/signature').success (data) -> return Uploads.signature = data

    saveToDatabase = (data) ->
      #for now just log
      console.log data

    return