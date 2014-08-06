define [
  'underscore'
  'config'
  'views/_base'
  'easel'
], (_, Config, Base) ->
  class System extends Base
    
    t: 200
    
    x: -> 0
    
    render: ->
      @sysScreen = new createjs.Container
      @sysScreen.setTransform(@borderSize, @borderSize)
      
      @sysScreenA = new createjs.Shape
      @sysScreenA.graphics.beginFill("rgba(0,0,0,0.5)").drawRect(0, @x(), @game.w2/2, @game.h2)
      
      @sysScreenB = new createjs.Shape
      @sysScreenB.graphics.beginFill("rgba(0,0,0,0.5)").drawRect(@game.w2/2, @x(), @game.w2/2, @game.h2)
      
      #@countDown = new createjs.Text("", "250px "+Config.font2_semibold, "#FFFFFF")
      #@countDown.textAlign = "center"
      #@countDown.textBaseline = "alphabetic"
      #@countDown.setTransform(@game.w/2, @game.h/2)
      
      @childsRender()
      
      @screen.addChild(@sysScreen)
    
    childsRender: -> false

    show: ->
      @screen.visible = true
      createjs.Tween.get(@sysScreenA).to({x:0}, @t)
      createjs.Tween.get(@sysScreenB).to({x:0}, @t).call =>
        @game.gameScreen.screen.visible = false
        @buttons.visible = true

    hide: ->
      @game.gameScreen.screen.visible = true
      @buttons.visible = false
      createjs.Tween.get(@sysScreenA).to({x:-@game.w2/2}, @t)
      createjs.Tween.get(@sysScreenB).to({x:@game.w2/2}, @t).call =>
        @screen.visible = false
