define [
  'gamework'
  'game/views/htp'
  'game/views/game'
  'views/system/pause'
  'views/system/over'
  'views/system/wait'
  'views/htp/success'
], (Gamework, HTPScreen, GameScreen, PauseScreen, OverScreen, WaitScreen, SuccessScreen) ->
  
  # simple Game
  
  class Game extends Gamework
    
    initScreens: ->
      @screens['game'] = new GameScreen @
      @screens['wait'] = new WaitScreen @
      @screens['htp'] = new HTPScreen @
      @screens['pause'] = new PauseScreen @
      @screens['over'] = new OverScreen @
      @screens['htp:success'] = new SuccessScreen @