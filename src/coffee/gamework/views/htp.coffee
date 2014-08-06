define [
  'underscore'
  'config'
  'views/game'
  'easel'
], (_, Config, Game) ->
  class HTP extends Game
    
    delegateEvents: -> false
    afterHide: -> @game.restart()
    
    render: ->
      @paintStaticObjects()
      @renderSupport()

    #override
    renderSupport: -> false