define [
  'helpers/mediator'
  'config'
  'professions/views/scenes/game'
  'professions/views/htp/billboard'
], (Mediator, Config, Game, Billboard) ->
  class HTPSimple extends Game
    
    constructor: ->
      super
      
    update: -> false
      
    afterShow: ->
      console.log 'afterShow'
      #setTimeout @highlight, 2000
      
    afterHide: ->
      @game.restart()
      
    paintGameObj: (params) ->
      @bbs[params.word.id] = new Billboard @, params 
      @bbs[params.word.id].dispatchEvent 'show'
      @bb_container.addChildAt @bbs[params.word.id].screen, 0
      
    paitQuest: ->
      @quest = new createjs.Text "Найдите соответствующее\nслову изображение:", "18px "+Config.font2_reg, "#4C4C4C"
      @quest.textAlign = "left"
      @quest.textBaseline = "alphabetic"
      @quest.setTransform 205, 95
      
      @word = new createjs.Text @currentWord.name, "35px "+Config.font2_reg, "#4C4C4C" 
      @word.textAlign = "left"
      @word.textBaseline = "alphabetic"
      @word.setTransform 205, 155
      
      @screen.addChild(@quest, @word)
      
    paitnScores: -> false