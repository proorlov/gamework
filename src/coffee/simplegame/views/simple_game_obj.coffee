define [
  'underscore'
  'config'
  'views/_base'
  'helpers/mediator'
  'easel'
], (_, Config, Base, Mediator) ->
  class SimpleGameObj extends Base
    visible: true
    
    stats: {}
    
    strike: 0
    timer: 0
    errors: 0
    
    ##
    #TODO create objects handler
    #
    #
    undelegateEvents: ->
      @target.removeEventListener 'click'

    delegateEvents: ->
      @target.addEventListener 'click', => @game.addScore(@countPoint())
      @on 'change:score', (event) => @update()
      Mediator.on 'change:score', (event) => @dispatchEvent(event)
      
    update: ->
      @timer = @game.gamingTime - @s_time
      @strike = 1 if @timer <= 2000
      
      @stats =
       rus:    @currentQuest()
       eng:    @currentQuest()
       strike: @strike
       score:  @countPoint()
       errors: @errors
       timer:  @timer
      
      @game.stats.words.push @stats

      @dispatchEvent 'updated'
      
      @
      
      #Mediator.on 'change:score', (event) => @update(event)
      #"WOOHOO! SUPERSPEED!" if @time_for_answer <= 2000
    
    paitQuest: ->
      @quests = gamework.queue.getResult('data').quests
      
      @quest = new createjs.Text(@currentQuest(), "30px "+Config.font2_reg, "#4C4C4C")
      @quest.textAlign = "left"
      @quest.textBaseline = "alphabetic"
      @quest.setTransform 220, 100
      
      @screen.addChild(@quest)

    countPoint: -> Config.points
    #
    ##
    
    currentQuest: -> @quests[0]
    
    render: ->
      @target = objContainer = new createjs.Container
      
      shape = new createjs.Shape()
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawCircle(0, 0, 65)
      shape.cursor = "pointer"
      
      @txt = new createjs.Text(Config.points, "60px "+Config.font2_reg, "#FFF")
      @txt.cursor = "pointer"
      @txt.textAlign = "center"
      @txt.textBaseline = "alphabetic"
      @txt.setTransform( 0, 20 )
      
      objContainer.setTransform( Config.w/2, Config.h/2 )
      
      objContainer.addChild(shape, @txt)
      
      @screen.addChild(objContainer)

    show: ->
      @screen.visible = true
      @afterShow()
      
    afterShow: ->
      @s_time = @game.gamingTime
      @paitQuest()

    destroy: ->
      super
      @screen.removeChild(@quest)
      
      @stats =
       rus: @currentQuest()
       eng: @currentQuest()
