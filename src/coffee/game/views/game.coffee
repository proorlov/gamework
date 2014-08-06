define [
  'underscore'
  'config'
  'views/game'
  'game/views/simple_game_obj'
  'easel'
], (_, Config, Game, SimpleGameObj) ->
  class SimpleGame extends Game
    
    visible: true
    
    render: ->
      @paintStaticObjects()
      @paitnScores()
      @showTime() if Config.needTime
      
      simpleGameObj = new SimpleGameObj @game
      @screen.addChild(simpleGameObj.screen)