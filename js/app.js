var app = angular.module("editor", []);


app.controller('editorController', ['$scope', '$http', function($scope, $http) {
    $scope.roomList = [];
    $scope.events =  ["swipeUp", "swipeLeft", "swipeDown", "swipeRight"];
    $scope.actions = ["pickItem", "gotoRoom"];
    /*
    $http.get('Level1.json')
     .then(function(res){
        $scope.roomList = res.data;
      });
     */
    $scope.loadJson = function (obj) {
        var json = obj.files[0];
        var r = new FileReader();
            r.onload = function(e) {
                $scope.roomList = angular.fromJson(e.target.result);
            };
            r.readAsText(json);
    };
    $scope.saveJson = function () {
        var element = document.createElement('a');
        element.setAttribute('href', 'data:application/json;charset=utf-8,' + encodeURIComponent(angular.toJson($scope.roomList)));
        element.setAttribute('download', "level.json");

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);
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

    $scope.newSound = function (soundArray) {
        soundArray = soundArray || [];
        soundArray.push({
            "offset": 0.0,
            "sound": "",
            "format": "",
            "x": 0.0,
            "y": 0.0
        });
    };

}]);
