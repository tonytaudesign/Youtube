angular.module 'angular', [ 'ngRoute','angular-main','templates' ]
  
  .config ($routeProvider) ->

    $routeProvider
      .otherwise
        redirectTo: '/'