#!/usr/bin/python3

import sys
import logging
import signal

from PyQt5.QtCore import QObject, QVariant, pyqtSlot, pyqtSignal
from PyQt5.QtWidgets import QApplication
from PyQt5.QtDBus import QDBus, QDBusConnection, QDBusInterface, QDBusMessage

from models import Server

logger = logging.getLogger(__name__)
signal.signal(signal.SIGINT, signal.SIG_DFL)


class Avahi(QObject):

    # Use those signals to get notified of changes in subscribed services
    # Emitted when initial scanning of avahi services is done
    initialized = pyqtSignal()
    # Emitted when a new service for our watched type is found
    added = pyqtSignal(QDBusMessage)
    removed = pyqtSignal(QDBusMessage)

    def __init__(self, parent, service, interface=-1, protocol=-1, domain='local'):
        super(Avahi, self).__init__(parent)
        self.service = service
        self.interface = interface
        self.protocol = protocol
        self.domain = domain
        self.bus = QDBusConnection.systemBus()
        self.bus.registerObject('/', self)
        self.server = QDBusInterface(
            'org.freedesktop.Avahi',
            '/',
            'org.freedesktop.Avahi.Server',
            self.bus
        )

    def run(self):
        flags = QVariant(0)
        flags.convert(QVariant.UInt)
        browser_path = self.server.call(
            'ServiceBrowserNew',
            self.interface,
            self.protocol,
            self.service,
            self.domain,
            flags
        )
        logger.debug('New ServiceBrowser: {}'.format(browser_path.arguments()))
        self.bus.connect(
            'org.freedesktop.Avahi',
            browser_path.arguments()[0],
            'org.freedesktop.Avahi.ServiceBrowser',
            'ItemNew',
            self.onItemNew
        )
        self.bus.connect(
            'org.freedesktop.Avahi',
            browser_path.arguments()[0],
            'org.freedesktop.Avahi.ServiceBrowser',
            'ItemRemove',
            self.onItemRemove
        )
        self.bus.connect(
            'org.freedesktop.Avahi',
            browser_path.arguments()[0],
            'org.freedesktop.Avahi.ServiceBrowser',
            'AllForNow',
            self.onAllForNow
        )

    @pyqtSlot(QDBusMessage)
    def onItemNew(self, msg):
        logger.debug('Avahi service discovered: {}'.format(msg.arguments()))
        flags = QVariant(0)
        flags.convert(QVariant.UInt)
        resolved = self.server.callWithArgumentList(
            QDBus.AutoDetect,
            'ResolveService',
            [
                *msg.arguments()[:5],
                self.protocol,
                flags
            ]
        )
        logger.debug('Avahi service resolved: {}'.format(resolved.arguments()))
        self.added.emit(resolved)

    @pyqtSlot(QDBusMessage)
    def onItemRemove(self, msg):
        logger.debug('Avahi service removed: {}'.format(msg.arguments()))
        self.removed.emit(msg)

    @pyqtSlot(QDBusMessage)
    def onAllForNow(self, msg):
        logger.debug('Avahi emitted all signals for discovered peers')
        self.initialized.emit()
