define [
  'underscore'
  'config'
  'views/_base'
  'easel'
], (_, Config, Base) ->
  class Game extends Base
    
    visible: true
    
    render: ->
      @paintStaticObjects()
      @paitnScores()
      @showTime() if Config.needTime
      
    paintStaticObjects: (stage) ->
      static_objects = new createjs.Container
      
      for obj in Config.static_objects by -1
        do (obj) =>
          el = new createjs.Bitmap(@game.queue.getResult(obj.img))
          el.setTransform(obj.x, obj.y, obj.scale, obj.scale)
          @screen.addChild(el)

    paitnScores: ->
      scoreContainer = new createjs.Container
      
      shape = new createjs.Shape
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawRoundRectComplex(@game.w-@game.borderSize-400, 0, 400, 130, 0, 0, 0, 10);
      
      txt = new createjs.Text("Your score: #{@game.points}", "30px "+Config.font2_reg, "#FFF")
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(@game.w-@game.borderSize-280, 75)
      
      scoreContainer.addChild(shape, txt)
      @screen.addChild(scoreContainer)
      

    showTime: ->
      @timeLabel = new createjs.Text("", "bold 40px "+Config.font3_bold, "#EA5151")
      @timeLabel.textAlign = "center"
      @timeLabel.textBaseline = "alphabetic"
      @timeLabel.x = 105
      @timeLabel.y = 115
      @timeCircle = new createjs.Shape
      @timeCircle.cache(0, 0, 146, 146)
      @timeCircle.setTransform(30, 30)
      @screen.addChild(@timeCircle, @timeLabel)

    updateTimer: (time) ->
      return unless Config.needTime
      
      @timeLabel.text = Config.gameTime/1000 - Math.floor(time/1000)
      @timeCircle.graphics.clear()
      @timeCircle.graphics.beginFill("#4A4A4A").drawCircle(73, 73, 73).endFill()
      @timeCircle.graphics.setStrokeStyle(3).beginStroke("#FFFFFF").drawCircle(73, 73, 45).endStroke()
      @timeCircle.graphics.beginFill("#FFFFFF").drawCircle(73, 73, 38).endFill()
      @timeCircle.graphics.setStrokeStyle(16).beginStroke("#FBFBFB").arc(73, 73, 60, -Math.PI / 2, -Math.PI / 2 + 2 * Math.PI * time / Config.gameTime)
      @timeCircle.updateCache()

    show: ->
      @screen.visible = true

    hide: ->
      @screen.visible = false