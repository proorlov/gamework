define [
  'underscore'
  'config'
  'views/_base'
  'helpers/mediator'
  'easel'
], (_, Config, Base, Mediator) ->
  class Game extends Base
    
    animated_objs: []
    
    delegateEvents: ->
      Mediator.on 'change:score', => @update()
    
    update: ->
      @txt.text = "Your score: #{@game.points}"
    
    # Override
    render: ->
      @paintObjects()
      @paitnScores()
      @showTime() if Config.needTime
      @paitQuest()
      
    paitQuest: ->
      @quests = @game.queue.getResult('data').quests
      
      txt = new createjs.Text(@quests[0], "30px "+Config.font2_reg, "#4C4C4C")
      txt.textAlign = "left"
      txt.textBaseline = "alphabetic"
      txt.setTransform 220, 100
      
      @screen.addChild(txt)
      
    paintObjects: (stage) ->
      static_objects = new createjs.Container
      
      for obj in Config.objects by -1
        do (obj) =>
          if obj.dynamic
            @paintDymamicObj(obj)
          else
            el = new createjs.Bitmap(@game.queue.getResult(obj.img))
            el.setTransform(obj.x, obj.y, obj.scale, obj.scale)
            @screen.addChild(el)

    paintDymamicObj: (obj) ->
      el = new createjs.Bitmap(@game.queue.getResult(obj.img))
      el.setTransform(obj.x, obj.y, obj.scale, obj.scale)
      @animated_objs.push {el: el, obj: obj}
      
      x = obj.x
      x1 = while x<(@game.w+obj.width)
        x+= obj.distance

      x = obj.x
      x = while x>0-obj.width
        x-= obj.distance
      
      @screen.addChild(el)
      
      _.each _.union(x, x1), (x) =>
        nel = el.clone()

        nobj = _.clone(obj)
        nobj.x = x
        
        nel.setTransform(nobj.x, nobj.y, nobj.scale, nobj.scale)

        @animated_objs.push {el: nel, obj: nobj}
        @screen.addChild(nel)
      
    
    paitnScores: ->
      scoreContainer = new createjs.Container
      
      shape = new createjs.Shape
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawRoundRectComplex 0, 0, 400, 130, 0, 0, 0, 10
      
      @txt = new createjs.Text("Your score: #{@game.points}", "30px "+Config.font2_reg, "#FFF")
      @txt.textAlign = "left"
      @txt.textBaseline = "alphabetic"
      @txt.setTransform 30, 75
      
      scoreContainer.setTransform @game.w-@game.borderSize-400, 0 
      
      scoreContainer.addChild(shape, @txt)
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

    timeLeft: (time) ->
      Config.gameTime/1000 - Math.floor(time/1000)

    updateTimer: (time) ->
      return unless Config.needTime
      
      @timeLabel.text = @timeLeft(time)
      @timeCircle.graphics.clear()
      @timeCircle.graphics.beginFill("#4A4A4A").drawCircle(73, 73, 73).endFill()
      @timeCircle.graphics.setStrokeStyle(3).beginStroke("#FFFFFF").drawCircle(73, 73, 45).endStroke()
      @timeCircle.graphics.beginFill("#FFFFFF").drawCircle(73, 73, 38).endFill()
      @timeCircle.graphics.setStrokeStyle(16).beginStroke("#FBFBFB").arc(73, 73, 60, -Math.PI / 2, -Math.PI / 2 + 2 * Math.PI * time / Config.gameTime)
      @timeCircle.updateCache()
