define [
  'config'
  'helpers/mediator'
  'simplegame/index'
  'professions/views/scenes/game'
  'professions/views/scenes/htp'
], (Config, Mediator, SimpleGame, GameScene, HTPScene) ->
  
  # Professions
  
  class Game extends SimpleGame
    
    # constructor: ->
      # super
      # createjs.Sound.setMute(true)
      
    initsScenes: ->
      super
      @scenes.game = GameScene
      @scenes.htp = HTPScene
        
    nextPhase: -> false
    
    restart: ->
      @stats.words = []
      @screens['wait'].downCounter = @downCounter = Config.startTime
      @gamingTime = 0
      @points = 0
      Mediator.trigger new createjs.Event('change:score')
      
      @screens['game'].destroy()
      @currentScene = @screens['game'] = new GameScene @
      
      Mediator.trigger new createjs.Event('state:change', 'wait')

    soundHandler: ->
      super
      Mediator.on 'change:score:error', (e) => createjs.Sound.play("error")
      
      Mediator.on 'game:strike:on:success', ->
        createjs.Sound.stop()
        createjs.Sound.play("strike")
      
      Mediator.on 'game:strike:off:success', ->
        createjs.Sound.stop()
        createjs.Sound.play("music")
      
    tickHandler: (tick) ->
      if @currentState == 'wait'
        @screens['wait'].downCounter-= tick.delta
        if @screens['wait'].value() < 0
          Mediator.trigger new createjs.Event('state:change', "game")
        else
          @screens['wait'].dispatchEvent 'update'

      if @currentState == 'game' or @currentState == 'htp'
        @gamingTime += tick.delta
        if @screens[@currentState].timeLeft(@gamingTime) <= 0
          @gameOver()
        else
          @screens[@currentState].updateTimer(@gamingTime)
      
      @fpsLabel.text = Math.round(createjs.Ticker.getMeasuredFPS()) + " fps" if Config.debug
      
      @stage.update()

    how: (e) ->
      e.preventDefault() if e?
      if @currentState == 'htp' or @currentState == 'htp:success'
        @restart()
      else
        @screens['htp'] = @currentScene = new @scenes['htp'] @
        Mediator.trigger new createjs.Event('state:change', 'htp')

