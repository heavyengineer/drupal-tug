import angular from 'angular';
import * as UserModule from './user/user.module';

console.log(angular.version);

angular.module('drupalTug',[])
.factory('userSvc', UserModule.svc)
.controller('userCtrl', UserModule.ctrl);
