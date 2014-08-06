define [
  'gamework'
  'game/views/game'
], (Gamework, GameScreen) ->
  
  # simple Game
  
  class Game extends Gamework
      
    initMainScreen: ->
      @screens.push @gameScreen = new GameScreen @