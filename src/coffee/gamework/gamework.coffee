define [
  'underscore'
  'config'
  'views/game'
  'views/system/pause'
  'views/system/over'
  'views/htp'
  'helpers/mediator'
  'easel'
], (_, Config, GameScreen, PauseScreen, OverScreen, HTPScreen, Mediator) ->
  
  class Gamework
    version: '0.1.1'
  
    screens: []

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
      @render()
      
      @gamingTime = 0
      @timerRun = true
      
      createjs.Ticker.addEventListener("tick", (tick) => @tickHandler(tick))
      
    render: ->
      document.getElementById("gameworkLoading").style.display = "none"
      
      @showFPS() if Config.debug
      
      @paintBackground()
      @initScreens()
      _.each @screens, (screen) => @stage.addChild screen.screen
      @paintBorder()
    
    initScreens: ->
      @screens.push @gameScreen = new GameScreen @
      @screens.push @systemScreen = new PauseScreen @
      @screens.push @overScreen = new OverScreen @
      @screens.push @htpScreen = new HTPScreen @
  
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
      @points = 0
      Mediator.dispatchEvent 'change:score'
      
      # fix, state machine
      _.each @screens, (screen) -> screen.screen.visible = false
      @gameScreen.screen.visible = true
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
        # fix, state machine
        _.each @screens, (screen) -> screen.screen.visible = false
        @htpScreen.screen.visible = true
        #
        @timerRun = false
        @htpScreen.show()
      else
        # fix, state machine
        _.each @screens, (screen) -> screen.screen.visible = false
        @gameScreen.screen.visible = true
        #
        @timerRun = true
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
      # fix, state machine
      _.each @screens, (screen) -> screen.screen.visible = false
      @overScreen.screen.visible = true
      #
      @overScreen.show()

    addScore: (screen) ->
      @points += 1
      if screen
        screen.dispatchEvent 'change:score'
      else
        Mediator.dispatchEvent 'change:score'
