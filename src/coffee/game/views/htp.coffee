define [
  'views/htp'
  'game/views/htp/simple_game_obj'
], (HTP, SimpleGameObj) ->
  class HTPSimple extends HTP
    
    renderSupport: ->
      @simpleGameObj = new SimpleGameObj @game
      @screen.addChild(@simpleGameObj.screen)
    
    afterHide: ->
      @simpleGameObj.txt.text = @simpleGameObj.start_text
      super