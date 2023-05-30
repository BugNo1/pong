import QtQuick 2.15

Item {
    id: racket
    width: 20
    height: 100

    property string color: "black"
    property real yAxisValue: 0

    Rectangle {
        anchors.fill: parent
        color: racket.color
    }

    Timer {
        id: animationTimer
        interval: 20
        running: true
        repeat: true
        onTriggered: {
            if (yAxisValue != 0.0) {
                move()
            }
        }
    }

    function move() {
        var offset = 15
        y += offset * yAxisValue

        if (y < mainWindow.borderWidth) {
            y = mainWindow.borderWidth
        } else if (y > mainWindow.height - mainWindow.borderWidth - height) {
            y = mainWindow.height - mainWindow.borderWidth - height
        }

        //hitboxY = y + height / 2
    }
}
