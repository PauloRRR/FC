var app = angular.module("editor", []);

app.controller('editorController', ['$scope', function($scope) {
    $scope.roomList = ["teste", "teste1"];
    $scope.newRoom = function () {
        $scope.roomList.push("wtf");
    };

}]);
