define [
  'underscore'
  'config'
  'views/game'
  'easel'
], (_, Config, Game) ->
  class HTP extends Game

    visible: false
    
    render: ->
      @paintStaticObjects()
      @renderSupport()

    hide: ->
      super
      @game.restart()
      
    #override
    renderSupport: -> false