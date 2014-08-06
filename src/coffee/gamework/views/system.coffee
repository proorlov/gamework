define [
  'underscore'
  'config'
  'views/_base'
  'easel'
], (_, Config, Base) ->
  class System extends Base
    
    t: 200
    
    render: ->
      @sysScreen = new createjs.Container
      @sysScreen.setTransform(@borderSize, @borderSize)
      
      @sysScreenA = new createjs.Shape
      @sysScreenA.graphics.beginFill("rgba(0,0,0,0.5)").drawRect(0, 0, @game.w2/2, @game.h2)
      
      @sysScreenB = new createjs.Shape
      @sysScreenB.graphics.beginFill("rgba(0,0,0,0.5)").drawRect(@game.w2/2, 0, @game.w2/2, @game.h2)
      
      @childsRender()
      @screen.addChild(@sysScreen)
    
    childsRender: -> false

    afterShow: ->
      createjs.Tween.get(@sysScreenA).to({x:0}, @t)
      createjs.Tween.get(@sysScreenB).to({x:0}, @t)

    beforeHide: ->
      createjs.Tween.get(@sysScreenA).to({x:-@game.w2/2}, @t)
      createjs.Tween.get(@sysScreenB).to({x:@game.w2/2}, @t).call => @hide()
