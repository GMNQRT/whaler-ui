angular.module('whaler.directives').directive 'imageSearchCard', [
  () ->
    restrict: 'AE'
    transclude: true
    scope:
      ngModel: '='
      onStart: "&"
    controller: ($scope) ->
      $scope.imgloaded = ($el) ->
        RGBaster.colors $el[0],
          exclude: ['rgb(0,0,0)']
          success: (payload) ->
            # dominant = payload.dominant.match(/rgb\(([0-9]+),([0-9]+),([0-9]+)\)/)
            # secondary = payload.secondary.match(/rgb\(([0-9]+),([0-9]+),([0-9]+)\)/)
            # gap = 2
            # return if dominant is null
            # if secondary[1] - gap < parseInt(dominant[1]) < secondary[1] + gap and secondary[2] - gap  < parseInt(dominant[2]) < secondary[2] + gap and secondary[3] - gap  < parseInt(dominant[3]) < secondary[3] + gap
              $el.parent().css 'background-color', payload.dominant
              console.log $el.parent()[0]
    template: """
    <div class="image-state bg-primary col-xs-3">
      <div class="img-default" ng-if="!ngModel.info.is_official">{{ngModel.info.name|limitTo:1:0}}</div>
      <img class="img-responsive" ng-src="https://raw.githubusercontent.com/docker-library/docs/master/{{ ngModel.info.id }}/logo.png" ng-if="ngModel.info.is_official" img-onload="imgloaded">
    </div>
    <div class="image-body col-xs-9">
      <header>
        <h2 class="image-title">{{ngModel.info.name}}</h2>
      </header>
      <p>{{ngModel.info.description}}</p>
      <footer class="row text-center">
        <div class="image-time col-xs-4 btn">
          <i class="glyphicon glyphicon-star-empty"></i> {{ngModel.info.star_count}}
        </div>
        <div class="image-tags col-xs-4 btn"><i class="glyphicon glyphicon-bookmark"></i> Tags</div>
        <div class="image-option col-xs-4">
          <a class="btn btn-primary-outline" ng-click="showOption($event)">Create</a>
        </div>
      </footer>
    </div>"""
]
angular.module('whaler.directives').directive 'imgOnload', () ->
  restrict: 'A',
  scope:
    imgOnload: '&'
  link: ($scope, $el) ->
    $el.bind 'load', () ->
      $scope.imgOnload()($el)
