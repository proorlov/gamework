define [
  'config'
  'simplegame/views/scenes/game'
  'professions/views/billboard'
  'helpers/mediator'
  'easel'
], (Config, SimpleGame, Billboard, Mediator) ->
  
  class SimpleGame extends SimpleGame
    
    bbs: {}
    consecutive_strikes: 0
    
    billboards:
      [
        { x:  502, y: 440, scaleX: 1, scaleY: 1 },
        { x:  53,  y: 529, scaleX: 0.8, scaleY: 0.8 },
        { x:  942, y: 342, scaleX: 0.833, scaleY: 0.833 },
        { x:  135, y: 239, scaleX: 0.926, scaleY: 0.926 },     
        { x:  674, y:  76, scaleX: 0.8, scaleY: 0.81 },
      ]
    
    constructor: ->
      @quests = gamework.queue.getResult('data').quests
      @getNextWord()
      @getCurrentWord()
      super
    
    delegateEvents: ->
      super
      Mediator.on "billboard:choose", (e) => @chooseItem(e)
      Mediator.on 'change:score:success', => @reset()
    
    render: ->
      @bb_container = new createjs.Container
      
      @paintObjects()
      @showTime() if Config.needTime
      @paintGameObj()
      @animateObjs()
      @paitQuest()
      @paitnScores()
      
    paintGameObj: ->
      @quests.words = _.sortBy @quests.words, (word, i) => i < _.random( 0, @quests.words.length-1 )
      
      _.each @quests.words, (word, i) =>
        position = @billboards[i]
        if @bbs[word.id]?
          @bbs[word.id].animation.gotoAndPlay 'normal'
          @bbs[word.id].target.setTransform position.x, position.y, position.scaleX, position.scaleY
          @bbs[word.id].dispatchEvent 'show'
        else
          @bbs[word.id] = new Billboard @, word.id, position
          @bbs[word.id].dispatchEvent 'show'
        @bb_container.addChild @bbs[word.id].screen
        @screen.addChild @bb_container
      
    paitnScores: ->
      @scoreContainer = new createjs.Container
      
      shape = new createjs.Shape
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawRoundRectComplex 0, 0, 350, 120, 0, 0, 0, 10
      
      @txt = new createjs.Text("your score: #{gamework.points}", "30px "+Config.font2_reg, "#FFF")
      @txt.textAlign = "left"
      @txt.textBaseline = "alphabetic"
      @txt.setTransform 70, 65
      
      @scoreContainer.setTransform Config.w-Config.borderSize-350, 0 
      
      @scoreContainer.addChild(shape, @txt)
      @screen.addChild @scoreContainer

    reset: ->
      @bb_container.removeAllChildren()
      @paintGameObj()
      #createjs.Tween.get(@bbs[@currentWord.id].box).to({scaleX:-1}, 5000)
      @getCurrentWord()
      @word.text = @currentWord.name
      @screen.removeChild @scoreContainer
      @paitnScores()
      
      Mediator.trigger 'next:phase'
        
    paitQuest: ->
      @quest = new createjs.Text @quests.quest, "23px "+Config.font2_reg, "#4C4C4C"
      @quest.textAlign = "left"
      @quest.textBaseline = "alphabetic"
      @quest.setTransform 225, 100
      
      @word = new createjs.Text @currentWord.name, "35px "+Config.font2_reg, "#4C4C4C" 
      @word.textAlign = "left"
      @word.textBaseline = "alphabetic"
      @word.setTransform 225, 150
      
      @screen.addChild(@quest, @word)
    
    getCurrentWord: ->
      @currentWord = @nextWord
      @getNextWord()
    
    getNextWord: ->
      a = _.without @quests.words, @currentWord
      @nextWord = a[_.random( 0, a.length-1 )]
    
    chooseItem: (e) ->
      @billboard = e.bubbles
      @updateStats()
      if @billboard.isCurrectWord()
        @timer = @game.gamingTime-@s_time
        @game.addScore(@billboard.countPoint())
      else
        Mediator.trigger 'change:score:error'
        @billboard.animation.gotoAndPlay 'error'
          
      @consecutive_strikes
        
    updateStats: ->
      if @billboard.stats.strike > 0 && @billboard.stats.errors < 1
        @consecutive_strikes += @billboard.stats.strike
      else
        @consecutive_strikes = 0