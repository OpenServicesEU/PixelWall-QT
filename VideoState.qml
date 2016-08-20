import QtQuick 2.6
import QtMultimedia 5.6

Item {
    id: video
    anchors.fill: parent
    visible: false

    MediaPlayer {
        id: player
        source: "file://video.webm"
        autoPlay: false
    }

    VideoOutput {
        id: videoOutput
        source: player
        anchors.fill: parent
    }
}
