define [
  'gamework'
  'scenes/system/wait'
  'scenes/system/pause'
  'scenes/system/over'
  'game/views/scenes/htp'
  'scenes/htp/success'
  'game/views/scenes/game'
], (Gamework, WaitScene, PauseScene, OverScene, HTPScene, HTPSuccessScene, GameScene) ->
  # simple Game
  
  class Game extends Gamework
    
    #Override
    initStates: ->
      @states =
        'wait':  ['game']
        'game':  ['htp', 'pause', 'over']
        'htp':   ['game', 'htp:success']
        'pause': ['game']
        'over':  ['game']
        'htp:success':  ['game']
      
    #Override
    initsScenes: ->
      @scenes = 
        'wait':         WaitScene
        'game':         GameScene
        'htp':          HTPScene
        'htp:success':  HTPSuccessScene
        'pause':        PauseScene
        'over':         OverScene