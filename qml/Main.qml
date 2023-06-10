import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15
import QtMultimedia 5.15
import QtQml.StateMachine 1.15 as DSM

import "../common-qml"
import "../common-qml/CommonFunctions.js" as Functions

//TODO:
// - copy coin indicator as generic point counter to common-qml
// - points are: how ofter the ball hits the racket
//    - and 50 points per ball window
//    - maybe -50 points for ball lost (oponent points) - check that it is not lower than 0
// - highscore are points
// - maybe level - on each new level the ball is getting faster
// - collectible items:
//   - show up somewhere on the middle line
//   - collected when hit by the ball (from a specific player)
//   - item: enlarge racket
//   - item: speed

Window {
    id: mainWindow
    width: 1280
    height: 800
    visible: true
    title: qsTr("Pong")

    property var rackets: [racket1, racket2]
    property var collectibleItems: []
    property var overlay
    property int borderWidth: 10

    Component.onCompleted: {
        // TODO: need something like this for item function end
        // TODO: racket model
        RacketModel1.ballWinsChanged.connect(onBallWinsChanged)
        RacketModel2.ballWinsChanged.connect(onBallWinsChanged)


        //BugModel1.itemTimerFinished.connect(onItemTimerFinished)
        //BugModel2.itemTimerFinished.connect(onItemTimerFinished)
    }

    // draw game canvas
    Rectangle {
        id: table
        color: "royalblue"
        border.color: "white"
        border.width: borderWidth
        anchors.fill: parent

        Shape {
            width: borderWidth
            height: parent.height
            anchors.centerIn: parent
            ShapePath {
                strokeWidth: borderWidth
                strokeColor: "white"
                strokeStyle: ShapePath.DashLine
                dashPattern: [ 2, 4 ]
                startX: 5; startY: 0
                PathLine { x: 5; y: table.height }
            }
        }
    }

    /*CollectibleItem {
        id: itemChest
        itemImageSource: "../common-media/treasure-chest.png"
        hitSoundSource: ""
        minimalWaitTime: 60000
        itemActive: false
    }*/

    Racket {
        id: racket1
        model: RacketModel1
        x: 50
        y: (parent.height / 2) - (height / 2)
        Connections {
            target: QJoysticks
            function onAxisChanged() {
                racket1.yAxisValue = Functions.filterAxis(QJoysticks.getAxis(0, 1))
            }
        }
    }

    Racket {
        id: racket2
        model: RacketModel2
        x: parent.width - 50 - width
        y: (parent.height / 2) - (height / 2)
        color: "red"
        Connections {
            target: QJoysticks
            function onAxisChanged() {
                racket2.yAxisValue = Functions.filterAxis(QJoysticks.getAxis(1, 1))
            }
        }
    }

    Ball {
        id: ball
        racketModel1: RacketModel1
        racketModel2: RacketModel2
    }

    RowLayout {
        id: layout
        width: mainWindow.width
        height: 70
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        // stay on top of everything
        z: 1000
        anchors.bottomMargin: 25
        PointsIndicator {
            id: racket1PointsIndicator
            model: RacketModel1
            player: GameData.player1
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        }
        TimeLevelIndicator {
            id: timeLevelIndicator
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
            Layout.bottomMargin: 5
        }
        PointsIndicator {
            id: racket2PointsIndicator
            model: RacketModel2
            player: GameData.player2
            Layout.alignment: Qt.AlignBottom | Qt.AlignHCenter
        }
    }

    Audio {
        id: itemTimerFinishedSound
        source: "../coinhunt-media/item-end.wav"
    }

    function onItemTimerFinished() {
        itemTimerFinishedSound.source = ""
        itemTimerFinishedSound.source = "../coinhunt-media/item-end.wav"
        itemTimerFinishedSound.play()
    }

    // game logic
    //TODO: put properties here
    property int activeRacketHitId: -1
    property double startTime: 0
    property double currentTime: 0
    property int currentLevel: 0
    property int levelDuration: 30
    property bool restart: false

    GameStateMachine {
        id: gameStateMachine
        gameResetAction: mainWindow.gameResetAction
        gameCountdownAction: mainWindow.gameCountdownAction
        gameStartAction: mainWindow.gameStartAction
        gameStopAction: mainWindow.gameStopAction
    }

    function gameResetAction() {
        console.log("Resetting game...")

        restart = false
        currentLevel = 1
        currentTime = 0
        timeLevelIndicator.setLevel(currentLevel)
        timeLevelIndicator.setTime(currentTime)

        // initialize models
        RacketModel1.initialize()
        RacketModel2.initialize()
        GameData.initialize()

        overlay = Qt.createQmlObject('import "../common-qml"; GameStartOverlay {}', mainWindow, "overlay")
        overlay.gameName = "Pong"
        overlay.player1ImageSource = "../pong-media/black.png"
        overlay.player2ImageSource = "../pong-media/red.png"
        overlay.signalStart = gameStateMachine.signalStartCountdown
        timer.start()
    }

    function gameCountdownAction() {
        console.log("Starting countdown...")

        GameData.savePlayerNames()
        overlay = Qt.createQmlObject('import "../common-qml"; CountdownOverlay {}', mainWindow, "overlay")
        overlay.signalStart = gameStateMachine.signalStartGame
    }

    function gameStartAction() {
        console.log("Starting game...")

        //gameTimer.start()
        //timer.start()

        if (!restart) {
            startTime = new Date().getTime()
            gameTimer.start()
        }

        // activate collectible items
        for (var itemIndex = 0; itemIndex < collectibleItems.length; itemIndex++) {
            collectibleItems[itemIndex].itemActive = true
        }

        ball.start()
    }

    function gameStopAction() {
        console.log("Stopping game...")

        //gameTimer.stop()
        //timer.stop()

        gameTimer.stop()

        // disable collectible items
        for (var itemIndex = 0; itemIndex < collectibleItems.length; itemIndex++) {
            collectibleItems[itemIndex].itemActive = false
        }

        //GameData.player1.pointsAchieved = BugModel1.coinsCollected
        //GameData.player2.pointsAchieved = BugModel2.coinsCollected
        //GameData.updateHighscores()
        //GameData.saveHighscores()

        overlay = Qt.createQmlObject('import "../common-qml"; GameEndOverlay { gameType: GameEndOverlay.GameType.Coop }', mainWindow, "overlay")
        overlay.signalStart = gameStateMachine.signalResetGame
    }

    Timer {
        id: gameTimer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            currentTime = new Date().getTime() - startTime
            updateClock()
            updateLevel()
        }
    }

    function updateClock() {
        timeLevelIndicator.setTime(currentTime)
    }

    function updateLevel() {
        var newLevel = 1 + Math.floor(currentTime / 1000 / levelDuration)
        if (newLevel != currentLevel) {
            timeLevelIndicator.setLevel(newLevel)
            currentLevel = newLevel
            // TODO: increase ball speed
        }
    }

    /*Timer {
        id: gameTimer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            if (gamePause) {
                startTime = new Date().getTime() - (levelDuration - currentTime)
            } else {
                currentTime = levelDuration - (new Date().getTime() - startTime)
            }

            if (currentTime <= 0) {
                checkGameEnd()
                startNextLevel()
            }

            if (gameTimer.running) {
                startNextCoinRound()
                timeLevelIndicator.setTime(currentTime)
            }
        }
    }*/

    /*Timer {
        id: gamePauseTimer
        interval: 10000
        running: false
        repeat: false
        onTriggered: {
            gamePause = false
            onItemTimerFinished()
        }
    }*/

    function onBallWinsChanged() {
        //TODO: delay
        //TODO: check for game end
        if (RacketModel1.ballWins > 0 || RacketModel2.ballWins > 0) {
            restart = true
            gameStateMachine.signalStartCountdown()
        }
    }

    function checkGameEnd() {
        //TODO: one player has 11 scores (other player misses) - these are not the actual points for the highscore
    }

    // collision detection
    Timer {
        id: timer
        interval: 20
        running: false
        repeat: true
        onTriggered: {
            ball.timer()
            racket1.timer()
            racket2.timer()
            detectAllCollision()
        }
    }

    function detectAllCollision() {
        // ball vs. racket collision - depends on where the ball hits the racket
        for (var racketIndex = 0; racketIndex < rackets.length; racketIndex++) {
            var colliding = Functions.detectCollisionRectangleRectangle(rackets[racketIndex], ball)
            if (colliding) {
                if (activeRacketHitId != racketIndex) {
                    ball.racketHit()
                    rackets[racketIndex].model.addBallHit()
                    activeRacketHitId = racketIndex
                }
            } else {
                if (activeRacketHitId == racketIndex) {
                    activeRacketHitId = -1
                }
            }
        }

        // ball vs. item collision
        /*if (itemCollisionEnabled) {
            for (bugIndex = 0; bugIndex < bugs.length; bugIndex++) {
                if (bugs[bugIndex].bugModel.enabled) {
                    for (var itemIndex = 0; itemIndex < collectibleItems.length; itemIndex++) {
                        if (collectibleItems[itemIndex].visible) {
                            colliding = Functions.detectCollisionCircleCircle(bugs[bugIndex], collectibleItems[itemIndex])
                            if (colliding) {
                                var condition
                                var action
                                if (itemIndex === 0) {
                                   // itemSpeed
                                   condition = true
                                   action = function func(speed) {bugs[bugIndex].bugModel.startSpeedRun(speed, 10000)}
                                } else if (itemIndex === 1) {
                                    // itemEnlarge
                                    condition = true
                                    action = function func() {bugs[bugIndex].bugModel.startEnlargeRun(253, 200, 10000)}
                                } else if (itemIndex === 2) {
                                    // itemPause
                                    condition = true
                                    action = function func() {gamePause = true; gamePauseTimer.start()}
                                } else if (itemIndex === 3) {
                                    // itemClean
                                    condition = true
                                    action = function func() {cleanCoins(bugs[bugIndex].bugModel)}
                                } else if (itemIndex === 4) {
                                    // itemChest
                                    chestCollisionCounter += 1
                                    condition = chestCollisionCounter >= 167 // about 5 secons
                                    action = function func() {
                                        chestCollisionCounter = 0;
                                        var coins = numberOfCoinsPerRound * 5;
                                        bugs[bugIndex].bugModel.coinsCollected = bugs[bugIndex].bugModel.coinsCollected + coins;
                                        extraCoins = extraCoins + coins
                                    }
                                }
                                collectibleItems[itemIndex].hit(condition, action)
                            }
                        }
                    }
                }
            }
        }*/
    }
}
