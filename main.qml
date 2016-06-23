import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    id: window1
    visible: true
    visibility: "FullScreen"
    width: 640
    height: 480
    title: qsTr("PixelWall")

    Image {
        id: logo
        antialiasing: false
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        source: "pixelwall-logo.svg"
    }
}
