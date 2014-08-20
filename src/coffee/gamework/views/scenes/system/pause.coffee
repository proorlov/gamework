define [
  'underscore'
  'config'
  'scenes/system'
  'helpers/mediator'
  'easel'
], (_, Config, System, Mediator) ->

  class Pause extends System
    
    childsRender: ->
      @buttons = new createjs.Container
      
      workoutButton = new createjs.Container
      fon = new createjs.Bitmap(@game.queue.getResult("button"))
      
      txt = new createjs.Text("BACK TO WORKOUT", "30px "+Config.font2_reg, "#4A4A4A")
      txt.lineWidth = 327
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(163, 47)
      
      workoutButton.addChild(fon, txt)
      workoutButton.setTransform 100, 0
      workoutButton.cursor = "pointer"
      workoutButton.on "mousedown", => console.log("back to workout")

      replayButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button"))
      txt = new createjs.Text("REPLAY", "30px "+Config.font2_reg, "#4A4A4A")
      txt.lineWidth = 327
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(163, 47)
      
      replayButton.addChild(fon, txt)
      replayButton.setTransform Config.w/2 - replayButton.getBounds().width/2, 0
      replayButton.cursor = "pointer"
      replayButton.on "mousedown", =>
        @game.restart()
        @hide()
      
      resumeButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button_green"))
      txt = new createjs.Text("RESUME", "30px "+Config.font2_reg, "#F1F1F1")
      txt.lineWidth = 327
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(163, 47)
      
      resumeButton.addChild(fon, txt)
      resumeButton.setTransform Config.w - 429, 0
      resumeButton.cursor = "pointer"
      resumeButton.on "mousedown", => @game.pause()
      
      @buttons.visible = false
      @buttons.addChild(workoutButton, replayButton, resumeButton)
      
      @buttons.setTransform 0, 353
      
      @sysScreen.addChild @buttons
      
    beforeHide: ->
      @buttons.visible = false
      super

    callbackBeforeHide: ->
      super
      
    callbackAfterShow: ->
      super
      @buttons.visible = true