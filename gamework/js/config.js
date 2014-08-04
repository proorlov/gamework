var manifest = [
    {src: 'gameres/img/bg.jpg', id: 'background'},
    {src: 'gameres/img/button.png', id: 'button'},
    {src: 'gameres/img/button_green.png', id: 'button_green'},
    {src: 'gameres/img/home1.png', id: 'home1'},
    {src: 'gameres/img/home2.png', id: 'home2'},
    {src: 'gameres/img/home3.png', id: 'home3'},
    {src: 'gameres/img/home4.png', id: 'home4'},
    {src: 'gameres/img/home5.png', id: 'home5'},
    {src: 'gameres/img/home6.png', id: 'home6'}
];

var config = {
    font: "Arial",
    font2_thin: "pf_beausans_prothin",
    font2_reg: "pf_beausans_proregular",
	font2_semibold: "pf_beausans_prosemibold",
	font2_bold: "pf_beausans_prosemibold",
	font3_bold: "pf_handbook_probold",

    debug: true, //fps and some console logs
    needTime: true,
    startTime: 0*1000,
    gameTime: 60*1000,

    static_objects: [
        {x:   59, y: 244, scale: 1, img: 'home1'},
        {x:  238, y:  32, scale: 1, img: 'home2'},
        {x:  487, y: 130, scale: 1, img: 'home3'},
        {x:  709, y:  32, scale: 1, img: 'home4'},
        {x:  880, y: 105, scale: 1, img: 'home5'},
        {x: 1034, y: 244, scale: 1, img: 'home6'},
    ],

};
