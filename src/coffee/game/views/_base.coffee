define [
  'underscore'
  'config'
  'easel'
], (_, Config) ->
  class Base
    
    constructor: (game) ->
      @screen = new createjs.Container
      @game = game
      @render()
      
    render: -> false