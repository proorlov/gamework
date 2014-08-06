define [
  'underscore'
  'config'
  'easel'
], (_, Config) ->
  class Base extends createjs.EventDispatcher
    
    visible: false
    
    constructor: (game) ->
      @screen = new createjs.Container
      @screen.visible = @visible
      @game = game
      @render()
      @delegateEvents()
      
      @on 'show', => @showPerformer()
      @on 'hide', => @hidePerformer()
    
    ##
    # override 
    render: -> false
    delegateEvents: -> false
    beforeShow: -> @show()
    afterShow: -> false
    beforeHide: -> @hide()
    afterHide: -> false
    #
    ##

    showPerformer: ->
      @beforeShow()

    hidePerformer: ->
      @beforeHide()
      

    show: ->
      @game.stage.addChildAt @screen, 1
      @screen.visible = true
      @afterShow()

    hide: ->
      @game.stage.removeChild @screen
      @screen.visible = false
      @afterHide()
