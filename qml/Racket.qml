import QtQuick 2.15

Item {
    id: racket
    width: 20
    height: model.size

    property var model
    property string color: "black"
    property real yAxisValue: 0
    property int speed: model.speed

    function timer() {
        if (yAxisValue != 0.0) {
            move()
        }
    }

    function move() {
        var offset = speed
        y += offset * yAxisValue

        if (y < mainWindow.borderWidth) {
            y = mainWindow.borderWidth
        } else if (y > mainWindow.height - mainWindow.borderWidth - height) {
            y = mainWindow.height - mainWindow.borderWidth - height
        }
    }

    Rectangle {
        anchors.fill: parent
        color: racket.color
    }
}
