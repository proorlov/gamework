define [
  'underscore'
  'config'
  'views/_base'
  'easel'
], (_, Config, Base) ->
  class System extends Base
    
    render: ->
      @sysScreen = new createjs.Container
      @sysScreen.setTransform(@borderSize, @borderSize)
      
      @sysScreenA = new createjs.Shape
      @sysScreenA.graphics.beginFill("rgba(0,0,0,0.5)").drawRect(0, 0, @game.w2/2, @game.h2)
      
      @sysScreenB = new createjs.Shape
      @sysScreenB.graphics.beginFill("rgba(0,0,0,0.5)").drawRect(@game.w2/2, 0, @game.w2/2, @game.h2)
      
      @countDown = new createjs.Text("", "250px "+Config.font2_semibold, "#FFFFFF")
      @countDown.textAlign = "center"
      @countDown.textBaseline = "alphabetic"
      @countDown.setTransform(@game.w/2, @game.h/2)
      
      #pause
      @pauseButtons = new createjs.Container
      @pauseButtons.visible = false
      
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
      replayButton.on "mousedown", => @game.restartGame()
      
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
      
      @pauseButtons.addChild(workoutButton, replayButton, resumeButton)
      
      #over
      
      total = new createjs.Text("Total score:", "120px "+Config.font2_bold, "#F1F1F1")
      total.textAlign = "center"
      total.textBaseline = "alphabetic"
      total.setTransform(@game.w/2, 300)
      
      score = new createjs.Text(@points + " points", "120px "+Config.font2_thin, "#F1F1F1")
      score.textAlign = "center"
      score.textBaseline = "alphabetic"
      score.setTransform(@game.w/2, 420)
      
      @overButtons = new createjs.Container
      @overButtons.visible = false
      
      nextButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button"))
      
      txt = new createjs.Text("NEXT", "30px "+Config.font2_reg, "#4A4A4A")
      txt.lineWidth = 327
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(163, 47)
      
      nextButton.addChild(fon, txt)
      nextButton.setTransform(@game.w/2 - nextButton.getBounds().width/2, @game.h*0.7 - nextButton.getBounds().height/2)
      nextButton.cursor = "pointer"
      nextButton.on "mousedown", => @restartGame()
      
      @overButtons.addChild(total, score, nextButton)
      
      @sysScreen.addChild(@sysScreenA, @sysScreenB, @countDown, @pauseButtons, @overButtons);
      @screen.addChild(@sysScreen)
      