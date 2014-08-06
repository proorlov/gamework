define [
  'underscore'
  'config'
  'views/system'
  'helpers/mediator'
  'easel'
], (_, Config, System, Mediator) ->
  class Over extends System
    
    delegateEvents: ->
      Mediator.on 'change:score', => @update()
    
    update: ->
      @score.text = "#{@game.points} points"
    
    childsRender: ->
      total = new createjs.Text("Total score:", "120px "+Config.font2_bold, "#F1F1F1")
      total.textAlign = "center"
      total.textBaseline = "alphabetic"
      total.setTransform(@game.w/2, 300)
      
      @score = score = new createjs.Text("#{@game.points} points", "120px "+Config.font2_thin, "#F1F1F1")
      score.textAlign = "center"
      score.textBaseline = "alphabetic"
      score.setTransform(@game.w/2, 420)
      
      @buttons = new createjs.Container
      
      nextButton = new createjs.Container
      
      fon = new createjs.Bitmap(@game.queue.getResult("button"))
      
      txt = new createjs.Text("NEXT", "30px "+Config.font2_reg, "#4A4A4A")
      txt.lineWidth = 327
      txt.textAlign = "center"
      txt.textBaseline = "alphabetic"
      txt.setTransform(163, 47)
      
      nextButton.addChild(fon, txt)
      nextButton.setTransform(@game.w/2 - nextButton.getBounds().width/2, @game.h*0.7 - nextButton.getBounds().height/2)
      nextButton.cursor = "pointer"
      nextButton.on "mousedown", =>
        @game.restart()
        Mediator.trigger new createjs.Event('state:change', 'game')
      
      @buttons.addChild(total, score, nextButton)
      
      @sysScreen.addChild @sysScreenA, @sysScreenB, @buttons

    afterShow: ->
      @sysScreenA.x = -618
      @sysScreenB.x = 618
      
      createjs.Tween.get(@sysScreenA).to({x:0}, @t)
      createjs.Tween.get(@sysScreenB).to({x:0}, @t).call =>
        @buttons.visible = true

    beforeHide: ->
      @buttons.visible = false
      createjs.Tween.get(@sysScreenA).to({x:-@game.w2/2}, @t)
      createjs.Tween.get(@sysScreenB).to({x:@game.w2/2}, @t).call => @hide()