define [
  'underscore'
  'config'
  'views/game'
  'views/pause'
  'views/over'
  'views/htp'
  'easel'
], (_, Config, GameScreen, PauseScreen, OverScreen, HTPScreen) ->
  
  class Gamework
    version: '0.1.1'

    w: 1248
    h: 794
    borderSize: 12
    w2: Gamework::w - Gamework::borderSize
    h2: Gamework::h - Gamework::borderSize
    
    points: 0
    #api
    howState: false
    pauseState: false
    muteState: false
    #run
    started: false
    ended: false
    downCounter: Config.startTime
    timerRun: false
    gamingTime: 0
    
    constructor: () ->
      @canvas = document.getElementById("gameworkCanvas")
      createjs.Ticker.setFPS(30)
      @stage = new createjs.Stage(@canvas)
      @stage.enableMouseOver(10)
      
      @workstage = new createjs.Container
      @workstage.visible = false

      @queue = new createjs.LoadQueue(true)
      @queue.addEventListener("complete", => @start())
      @queue.loadManifest(Config.manifest)
     
    start: ->
      document.getElementById("gameworkLoading").style.display = "none"
      
      @paintBackground()

      @gameScreen = new GameScreen @
      @htpScreen = new HTPScreen @
      @systemScreen = new PauseScreen @
      @overScreen = new OverScreen @
      
      @stage.addChild @gameScreen.screen
      @stage.addChild @htpScreen.screen
      @stage.addChild @overScreen.screen
      @stage.addChild @systemScreen.screen
      
      @showFPS() if Config.debug
      
      @paintBorder()
      
      @gamingTime = 0
      @timerRun = true
      
      createjs.Ticker.addEventListener("tick", (tick) => @tickHandler(tick))
  
    paintBackground: ->
      background = new createjs.Bitmap @queue.getResult("background")
      background.cache(0, 0, @w, @h)
      @stage.addChild(background)

    showFPS: ->
      @fpsLabel = new createjs.Text("-- fps", "18px "+Config.font, "#FFFFFF")
      @fpsLabel.setTransform(15, 15)
      @stage.addChild(@fpsLabel)
    
    paintHowScreen: ->
      @systemScreen.sysScreen = new createjs.Container
      
    paintBorder: ->
      @border = new createjs.Shape
      color = "#4A4A4A"
      @border.graphics.setStrokeStyle(@borderSize).beginStroke(color)
      @border.graphics.drawRoundRect(@borderSize/2, @borderSize/2, @w - @borderSize, @h - @borderSize, 1)
      @border.graphics.endStroke()
      @border.cache(0, 0, @w, @h)
      @stage.addChild(@border)
      
    tickHandler: (tick) ->
      if @downCounter > 0
        @downCounter -= tick.delta
        @updateCounter()
      else
        @startGame()

      if @timerRun && !@pauseState
        @gamingTime += tick.delta;
        if Config.needTime == false || @gamingTime < Config.gameTime
          #playing
          @gameScreen.updateTimer(@gamingTime)
        else
          #time finished
          @gameScreen.updateTimer(Config.gameTime);
          @timerRun = false
          @gameOver()

      if !@timerRun && @gamingTime >= Config.gameTime && !@systemScreen.sysScreen.visible
        #fix if pause
        @gameOver()
      if Config.debug
        @fpsLabel.text = Math.round(createjs.Ticker.getMeasuredFPS()) + " fps"
      @stage.update()
      
    restart: ->
      @ended = false
      @started = false
      @pauseState = false
      @downCounter = Config.startTime
      @gamingTime = 0
      
      # fix, state machine
      @gameScreen.screen.visible = true
      @htpScreen.screen.visible = false
      @systemScreen.screen.visible = false
      @overScreen.screen.visible = false
      #
      
      @systemScreen.screen.visible = false

    startGame: ->
      return if @started
      
      @started = true
      @gamingTime = 0
      @timerRun = true
      @systemScreen.hide()

    how: (e) ->
      e.preventDefault() if e
      @howState = !@howState
      if @howState
        @overScreen.screen.visible = false if @ended
        @gameScreen.hide()
        @htpScreen.show()
      else
        @htpScreen.hide()
      @howState
      
    pause: (e) ->
      e.preventDefault() if e
      return unless @timerRun
      @pauseState = !@pauseState
      if @pauseState then @systemScreen.show() else @systemScreen.hide()

      @pauseState
    
    mute: (e) ->
      e.preventDefault() if e
      @muteState = !@muteState
    
    gameOver: ->
      @ended = true
      @overScreen.show()
