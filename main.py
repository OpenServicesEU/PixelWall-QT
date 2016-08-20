import sys
import logging

from OpenGL import GL

from PyQt5.QtCore import QUrl, QObject, QSettings, pyqtSlot
from PyQt5.QtWidgets import QApplication, QListView
from PyQt5.QtQml import QQmlApplicationEngine, QQmlNetworkAccessManagerFactory
from PyQt5.QtNetwork import QNetworkAccessManager, QNetworkProxy

from autodiscover import Avahi
from models import ServerModel

logger = logging.getLogger(__name__)


class NetworkAccessManagerFactory(QQmlNetworkAccessManagerFactory):

    def __init__(self, host, port):
        super(NetworkAccessManagerFactory, self).__init__()
        self.proxy = QNetworkProxy(QNetworkProxy.HttpProxy, host, port)

    def create(parent):
        nam = QNetworkAccessManager(parent)
        nam.setProxy(self.proxy)
        return nam


class PixelWall(QApplication):

    def __init__(self, *args, **kwargs):
        super(PixelWall, self).__init__(*args, **kwargs)
        self.engine = QQmlApplicationEngine(self)
        self.servers = ServerModel(self.engine)
        self.settings = QSettings('OpenServices', 'PixelWall')
        url = self.settings.value('server/url')
        self.engine.setNetworkAccessManagerFactory(NetworkAccessManagerFactory('hetzner.fladi.at', 3128))
        ctxt = self.engine.rootContext()
        ctxt.setContextProperty('app', self)
        ctxt.setContextProperty('url', 'about:blank')
        self.engine.load(QUrl('states.qml'))
        discoverer = Avahi(self.engine, '_pixelwall._tcp')
        discoverer.initialized.connect(self.serverState)
        discoverer.added.connect(self.servers.addService)
        ctxt.setContextProperty('serverModel', self.servers)
        discoverer.run()
        if url:
            self.setUrl(url)
            self.setState('Web')

    def setState(self, state):
        for root in self.engine.rootObjects():
            node = root.findChild(QObject, 'main')
            if node:
                logger.info('Setting state: {}'.format(state))
                node.setProperty('state', state)

    def setUrl(self, url):
        logger.info('Connecting WebView to {}'.format(url))
        ctxt = self.engine.rootContext()
        ctxt.setContextProperty('url', 'https://www.heise.de/')

    @pyqtSlot()
    def reset(self):
        self.settings.remove('server/url')
        self.setState('Servers')

    @pyqtSlot(int)
    def serverSelected(self, index):
        server = self.servers.getIndex(index)
        logger.info('Server selected {}'.format(server))
        url = 'https://{server.host}:{server.port}/'.format(server=server)
        self.settings.setValue('server/url', url)
        self.setUrl(url)
        self.setState('Web')

    @pyqtSlot()
    def serverState(self):
        self.setState('Servers')


# Main Function
if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    # Create main app
    app = PixelWall(sys.argv)
    # Execute the Application and Exit
    sys.exit(app.exec_())
