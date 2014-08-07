define [
  'underscore'
  'config'
  'views/_base'
  'helpers/mediator'
  'easel'
], (_, Config, Base, Mediator) ->
  class SimpleGameObj extends Base
    visible: true
    
    best_time: 0
    
    delegateEvents: ->
      @target.addEventListener 'click', => @game.addScore(@countPoint())
      Mediator.on 'change:score', (event) => @update(event)
      
    update: (event) ->
      @time_for_answer = @game.gamingTime - @s_time
      @best_time = @time_for_answer if @time_for_answer < @best_time
      @s_time = @game.gamingTime
      
      #Mediator.on 'change:score', (event) => @update(event)
      #"WOOHOO! SUPERSPEED!" if @time_for_answer <= 2000
    
    countPoint: -> Config.points
    
    render: ->
      @target = objContainer = new createjs.Container
      
      shape = new createjs.Shape()
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawCircle(0, 0, 65)
      shape.cursor = "pointer"
      
      @txt = new createjs.Text(Config.points, "60px "+Config.font2_reg, "#FFF")
      @txt.cursor = "pointer"
      @txt.textAlign = "center"
      @txt.textBaseline = "alphabetic"
      @txt.setTransform( 0, 20 )
      
      objContainer.setTransform( @game.w/2, @game.h/2 )
      
      objContainer.addChild(shape, @txt)
      
      @screen.addChild(objContainer)

    show: ->
      @screen.visible = true
      @afterShow()
      
    afterShow: ->
      @s_time = @game.gamingTime
