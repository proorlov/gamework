define [
  'underscore'
  'config'
  'easel'
], (_, Config) ->
  class Base extends createjs.EventDispatcher
    
    visible: false
    
    constructor: (parent) ->
      @screen = new createjs.Container
      @screen.visible = @visible
      @parent = parent
      @game = gamework
      @parent.screen.addChild @screen
      @render()
      @delegateEvents()
      
      @on 'show', => @showPerformer()
      @on 'hide', => @hidePerformer()
    
    ##
    # override 
    render: -> false
    undelegateEvents: -> false
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
      @screen.visible = true
      @afterShow()

    hide: ->
      @screen.visible = false
      @afterHide()

    destroy: ->
      @undelegateEvents()
      @screen.removeAllEventListeners()
      @removeAllEventListeners()
      @parent.screen.removeChild @screen