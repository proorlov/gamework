define [
  'helpers/mediator'
  'config'
  'professions/views/scenes/game'
  'professions/views/htp/billboard'
], (Mediator, Config, Game, Billboard) ->
  class HTPSimple extends Game
      
    update: -> false
      
    getWords: ->
      words = _.clone Config.htp.words
      words.push Config.htp.word
      @quests.words = words
      @currentWords = words
      @currentWord = Config.htp.word
    
    render: ->
      @bb_container = new createjs.Container
  
      @paintObjects()
      
      @getWords()
      @paintGameObjs()
       
      @billboard = @bbs[@currentWord.id]
      @billboard.paitMask()
 
      @paitQuest()
      
    afterShow: ->
      @game.setTimeout (=> @highlight()), 2000
      
    paitQuest: ->
      @quest = new createjs.Text "Найдите соответствующее\nслову изображение:", "15px "+Config.font2_bold, "#2d2d2d"
      @quest.textAlign = "left"
      @quest.textBaseline = "alphabetic"
      @quest.setTransform 219, 95
      
      @word = new createjs.Text @currentWord.name, "40px "+Config.font2_bold, "#2d2d2d" 
      @word.textAlign = "left"
      @word.textBaseline = "alphabetic"
      @word.setTransform 219, 158
      
      @screen.addChild(@quest, @word)

    paintGameObjs: ->
      _.each @currentWords, (word, i) =>
        params = {word: word, position: @billboards[i]}
        @paintGameObj(params)
        
      @screen.addChild @bb_container

    paintGameObj: (params) ->
      @bbs[params.word.id] = new Billboard @, params 
      @bbs[params.word.id].dispatchEvent 'show'
      @bb_container.addChildAt @bbs[params.word.id].screen, 0
      
    paitnScores: -> false
    
    highlight: ->
      _.each @bbs, (bb) ->
        bb.lightOff()
        bb.lightOn = -> false
        bb.lightOff = -> false
        createjs.Tween.get(bb.profession).to({alpha: 0.3}, 600) unless bb.isCurrectWord()
      
      @billboard.light.gotoAndPlay 'on'
      @billboard.light_bg.visible = true
      
    paintObjects: (stage) ->
      static_objects = new createjs.Container
      
      for obj in Config.objects by -1
        do (obj) =>
          return if _.indexOf(Config.scenes['htp'], obj.group) < 0
          el = new createjs.Bitmap(@game.queue.getResult(obj.img))
          el.setTransform(obj.x, obj.y, obj.scale, obj.scale)
          @screen.addChild(el)

    show: ->
      @game.screens['game'].screen.visible = false
      @screen.visible = true
      @afterShow()

    hide: ->
      @screen.visible = false
      @afterHide()
   
    timeLeft: -> 1
    updateTimer: -> false
    isStrike: -> false
    strikeOn: -> false
    strikeOff: -> false