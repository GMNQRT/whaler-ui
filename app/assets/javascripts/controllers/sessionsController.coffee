angular.module('whaler.controllers').controller 'SessionsController', [
	'$scope',
	'$http',
	($scope, $http) ->
		$http.post('http://localhost:3000/users/sign_in.json',
			user: {
				email: 'clor.matthieu.tl@gmail.com',
				password: 'immo8802',
				remember_me: 1
			}
			).success((data, status, headers, config) ->
				$scope.values = data
				console.log data
			).error (data, status, headers, config) ->
				console.log data
]