import sys
from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQml import QQmlApplicationEngine

# Main Function
if __name__ == '__main__':
    # Create main app
    app = QApplication(sys.argv)
    # Create a label and set its properties
    #appLabel = QQuickView()
    #appLabel.setSource(QUrl('main.qml'))

    # Show the Label
    #appLabel.show()
    engine = QQmlApplicationEngine(app)
    engine.load(QUrl('main.qml'))

    # Execute the Application and Exit
    app.exec_()
    sys.exit()
