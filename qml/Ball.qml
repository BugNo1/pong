import QtQuick 2.15

Item {
    id: ball
    width: 20
    height: 20
    visible: false

    property int xOffset: 0
    property int yOffset: 0
    property int minimalSpeed: 10
    property int speed: minimalSpeed
    property int xDirection: dRIGHT
    property int yDirection: dSTRAIGHT

    readonly property int dLEFT: -1
    readonly property int dRIGHT: 1
    readonly property int dUP: -1
    readonly property int dDOWN: 1
    readonly property int dSTRAIGHT: 0

    function start() {
        reset()
        xDirection = randomElement([dLEFT, dRIGHT])
        ball.visible = true
        animationTimer.start()
    }

    function reset() {
        x = (parent.width / 2) - (width / 2)
        y = (parent.height / 2) - (height / 2)
        speed = minimalSpeed
        xOffset = speed
        yDirection = dSTRAIGHT
    }

    function randomElement(array) {
        return array[Math.floor(Math.random() * array.length)]
    }

    function move() {
        x = x + (xOffset * xDirection)
        y = y + (yOffset * yDirection)
    }

    Rectangle {
        anchors.fill: parent
        color: "white"
    }

    Timer {
        id: animationTimer
        interval: 20
        running: false
        repeat: true
        onTriggered: {
            move()
        }
    }
}
