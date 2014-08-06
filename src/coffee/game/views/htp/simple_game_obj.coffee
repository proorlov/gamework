define [
  'config'
  'helpers/mediator'
  'game/views/simple_game_obj'
], (Config, Mediator, SimpleGameObj) ->
  class HTPGameObj extends SimpleGameObj
    
    start_text: "Click me"
    
    delegateEvents: ->
      @target.addEventListener 'click', => @game.addScore(@)
      @on 'change:score', @update
    
    update: -> @txt.text = 'Success!'
    
    render: ->
      @target = objContainer = new createjs.Container
      
      shape = new createjs.Shape()
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawCircle(0, 0, 65)
      
      @txt = new createjs.Text(@start_text, "30px "+Config.font2_reg, "#FFF")
      @txt.textAlign = "center"
      @txt.textBaseline = "alphabetic"
      @txt.setTransform 0, 10 
      
      objContainer.setTransform @game.w/2, @game.h/2
      
      objContainer.addChild shape, @txt
      
      @screen.addChild objContainer