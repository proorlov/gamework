define [
  'config'
  'helpers/mediator'
  'simplegame/index'
  'professions/views/scenes/game'
  'professions/views/scenes/htp'
], (Config, Mediator, SimpleGame, GameScene, HTPScene) ->
  
  # Professions
  
  class Game extends SimpleGame
    
    currentMusic: 'music'
    
    constructor: ->
      Mediator.on 'game:strike:on:success', => @addStrike()
      super
      
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

    initSounds: ->
      @sounds.strike = createjs.Sound.play("strike", loop: -1)
      super

    soundHandler: (e) ->
      if @isTransaction 'wait', 'game', e
        createjs.Sound.stop()
        @sounds.music.play loop: -1

      if @isTransaction 'pause', 'game', e
        if @currentMusic == 'music'
          @sounds.music.play loop: -1
        else
          @sounds.strike.play loop: -1

      if @isTransaction 'game', 'pause', e
        @sounds.music.pause()
        @sounds.strike.pause() if _.has @sounds, 'strike'
        
      if @isTransaction 'game', 'htp', e
        createjs.Sound.stop()
        @sounds.music.play(loop: -1)

      if @isTransaction 'game', 'over', e
        createjs.Sound.stop()
        @sounds.over.play loop: -1

      if (@isTransaction 'over', 'wait', e) or
         (@isTransaction 'htp:success', 'wait', e)
        createjs.Sound.stop()

    soundEventsDispatch: ->
      Mediator.on 'change:score:error', (e) => createjs.Sound.play("error")
      Mediator.on 'billboard:success', (e) => createjs.Sound.play("success")
      Mediator.on 'change:score:error', (e) => createjs.Sound.play("error")
      
      Mediator.on 'game:strike:on:success', =>
        return unless @currentState == 'game'
        @currentMusic = 'strike'
        @sounds.music.pause()
        @sounds.strike.play loop: -1
      
      Mediator.on 'game:strike:off:success', =>
        return unless @currentState == 'game'
        @currentMusic = 'music'
        @sounds.music.play loop: -1
        @sounds.strike.stop()
        
      
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
        
    nextPhase: ->
      @stats.timer = 0
      @stats.errors = 0
      _.each @stats.words, (word) =>
        @stats.timer += word.timer
        @stats.errors += word.errors
      @stats.score = @points
      @saveResult()

    ##
    # override
    #      
    saveResult: -> localStorage.setItem "result", JSON.stringify(@stats)
    ##

    addStrike: -> @stats.strike += 1
    
    setTimeout: (callback, duration) ->
      time = @gamingTime
      timer = setInterval (=>
        if @gamingTime-time >= duration
          callback()
          clearInterval(timer) 
      ), 100
