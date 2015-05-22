import angular from 'angular';

var drupalTug = angular.module('drupalTug',[]);

drupalTug.controller('envCtrl', function($scope) {

  var jf = require('jsonfile')
  var file = __dirname+'/config/env_variables.json'
  var out = jf.readFileSync(file);

$scope.env_variables = out['env'];

  $scope.save = function() {
    $scope.msg = 'yoink';
  };
});
