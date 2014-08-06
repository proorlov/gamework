define [
  'views/htp'
  'game/views/htp/simple_game_obj'
], (HTP, SimpleGameObj) ->
  class HTPSimple extends HTP
    
    renderSupport: ->
      @simpleGameObj = new SimpleGameObj @game
      @screen.addChild(@simpleGameObj.screen)

    hide: ->
      @simpleGameObj.txt.text = 'Click me' #FIXME
      super