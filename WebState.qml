import QtQuick 2.6
import QtWebKit 3.0

Item {
    id: web
    anchors.fill: parent
    visible: false
    onVisibleChanged: {
        if (web.visible == true) {
            webview.url = url
        } else {
            webview.stop()
            webview.url = "about:blank"
        }
    }

    WebView {
        id: webview
        url: url
        anchors.fill: parent
        enabled: parent.visible
    }
}
