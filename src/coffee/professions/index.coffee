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

    soundHandler: ->
      Mediator.on 'state:change:success', =>
        switch @currentState
          when 'htp'
            createjs.Sound.stop()
            createjs.Sound.play("music", loop: -1)
          when 'game'
            createjs.Sound.stop()
            if @isStrike
              createjs.Sound.play("strike", loop: -1)
            else
              createjs.Sound.play("music", loop: -1)
          when 'over'
            createjs.Sound.stop()
            createjs.Sound.play("over", loop: -1)
          when 'pause'
            createjs.Sound.stop()
          when 'wait'
            createjs.Sound.stop()
        @setMute(@isMute)
                
      Mediator.on 'billboard:success', (e) => createjs.Sound.play("success")
        
      Mediator.on 'change:score:error', (e) => createjs.Sound.play("error")
      
      Mediator.on 'game:strike:on:success', =>
        @isStrike = true
        createjs.Sound.stop()
        createjs.Sound.play("strike", loop: -1)
      
      Mediator.on 'game:strike:off:success', =>
        @isStrike = false
        createjs.Sound.stop()
        createjs.Sound.play("music", loop: -1)
      
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
