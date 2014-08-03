var gamework = new function() {

    var canvas;
    var stage;
    var workstage;
    var queue;
    var fpsLabel;
    var timeLabel;
    var timeCircle;
    var borderSize = 12;
    var w = 1248;
    var h = 794;
    var w2 = w - borderSize * 2;
    var h2 = h - borderSize * 2;
    var sysScreen, sysScreenA, sysScreenB, startButton;
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
        stage.enableMouseOver(10);
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
                showSystemScreen(true);
            } else {
                showSystemScreen(false);
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
        //timerRun = true;
        createjs.Ticker.addEventListener("tick", tickHandler);
    }
    function startGame() {
        timerRun = true;
        showSystemScreen(false);
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
        showSystemScreen(true);
    }

    function paintBackground() {
        var background = new createjs.Bitmap(queue.getResult("background"));
        background.cache(0, 0, w, h);
        stage.addChild(background);
    }
    function paintSystemScreen() {
        sysScreen = new createjs.Container;
        sysScreen.setTransform(borderSize, borderSize);
        sysScreenA = new createjs.Shape;
        sysScreenA.graphics.beginFill("rgba(0,0,0,0.3)").drawRect(0, 0, w2/2, h2);
        sysScreenB = new createjs.Shape;
        sysScreenB.graphics.beginFill("rgba(0,0,0,0.3)").drawRect(w2/2, 0, w2/2, h2);
        startButton = new createjs.Container;
        startButton.addChild(new createjs.Bitmap(queue.getResult("button")));
        startButton.setTransform(w/2 - startButton.getBounds().width/2, h/2 - startButton.getBounds().height/2);
        startButton.cursor = "pointer";
        startButton.on("mousedown", function() {
            startGame();
        });
        sysScreen.addChild(sysScreenA, sysScreenB, startButton);
        stage.addChild(sysScreen);
    }
    function showSystemScreen(show) {
        var t = 200;
        if (show) {
            //console.log('showSystemFade(true)');
            sysScreen.visible = true;
            workstage.visible = false;
            createjs.Tween.get(sysScreenA).to({x:0}, t);
            createjs.Tween.get(sysScreenB).to({x:0}, t);
        } else {
            //console.log('showSystemFade(false)');
            createjs.Tween.get(sysScreenA).to({x:-w2/2}, t);
            createjs.Tween.get(sysScreenB).to({x:w2/2}, t).call(function() {
                sysScreen.visible = false;
                workstage.visible = true;
            });
        }
    }
    function paintBorder() {
        var border = new createjs.Shape;
        var color = "#4A4A4A";
        border.graphics.setStrokeStyle(borderSize).beginStroke(color);
        border.graphics.drawRoundRect(borderSize/2, borderSize/2, w - borderSize, h - borderSize, 1);
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
            timeLabel = new createjs.Text("", "bold 36px "+config.font, "#EA5151");
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
