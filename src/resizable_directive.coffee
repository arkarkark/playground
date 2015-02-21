angular.module('Resizable', []).directive('arkResizable', ($timeout) ->
  restrict: 'EA'
  scope:
    options: '&arkResizable'
  link: ($scope, $element) ->
    enabled = false
    sibling = null
    $timeout(->
      sibling = $element.next('[ark-resizable]')
      if sibling.length
        console.log($element.resizable)

        $scope.$watch(
          -> $scope.options()
          (options) ->
            if options.disabled
              if enabled
                $element.resizable('disable')
            else
              if !enabled
                startWidth = null
                startTwelth = null
                $element.resizable({
                  helper: 'ui-resizable-helper'
                  resize: (event, ui) ->
                    console.log('resize!')
                  start: (event, ui) ->
                    console.log('start!')
                    # work out the width and how many twelths wide this is.
                    startWidth = $element.width()
                    startTwelth = null
                    for className in $element[0].classList
                      match = className.match(/col-sm-([0-9]+)/)
                      if match
                        startTwelth = match[1]
                        break
                    console.log('width/twelth', startWidth, startTwelth)
                  stop: (event, ui) ->
                    console.log('stop!', ui.size.height)
                    options = $scope.options()
                    row = options.row
                    index = options.index
                    # heights is easy
                    for col in row
                      col.height = ui.size.height
                    # now work out the new twelth width is...
                    maxNewTwelth = row[index + 1].width + row[index + 1].width - 1
                    newTwelth = Math.max(Math.round((ui.size.width * startTwelth) / startWidth), 1)
                    console.log('start, nt, max', startTwelth, newTwelth, maxNewTwelth)
                    newTwelth = Math.min(maxNewTwelth, newTwelth)
                    console.log('newTwelth', newTwelth)
                    $element.css('width', '')
                    row[index].width = newTwelth
                    row[index + 1].width += startTwelth - newTwelth

                    $scope.$apply()


                })
          true
        )
    )

)
