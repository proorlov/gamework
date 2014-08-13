define [
  'underscore'
  'config'
  'views/_base'
  'helpers/mediator'
  'simplegame/views/simple_game_obj'
  'easel'
], (_, Config, Base, Mediator, SimpleGameObj) ->
  
  class Billboard extends SimpleGameObj

    constructor: (parent, params) ->
    
      @stats =
        word: ""
        strike: 0
        score: 0
        errors: 0
        timer: 0
      
      @params = params
      super
      
    isCurrectWord: -> @parent.currentWord.id == @params.word.id

    undelegateEvents: ->
      @target.removeAllEventListeners()
      @screen.removeAllEventListeners()
      @removeAllEventListeners()

    delegateEvents: ->
      @target.addEventListener 'mouseover', =>
        unless @error.visible
          @light.gotoAndPlay 'on'
          @light_bg.visible = true

      @target.addEventListener 'mouseout',  =>
        @light.gotoAndPlay 'off'
        @light_bg.visible = false
      
      @on 'change:score:success', =>
        @error.visible = false
        @resetStats()
        if @isCurrectWord()
          @animateMask()
        
      @on 'change:score:error', =>
        @error.visible = false
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
      @game.stats.words.push(@stats)
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
      @billboard = new createjs.Container
      
      @profession = new createjs.Bitmap(@game.queue.getResult(@params.word.id))
      @profession.setTransform( (155-@profession.getBounds().width/2), (120-@profession.getBounds().height/2) )
      
      @bg = new createjs.Shape()
      @bg.graphics.beginFill(@params.word.color).drawRect(0, 0, 320, 240)
      
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
      
      @target.setTransform @params.position.x, @params.position.y, @params.position.scaleX, @params.position.scaleY
      @light.setTransform 0, 170
      
      @billboard.addChild @bg, @light_bg, @profession
      @target.addChild @billboard, @light, @error
      @screen.addChild @target 
      
    paitMask: ->
      width = 20
      @box = new createjs.Shape()
      @paintBoxForMask(width)
      @target.mask = @box
      
    animateMask: ->
      width = 20
      @interval = setInterval (
        =>
          @box.graphics.clear()
          width -= 1
          if width <= 0
            @destroy()
            clearInterval @interval
          @paintBoxForMask(width)
       ), 35
    
    paintBoxForMask: (widthCell, box) ->
      @box.setTransform @params.position.x, @params.position.y, @params.position.scaleX, @params.position.scaleY
      @box.graphics.beginFill("#FFFFFF").drawRect 0, 0, widthCell*@params.position.scaleX, 240
      x = 0
      while x < 320 then do =>
        @box.graphics.beginFill("#FFFFFF").drawRect x, 0, widthCell*@params.position.scaleX, 240
        x+=20*@params.position.scaleX
     
    destroy: ->
      @undelegateEvents()
      @screen.removeChild(@quest)
      @parent.bb_container.removeChild @screen

    show: -> @afterShow()
      
    afterShow: -> @resetStats()
      
    resetStats: ->
      @stats =
        word: @params.word.id
        strike: 0
        score: 0
        errors: 0
        timer: 0
      
      @s_time = @game.gamingTime

    errorShow: ->
      @error.visible = true
      @light.gotoAndPlay 'off'
      @light_bg.visible = false