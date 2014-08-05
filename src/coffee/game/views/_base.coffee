define [
  'underscore'
  'config'
  'easel'
], (_, Config) ->
  class Base
    
    visible: false
    
    constructor: (game) ->
      @screen = new createjs.Container
      @screen.visible = @visible
      @game = game
      @render()
      
    render: -> false