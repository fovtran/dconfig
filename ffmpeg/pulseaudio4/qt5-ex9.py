# !/usr/bin/env python3
# Filename: pycalc.py
# """PyCalc is a simple calculator built using Python and PyQt5."""
import sys
import random
import os
# Import QApplication and the required widgets from PyQt5.QtWidgets
from PyQt5.QtWidgets import QApplication
from PyQt5.QtWidgets import QMainWindow
from PyQt5.QtWidgets import QWidget
from PyQt5.QtWidgets import QDialog
from PyQt5.QtCore import Qt, QObject
from PyQt5.QtWidgets import QGridLayout, QLineEdit, QFileDialog, QPushButton, QVBoxLayout
from PyQt5.QtWidgets import QShortcut, QListWidget, QAbstractItemView
from PyQt5.QtGui import QKeySequence
from PyQt5.QtCore import pyqtSlot, pyqtSignal

from functools import partial
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.backends.backend_qt5agg import NavigationToolbar2QT as NavigationToolbar
from matplotlib.figure import Figure
import matplotlib.pyplot as plt

#from pyarma import mat, fill, norm, normalise
#from pyarma import log, log10, stddev, var, mean, median, conj
from numpy import zeros, matrix, float64, linalg, arange, array, ndarray, array, random
from numpy import set_printoptions, inf, nan, savetxt, savez, load
set_printoptions(precision=14, threshold=sys.maxsize)


# __version__ = '0.1'
# __author__ = 'Diego Cadogan'


class PyGeoCalcUi(QMainWindow):
    """PyCalc's View (GUI)."""

    def __init__(self):
        """View initializer."""
        super().__init__()
        # Set some main window's properties
        self.setWindowTitle("PyGeoCompute")
        self.setFixedSize(1048, 802)
        self.generalLayout = QVBoxLayout()
        self._centralWidget = QWidget(self)
        self.setCentralWidget(self._centralWidget)
        self._centralWidget.setLayout(self.generalLayout)

        # Create the display and the buttons
        self._createDisplay()
        self._setHotKeys()
        # self._createDropList()
        self._create_draw()
        self._createButtons()

    def _createDropList(self):
        self.drop = NewDragDropWidget()
        self.generalLayout.addWidget(self.drop)

    def _setHotKeys(self):
        self.shortcut = QShortcut(QKeySequence("Q"), self)
        self.shortcut.activated.connect(self._exit)
        self.reload = QShortcut(QKeySequence("Ctrl+R"), self)
        self.reload.activated.connect(self._exit)

    @pyqtSlot()
    def _exit(self):
        exit(0)

    def _createDisplay(self):
        """Create the display."""
        # Create the display widget
        self.display = QLineEdit()
        # Set some display's properties
        self.display.setFixedHeight(35)
        self.display.setAlignment(Qt.AlignRight)
        self.display.setReadOnly(True)
        # self.setDragDropMode(QtGui.QAbstractItemView.DragDrop)
        # self.setSelectionMode(QtGui.QAbstractItemView.ExtendedSelection)
        # self.setAcceptDrops(True)
        # Add the display to the general layout
        self.generalLayout.addWidget(self.display)

    def _create_draw(self):
        self.w = Window()
        self.generalLayout.addWidget(self.w)
        self.w.plot()

    def _createButtons(self):
        """Create the buttons."""
        self.buttons = {}
        buttonsLayout = QGridLayout()
        buttons = {
            "C": (0, 0),
            "N": (0, 1),
            "S": (0, 2),
            "V": (0, 3),
            "Q": (0, 4),
            "D": (1, 0),
            "F": (1, 1),
            "W": (1, 2),
            "T": (1, 3),
            "H": (1, 4),
        }
        # Create the buttons and add them to the grid layout
        for btnText, pos in buttons.items():
            self.buttons[btnText] = QPushButton(btnText)
            self.buttons[btnText].setFixedSize(32, 32)
            buttonsLayout.addWidget(self.buttons[btnText], pos[0], pos[1])
        # Add buttonsLayout to the general layout
        self.generalLayout.addLayout(buttonsLayout)

    def setDisplayText(self, text):
        """Set display's text."""
        self.display.setText(text)
        self.display.setFocus()

    def displayText(self):
        """Get display's text."""
        return self.display.text()

    def clearDisplay(self):
        """Clear the display."""
        self.setDisplayText("")

    def dropEvent(self, e):
        """This function will enable the drop file directly"""
        drag = QDrag(self)
        data = QMimeData()
        data.setData("text/plain", "")

        if e.mimeData().hasUrls:
            e.setDropAction(QtCore.Qt.CopyAction)
            e.accept()
            for url in e.mimeData().urls():
                fname = ""
            self.filename = fname
            print("GOT ADDRESS:", self.filename)
            self.readData()
        else:
            e.ignore()


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
        for btnText, btn in self._view.buttons.items():
            if btnText not in {"=", "C"}:
                btn.clicked.connect(partial(self._buildExpression, btnText))
        self._view.buttons["C"].clicked.connect(self._view.clearDisplay)
        self._view.buttons["Q"].clicked.connect(self._view._exit)


