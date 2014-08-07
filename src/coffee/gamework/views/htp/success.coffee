define [
  'underscore'
  'config'
  'views/system'
  'helpers/mediator'
  'easel'
], (_, Config, System, Mediator) ->

  class Success extends System
    
    childsRender: ->
      @container = new createjs.Container
      @container.visible = false
      
      title = new createjs.Text("Nice work!", "100px "+Config.font2_bold, "#FFFFFF")
      title.textAlign = "left"
      title.textBaseline = "alphabetic"
      title.setTransform(380, 300)
      
      txt = new createjs.Text("Now it's time to play a real game", "65px "+Config.font2_reg, "#FFFFFF")
      txt.textAlign = "left"
      txt.textBaseline = "alphabetic"
      txt.setTransform(150, 400)
      
      @playButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button"))
      
      playButtonTxt = new createjs.Text "PLAY", "30px "+Config.font2_reg, "#4A4A4A"
      playButtonTxt.textBaseline = "alphabetic"
      playButtonTxt.setTransform 130, 45
      
      @playButton.addChild fon, playButtonTxt
      @playButton.setTransform @game.w/2 - 160, @game.h/2+120
      @playButton.cursor = "pointer"
      @playButton.on "mousedown", =>
        @game.restart()
        Mediator.trigger new createjs.Event('state:change', 'game')
      
      @container.addChild(title, txt, @playButton)
      
      @sysScreen.addChild @container
      
    afterShow: ->
      createjs.Tween.get(@sysScreenA).to({x:0}, @t)
      createjs.Tween.get(@sysScreenB).to({x:0}, @t).call => @container.visible = true

    beforeHide: ->
      @container.visible = false
      createjs.Tween.get(@sysScreenA).to({x:-@game.w2/2}, @t)
      createjs.Tween.get(@sysScreenB).to({x:@game.w2/2}, @t).call => @hide()