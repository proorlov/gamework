define [
  'gamework'
  'game/views/htp'
  'game/views/game'
  'views/system/pause'
  'views/system/over'
  'views/system/wait'
], (Gamework, HTPScreen, GameScreen, PauseScreen, OverScreen, WaitScreen) ->
  
  # simple Game
  
  class Game extends Gamework
    
    initScreens: ->
      @screens['game'] = new GameScreen @
      @screens['wait'] = new WaitScreen @
      @screens['htp'] = new HTPScreen @
      @screens['pause'] = new PauseScreen @
      @screens['over'] = new OverScreen @