define [
  'helpers/mediator'
  'config'
  'professions/views/scenes/game'
  'professions/views/htp/billboard'
], (Mediator, Config, Game, Billboard) ->
  class HTPSimple extends Game
      
    update: -> false
      
    afterShow: ->
      @game.setTimeout (=> @highlight()), 2000
      
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
    
    highlight: ->
      _.each @bbs, (bb) ->
        createjs.Tween.get(bb.profession).to({alpha: 0.5}, 600) unless bb.isCurrectWord()
      
      @billboard.light.gotoAndPlay 'on'
      @billboard.light_bg.visible = true
      
    isStrike: -> false
    strikeOn: -> false
    strikeOff: -> false