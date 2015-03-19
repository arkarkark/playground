app = angular.module('Playground', [
  'ui.bootstrap'
])

angular.module('Playground').controller('PlaygroundController', ($scope) ->
  $scope.message = 'hello'
  @controllerMessage = 'from Controller'

  @ # must be last
)
