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
      
    isCurrectWord: -> @parent.currentWord.id == @professionName

    undelegateEvents: ->
      @target.removeAllEventListeners()

    delegateEvents: ->
      @target.addEventListener 'mouseover', => @animation.gotoAndPlay 'hover'
      @target.addEventListener 'mouseout',  => @animation.gotoAndPlay 'normal'
      
      Mediator.on 'change:score:success', =>
        @game.stats.words.push @stats
        
      Mediator.on 'change:score:error', => @error()
      
      @target.addEventListener 'click', =>
        @update()
        Mediator.trigger new createjs.Event("billboard:choose", @)
    
    error: -> @stats.errors+=1
    
    update: ->
      timer = @game.gamingTime - @s_time
      strike = if timer <= Config.strike && @errors == 0 then 1 else 0
      
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
      
      data = {
        framerate: 3
        images: [ @game.queue.getResult("#{@professionName}") ]
        frames:
          {
            width:  320
            height: 240
            count:  3
            regX:   0
            regY:   0
          }
        animations: {
          hover:  [ 0 ]
          normal: [ 1 ]
          error:  [ 2 ]
        }
      }
          
      spriteSheet = new createjs.SpriteSheet data
      @animation = new createjs.Sprite spriteSheet, "normal"
      
      @target.addChild @animation
      @target.setTransform @billboardPosition.x, @billboardPosition.y, @billboardPosition.scaleX, @billboardPosition.scaleY
      
      #if @parent.currentWord.id == @professionName
      #  new Billboard @parent, @parent.nextWord.id, @billboardPosition
      #  @box = box = new createjs.Shape()
      #  width = 320
      #  
      #  box.graphics.beginFill("#FFFFFF").drawRect @billboardPosition.x, @billboardPosition.y, 10, 240*@billboardPosition.scaleY
      #  
      #  while width-=20 then do =>
      #    box.graphics.beginFill("#FFFFFF").drawRect @billboardPosition.x+width, @billboardPosition.y, 10, 240*@billboardPosition.scaleY
      #
      # @target.AlphaMaskFilter = [new createjs.AlphaMaskFilter(@box)]

      @screen.addChild @target 
      
    destroy: ->
      @undelegateEvents()
      @screen.removeAllEventListeners()
      @removeAllEventListeners()
      @screen.removeChild(@quest)
      @parent.screen.removeChild @screen

    show: ->
      @afterShow()
      
    afterShow: ->
    
      @stats =
        word: @professionName
        strike: 0
        score: 0
        errors: 0
        timer: 0
      
      @s_time = @game.gamingTime
