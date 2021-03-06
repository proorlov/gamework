define [
  'underscore'
  'config'
  'scenes/system'
  'helpers/mediator'
  'easel'
], (_, Config, System, Mediator) ->

  class Success extends System
    
    childsRender: ->
      @container = new createjs.Container
      @container.visible = false
      
      textContainer = new createjs.Container
      
      title = new createjs.Text("Nice work!", "124px "+Config.font2_bold, "#FFFFFF")
      title.textAlign = "left"
      title.textBaseline = "alphabetic"
      title.setTransform(320, 250)
      
      txt = new createjs.Text("Now it's time to play a real game", "65px "+Config.font2_thin, "#FFFFFF")
      txt.textAlign = "left"
      txt.textBaseline = "alphabetic"
      txt.setTransform(150, 350)
      
      textContainer.addChild title, txt
      textContainer.setTransform 0, 100
      
      @playButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button_next"))
      fon.setTransform 70, 0
      
      playButtonTxt = new createjs.Text "PLAY", "30px "+Config.font2_reg, "#4A4A4A"
      playButtonTxt.textBaseline = "alphabetic"
      playButtonTxt.setTransform 130, 45
      
      @playButton.addChild fon, playButtonTxt
      
      @playButton.setTransform Config.w/2 - 180, 550
      
      @playButton.cursor = "pointer"
      @playButton.on "mousedown", =>
        @game.restart()
        @hide()
      
      @container.addChild(textContainer, @playButton)
      
      @sysScreen.addChild @container

    beforeShow: ->
      _.each _.flatten(@els), (el) -> el.visible = true
      super

    callbackAfterShow: ->
      @game.screens['game'].screen.visible = false
      @container.visible = true

    beforeHide: ->
      @container.visible = false
      _.each _.flatten(@els), (el) -> el.visible = false
      createjs.Tween.get(@sysScreenA).to({x:-Config.w2/2}, @t)
      createjs.Tween.get(@sysScreenB).to({x:Config.w2/2}, @t).call => @callbackBeforeHide()
