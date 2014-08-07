define [
  'underscore'
  'config'
  'helpers/mediator'
  'easel'
], (_, Config, Mediator) ->
  
  class Gamework
    version: '0.1.1'
  
    screens: []
    
    currentState: 'wait'
    
    states:
      'wait':         ['game']
      'game':         ['htp', 'pause', 'over']
      'htp':          ['game', 'htp:success']
      'htp:success':  ['game']
      'pause':        ['game']
      'over':         ['game']

    w: 1248
    h: 794
    borderSize: 12
    w2: Gamework::w - Gamework::borderSize
    h2: Gamework::h - Gamework::borderSize
      
    gamingTime: 0
    
    points: 0
    
    constructor: () ->
      @canvas = document.getElementById("gameworkCanvas")
      createjs.Ticker.setFPS(30)
      
      @stage = new createjs.Stage(@canvas)
      @stage.enableMouseOver(10)
      
      @queue = new createjs.LoadQueue(true)
      @queue.addEventListener("complete", => @start())
      @queue.loadManifest(Config.manifest)
     
    start: ->
      @render()
      createjs.Ticker.addEventListener("tick", (tick) => @tickHandler(tick))
      Mediator.on 'state:change', (event) => @changeState(event)
      
    render: ->
      document.getElementById("gameworkLoading").style.display = "none"
      
      @paintBackground()
      @showFPS() if Config.debug
      @initScreens()
      
      @screens[@currentState].show()
      
      @paintBorder()
    
    #Override
    initScreens: ->
      @screens['game'] = new GameScreen @
      @screens['wait'] = new WaitScreen @
      @screens['htp'] = new HTPScreen @
      @screens['pause'] = new PauseScreen @
      @screens['over'] = new OverScreen @
      @screens['htp:success'] = new SuccessScreen @
    
    changeState: (event) ->
      to = event.bubbles
      return console.info "unspecified transition" if _.indexOf(@states[@currentState], to) < 0
      
      @screens[@currentState].dispatchEvent 'hide'
      @screens[to].dispatchEvent 'show'
      
      @currentState = to 
  
    paintBackground: ->
      background = new createjs.Bitmap @queue.getResult("background")
      background.cache(0, 0, @w, @h)
      @stage.addChild(background)

    showFPS: ->
      @fpsLabel = new createjs.Text("-- fps", "18px "+Config.font, "#FFFFFF")
      @fpsLabel.setTransform(15, 15)
      @stage.addChild(@fpsLabel)
    
    paintBorder: ->
      @border = new createjs.Shape
      color = "#4A4A4A"
      @border.graphics.setStrokeStyle(@borderSize).beginStroke(color)
      @border.graphics.drawRoundRect(@borderSize/2, @borderSize/2, @w - @borderSize, @h - @borderSize, 1)
      @border.graphics.endStroke()
      @border.cache(0, 0, @w, @h)
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
      state = if @currentState != 'htp' then 'htp' else 'game'
      Mediator.trigger new createjs.Event('state:change', state)
      
    pause: (e) ->
      e.preventDefault() if e
      state = if @currentState != 'pause' then 'pause' else 'game'
      Mediator.trigger new createjs.Event('state:change', state)
    
    gameOver: ->
      e.preventDefault() if e
      state = if @currentState != 'over' then 'over' else 'game'
      Mediator.trigger new createjs.Event('state:change', state)
    
    mute: (e) ->
      e.preventDefault() if e
      @muteState = !@muteState

    addScore: (points) ->
      @points += points
      Mediator.trigger new createjs.Event('change:score')
