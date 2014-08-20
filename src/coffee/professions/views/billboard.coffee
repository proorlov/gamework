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
      @params = _.extend params, Config.game_objs[params.word.id]
      super
      
    isCurrectWord: -> @parent.currentWord.id == @params.word.id

    targetDelegateEvents: ->
      @target.addEventListener 'mouseover', =>
        @lightOn() unless @error.visible

      @target.addEventListener 'mouseout',  =>
        @lightOff() unless @success
      
      @target.addEventListener 'click', =>
        if @isCurrectWord()
          @lightOn()
          @update()
          @success = true
          Mediator.trigger 'billboard:success'
          @game.setTimeout (=>@parent.chooseCurrectItem(@)), Config.nextWordTime
        else
          @parent.chooseNotCurrectItem(@)

    lightOff: ->
      @light.gotoAndPlay 'off'
      @light_bg.visible = false
      
    lightOn: ->
      @light.gotoAndPlay 'on'
      @light_bg.visible = true

    undelegateEvents: ->
      @target.removeAllEventListeners()
      @screen.removeAllEventListeners()
      @removeAllEventListeners()

    delegateEvents: ->
      @targetDelegateEvents()
      
      @on 'change:score:success', => @onChangeScoreSuccess()
        
      @on 'change:score:error', =>
        @error.visible = false
        @error_add() if @isCurrectWord()
        
      @on 'billboard:success', =>
        @error.visible = false
        @target.removeAllEventListeners()
        if Config.nextWordTime > 400
          createjs.Tween.get(@profession).to({alpha: 0.3}, 400) unless @isCurrectWord()
      
      Mediator.on 'billboard:success', => @dispatchEvent 'billboard:success'
      Mediator.on 'change:score:success', => @dispatchEvent 'change:score:success'
      Mediator.on 'change:score:error', => @dispatchEvent 'change:score:error'
    
    onChangeScoreSuccess: ->
      @targetDelegateEvents()
      if Config.nextWordTime > 400
        createjs.Tween.get(@profession).to({alpha: 1}, 400)
      @error.visible = false
      @resetStats() if not @isCurrectWord()
      @animateMask() if @isCurrectWord()
    
    error_add: -> @stats.errors+=1
    
    update: ->
      timer = @game.gamingTime - @s_time
      @stats.score = @countPoint()
      @stats.strike = @parent.isStrike()+0
      @stats.timer = timer
      @game.stats.words.push(@stats)
      @

    countPoint: ->
      if @parent.isStrike()
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
      
      @target.cursor = 'pointer'
      @profession = new createjs.Bitmap(@game.queue.getResult(@params.word.id))
      @profession.setTransform( (155-@profession.getBounds().width/2), (120-@profession.getBounds().height/2) )
      
      @bg = new createjs.Shape()
      @bg.graphics.beginFill(@params.color).drawRect(0, 0, 320, 240)
      
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
      @light.setTransform 0, 174
      
      @billboard.addChild @bg, @light_bg, @profession
      @target.addChild @billboard, @error, @light
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
