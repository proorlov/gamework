define [
  'underscore'
  'config'
  'views/_base'
  'helpers/mediator'
  'easel'
], (_, Config, Base, Mediator) ->
  class SimpleGameObj extends Base
    
    visible: true
    
    delegateEvents: ->
      @target.addEventListener 'click', => @game.addScore()
      Mediator.on 'change:score', => @update()
    
    update: ->
      @txt.text = @game.points
    
    render: ->
      @target = objContainer = new createjs.Container
      
      shape = new createjs.Shape()
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawCircle(0, 0, 65)
      
      @txt = new createjs.Text(@game.points, "60px "+Config.font2_reg, "#FFF")
      @txt.textAlign = "center"
      @txt.textBaseline = "alphabetic"
      @txt.setTransform( 0, 20 )
      
      objContainer.setTransform( @game.w/2, @game.h/2 )
      
      objContainer.addChild(shape, @txt)
      
      @screen.addChild(objContainer)      