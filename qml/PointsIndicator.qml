import QtQuick 2.15
import QtMultimedia 5.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15

import Theme 1.0

Item {
    id: pointsIndicator
    width: 300
    height: parent.height

    property var model
    property var player

    Component.onCompleted: {
        model.ballHitsChanged.connect(onBallHitsChanged)
        model.ballWinsChanged.connect(onBallWinsChanged)
    }

    function onBallHitsChanged() {
        ballHitsText.text = "Hits: " + model.ballHits
    }

    function onBallWinsChanged() {
        ballWinsText.text = "Wins: " + model.ballWins
    }

    Text {
        id: name
        width: parent.width
        text: player.name
        font.family: Theme.mainFont
        font.pixelSize: Theme.textFontSize
        color: Theme.lightTextColor
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
    }

    Rectangle {
        id: background
        width: parent.width
        height: 40
        anchors.top: name.bottom
        color: Theme.overlayBackgroundColor
        radius: 10
        border.width: Theme.overlayBorderWidth
        border.color: Theme.overlayBorderColor

        RowLayout {
            id: layout
            anchors.fill: parent

            Text {
                id: ballWinsText
                font.family: Theme.mainFont
                font.pixelSize: Theme.textFontSize
                color: Theme.lightTextColor
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.bottomMargin: 5
                text: "Wins: 0"
            }

            Text {
                id: ballHitsText
                font.family: Theme.mainFont
                font.pixelSize: Theme.textFontSize
                color: Theme.lightTextColor
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.bottomMargin: 5
                text: "Hits: 0"
            }
        }
    }
}
