define [
  'underscore'
  'config'
  'views/_base'
  'helpers/mediator'
  'simplegame/views/simple_game_obj'
  'easel'
], (_, Config, Base, Mediator, SimpleGameObj) ->
  
  class Billboard extends SimpleGameObj
    
    stats:
      word: ""
      strike: 0
      score: 0
      errors: 0
      timer: 0

    constructor: (parent, professionName, billboardPosition) ->
      @billboardPosition = billboardPosition
      @professionName = professionName
      
      super
      
    isCurrectWord: -> @parent.currentWord.id == @professionName.id

    undelegateEvents: ->
      @target.removeAllEventListeners()

    delegateEvents: ->
      @target.addEventListener 'mouseover', =>
        @light.gotoAndPlay 'on'
        @light_bg.visible = true

      @target.addEventListener 'mouseout',  =>
        @light.gotoAndPlay 'off'
        @light_bg.visible = false
      
      @on 'change:score:success', =>
        @error.visible = false
        @resetStats()
        @game.stats.words.push(@stats) if @isCurrectWord()
        
      @on 'change:score:error', =>
        @error_add() if @isCurrectWord()
      
      Mediator.on 'change:score:success', => @dispatchEvent 'change:score:success'
      Mediator.on 'change:score:error', => @dispatchEvent 'change:score:error'
      
      @target.addEventListener 'click', =>
        @update() if @isCurrectWord()
        @parent.chooseItem(@)
    
    error_add: -> @stats.errors+=1
    
    update: ->
      timer = @game.gamingTime - @s_time
      strike = if timer <= Config.strike && @stats.errors == 0 then 1 else 0
      @stats.score = @countPoint()
      @stats.strike = strike
      @stats.timer = timer
      @

    countPoint: ->
      if @parent.consecutive_strikes >= 5
        Config.points*2
      else
        Config.points
    
    ##
    # deprecated
    currentQuest: -> false
    paitQuest: -> false
    #
    ##
    
    render: ->
      @target = new createjs.Container
      
      @profession = new createjs.Bitmap(@game.queue.getResult(@professionName.id))
      @profession.setTransform( (155-@profession.getBounds().width/2), (120-@profession.getBounds().height/2) )
      
      @bg = new createjs.Shape()
      @bg.graphics.beginFill(@professionName.color).drawRect(0, 0, 320, 240)
      
      data = {
        framerate:  2
        images:     [ @game.queue.getResult('light') ]
        frames:     { width:321, height:72, count:2, regX: 0, regY:0 }
        animations: { off: [0], on: [1] }
      }
      
      @light = new createjs.Sprite(new createjs.SpriteSheet(data), "off")
      @light_bg = new createjs.Bitmap(@game.queue.getResult('light_bg'))
      @light_bg.visible = false
      
      @error = new createjs.Bitmap(@game.queue.getResult('error_bg'))
      @error.visible = false
      
      @target.setTransform @billboardPosition.x, @billboardPosition.y, @billboardPosition.scaleX, @billboardPosition.scaleY
      @light.setTransform 0, 170

      @target.addChild @bg, @light_bg, @profession, @light, @error
      @screen.addChild @target 
      
    destroy: ->
      @undelegateEvents()
      @screen.removeAllEventListeners()
      @removeAllEventListeners()
      @screen.removeChild(@quest)
      @parent.bb_container.removeChild @screen

    show: -> @afterShow()
      
    afterShow: -> @resetStats()
      
    resetStats: ->
      @stats =
        word: @professionName.id
        strike: 0
        score: 0
        errors: 0
        timer: 0
      
      @s_time = @game.gamingTime

