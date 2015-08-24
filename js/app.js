var app = angular.module("editor", []);

app.controller('editorController', ['$scope', '$http', function($scope, $http) {
    $scope.roomList = [];
    $scope.events =  ["swipeUp", "swipeLeft", "swipeDown", "swipeRight"];
    $scope.actions = ["pickItem", "gotoRoom"];
    $http.get('Level1.json')
     .then(function(res){
        $scope.roomList = res.data;
      });

    $scope.loadJson = function () {

    };
    $scope.saveJson = function () {

    };

    $scope.newRoom = function () {
        $scope.roomList.push({
            "background": "",
            "events": {}
        } );
    };

    $scope.newEvent = function (room, eventType) {
        room.events[eventType] = {
            "action": ""
        };
    };

}]);
