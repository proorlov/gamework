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
        { x:  675, y:  76, scaleX: 0.8, scaleY: 0.805 },
      ]
    
    constructor: ->
      @bbs = {}
      @quests = gamework.queue.getResult('data').quests
      super
    
    undelegateEvents: ->
      

    delegateEvents: ->
      Mediator.on 'change:score', => @update()
      @on "change:score",         => @dispatchEvent "change:score"
    
    render: ->
      @bb_container = new createjs.Container
  
      @paintObjects()
      @showTime() if Config.needTime
      
      @getWords()
      @paintGameObjs()
       
      @billboard = @bbs[@currentWord.id]
      @billboard.paitMask()
 
      @animateObjs()
      @paitQuest()
      @paitnScores()
    
    getWords: ->
      @quests.words = _.sortBy @quests.words, (word, i) => i < _.random( 0, @quests.words.length-1 )
      @currentWords = []
      for i in [0..4]
        do => @currentWords.push @quests.words[i]
      @currentWord = @getNextWord()
    
    paintGameObjs: ->
      _.each @currentWords, (word, i) =>
        params = {word: word, position: @billboards[i]}
        @paintGameObj(params)
        
      @paintGameObj({ word: @wordToAdd = @getRandomtWord(), position:@bbs[@currentWord.id].params.position })
      
      @screen.addChild @bb_container
      
    paintGameObj: (params) ->
      @bbs[params.word.id] = new Billboard @, params 
      @bbs[params.word.id].dispatchEvent 'show'
      @bb_container.addChildAt @bbs[params.word.id].screen, 0
      
    update: -> @points.text = "#{gamework.points} points"

    paitnScores: ->
      @scoreContainer = new createjs.Container
      
      shape = new createjs.Shape
      shape.graphics.beginFill("rgba(0,0,0,0.5)").drawRoundRectComplex 0, 0, 350, 105, 0, 0, 0, 10
      
      ys = new createjs.Text("your score:", "23px "+Config.font2_reg, "#FFF")
      ys.textAlign = "left"
      ys.textBaseline = "alphabetic"
      ys.setTransform 50, 55
      
      @points = new createjs.Text("#{gamework.points} points", "30px "+Config.font2_bold, "#FFF")
      @points.textAlign = "left"
      @points.textBaseline = "alphabetic"
      @points.setTransform 180, 55
      
      @strikeContainer = new createjs.Container
      @strikeContainer.visible = false
      
      woohoo = new createjs.Text("WOOHOO!", "20px "+Config.font2_reg, "#FFF")
      woohoo.textAlign = "left"
      woohoo.textBaseline = "alphabetic"
      woohoo.setTransform 68, 85
      
      superSpeed = new createjs.Text("SUPERSPEED!", "20px "+Config.font2_bold, "#FFF")
      superSpeed.textAlign = "left"
      superSpeed.textBaseline = "alphabetic"
      superSpeed.setTransform 168, 85
      
      @strikeContainer.addChild woohoo, superSpeed
      
      @scoreContainer.setTransform Config.w-Config.borderSize-350, 0 
      
      @scoreContainer.addChild(shape, ys, @points, @strikeContainer)
      @screen.addChild @scoreContainer
    
    next: ->
      delete @bbs[@currentWord.id]
      @currentWords.push @wordToAdd if @wordToAdd?
      @wordToAdd = null
      @currentWords = _.difference @currentWords, [@currentWord]
      
      @billboard = @bbs[@nextWord.id]
      @billboard.paitMask()
      
      @wordToAdd = @getRandomtWord()
      
      @paintGameObj({ word: @wordToAdd, position:@bbs[@nextWord.id].params.position })
      
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
    
    getNextWord: ->
      a = _.difference @currentWords, [@wordToAdd, @currentWord]
      a[_.random( 0, a.length-1 )]
    
    getRandomtWord: ->
      a = _.difference @quests.words, @currentWords, [@wordToAdd]
      a[_.random( 0, a.length-1 )]
    
    chooseItem: (bb) ->
      @updateStats()
      if bb.isCurrectWord()
        @game.addScore(bb.countPoint())
        
        @nextWord = @getNextWord()
        @next()

        @timer = @game.gamingTime-@s_time
        
        @currentWord = @nextWord
        @word.text = @currentWord.name
      else
        Mediator.trigger 'change:score:error'
        bb.errorShow()
      @consecutive_strikes
        
    updateStats: ->
      if @billboard.stats.strike > 0
        @consecutive_strikes += @billboard.stats.strike
        @strikeContainer.visible = true
      else
        @strikeContainer.visible = false
        @consecutive_strikes = 0
