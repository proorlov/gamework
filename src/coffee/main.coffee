requirejs.config 
  paths:
    jquery:  "./../vendor/jquery-1.11.1.min"
    underscore: "./../vendor/underscore-min"
    easel: "./../vendor/easeljs-0.7.1.min"
    preload: "./../vendor/preloadjs-0.4.1.min"
    sound: "./../vendor/soundjs-0.5.2.min"
    tween: "./../vendor/tweenjs-0.5.1.min"
    config: "/js/config"
    views: "/js/gamework/views"
    scenes: "/js/gamework/views/scenes"
    helpers: "/js/gamework/helpers"
    gamework: '/js/gamework/gamework'
    layouts: "/js/app/layouts"
    game: "/js/simplegame/index"
  shim:
    jquery:
      exports: 'jQuery'
    underscore:
      exports: '_'
    easel:
      deps: ['preload', 'tween', 'sound'],
      exports: 'easel'

require ["jquery", "game"], ($, game) ->
  $ ->
    window.gamework = new game

    gamework.mediator.on 'game:start', ->
      $('#pause').removeClass('disabled')
      $('#htp').removeClass('disabled')
      $('#mute').removeClass('disabled')

    gamework.mediator.on 'state:change:success', =>
    
      if gamework.currentState == 'htp' or gamework.currentState == 'htp:success' then $('#htp').addClass('active') else $('#htp').removeClass('active')
      if gamework.currentState == 'pause' then $('#pause').addClass('active') else $('#pause').removeClass('active')
      
    gamework.mediator.on 'change:mute', =>
      if gamework.isMute then $('#mute').addClass('active') else $('#mute').removeClass('active')
    
    $('#pause').on 'click', (e) -> gamework.pause(e)
    $('#htp').on 'click', (e) -> gamework.how(e)
    $('#mute').on 'click', (e) -> gamework.mute(e)
    
    document.onselectstart = -> return false
    