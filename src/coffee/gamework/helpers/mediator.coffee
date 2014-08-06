define [ 'easel' ], ->
  class Mediator extends createjs.EventDispatcher
    
    trigger: (eventObj) -> @dispatchEvent(eventObj)
    
  new Mediator