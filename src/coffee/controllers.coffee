'use strict'

listControllers = angular.module('listControllers', [])

listControllers.controller('ListCtrl', 
    ($scope, $http) ->
        $http.get('/packages.json').success( (data) ->
            $scope.data = data
        )
)
