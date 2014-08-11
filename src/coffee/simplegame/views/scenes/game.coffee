define [
  'underscore'
  'config'
  'gamework'
  'scenes/game'
  'simplegame/views/simple_game_obj'
  'helpers/mediator'
  'easel'
], (_, Config, Gamework, Game, SimpleGameObj, Mediator) ->
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
      @paintGameObj()
      @animateObjs()
      
    paintGameObj: ->
      @simpleGameObj = new SimpleGameObj @, @game
      @simpleGameObj.dispatchEvent 'show'
      
      @simpleGameObj.on 'updated', =>
        @simpleGameObj.destroy()
        @paintGameObj()
        Mediator.trigger 'next:phase'
      
    animateObjs: ->
      _.each @animated_objs, (obj) =>
        animate = @animates[obj.obj.animate](obj.obj)
        createjs.Tween.get(obj.el, {loop:true})
         .to(animate.props, animate.duration)
      
