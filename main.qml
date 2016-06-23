import QtQuick 2.6
import QtQuick.Window 2.2
import QtWebKit 3.0
import QtWebSockets 1.0
import QtAudioEngine 1.1
import QtPositioning 5.6
import QtQuick.Extras 1.4
import QtQuick.Controls 1.5
import QtQuick.Layouts 1.3

Window {
    id: window1
    visible: true
    visibility: "FullScreen"
    title: qsTr("PixelWall")

    Image {
        id: logo
        antialiasing: false
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "pixelwall-logo.svg"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        transform: [
            Rotation {
                id: yRot
                origin.x: logo.width / 2
                origin.y: logo.height / 2
                angle: 0
                axis {
                    x: 0
                    y: 1
                    z: 0
                }
            }
        ]
        NumberAnimation {
            running: true
            loops: Animator.Infinite
            target: yRot
            property: "angle"
            from: 0
            to: 360
            duration: 4000
        }
    }

    Text {
        id: name
        x: 74
        y: 216
        text: "PixelWall"
        clip: true
        opacity: 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        transformOrigin: Item.Left
        font.pointSize: 50
        style: Text.Normal
        textFormat: Text.AutoText
        wrapMode: Text.NoWrap
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: "Verdana"
    }

    Text {
        id: state
        x: 317
        y: 432
        text: qsTr("Looking for servers ...")
        anchors.bottomMargin: 21
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: logo.horizontalCenter
        font.pixelSize: 12
    }
}
