define [
  'underscore'
  'config'
  'easel'
], (_, Config) ->
  class Base
    
    constructor: (game) ->
      @game = game
      @render()
      
    render: -> false