var manifest = [
    {src: 'gameres/img/bg.jpg', id: 'background'},
    {src: 'gameres/img/button.png', id: 'button'},
    {src: 'gameres/img/button_green.png', id: 'button_green'},
    {src: 'gameres/img/home1.png', id: 'home1'},
    {src: 'gameres/img/home2.png', id: 'home2'},
    {src: 'gameres/img/home3.png', id: 'home3'},
    {src: 'gameres/img/home4.png', id: 'home4'},
    {src: 'gameres/img/home5.png', id: 'home5'},
    {src: 'gameres/img/home6.png', id: 'home6'},
    {src: 'gameres/img/cloud1.png', id: 'cloud_top'},
    {src: 'gameres/img/cloud2.png', id: 'cloud'},
    {src: 'gameres/img/tree1.png', id: 'tree1'},
    {src: 'gameres/img/tree2.png', id: 'tree2'},
    {src: 'gameres/img/tree3.png', id: 'tree3'},
    {src: 'gameres/img/tree4.png', id: 'tree4'},
    {src: 'gameres/img/birds1.png', id: 'birds1'},
    {src: 'gameres/img/birds2.png', id: 'birds2'},
    {src: 'gameres/img/car1.png', id: 'car1'},
    {src: 'gameres/img/car2.png', id: 'car2'},
    {src: 'gameres/img/car3.png', id: 'car3'},
    {src: 'gameres/img/car4.png', id: 'car4'},
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
		{x: 140, y: 2, scale: 1, img: 'cloud_top'},
		
		{x: 158, y: 556, scale: 1, img: 'tree1'},
		{x: 357, y: 607, scale: 1, img: 'tree2'},
		{x: 881, y: 566, scale: 1, img: 'tree3'},
		{x: 1090, y: 581, scale: 1, img: 'tree4'},
		
        {x:   59, y: 244, scale: 1, img: 'home1'},
        {x:  716, y:  32, scale: 1, img: 'home4'},
	    {x:  238, y:  32, scale: 1, img: 'home2'},
        {x:  487, y: 103, scale: 1, img: 'home3'},     
        {x:  880, y: 105, scale: 1, img: 'home5'},
        {x: 1034, y: 244, scale: 1, img: 'home6'},
		
		//dinamic
        {x:-59, y:391, scale: 0.64, img: 'cloud'},
		{x:122, y:209, scale: 0.58, img: 'cloud'},
		{x:181, y:303, scale: 0.73, img: 'cloud'},
		{x:553, y:61, scale: 1, img: 'cloud'},
		{x:671, y:375, scale: 0.58, img: 'cloud'},
		{x:976, y:83, scale: 1, img: 'cloud'},
		{x:1142, y:281, scale: 1, img: 'cloud'},
		
		{x:522, y:30, scale: 1, img: 'birds1'},
		{x:1126, y:200, scale: 1, img: 'birds1'},
		{x:227, y:120, scale: 1, img: 'birds2'},
		
		{x:445, y:704, scale: 1, img: 'car1'},
		{x:610, y:704, scale: 1, img: 'car2'},
		{x:826, y:693, scale: 1, img: 'car3'},
		{x:983, y:672, scale: 1, img: 'car4'},
		
    ],
    
    dynamic_objects: [

    ],

};
