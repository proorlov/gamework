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
      textContainer = new createjs.Container
      
      total = new createjs.Text("Total score:", "124px "+Config.font2_bold, "#F1F1F1")
      total.textAlign = "center"
      total.textBaseline = "alphabetic"
      total.setTransform(Config.w/2, 250)
      
      @score = score = new createjs.Text("#{@game.points} points", "120px "+Config.font2_thin, "#F1F1F1")
      score.textAlign = "center"
      score.textBaseline = "alphabetic"
      score.setTransform(Config.w/2, 365)
      
      textContainer.addChild total, @score
      textContainer.setTransform 0, 90
      
      @buttons = new createjs.Container
      
      nextButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button_next"))
      
      txt = new createjs.Text("NEXT", "30px "+Config.font2_reg, "#4A4A4A")
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(100, 47)
      
      nextButton.addChild(fon, txt)
      nextButton.setTransform Config.w/2 - nextButton.getBounds().width/2, 550
      nextButton.cursor = "pointer"
      nextButton.on "mousedown", =>
        @game.restart()
        @hide()
      
      @buttons.addChild textContainer, nextButton
      
      @sysScreen.addChild @buttons

    callbackBeforeHide: ->
      super
      
    callbackAfterShow: ->
      super
      @buttons.visible = true