class NewDragDropWidget(QListWidget):
    def __init__(self):
        super().__init__()
        self.setFixedSize(124, 124)
        self.setDragDropMode(QAbstractItemView.DragDrop)
        # self.setDefaultDropAction(QtCore.Qt.MoveAction) # this was the magic line
        self.setSelectionMode(QAbstractItemView.ExtendedSelection)
        self.setAcceptDrops(True)


class Window(QWidget):
    def __init__(self, parent=None):
        super(Window, self).__init__(parent)
        # Matplotlib figure settings
        self.figure = plt.figure()
        self.canvas = FigureCanvas(self.figure)
        self.toolbar = NavigationToolbar(self.canvas, self)
        self.button = QPushButton("Plot")
        self.button.clicked.connect(self.plot)

        # set the layout
        layout = QVBoxLayout()
        layout.addWidget(self.toolbar)
        layout.addWidget(self.canvas)
        layout.addWidget(self.button)
        self.setLayout(layout)

    def getFile(self):
        dialog = QFileDialog(self, windowTitle="Open GeoJSON")
        dialog.setFileMode(dialog.ExistingFiles)
        dialog.setOption(dialog.DontUseNativeDialog, False)
        dialog.setDirectory(os.getcwd())
        dialog.setNameFilter("*.geojson")
        dialog.open()
        self.geojsonfile = dialog.selectedFiles()

    def plot(self):
        """plot some random stuff"""
        qsize = 1024 * 8
        # data = [random.random() for i in range(qsize)]
        #pfilename = "my-pickle"
        #db = load(pfilename + ".npz")
        #M = db["V"][:, 0]
        #U = db["U"]
        #C = db["C"]
        #depth = C[:, 0]
        #intensity = C[:, 1]
        #A = db["A"]
        # M = array([[[1],[2],[3]], [[4],[5],[6]]])
        #print(M.shape)
        depth = random.random(20)
        intensity = random.random(20)
        p = 1

        _MAT = matrix([depth, intensity])
        print(_MAT)
        A = zeros((depth.shape[0], intensity.shape[0]))
        _U = mat(_MAT)
        P = linalg.norm(_U, p)
        S = linalg.norm(_U, p)
        _normal = normalise(_U, p)
        print(f"norm: {P} {S}")
        #f = savetxt(sys.stdout, _normal)
        _NORM = matrix(_normal)
        _NORM_D = _NORM[0][0]
        _NORM_I = _NORM[1][0]
        print(f"norm_D: {_NORM_D}")
        print(f"norm_I: {_NORM_I}")

        # instead of ax.hold(False)
        self.figure.clear()
        # create an axis
        ax1 = self.figure.add_subplot(211)
        ax2 = self.figure.add_subplot(212)
        #ax3 = self.figure.add_subplot(313)
        ax1.plot(depth, ".", markersize=1, color="red")
        ax2.plot(intensity, ".", markersize=1, color="green")
        #ax3.plot(_NORM_D, _NORM_I, ".", color="orange")

        # refresh canvas
        self.canvas.draw()


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
