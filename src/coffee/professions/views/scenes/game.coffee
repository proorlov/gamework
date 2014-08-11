define [
  'config'
  'simplegame/views/scenes/game'
  'professions/views/billboard'
  'helpers/mediator'
  'easel'
], (Config, SimpleGame, Billboard, Mediator) ->
  
  class SimpleGame extends SimpleGame
    
    consecutive_strikes: 0
    currentWords: []
    
    billboards:
      [
        { x:  502, y: 440, scaleX: 1, scaleY: 1 },
        { x:  53,  y: 529, scaleX: 0.8, scaleY: 0.8 },
        { x:  942, y: 342, scaleX: 0.833, scaleY: 0.833 },
        { x:  135, y: 239, scaleX: 0.926, scaleY: 0.926 },     
        { x:  674, y:  76, scaleX: 0.8, scaleY: 0.81 },
      ]
    
    constructor: ->
      @bbs = {}
      @quests = gamework.queue.getResult('data').quests
      super
    
    undelegateEvents: ->
      
      
    delegateEvents: ->
      Mediator.on 'change:score',         => @update()
      Mediator.on 'change:score:success', => @next()
      
      @on "change:score:success", => @dispatchEvent "change:score:success"
      @on "change:score",         => @dispatchEvent "change:score"
    
    render: ->
      @bb_container = new createjs.Container
  
      @paintObjects()
      @showTime() if Config.needTime
      @paintGameObj()
      @getCurrentWord()
       
      @billboard = @bbs[@currentWord.id]
 
      @animateObjs()
      @paitQuest()
      @paitnScores()
      
    paintGameObj: ->
      @quests.words = _.sortBy @quests.words, (word, i) => i < _.random( 0, @quests.words.length-1 )
      
      @currentWords = []
      
      _.each @quests.words, (word, i) =>
        return unless _.has @billboards, i
        @currentWords.push word
        position = @billboards[i]
        if @bbs[word.id]?
          @bbs[word.id].target.setTransform position.x, position.y, position.scaleX, position.scaleY
          @bbs[word.id].dispatchEvent 'show'
        else
          @bbs[word.id] = new Billboard @, word, position
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
    
    reset: -> @next()

    next: ->
      @billboard.destroy()

      @getCurrentWord()
      @word.text = @currentWord.name
      
      word = @getRandomtWord()
      @bbs[word.id] = new Billboard @, word, @billboard.billboardPosition
      @bbs[word.id].dispatchEvent 'show'
      
      @screen.removeChild @scoreContainer
      @paitnScores()
      
      @billboard = @bbs[@currentWord.id]
      
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
      @currentWords = _.without @currentWords, @currentWord
      @currentWord = @currentWords[_.random( 0, @currentWords.length-1 )]
    
    # getNextWord: ->
      # a = _.without @currentWords, @currentWord
      # @nextWord = a[_.random( 0, a.length-1 )]
    
    getRandomtWord: ->
      a = _.difference @quests.words, @currentWords
      word = a[_.random( 0, a.length-1 )]
      @currentWords.push word
      word
    
    chooseItem: (bb) ->
      @updateStats()
      if bb.isCurrectWord()
        @timer = @game.gamingTime-@s_time
        @game.addScore(bb.countPoint())
      else
        Mediator.trigger 'change:score:error'
        bb.error.visible = true
      @consecutive_strikes
        
    updateStats: ->
      if @billboard.stats.strike > 0 && @billboard.stats.errors < 1
        @consecutive_strikes += @billboard.stats.strike
      else
        @consecutive_strikes = 0
