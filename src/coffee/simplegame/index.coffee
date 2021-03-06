define [
  'gamework'
  'scenes/system/wait'
  'scenes/system/pause'
  'scenes/system/over'
  'simplegame/views/scenes/htp'
  'scenes/htp/success'
  'simplegame/views/scenes/game'
], (Gamework, WaitScene, PauseScene, OverScene, HTPScene, HTPSuccessScene, GameScene) ->
  # simple Game
  
  class Game extends Gamework
    
    initStates: ->
      @states =
        'wait':  ['game']
        'game':  ['htp', 'pause', 'over']
        'htp':   ['game', 'htp:success', 'wait']
        'pause': ['game', 'wait']
        'over':  ['game', 'wait', 'htp']
        'htp:success':  ['game', 'wait']
      
    initsScenes: ->
      @scenes = 
        'wait':         WaitScene
        'game':         GameScene
        'htp':          HTPScene
        'htp:success':  HTPSuccessScene
        'pause':        PauseScene
        'over':         OverScene