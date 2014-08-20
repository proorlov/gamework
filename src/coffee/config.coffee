define [
  'easel'], ->
 
  class Config

    w: 1248
    h: 794
    borderSize: 12
    w2: Config::w - Config::borderSize
    h2: Config::h - Config::borderSize
    
    manifest: [
      {src: 'res/img/bg.jpg', id: 'background'},
      {src: 'res/img/button.png', id: 'button'},
      {src: 'res/img/button_green.png', id: 'button_green'},
      {src: 'res/img/button_next.png', id: 'button_next'},
      {src: 'res/img/home1.png', id: 'home1'},
      {src: 'res/img/home2.png', id: 'home2'},
      {src: 'res/img/home3.png', id: 'home3'},
      {src: 'res/img/home4.png', id: 'home4'},
      {src: 'res/img/home5.png', id: 'home5'},
      {src: 'res/img/home6.png', id: 'home6'},
      {src: 'res/img/cloud1.png', id: 'cloud_top'},
      {src: 'res/img/cloud2.png', id: 'cloud'},
      {src: 'res/img/tree1.png', id: 'tree1'},
      {src: 'res/img/tree2.png', id: 'tree2'},
      {src: 'res/img/tree3.png', id: 'tree3'},
      {src: 'res/img/tree4.png', id: 'tree4'},
      {src: 'res/img/birds1.png', id: 'birds1'},
      {src: 'res/img/birds2.png', id: 'birds2'},
      {src: 'res/img/car1.png', id: 'car1'},
      {src: 'res/img/car2.png', id: 'car2'},
      {src: 'res/img/car3.png', id: 'car3'},
      {src: 'res/img/car4.png', id: 'car4'},
      {src: 'res/data.json', id: 'data'},
      {src: 'res/sound/error_apple.wav', id: 'error'},
      {src: 'res/sound/music.wav', id: 'music'},
      {src: 'res/sound/score.wav', id: 'over'},
      {src: 'res/sound/score.wav', id: 'strike'},
      {src: 'res/sound/right_apple.wav', id: 'success'}
    ]
  
    font:           "Arial"
    font2_thin:     "pf_beausans_prothin"
    font2_reg:      "pf_beausans_proregular"
    font2_semibold: "pf_beausans_prosemibold"
    font2_bold:     "pf_beausans_prosemibold"
    font3_bold:     "pf_handbook_probold"

    debug: false #fps and some console logs
    needTime: true
    startTime: 3*1000
    gameTime: 1*1000
    
    points: 1

    scenes:
      game:[
        'interface'
        'trees'
        'cars'
        'builds'
        'clouds'
        'birds'
      ]
      system:[
        'trees'
        'builds'
        'clouds'
        'birds'
      ]
      htp:[
        'interface'
        'builds'
      ]

    objects: [
      {x:  140, y: 2,   scale: 1, img: 'cloud_top', group: 'interface'}
      {x:  357, y: 607, scale: 1, img: 'tree2', group: 'trees'}
      {x:  881, y: 566, scale: 1, img: 'tree3', group: 'trees'}
      
      {x:445, y:704, scale: 1, img: 'car1', animate: 'right', duration: 15000, distance: 1200, group: 'cars' },
      {x:610, y:704, scale: 1, img: 'car2', animate: 'right', duration: 15000, distance: 1200, group: 'cars' },
      {x:826, y:693, scale: 1, img: 'car3', animate: 'right', duration: 15000, distance: 1200, group: 'cars' },
      {x:983, y:672, scale: 1, img: 'car4', animate: 'left',  duration: 15000, distance: 1200, group: 'cars' },
      
      {x:  158, y: 556, scale: 1, img: 'tree1', group: 'trees'}
      {x: 1090, y: 581, scale: 1, img: 'tree4', group: 'trees'}
      {x:  716, y:  32, scale: 1, img: 'home4', group: 'builds'}
      {x:  233, y:  32, scale: 1, img: 'home2', group: 'builds'}
      {x:  487, y: 103, scale: 1, img: 'home3', group: 'builds'}     
      {x:  880, y: 105, scale: 1, img: 'home5', group: 'builds'}
      
      {x:  181, y:303, scale: 0.73, img: 'cloud', animate: 'left', duration: 32000, distance: 1200, group: 'clouds' },
      {x:   59, y: 244, scale: 1, img: 'home1', group: 'builds'}
      {x: 1015, y: 244, scale: 1, img: 'home6', group: 'builds'}

      {x:522,  y:30,  scale: 1, img: 'birds1', animate: 'right', duration: 25000, distance: 1200, group: 'birds' },
      {x:1126, y:200, scale: 1, img: 'birds1', animate: 'right', duration: 25000, distance: 1200, group: 'birds' },
      {x:227,  y:120, scale: 1, img: 'birds2', animate: 'right', duration: 25000, distance: 1200, group: 'birds' },
    
      {x:-59,  y:391, scale: 0.64, img: 'cloud', animate: 'left', duration: 55000, distance: 1200, group: 'clouds' },
      {x:122,  y:209, scale: 0.58, img: 'cloud', animate: 'left', duration: 55000, distance: 1200, group: 'clouds' },
      {x:553,  y:61,  scale: 1,    img: 'cloud', animate: 'left', duration: 55000, distance: 1200, group: 'clouds' },
      {x:671,  y:375, scale: 0.58, img: 'cloud', animate: 'left', duration: 35000, distance: 1200, group: 'clouds' },
      {x:976,  y:83,  scale: 1,    img: 'cloud', animate: 'left', duration: 30000, distance: 1200, group: 'clouds' },
      {x:1142, y:281, scale: 1,    img: 'cloud', animate: 'left', duration: 30000, distance: 1200, group: 'clouds' },
    ]

  new Config