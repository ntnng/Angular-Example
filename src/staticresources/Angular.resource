PK
     ��J               pages/PK
     H��J�Jk/�  �     pages/form.html<div class="center">
    <form name='noteForm' role="form">
        <div class="form-group">
            <textarea class="form-control" rows="5" style="resize:none" placeholder="Your message here!" ng-model="message"></textarea>
        </div>
        <button type="submit" class="btn btn-primary" ng-disabled="!noteForm.$dirty" ng-click="!noteForm.$dirty || post()">Submit</button>
    </form>
</div>
PK
     ��J�  �  �     pages/list.html<div class="center">
    <div class="panel panel-default">
        <div class="panel-heading">
            <div class="row">
                <div class="col-xs-12 col-md-8"></div>
                <div class="col-xs-6 col-md-4">
                    <input type="text" class="form-control" placeholder="Search" ng-model="searchText"/>
                </div>
            </div>
        </div>
        <div class="panel-body">
            <ul class="list-group">
                <li class="list-group-item" ng-repeat="item in feedItems | filter: { postBody: searchText}">
                    <feed-item item="item"></feed-item>
                </li>
            </ul>
        </div>
    </div>
</div>
PK
     ���J               scripts/PK
      ��J               styles/PK
     �V�J�PS�F  F     scripts/script.js(function() {
    'use strict';
    var myApp = angular.module('myApp', ['ngRoute']);

    myApp.config(function($routeProvider) {
        $routeProvider.when('/', {
            templateUrl: _ResourceUrl + '/pages/list.html',
            controller: 'mainController'
        }).when('/create', {
            templateUrl: _ResourceUrl + '/pages/form.html',
            controller: 'FormController'
        });
    });

    myApp.controller('mainController', ['$scope', 'dataServices', function(
        $scope, dataServices) {
        var promise = dataServices.getFeed();
        promise.then(function(data) {
            console.log(data);
            $scope.feedItems = data;
        }, function(message) {
            alert(message);
        });
    }]);

    myApp.controller('FormController', ['$scope', 'dataServices', '$location',
        function($scope, dataServices, $location) {
            $scope.message = '';
            $scope.post = function() {
                if ($scope.message.length <= 2) {
                    alert('Please enter some proper message');
                } else {
                    var promise = dataServices.createPost(
                        $scope.message);
                    promise.then(function(data) {
                        if (typeof data.status !== 'undefined') {
                            if (data.status === 'success') {
                                $location.path('/');
                            } else if (data.status === 'failure') {
                                alert(data.message);
                            }
                        }
                    }, function(data) {
                        console.log(data);
                    });
                }
            }
        }
    ]);

    myApp.directive('feedItem', function() {
        return {
            scope: {
                item: '='
            },
            replace: true,
            restrict: 'E',
            templateUrl: _ResourceUrl + '/templates/item.html'
        };
    });

    var getStandardCallback = function(deferred) {
        var callback = function(result, event) {
            if (event.status) {
                deferred.resolve(result);
            } else {
                deferred.reject(event.message);
            }
        };
        return callback;
    };

    myApp.factory('dataServices', ['$q', function($q) {
        return {
            getFeed: function() {
                var deferred = $q.defer();
                Visualforce.remoting.Manager.invokeAction(
                    _RemoteActions.getFeed,
                    getStandardCallback(deferred), {
                        escape: false
                    });
                return deferred.promise;
            },
            createPost: function(text) {
                var deferred = $q.defer();
                Visualforce.remoting.Manager.invokeAction(
                    _RemoteActions.createPost, text,
                    getStandardCallback(deferred), {
                        escape: false
                    });
                return deferred.promise;
            }
        }
    }]);
})();
PK
     ���JX��Ke   e      styles/style.css.center {
  margin-left: auto;
  margin-right: auto;
}
.media-photo {
    border-radius: 50%;
}PK
     ���J            
   templates/PK
     ���J�G�{  {     templates/item.html<div class="media">
    <span href="#" class="pull-left">
        <img src="{{item.postCreatorPhoto}}" class="media-photo">
    </span>
    <div class="media-body">
        <span class="media-meta pull-right">{{item.postDate}}</span>
        <h4 class="title">
            {{item.postCreatorName}}
        </h4>
        <p class="summary">{{item.postBody}}</p>
    </div>
</div>
PK 
     ��J                            pages/PK 
     H��J�Jk/�  �               $   pages/form.htmlPK 
     ��J�  �  �               �  pages/list.htmlPK 
     ���J                        �  scripts/PK 
      ��J                        �  styles/PK 
     �V�J�PS�F  F                 scripts/script.jsPK 
     ���JX��Ke   e                �  styles/style.cssPK 
     ���J            
              templates/PK 
     ���J�G�{  {               D  templates/item.htmlPK    	 	   �    