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
    helpers: "/js/gamework/helpers"
    gamework: '/js/gamework/gamework'
    layouts: "/js/app/layouts"
    game: "/js/game"
  shim:
    jquery:
      exports: 'jQuery'
    underscore:
      exports: '_'
    easel:
      deps: ['preload', 'tween', 'sound'],
      exports: 'easel'

require ["jquery", "js/game/index.js"], ($, game) ->
  $ ->
    gamework = new game
    
    $('#pause').on 'click', (e) -> gamework.pause(e)
    $('#htp').on 'click', (e) -> gamework.how(e)
    $('#mute').on 'click', (e) -> gamework.mute(e)
    
    document.onselectstart = -> return false
    