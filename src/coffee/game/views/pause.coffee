define [
  'underscore'
  'config'
  'views/system'
  'easel'
], (_, Config, System) ->
  class Pause extends System
    
    visible: true
    
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
      workoutButton.setTransform(100, @game.h/2 - workoutButton.getBounds().height/2)
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
      replayButton.setTransform(@game.w/2 - replayButton.getBounds().width/2, @game.h/2 - replayButton.getBounds().height/2)
      replayButton.cursor = "pointer"
      replayButton.on "mousedown", => @game.restart()
      
      resumeButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button_green"))
      txt = new createjs.Text("RESUME", "30px "+Config.font2_reg, "#F1F1F1")
      txt.lineWidth = 327
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(163, 47)
      
      resumeButton.addChild(fon, txt)
      resumeButton.setTransform(@game.w - 429, @game.h/2 - resumeButton.getBounds().height/2)
      resumeButton.cursor = "pointer"
      resumeButton.on "mousedown", => @game.pause()
      
      @buttons.addChild(workoutButton, replayButton, resumeButton)
      
      @sysScreen.addChild @sysScreenA, @sysScreenB, @buttons#, @countDown

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
