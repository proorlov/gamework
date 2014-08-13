define [
  'config'
  'helpers/mediator'
  'simplegame/index'
  'professions/views/scenes/game'
  'professions/views/scenes/htp'
], (Config, Mediator, SimpleGame, GameScene, HTPScene) ->
  
  # Professions
  
  class Game extends SimpleGame
    
    constructor: ->
      super
      createjs.Sound.setMute(true)
      
    initsScenes: ->
      super
      @scenes.game = GameScene
      @scenes.htp = HTPScene
        
    nextPhase: -> false
    
    restart: ->
      super
      @stats.words = []
      @screens['game'].destroy()
      @currentScene = @screens['game'] = new GameScene @
      
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
      
      super

    soundHandler: ->
      super
      Mediator.on 'change:score:error', (e) => createjs.Sound.play("error")
      
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
      
    restart: ->
      @screens['wait'].downCounter = @downCounter = Config.startTime
      @gamingTime = 0
      @points = 0
