define [
  'underscore'
  'config'
  'views/_base'
  'easel'
], (_, Config, Base) ->
  class Game extends Base
    
    render: ->
      @paintBackground()
      @paintStaticObjects()
      @showTime() if Config.needTime
  
    paintBackground: ->
      background = new createjs.Bitmap @game.queue.getResult("background")
      background.cache(0, 0, @game.w, @game.h)
      @game.stage.addChild(background)
      
    paintStaticObjects: (stage) ->
      static_objects = new createjs.Container
      
      for obj in Config.static_objects by -1
        do (obj) =>
          el = new createjs.Bitmap(@game.queue.getResult(obj.img))
          el.setTransform(obj.x, obj.y, obj.scale, obj.scale)
          @game.stage.addChild(el)
      
    showTime: ->
      @timeLabel = new createjs.Text("", "bold 40px "+Config.font3_bold, "#EA5151")
      @timeLabel.textAlign = "center"
      @timeLabel.textBaseline = "alphabetic"
      @timeLabel.x = 105
      @timeLabel.y = 115
      @timeCircle = new createjs.Shape
      @timeCircle.cache(0, 0, 146, 146)
      @timeCircle.setTransform(30, 30)
      @game.workstage.addChild(@timeCircle, @timeLabel)

    updateTimer: (time) ->
      if Config.needTime
        @timeLabel.text = Config.gameTime/1000 - Math.floor(time/1000)
        @timeCircle.graphics.clear()
        @timeCircle.graphics.beginFill("#4A4A4A").drawCircle(73, 73, 73).endFill()
        @timeCircle.graphics.setStrokeStyle(3).beginStroke("#FFFFFF").drawCircle(73, 73, 45).endStroke()
        @timeCircle.graphics.beginFill("#FFFFFF").drawCircle(73, 73, 38).endFill()
        @timeCircle.graphics.setStrokeStyle(16).beginStroke("#FBFBFB").arc(73, 73, 60, -Math.PI / 2, -Math.PI / 2 + 2 * Math.PI * time / Config.gameTime)
        @timeCircle.updateCache()