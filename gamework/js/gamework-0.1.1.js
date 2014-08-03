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
    var sysScreen, sysScreenA, sysScreenB, countDown, buttons, startButton;
    //api
    var howState = false;
    var pauseState = false;
    var muteState = false;
    //run
    var started = false;
    var downCounter = config.startTime;
    var timerRun = false;
    var gamingTime = 0;

    this.init = function() {
        canvas = document.getElementById("gameworkCanvas");
        createjs.Ticker.setFPS(30);
        stage = new createjs.Stage(canvas);
        stage.enableMouseOver(10);
        workstage = new createjs.Container;
        workstage.visible = false;
        queue = new createjs.LoadQueue(true);
        queue.addEventListener("complete", start);
        queue.loadManifest(manifest);
    }
    this.how = function() {
        howState = !howState;
        return howState;
    }
    this.pause = function() {
        return pauseClick();
    }
    this.mute = function() {
        muteState = !muteState;
        return muteState;
    }

    function pauseClick() {
        if (timerRun) {
            pauseState = !pauseState;
            if (pauseState) {
                showSystemScreen(true);
            } else {
                showSystemScreen(false);
            }
        }
        return pauseState;
    }

    function start() {
        document.getElementById("gameworkLoading").style.display = "none";
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
        if (pauseState) {
            pauseClick();
        } else {
            started = false;
            downCounter = config.startTime;
            startButton.visible = false;
        }
    }
    function tickHandler(tick) {
        if (downCounter>0) {
            downCounter -= tick.delta;
            updateCounter();
        } else {
            if (!started) {
                started = true;
                startButton.visible = true;
                gamingTime = 0;
                timerRun = true;
                showSystemScreen(false);
            }
        }
        if (timerRun && !pauseState) {
            //console.log(createjs.Ticker.getTime(true));
            gamingTime += tick.delta;
            if (config.needTime == false || gamingTime < config.gameTime) {
                //playing
                updateTimer(gamingTime);
            } else {
                //time finished
                updateTimer(config.gameTime);
                timerRun = false;
                stop();
            }
        }
        if (!timerRun && gamingTime >= config.gameTime && !sysScreen.visible) {
            //fix if pause
            stop();
        }
        if (config.debug) {
            fpsLabel.text = Math.round(createjs.Ticker.getMeasuredFPS()) + " fps";
        }
        stage.update();
    }
    function updateTimer(time) {
        if (config.needTime) {
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
    function updateCounter() {
        var i = Math.ceil(downCounter/1000);
        if (i>0) {
            countDown.text = i;
        } else {
            countDown.text = "";
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
        countDown = new createjs.Text(Math.floor(downCounter/1000), "200px "+config.font, "#FFFFFF");
        countDown.setTransform(w/2 - countDown.getBounds().width/2, h/3 - countDown.getBounds().height/2);
        buttons = new createjs.Container;
        startButton = new createjs.Container;
        var fon = new createjs.Bitmap(queue.getResult("button"));
        var txt = new createjs.Text("START", "36px "+config.font, "#4A4A4A");
        txt.setTransform(100, 17);
        startButton.addChild(fon, txt);
        startButton.setTransform(w/2 - startButton.getBounds().width/2, h/2 - startButton.getBounds().height/2);
        startButton.cursor = "pointer";
        startButton.on("mousedown", function() {
            startGame();
        });
        startButton.visible = false;
        buttons.addChild(countDown, startButton);
        sysScreen.addChild(sysScreenA, sysScreenB, buttons);
        stage.addChild(sysScreen);
    }
    function showSystemScreen(show) {
        var t = 200;
        if (show) {
            //console.log('showSystemFade(true)');
            sysScreen.visible = true;
            workstage.visible = false;
            createjs.Tween.get(sysScreenA).to({x:0}, t);
            createjs.Tween.get(sysScreenB).to({x:0}, t).call(function() {
                buttons.visible = true;
            });
        } else {
            //console.log('showSystemFade(false)');
            buttons.visible = false;
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
        if (config.needTime) {
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
