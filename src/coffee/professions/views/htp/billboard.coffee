define [
  'config'
  'helpers/mediator'
  'professions/views/billboard'
], (Config, Mediator, Billboard) ->
  
  class HTPBillboard extends Billboard
    
    delegateEvents: ->
      @target.addEventListener 'mouseover', =>
        unless @error.visible
          @light.gotoAndPlay 'on'
          @light_bg.visible = true

      @target.addEventListener 'mouseout',  =>
        @light.gotoAndPlay 'off'
        @light_bg.visible = false
      
      @on 'change:score:success', => false
      @on 'change:score:error', => @error.visible = false
      
      Mediator.on 'change:score:success', => @dispatchEvent 'change:score:success'
      Mediator.on 'change:score:error', => @dispatchEvent 'change:score:error'
      
      @target.addEventListener 'click', =>
        Mediator.trigger new createjs.Event('state:change', 'htp:success') if @isCurrectWord()
