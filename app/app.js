import angular from 'angular';

var drupalTug = angular.module('drupalTug',[]);

drupalTug.controller('envCtrl', function($scope) {

  var jf = require('jsonfile')
  var file = __dirname+'/config/env_variables.json'
  var out = jf.readFileSync(file);

$scope.env_variables = out;

  $scope.save = function() {
    // some kind of try/catch here?
    $scope.msg = 'Updated'

var obj = $scope.env_variables

jf.writeFileSync(file, obj)
  };
});
