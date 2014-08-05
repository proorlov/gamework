define [
  'underscore'
  'config'
  'views/game'
  'views/system'
  'views/htp'
  'easel'
], (_, Config, GameScreen, SystemScreen, HTPScreen) ->
  
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
      
      @gameScreen = new GameScreen @
      @systemScreen = new SystemScreen @
      # @htpScreen = new HTPScreen @
      
      @stage.addChild @workstage
      
      @showFPS() if Config.debug
      
      @paintBorder()
      @stage.update()
      
      @gamingTime = 0
      @timerRun = true
      
      createjs.Ticker.addEventListener("tick", (tick) => @tickHandler(tick))

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
      
    restartGame: ->
      @ended = false
      @started = false
      @pauseState = false
      @downCounter = Config.startTime
      @gamingTime = 0
      @systemScreen.pauseButtons.visible = false
      @systemScreen.overButtons.visible = false

    startGame: ->
      return if @started
      
      @started = true
      @gamingTime = 0
      @timerRun = true
      @showSystemScreen(false)

    showSystemScreen: (show) ->
      t = 200
      if show
        @systemScreen.sysScreen.visible = true
        @workstage.visible = false
        createjs.Tween.get(@systemScreen.sysScreenA).to({x:0}, t)
        createjs.Tween.get(@systemScreen.sysScreenB).to({x:0}, t).call =>
          if @ended
            @systemScreen.overButtons.visible = true
            @systemScreen.pauseButtons.visible = false
          else
            @systemScreen.overButtons.visible = false
            @systemScreen.pauseButtons.visible = true
      else
        @systemScreen.overButtons.visible = false
        @systemScreen.pauseButtons.visible = false
        createjs.Tween.get(@systemScreen.sysScreenA).to({x:-@w2/2}, t);
        createjs.Tween.get(@systemScreen.sysScreenB).to({x:@w2/2}, t).call =>
          @systemScreen.sysScreen.visible = false
          @workstage.visible = true

    showHowScreen: (show) ->
      console.log show

    how: ->
      @howState = !@howState
      @showHowScreen if @howState then true else false
      @howState
      
    pause: ->
      if @timerRun
        @pauseState = !@pauseState
        if @pauseState
          @showSystemScreen true
        else
          @showSystemScreen false
      @pauseState
    
    mute: -> @muteState = !@muteState
    
    gameOver: ->
      @ended = true
      @showSystemScreen true
