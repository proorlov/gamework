define [
  'views/htp'
  'game/views/htp/simple_game_obj'
], (HTP, SimpleGameObj) ->
  class HTPSimple extends HTP
    
    renderSupport: ->
      @simpleGameObj = new SimpleGameObj @game
      
    afterShow: ->
      @screen.addChild @simpleGameObj.screen
      @simpleGameObj.dispatchEvent 'show'
