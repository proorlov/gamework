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
      workoutButton.setTransform(100, Config.h/2 - workoutButton.getBounds().height/2)
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
      replayButton.setTransform(Config.w/2 - replayButton.getBounds().width/2, Config.h/2 - replayButton.getBounds().height/2)
      replayButton.cursor = "pointer"
      replayButton.on "mousedown", =>
        @game.restart()
        @hide()
        Mediator.trigger new createjs.Event('state:change', 'wait')
      
      resumeButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button_green"))
      txt = new createjs.Text("RESUME", "30px "+Config.font2_reg, "#F1F1F1")
      txt.lineWidth = 327
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(163, 47)
      
      resumeButton.addChild(fon, txt)
      resumeButton.setTransform(Config.w - 429, Config.h/2 - resumeButton.getBounds().height/2)
      resumeButton.cursor = "pointer"
      resumeButton.on "mousedown", => @game.pause()
      
      @buttons.visible = false
      @buttons.addChild(workoutButton, replayButton, resumeButton)
      
      @sysScreen.addChild @buttons

    afterShow: ->
      createjs.Tween.get(@sysScreenA).to({x:0}, @t)
      createjs.Tween.get(@sysScreenB).to({x:0}, @t).call =>
        @buttons.visible = true

    beforeHide: ->
      @buttons.visible = false
      createjs.Tween.get(@sysScreenA).to({x:-Config.w2/2}, @t)
      createjs.Tween.get(@sysScreenB).to({x:Config.w2/2}, @t).call => @hide()
