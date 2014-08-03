var gamework = new function() {

    var canvas;
    var stage;
    var workstage;
    var queue;
    var fpsLabel;
    var timeLabel;
    var timeCircle;
    var w = 1248;
    var h = 794;
    var sysScreen;
    //api
    var how = false;
    var pause = false;
    var mute = false;
    //run
    var timerRun = false;
    var gamingTime = 0;

    this.init = function() {
        canvas = document.getElementById("gamework");
        createjs.Ticker.setFPS(30);
        stage = new createjs.Stage(canvas);
        workstage = new createjs.Container;        
        queue = new createjs.LoadQueue(true);
        queue.addEventListener("complete", start);
        queue.loadManifest(manifest);
    }
    this.how = function() {
        how = !how;
        return how;
    }
    this.pause = function() {
        if (timerRun) {
            pause = !pause;
            if (pause) {
                sysScreen.visible = true;
                workstage.visible = false;
            } else {
                sysScreen.visible = false;
                workstage.visible = true;
            }
        }
        return pause;
    }
    this.mute = function() {
        mute = !mute;
        return mute;
    }

    function start() {
        paintBackground();
        stage.addChild(workstage);
        showFPS();
        showTime();
        paintSystemScreen();
        paintBorder();
        stage.update();
        gamingTime = 0;
        timerRun = true;
        createjs.Ticker.addEventListener("tick", tickHandler);
    }
    function tickHandler(tick) {
        if (timerRun && !pause) {
            //console.log(createjs.Ticker.getTime(true));
            gamingTime += tick.delta;
            if (config.showTime == false || gamingTime < config.gameTime) {
                //playing
                updateTimer(gamingTime);
            } else {
                //time finished
                updateTimer(config.gameTime);
                timerRun = false;
                stop();
            }
        }
        if (config.debug) {
            fpsLabel.text = Math.round(createjs.Ticker.getMeasuredFPS()) + " fps";
        }
        stage.update();
    }
    function updateTimer(time) {
        if (config.showTime) {
            timeLabel.text = config.gameTime/1000 - Math.floor(time/1000);
            timeCircle.graphics.clear();
            timeCircle.graphics.beginFill("#4A4A4A").drawCircle(73, 73, 73).endFill();
            timeCircle.graphics.setStrokeStyle(3).beginStroke("#FFFFFF").drawCircle(73, 73, 45).endStroke();
            timeCircle.graphics.beginFill("#FFFFFF").drawCircle(73, 73, 38).endFill();
            timeCircle.graphics.setStrokeStyle(16).beginStroke("#FBFBFB").arc(73, 73, 60, -Math.PI / 2, -Math.PI / 2 + 2 * Math.PI * time / config.gameTime);
            timeCircle.updateCache();
        }
        if (config.debug) {
            //console.log(Math.floor(time / 1000));
        }
    }
    function stop(){
        console.log('stop');
        sysScreen.visible = true;
        workstage.visible = false;
    }

    function paintBackground() {
        var background = new createjs.Bitmap(queue.getResult("background"));
        background.cache(0, 0, w, h);
        stage.addChild(background);
    }
    function paintSystemScreen() {
        var size = 12;
        sysScreen = new createjs.Shape;
        sysScreen.graphics.beginFill("rgba(0,0,0,0.3)").drawRect(size, size, w - size*2, h - size*2);
        sysScreen.visible = false;
        stage.addChild(sysScreen);
    }
    function paintBorder() {
        var border = new createjs.Shape;
        var size = 12;
        var color = "#4A4A4A";
        border.graphics.setStrokeStyle(size).beginStroke(color);
        border.graphics.drawRoundRect(size/2, size/2, w - size, h - size, 1);
        border.graphics.endStroke();
        border.cache(0, 0, w, h);
        stage.addChild(border);
    }
    function showFPS() {
        if (config.debug) {
            fpsLabel = new createjs.Text("-- fps", "18px "+config.font, "#FFFFFF");
            fpsLabel.setTransform(15, 15);
            stage.addChild(fpsLabel);
        }
    }
    function showTime() {
        if (config.showTime) {
            timeLabel = new createjs.Text(config.gameTime/1000, "bold 36px "+config.font, "#EA5151");
            timeLabel.textAlign = "center";
            timeLabel.x = 103;
            timeLabel.y = 83;
            timeCircle = new createjs.Shape;
            timeCircle.cache(0, 0, 146, 146);
            timeCircle.setTransform(30, 30);
            workstage.addChild(timeCircle, timeLabel);
        }
    }

};
