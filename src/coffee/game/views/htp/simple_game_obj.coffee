define [
  'config'
  'helpers/mediator'
  'game/views/simple_game_obj'
], (Config, Mediator, SimpleGameObj) ->
  class HTPGameObj extends SimpleGameObj
    
    delegateEvents: ->
      @target.addEventListener 'click', => @update()
    
    update: ->
      Mediator.trigger 'change:score:success'
      Mediator.trigger new createjs.Event('state:change', 'htp:success')
    
    render: ->
      @target = objContainer = new createjs.Container
      
      shape = new createjs.Shape()
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawCircle(0, 0, 65)
      shape.cursor = "pointer"
      
      @txt = new createjs.Text("Click me", "30px "+Config.font2_reg, "#FFF")
      @txt.cursor = "pointer"
      @txt.textAlign = "center"
      @txt.textBaseline = "alphabetic"
      @txt.setTransform 0, 10 
      
      objContainer.setTransform Config.w/2, Config.h/2
      
      objContainer.addChild shape, @txt
      
      @screen.addChild objContainer