define [
  'underscore'
  'config'
  'helpers/mediator'
  'scenes/system/wait'
  'scenes/system/pause'
  'scenes/system/over'
  'scenes/htp'
  'scenes/htp/success'
  'scenes/game'
  'easel'
], (_, Config, Mediator, WaitScene, PauseScene, OverScene, HTPScene, HTPSuccessScene, GameScene) ->
  
  class Gamework
    version: '0.1.1'
  
    screens: []
    currentState: 'wait'
    gamingTime: 0
    points: 0
    isMute: false
    
    stats:
      strike: 0
      score: 0
      errors: 0
      timer: 0
      words: []
    
    constructor: ->
      @initStates()
      @initsScenes()
      
      @canvas = document.getElementById("gameworkCanvas")
      createjs.Ticker.setFPS(30)
      
      @stage = new createjs.Stage(@canvas)
      @stage.enableMouseOver(10)
      
      @queue = new createjs.LoadQueue(true)
      @queue.installPlugin(createjs.Sound)
      @queue.addEventListener("complete", => @start())
      @queue.loadManifest(Config.manifest)
      
      @screen = new createjs.Container
      
      Mediator.on 'next:phase', => @nextPhase()
      
    #Override
    initStates: ->
      @states =
        'wait':  ['game']
        'game':  ['htp', 'pause', 'over']
        'htp':   ['game', 'htp:success']
        'pause': ['game']
        'over':  ['game']
        'htp:success':  ['game']
      
    #Override
    initsScenes: ->
      @scenes = 
        'wait':         WaitScene
        'game':         GameScene
        'htp':          HTPScene
        'htp:success':  HTPSuccessScene
        'pause':        PauseScene
        'over':         OverScene
    
    start: ->
      @render()
      @soundHandler()
      createjs.Ticker.addEventListener("tick", (tick) => @tickHandler(tick))
      Mediator.on 'state:change', (event) => @changeState(event)
      
    render: ->
      document.getElementById("gameworkLoading").style.display = "none"
      
      @paintBackground()
      @showFPS() if Config.debug
      @initCurrentScene()
      @stage.addChild(@screen)
      @paintBorder()
    
    #Override
    initCurrentScene: ->
      @screens[@currentState] ||= @currentScene = new @scenes[@currentState] @
      @screens[@currentState].dispatchEvent 'show'
    
    changeState: (event) ->
      to = event.bubbles
      return console.info "unspecified transition" if _.indexOf(@states[@currentState], to) < 0
      @screens[@currentState].dispatchEvent 'hide'
      @currentState = to
      @initCurrentScene()
      
      Mediator.trigger new createjs.Event('state:change:success')
  
    paintBackground: ->
      background = new createjs.Bitmap @queue.getResult("background")
      background.cache(0, 0, Config.w, Config.h)
      @stage.addChild(background)

    showFPS: ->
      @fpsLabel = new createjs.Text("-- fps", "18px "+Config.font, "#FFFFFF")
      @fpsLabel.setTransform(15, 15)
      @stage.addChild(@fpsLabel)
    
    paintBorder: ->
      @border = new createjs.Shape
      color = "#4A4A4A"
      @border.graphics.setStrokeStyle(Config.borderSize).beginStroke(color)
      @border.graphics.drawRoundRect(Config.borderSize/2, Config.borderSize/2, Config.w - Config.borderSize, Config.h - Config.borderSize, 1)
      @border.graphics.endStroke()
      @border.cache(0, 0, Config.w, Config.h)
      @stage.addChild(@border)
      
    tickHandler: (tick) ->
      if @currentState == 'wait'
        @screens['wait'].downCounter-= tick.delta
        if @screens['wait'].value() < 0
          Mediator.trigger new createjs.Event('state:change', "game")
        else
          @screens['wait'].dispatchEvent 'update'

      if @currentState == 'game'
        @gamingTime += tick.delta
        if @screens['game'].timeLeft(@gamingTime) <= 0
          Mediator.trigger new createjs.Event('state:change', "over")
        else
          @screens['game'].updateTimer(@gamingTime)
      
      @fpsLabel.text = Math.round(createjs.Ticker.getMeasuredFPS()) + " fps" if Config.debug
      
      @stage.update()
      
    restart: ->
      @downCounter = Config.startTime
      @gamingTime = 0
      @points = 0
      Mediator.trigger new createjs.Event('change:score')

    how: (e) ->
      e.preventDefault() if e
      if @currentState == 'htp' or @currentState == 'htp:success'
        state = 'game'
      else
        state = 'htp'
      Mediator.trigger new createjs.Event('state:change', state)
      @currentState == 'htp'
      
    pause: (e) ->
      e.preventDefault() if e
      state = if @currentState != 'pause' then 'pause' else 'game'
      Mediator.trigger new createjs.Event('state:change', state)
      @currentState == 'pause'
    
    gameOver: ->
      e.preventDefault() if e
      state = if @currentState != 'over' then 'over' else 'game'
      Mediator.trigger new createjs.Event('state:change', state)
    
    mute: (e) ->
      e.preventDefault() if e
      createjs.Sound.setMute(@isMute = !@isMute)
      @isMute

    addScore: (points) ->
      @points += points
      Mediator.trigger new createjs.Event('change:score')
      Mediator.trigger new createjs.Event('change:score:success')

    soundHandler: ->
      Mediator.on 'state:change:success', =>
        switch @currentState
          when 'game'
            createjs.Sound.stop()
            createjs.Sound.play("music", loop: -1)
          when 'over'
            createjs.Sound.stop()
            createjs.Sound.play("over", loop: -1)
          when 'pause'
            createjs.Sound.stop()
                
      Mediator.on 'change:score:success', (e) =>
        createjs.Sound.play("success")
        
    nextPhase: ->
      @stats.strike = 0
      @stats.timer = 0
      @stats.errors = 0
      _.each @stats.words, (word) =>
        @stats.strike += word.strike
        @stats.timer += word.timer
        @stats.errors += word.errors
      @stats.score = @points
      localStorage.setItem "result", JSON.stringify(@stats)
