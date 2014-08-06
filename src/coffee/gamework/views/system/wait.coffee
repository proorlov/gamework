define [
  'underscore'
  'config'
  'views/system'
  'helpers/mediator'
  'easel'
], (_, Config, System, Mediator) ->
  class Wait extends System
    
    downCounter: Config.startTime
    
    delegateEvents: ->
      @on 'update', => @update()
    
    update: ->
      @countDown.text = @value()
    
    value: -> Math.round(@downCounter/1000)
    
    childsRender: ->
      @countDown = new createjs.Text( @value(), "250px "+Config.font2_semibold, "#FFFFFF" )
      @countDown.textAlign = "center"
      @countDown.textBaseline = "alphabetic"
      @countDown.setTransform(@game.w/2, @game.h/2)
      
      @sysScreen.addChild @sysScreenA, @sysScreenB, @countDown

    beforeHide: ->
      @countDown.visible = false
      super
