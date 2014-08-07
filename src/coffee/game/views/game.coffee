define [
  'underscore'
  'config'
  'gamework'
  'views/game'
  'game/views/simple_game_obj'
  'easel'
], (_, Config, Gamework, Game, SimpleGameObj) ->
  class SimpleGame extends Game
    
    animates:
      left: (obj) ->
        x = obj.x-obj.distance
        props: { x: x }, duration: obj.duration
      right: (obj) ->
        x = obj.x+obj.distance
        props: { x: x }, duration: obj.duration
    
    render: ->
      @paintObjects()
      
      @paitnScores()
      @showTime() if Config.needTime
      @paitQuest()
      
      @simpleGameObj = new SimpleGameObj @game
      
    afterShow: ->
      @screen.addChild @simpleGameObj.screen
      @simpleGameObj.dispatchEvent 'show'
      
      @animateObjs()
      
    animateObjs: ->
      _.each @animated_objs, (obj) =>
        animate = @animates[obj.obj.animate](obj.obj)
        createjs.Tween.get(obj.el, {loop:true})
         .to(animate.props, animate.duration)
      
