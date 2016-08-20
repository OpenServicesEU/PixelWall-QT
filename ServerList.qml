import QtQuick 2.0

Item {
  width: parent.width * 0.5
  height: parent.height * 0.5
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.verticalCenter: parent.verticalCenter
  Text {
    id: hint
    text: "Please select a master server"
    clip: true
    opacity: 0.8
    anchors.horizontalCenter: parent.horizontalCenter
    transformOrigin: Item.Center
    font.pointSize: 20
    style: Text.Normal
    textFormat: Text.AutoText
    wrapMode: Text.NoWrap
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    font.family: "Verdana"
  }
  ListView {
    signal itemChanged(var item)
    id: serverList
    objectName: "servers"
    anchors.topMargin: hint.height *1.1
    anchors.fill: parent
    spacing: 40
    model: serverModel
    highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
    focus: true
    interactive: false //Disable interactive so we can re-implement key behaviour
    Keys.onPressed: {
      if (event.key == Qt.Key_Up){
        serverList.decrementCurrentIndex();
      }
      else if (event.key == Qt.Key_Down){
        serverList.incrementCurrentIndex();
      }
      itemChanged(serverList.currentItem.selectedItem.data);
    }
    delegate: Component {
      MouseArea {
        property variant selectedItem: model
        height: 60
        width: parent.width
        onClicked: {
            app.serverSelected(index);
        }
        Rectangle {
          anchors.fill: parent
          color: "#cecece"
          Text {
            anchors.left: parent.left
            anchors.leftMargin: parent.height * 0.5
            anchors.verticalCenter: parent.verticalCenter
            text: name + " [" + host + ":" + port + "]"
          }
          Rectangle {
            height: parent.height * 0.8
            width: height
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            color: "#ffffff"
            Image {
              source: "pixelwall-logo.svg"
              sourceSize.height: parent.height * 2
              sourceSize.width: parent.width * 2
              fillMode: Image.PreserveAspectFit
              anchors.fill: parent
            }
          }
        }
      }
    }
  }
}
