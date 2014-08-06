define [
  'gamework'
  'game/views/htp'
  'game/views/game'
  'views/pause'
  'views/over'
], (Gamework, HTPScreen, GameScreen, PauseScreen, OverScreen) ->
  
  # simple Game
  
  class Game extends Gamework
    
    initScreens: ->
      @screens.push @gameScreen = new GameScreen @
      @screens.push @htpScreen = new HTPScreen @
      @screens.push @systemScreen = new PauseScreen @
      @screens.push @overScreen = new OverScreen @