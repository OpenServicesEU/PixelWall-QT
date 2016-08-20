import logging

from PyQt5.QtCore import (
    QAbstractListModel,
    QModelIndex,
    QObject,
    Qt,
    QVariant,
    pyqtProperty,
    pyqtSlot,
    pyqtSignal
)
from PyQt5.QtDBus import QDBusMessage

logger = logging.getLogger(__name__)


class Server(QObject):

    def __init__(self, parent, interface, protocol, name, stype, domain, host=None, aprotocol=None, address=None, port=None, txt=None):
        super(Server, self).__init__(parent)
        self._name = name
        self._host = host
        self._port = port
        self._data = txt

    def __eq__(self, other):
        pass

    @pyqtProperty(str)
    def name(self):
        return self._name

    @pyqtProperty(str)
    def host(self):
        return self._host

    @pyqtProperty(int)
    def port(self):
        return self._port


class ServerModel(QAbstractListModel):

    updated = pyqtSignal()

    NameRole = Qt.UserRole + 1
    HostRole = Qt.UserRole + 2
    PortRole = Qt.UserRole + 3

    _roles = {
        NameRole: b'name',
        HostRole: b'host',
        PortRole: b'port'
    }

    def __init__(self, parent):
        super(ServerModel, self).__init__(parent)
        self._servers = []

    def getIndex(self, index):
        return self._servers[index]

    def data(self, index, role=Qt.DisplayRole):
        try:
            server = self._servers[index.row()]
        except IndexError:
            return QVariant()

        if role == self.NameRole:
            return server.name

        if role == self.HostRole:
            return server.host

        if role == self.PortRole:
            return server.port

        return QVariant()

    def rowCount(self, parent=QModelIndex()):
        return len(self._servers)

    def roleNames(self):
        return self._roles

    @pyqtSlot(QDBusMessage)
    def addService(self, msg):
        server = Server(self, *msg.arguments()[:10])
        logger.debug('Adding new server: {}'.format(server))
        self.beginInsertRows(QModelIndex(), self.rowCount(), self.rowCount())
        self._servers.append(server)
        self.endInsertRows()
        self.updated.emit()

