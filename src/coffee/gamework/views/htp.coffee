define [
  'underscore'
  'config'
  'views/game'
  'easel'
], (_, Config, Game) ->
  class HTP extends Game
    
    delegateEvents: -> false
    afterHide: -> @game.restart()
    
    render: ->
      @paintObjects()
      @renderSupport()
      @paitQuest()

    #override
    renderSupport: -> false
      
    paintObjects: (stage) ->
      static_objects = new createjs.Container
      
      for obj in Config.objects by -1
        do (obj) =>
          el = new createjs.Bitmap(@game.queue.getResult(obj.img))
          el.setTransform(obj.x, obj.y, obj.scale, obj.scale)
          @screen.addChild(el)