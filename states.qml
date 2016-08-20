import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    id: main
    visibility: Window.FullScreen
    visible: true

    Item {
        id: pixelwall
        objectName: "main"
        anchors.fill: parent
        Keys.onEscapePressed: Qt.quit()
        Keys.onDigit1Pressed: pixelwall.state = "Splash"
        Keys.onDigit2Pressed: pixelwall.state = "Servers"
        Keys.onDigit3Pressed: pixelwall.state = "Settings"
        Keys.onDigit4Pressed: pixelwall.state = "Web"
        Keys.onDigit5Pressed: pixelwall.state = "Video"
        Keys.onDigit6Pressed: app.reset();
        focus: true

        Item {
            id: splash
            visible: true
            anchors.fill: parent

            Image {
                id: logo
                antialiasing: true
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "pixelwall-logo.svg"
                sourceSize.width: parent.width * 2
                sourceSize.height: parent.height * 2
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
                    running: splash.visible
                    loops: Animator.Infinite
                    target: yRot
                    property: "angle"
                    from: 0
                    to: 360
                    duration: 10000
                }
            }

            Text {
                id: name
                text: "PixelWall"
                clip: true
                opacity: 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                transformOrigin: Item.Center
                font.pointSize: 50
                style: Text.Normal
                textFormat: Text.AutoText
                wrapMode: Text.NoWrap
                anchors.centerIn: parent.Center
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: "Verdana"
            }

        }
        ServersState {
            id: servers
        }
        SettingsState {
            id: settings
        }
        WebState {
            id: web
        }
        VideoState {
            id: video
        }
        states: [
            State {
                name: "Servers"

                PropertyChanges {
                    target: splash
                    visible: true
                    opacity: 0.2
                }

                PropertyChanges {
                    target: servers
                    visible: true
                    opacity: 1
                }

                PropertyChanges {
                    target: settings
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: web
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: video
                    visible: false
                    opacity: 0
                }
            },
            State {
                name: "Settings"

                PropertyChanges {
                    target: splash
                    visible: true
                    opacity: 0.2
                }

                PropertyChanges {
                    target: web
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: servers
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: settings
                    visible: true
                    opacity: 1
                }

                PropertyChanges {
                    target: video
                    visible: false
                    opacity: 0
                }
            },
            State {
                name: "Web"

                PropertyChanges {
                    target: splash
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: settings
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: servers
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: web
                    visible: true
                    opacity: 1
                }

                PropertyChanges {
                    target: video
                    visible: false
                    opacity: 0
                }
            },
            State {
                name: "Video"

                PropertyChanges {
                    target: splash
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: settings
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: servers
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: web
                    visible: false
                    opacity: 0
                }

                PropertyChanges {
                    target: video
                    visible: true
                    opacity: 1
                }
            }
        ]
    }
}
