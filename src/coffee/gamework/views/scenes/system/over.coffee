define [
  'underscore'
  'config'
  'scenes/system'
  'helpers/mediator'
  'easel'
], (_, Config, System, Mediator) ->

  class Over extends System
    
    delegateEvents: ->
      Mediator.on 'change:score', => @update()
    
    update: ->
      @score.text = "#{@game.points} points"
    
    childsRender: ->
      total = new createjs.Text("Total score:", "120px "+Config.font2_bold, "#F1F1F1")
      total.textAlign = "center"
      total.textBaseline = "alphabetic"
      total.setTransform(Config.w/2, 300)
      
      @score = score = new createjs.Text("#{@game.points} points", "120px "+Config.font2_thin, "#F1F1F1")
      score.textAlign = "center"
      score.textBaseline = "alphabetic"
      score.setTransform(Config.w/2, 420)
      
      @buttons = new createjs.Container
      
      nextButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button"))
      
      txt = new createjs.Text("NEXT", "30px "+Config.font2_reg, "#4A4A4A")
      txt.lineWidth = 327
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(163, 47)
      
      nextButton.addChild(fon, txt)
      nextButton.setTransform(Config.w/2 - nextButton.getBounds().width/2, Config.h*0.7 - nextButton.getBounds().height/2)
      nextButton.cursor = "pointer"
      nextButton.on "mousedown", =>
        @game.restart()
        @hide()
      
      @buttons.addChild(total, score, nextButton)
      
      @sysScreen.addChild @buttons

    callbackBeforeHide: ->
      super
      
    callbackAfterShow: ->
      super
      @buttons.visible = true
