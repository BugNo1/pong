import QtQuick 2.15
import QtMultimedia 5.15
import "../common-qml/CommonFunctions.js" as Functions

Item {
    id: ball
    width: 20
    height: 20
    visible: false

    property int speed: 0
    property bool active: false

    property var racketModel1
    property var racketModel2

    property real xDirection: dUNDEFINED
    property real yDirection: dUNDEFINED

    readonly property int dLEFT: -1
    readonly property int dRIGHT: 1
    readonly property int dUP: -1
    readonly property int dDOWN: 1
    readonly property int dUNDEFINED: 0

    function start() {
        reset()
        if (xDirection === dUNDEFINED) {
            xDirection = randomElement([dLEFT, dRIGHT])
        }
        yDirection = randomElement([dUP, dDOWN])
        ball.visible = true
        active = true
    }

    function reset() {
        active = false
        ball.visible = false
        x = (parent.width / 2) - (width / 2)
        y = (parent.height / 2) - (height / 2)
    }

    function racketHit(hitFactor) {
        xDirection = -xDirection
        yDirection = hitFactor
        racketHitAudio.source = ""
        racketHitAudio.source = "../pong-media/racket-hit.wav"
        racketHitAudio.play()
    }

    function timer() {
        if (active) {
            checkBorderCollision()
            move()
        }
    }

    function randomElement(array) {
        return array[Math.floor(Math.random() * array.length)]
    }

    function checkBorderCollision() {
        if ((y <= mainWindow.borderWidth) || (y >= mainWindow.height - mainWindow.borderWidth - width)) {
            yDirection = -yDirection
            wallHitAudio.source = ""
            wallHitAudio.source = "../pong-media/wall-hit.wav"
            wallHitAudio.play()
        } else if (x <= mainWindow.borderWidth) {
            if (active) {
                racketModel2.addBallWin()
                reset()
                xDirection = dRIGHT
            }
        } else if (x >= mainWindow.width - mainWindow.borderWidth - width) {
            if (active) {
                racketModel1.addBallWin()
                reset()
                xDirection = dLEFT
            }
        }
    }

    function move() {
        x = x + (speed * xDirection)
        y = y + (speed * yDirection)
    }

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    Audio {
        id: racketHitAudio
        source: "../pong-media/racket-hit.wav"
    }

    Audio {
        id: wallHitAudio
        source: "../pong-media/wall-hit.wav"
    }
}
