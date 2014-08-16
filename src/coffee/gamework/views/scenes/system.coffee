define [
  'underscore'
  'config'
  'views/_base'
  'easel'
], (_, Config, Base) ->

  class System extends Base
    
    t: 200
    els: {}
    
    render: ->
      @paintObjects()
      @sysScreen = new createjs.Container
      @sysScreen.setTransform(@borderSize, @borderSize)
      
      @sysScreenA = new createjs.Shape
      @sysScreenA.graphics.beginFill("rgba(0,0,0,0.6)").drawRect(0, 0, Config.w2/2, Config.h2)
      
      @sysScreenB = new createjs.Shape
      @sysScreenB.graphics.beginFill("rgba(0,0,0,0.6)").drawRect(Config.w2/2, 0, Config.w2/2, Config.h2)
      
      @sysScreen.addChild @sysScreenA, @sysScreenB
      @childsRender()
      @screen.addChild(@sysScreen)
      
    paintObjects: (stage) ->
      static_objects = new createjs.Container
      
      for obj in Config.objects by -1
        do (obj) =>
          return if _.indexOf(Config.scenes['system'], obj.group) < 0
          @els[obj.group] ||= []
          @els[obj.group].push el = new createjs.Bitmap(gamework.queue.getResult(obj.img))
          el.visible = false
          el.setTransform(obj.x, obj.y, obj.scale, obj.scale)
          @screen.addChild(el)
    
    childsRender: -> false
    
    beforeShow: ->
      @sysScreenA.x = -618
      @sysScreenB.x = 618
      super

    afterShow: ->
      createjs.Tween.get(@sysScreenA).to({x:0}, @t)
      createjs.Tween.get(@sysScreenB).to({x:0}, @t).call => @callbackAfterShow()
      
    beforeHide: ->
      _.each _.flatten(@els), (el) -> el.visible = false
      @game.screens['game'].screen.visible = true
      createjs.Tween.get(@sysScreenA).to({x:-Config.w2/2}, @t)
      createjs.Tween.get(@sysScreenB).to({x:Config.w2/2}, @t).call => @callbackBeforeHide()
      
    callbackBeforeHide: -> @hide()
      
    callbackAfterShow: ->
      @game.screens['game'].screen.visible = false
      _.each _.flatten(@els), (el) -> el.visible = true
