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
      
      @target.addEventListener 'mouseover', => @lightOn()
      @target.addEventListener 'mouseout',  => @lightOff()
      
      @target.addEventListener 'click', =>
        Mediator.trigger new createjs.Event('state:change', 'htp:success') if @isCurrectWord()
          
