define [
  'helpers/mediator'
  'simplegame/index'
  'professions/views/scenes/game'
], (Mediator, SimpleGame, GameScene) ->
  
  # Professions
  
  class Game extends SimpleGame
      
    initsScenes: ->
      super
      @scenes.game = GameScene
        
    nextPhase: -> false
      # @stats.strike = 0
      # @stats.timer = 0
      # @stats.errors = 0
#       
      # _.each @stats.words, (word) =>
        # @stats.strike += word.strike
        # @stats.timer += word.timer
        # @stats.errors += word.errors
      # @stats.score = @points
      #localStorage.setItem "result", JSON.stringify(@stats)
    
    restart: ->
      super
      @screens['game'].reset()
      
    gameOver: ->
      console.log @screens['game'].stats
      super

    soundHandler: ->
      super
      Mediator.on 'change:score:error', (e) => createjs.Sound.play("error")
