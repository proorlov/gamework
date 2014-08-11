define [
  'underscore'
  'config'
  'scenes/system'
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
      @countDown.setTransform(Config.w/2, Config.h/2)
      
      @sysScreen.addChild @countDown
    
    beforeShow: -> @show()

    beforeHide: ->
      @countDown.visible = false
      super