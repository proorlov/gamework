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
      
      {src: 'res/img/home1.png', id: 'home1'},
      {src: 'res/img/home2.png', id: 'home2'},
      {src: 'res/img/home3.png', id: 'home3'},
      {src: 'res/img/home4.png', id: 'home4'},
      {src: 'res/img/home5.png', id: 'home5'},
      {src: 'res/img/home6.png', id: 'home6'},
      
      {src: 'res/img/professions/billboard_1.png', id: 'billboard_1'},
      {src: 'res/img/professions/billboard_2.png', id: 'billboard_2'},
      {src: 'res/img/professions/billboard_3.png', id: 'billboard_3'},
      {src: 'res/img/professions/billboard_4.png', id: 'billboard_4'},
      {src: 'res/img/professions/billboard_5.png', id: 'billboard_5'},
      
      {src: 'res/img/professions/doctor.png', id: 'doctor'},
      {src: 'res/img/professions/adiner.png', id: 'adiner'},
      {src: 'res/img/professions/driver.png', id: 'driver'},
      {src: 'res/img/professions/lawyer.png', id: 'lawyer'},
      {src: 'res/img/professions/photographer.png', id: 'photographer'},
      {src: 'res/img/professions/policeman.png', id: 'policeman'},
      {src: 'res/img/professions/receptionist.png', id: 'receptionist'},
      {src: 'res/img/professions/administrator.png', id: 'administrator'},
      {src: 'res/img/professions/assistant.png', id: 'assistant'},
      {src: 'res/img/professions/firefighter.png', id: 'firefighter'},
      {src: 'res/img/professions/judge.png', id: 'judge'},
      {src: 'res/img/professions/nurse.png', id: 'nurse'},
      {src: 'res/img/professions/student.png', id: 'student'},
      {src: 'res/img/professions/teacher.png', id: 'teacher'},
      {src: 'res/img/professions/waiter.png', id: 'waiter'},
      {src: 'res/img/professions/worker.png', id: 'worker'},
      
      {src: 'res/img/professions/error.png', id: 'error_bg'},
      
      {src: 'res/img/professions/light.png', id: 'light'},
      {src: 'res/img/professions/light_bg.png', id: 'light_bg'},
      
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
      {src: 'res/sound/right_apple.wav', id: 'success'}
    ]
  
    font:           "Arial"
    font2_thin:     "pf_beausans_prothin"
    font2_reg:      "pf_beausans_proregular"
    font2_semibold: "pf_beausans_prosemibold"
    font2_bold:     "pf_beausans_prosemibold"
    font3_bold:     "pf_handbook_probold"

    debug: true #fps and some console logs
    needTime: true

    startTime: 3*1000
    gameTime: 60*1000
    strike: 3*1000
    
    points: 10

    objects: [
      {x:  140, y: 2,   scale: 1, img: 'cloud_top'}
      {x:  357, y: 607, scale: 1, img: 'tree2'}
      {x:  881, y: 566, scale: 1, img: 'tree3'}
      
      {x:  490, y:  425, scale: 1, img: 'billboard_1'}
      {x:  45, y:  517, scale: 1, img: 'billboard_2'}
      
      {x:445, y:704, scale: 1, img: 'car1', animate: 'right', duration: 15000, distance: 1200 },
      {x:610, y:704, scale: 1, img: 'car2', animate: 'right', duration: 13000, distance: 1200 },
      {x:826, y:693, scale: 1, img: 'car3', animate: 'right', duration: 17000, distance: 1200 },
      {x:983, y:672, scale: 1, img: 'car4', animate: 'left',  duration: 16000, distance: 1200 },
      
      {x:  932, y: 330, scale: 1, img: 'billboard_3'}  
      {x:  125, y: 225, scale: 1, img: 'billboard_4'}     
      {x:  665, y:  64, scale: 1, img: 'billboard_5'}
      
      {x:  158, y: 556, scale: 1, img: 'tree1'}
      {x: 1090, y: 581, scale: 1, img: 'tree4'}
      {x:  716, y:  32, scale: 1, img: 'home4'}
      {x:  238, y:  32, scale: 1, img: 'home2'}
      {x:  487, y: 103, scale: 1, img: 'home3'}     
      {x:  880, y: 105, scale: 1, img: 'home5'}
      
      {x:181,  y:303, scale: 0.73, img: 'cloud', animate: 'left', duration: 32000, distance: 1200 },
      {x:   59, y: 244, scale: 1, img: 'home1'}
      {x: 1034, y: 244, scale: 1, img: 'home6'}

      {x:522,  y:30,  scale: 1, img: 'birds1', animate: 'right', duration: 25000, distance: 1200 },
      {x:1126, y:200, scale: 1, img: 'birds1', animate: 'right', duration: 25000, distance: 1200 },
      {x:227,  y:120, scale: 1, img: 'birds2', animate: 'right', duration: 25000, distance: 1200 },
    
      {x:-59,  y:391, scale: 0.64, img: 'cloud', animate: 'left', duration: 55000, distance: 1200 },
      {x:122,  y:209, scale: 0.58, img: 'cloud', animate: 'left', duration: 55000, distance: 1200 },
      {x:553,  y:61,  scale: 1,    img: 'cloud', animate: 'left', duration: 55000, distance: 1200 },
      {x:671,  y:375, scale: 0.58, img: 'cloud', animate: 'left', duration: 35000, distance: 1200 },
      {x:976,  y:83,  scale: 1,    img: 'cloud', animate: 'left', duration: 30000, distance: 1200 },
      {x:1142, y:281, scale: 1,    img: 'cloud', animate: 'left', duration: 30000, distance: 1200 },
    ]

  new Config