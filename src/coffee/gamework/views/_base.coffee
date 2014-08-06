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
    
    ##
    # override 
    render: -> false
    delegateEvents: -> false
    #
    ##

    show: ->
      @screen.visible = true

    hide: ->
      @screen.visible = false