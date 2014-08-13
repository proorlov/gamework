define [
  'config'
  'helpers/mediator'
  'professions/views/billboard'
], (Config, Mediator, Billboard) ->
  
  class HTPBillboard extends Billboard
    
    delegateEvents: ->
      @on 'change:score:success', => false
      @on 'change:score:error', => @error.visible = false
      
      Mediator.on 'change:score:success', => @dispatchEvent 'change:score:success'
      Mediator.on 'change:score:error', => @dispatchEvent 'change:score:error'
      
      @target.addEventListener 'click', =>
        if @isCurrectWord()
          Mediator.trigger new createjs.Event('state:change', 'htp:success')
        else
          Mediator.trigger new createjs.Event('change:score:error')
          @error.visible = true
          
