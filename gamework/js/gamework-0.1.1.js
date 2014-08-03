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
    var sysScreen, sysScreenA, sysScreenB, countDown, pauseButtons, overButtons, workoutButton, replayButton, resumeButton, nextButton;
    var points = 0;
    //api
    var howState = false;
    var pauseState = false;
    var muteState = false;
    //run
    var started = false;
    var ended = false;
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
    function restartGame() {
        ended = false;
        started = false;
        pauseState = false;
        downCounter = config.startTime;
        gamingTime = 0;
        pauseButtons.visible = false;
        overButtons.visible = false;
    }
    function startGame() {
        if (!started) {
            started = true;
            gamingTime = 0;
            timerRun = true;
            showSystemScreen(false);
        }
    }
    function tickHandler(tick) {
        if (downCounter>0) {
            downCounter -= tick.delta;
            updateCounter();
        } else {
            startGame();
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
                gameOver();
            }
        }
        if (!timerRun && gamingTime >= config.gameTime && !sysScreen.visible) {
            //fix if pause
            gameOver();
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
    function gameOver(){
        console.log('gameOver');
        ended = true;
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
        sysScreenA.graphics.beginFill("rgba(0,0,0,0.5)").drawRect(0, 0, w2/2, h2);
        sysScreenB = new createjs.Shape;
        sysScreenB.graphics.beginFill("rgba(0,0,0,0.5)").drawRect(w2/2, 0, w2/2, h2);
        countDown = new createjs.Text("", "250px "+config.font2_semibold, "#FFFFFF");
        countDown.textAlign = "center";
        countDown.textBaseline = "alphabetic";
        countDown.setTransform(w/2, h/2);
        //pause
        pauseButtons = new createjs.Container;
        pauseButtons.visible = false;
        workoutButton = new createjs.Container;
        var fon = new createjs.Bitmap(queue.getResult("button"));
        var txt = new createjs.Text("BACK TO WORKOUT", "30px "+config.font2_reg, "#4A4A4A");
        txt.lineWidth = 327;
        txt.textAlign = "center";
        txt.textBaseline = "alphabetic";
        txt.setTransform(163, 47);
        workoutButton.addChild(fon, txt);
        workoutButton.setTransform(100, h/2 - workoutButton.getBounds().height/2);
        workoutButton.cursor = "pointer";
        workoutButton.on("mousedown", function() {
            console.log("back to workout");
        });
        replayButton = new createjs.Container;
        var fon = new createjs.Bitmap(queue.getResult("button"));
        var txt = new createjs.Text("REPLAY", "30px "+config.font2_reg, "#4A4A4A");
        txt.lineWidth = 327;
        txt.textAlign = "center";
        txt.textBaseline = "alphabetic";
        txt.setTransform(163, 47);
        replayButton.addChild(fon, txt);
        replayButton.setTransform(w/2 - replayButton.getBounds().width/2, h/2 - replayButton.getBounds().height/2);
        replayButton.cursor = "pointer";
        replayButton.on("mousedown", function() {
            restartGame();
        });
        resumeButton = new createjs.Container;
        var fon = new createjs.Bitmap(queue.getResult("button_green"));
        var txt = new createjs.Text("RESUME", "30px "+config.font2_reg, "#F1F1F1");
        txt.lineWidth = 327;
        txt.textAlign = "center";
        txt.textBaseline = "alphabetic";
        txt.setTransform(163, 47);
        resumeButton.addChild(fon, txt);
        resumeButton.setTransform(w - 429, h/2 - resumeButton.getBounds().height/2);
        resumeButton.cursor = "pointer";
        resumeButton.on("mousedown", function() {
            pauseClick();
        });
        pauseButtons.addChild(workoutButton, replayButton, resumeButton);
        //over
        var total = new createjs.Text("Total score:", "120px "+config.font2_bold, "#F1F1F1");
        total.textAlign = "center";
        total.textBaseline = "alphabetic";
        total.setTransform(w/2, 300);
        var score = new createjs.Text(points + " points", "120px "+config.font2_thin, "#F1F1F1");
        score.textAlign = "center";
        score.textBaseline = "alphabetic";
        score.setTransform(w/2, 420);
        overButtons = new createjs.Container;
        overButtons.visible = false;
        nextButton = new createjs.Container;
        var fon = new createjs.Bitmap(queue.getResult("button"));
        var txt = new createjs.Text("NEXT", "30px "+config.font2_reg, "#4A4A4A");
        txt.lineWidth = 327;
        txt.textAlign = "center";
        txt.textBaseline = "alphabetic";
        txt.setTransform(163, 47);
        nextButton.addChild(fon, txt);
        nextButton.setTransform(w/2 - nextButton.getBounds().width/2, h*0.7 - nextButton.getBounds().height/2);
        nextButton.cursor = "pointer";
        nextButton.on("mousedown", function() {
            restartGame();
        });
        overButtons.addChild(total, score, nextButton);
        sysScreen.addChild(sysScreenA, sysScreenB, countDown, pauseButtons, overButtons);
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
                if (ended) {
                    overButtons.visible = true;
                    pauseButtons.visible = false;
                } else {
                    overButtons.visible = false;
                    pauseButtons.visible = true;
                }
            });
        } else {
            //console.log('showSystemFade(false)');
            overButtons.visible = false;
            pauseButtons.visible = false;
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
            timeLabel = new createjs.Text("", "bold 40px "+config.font3_bold, "#EA5151");
            timeLabel.textAlign = "center";
            timeLabel.textBaseline = "alphabetic";
            timeLabel.x = 105;
            timeLabel.y = 115;
            timeCircle = new createjs.Shape;
            timeCircle.cache(0, 0, 146, 146);
            timeCircle.setTransform(30, 30);
            workstage.addChild(timeCircle, timeLabel);
        }
    }

};
