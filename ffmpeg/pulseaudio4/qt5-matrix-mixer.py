# !/usr/bin/env python3
import sys
import random
import os
# Import QApplication and the required widgets from PyQt5.QtWidgets
from PyQt5.QtWidgets import QApplication
from PyQt5.QtWidgets import QMainWindow
from PyQt5.QtWidgets import QWidget
from PyQt5.QtWidgets import QDialog
from PyQt5.QtCore import Qt, QObject
# from PyQt5.QtGui import QtWebEngineWidgets  ??????
from PyQt5.QtWidgets import QGridLayout, QLineEdit, QFileDialog, QPushButton, QVBoxLayout
from PyQt5.QtWidgets import QShortcut, QListWidget, QAbstractItemView
from PyQt5.QtGui import QKeySequence
from PyQt5.QtCore import pyqtSlot, pyqtSignal

from functools import partial
from numpy import zeros, matrix, float64, linalg, arange, array, ndarray, array, random
from numpy import set_printoptions, inf, nan, savetxt, savez, load
set_printoptions(precision=14, threshold=sys.maxsize)

class PyGeoCalcUi(QMainWindow):
    """PyCalc's View (GUI)."""

    def __init__(self):
        """View initializer."""
        super().__init__()
        self.setWindowTitle("PyGeoCompute")
        self.setFixedSize(1048, 802)
        self.generalLayout = QVBoxLayout()
        self.generalLayout.setContentsMargins(0, 0, 0, 0)
        self.generalLayout.setSizeConstraint(1)
        self.generalLayout.addStretch(0)
        self._centralWidget = QWidget(self)
        self.setCentralWidget(self._centralWidget)
        self._centralWidget.setLayout(self.generalLayout)
        #self.view = QtWebEngineWidgets.QWebEngineView()
        #self.generalLayout.addWidget(self.view)
        #self.page = QtWebEngineWidgets.QWebEnginePage(self)
        #self.page = ""
        #self.view.setPage(self.page)
        # Create the display and the buttons
        self._createButtons()

    @pyqtSlot()
    def _exit(self):
        exit(0)

    def _createButtons(self):
        """Create the buttons."""
        self.buttons = {}
        buttonsLayout = QGridLayout()
        buttonsLayout.setSpacing(0)
        buttonsLayout.rowStretch(1)
        buttonsLayout.setHorizontalSpacing(0)
        buttonsLayout.setVerticalSpacing(0)
        buttonsLayout.setColumnStretch(1,1)
        buttonsLayout.setContentsMargins(0, 0, 0, 0)        
        buttons= {}

        for x in range(232):
            for y in range(32):
                d = random.randint(32)+1
                field = str(chr(d+36))
                buttons[field] = (x,y)

        # Create the buttons and add them to the grid layout
        for btnText, pos in buttons.items():
            self.buttons[btnText] = QPushButton(btnText)
            self.buttons[btnText].setFixedSize(32, 32)
            self.buttons[btnText].sizePolicy() # (QWidget.QSizePolicy.Expanding, QWidget.QSizePolicy.Expanding)
            #qsize = QSize()
            #self.buttons[btnText].setSizePolicy(qsize)
            buttonsLayout.addWidget(self.buttons[btnText], pos[0], pos[1])			
        self.generalLayout.addLayout(buttonsLayout)

class PyGeoCalcCtrl(QObject):
    """PyCalc Controller class."""

    dropped = pyqtSignal()

    def __init__(self, view):
        """Controller initializer."""
        self._view = view
        # Connect signals and slots
        self._connectSignals()

    def _buildExpression(self, sub_exp):
        """Build expression."""
        expression = self._view.displayText() + sub_exp
        self._view.setDisplayText(expression)

    def _connectSignals(self):
        """Connect signals and slots."""
        #for btnText, btn in self._view.buttons.items():
        #    if btnText not in {"=", "C"}:
        #        btn.clicked.connect(partial(self._buildExpression, btnText))
        #self._view.buttons["Q"].clicked.connect(self._view._exit)
        pass

class Window(QWidget):
    def __init__(self, parent=None):
        super(Window, self).__init__(parent)
        self.toolbar = NavigationToolbar(self.canvas, self)
        self.button = QPushButton("Plot")
        #self.button.clicked.connect(self.plot)

        # set the layout
        layout = QVBoxLayout()
        layout.addWidget(self.toolbar)
        layout.addWidget(self.button)
        self.setLayout(layout)

# Client code
def main():
    """Main function."""
    # Create an instance of QApplication
    pygeocalc = QApplication(sys.argv)
    # Show the calculator's GUI
    view = PyGeoCalcUi()
    view.show()
    # Create instances of the model and the controller
    PyGeoCalcCtrl(view=view)
    sys.exit(pygeocalc.exec_())


if __name__ == "__main__":
    main()
