# $ pip install pygst
# $ pip install gst

# ... # other imports
import pygst
pygst.require('0.10')
import gst
# ... # other imports

gobjects.threads_init()
# ...

def my_handler(bus, message):
    # handle the message

# ...


player = gst.element_factory_make('playbin2', 'my_player')
bus = player.get_bus()
bus.connect('message', my_handler)
bus.add_signal_watch()
...
player.set_state(gst.STATE_PLAYING)
# start the main Glib loop

# The message parameter has an attribute .type which can be used for selective processing (I'm only interested in the end of stream (EOS) and error). Using the new system I have:
# ... # other imports
from gi.repository import Gst
import glib
import gobject
# .... # other imports

gobject.threads_init()

loop = glib.MainLoop(None, False)

def bus_handler(bus, message):
    print message
    # handle the message
# ...

Gst.init_check(None)
player = Gst.ElementFactory.make('playbin2', 'my_player')
player.set_property('uri', 'file:///home/kenji/button.ogg')
bus = player.get_bus()
bus.connect('message', bus_handler)
bus.add_signal_watch()
player.set_state(Gst.State.PLAYING)
# start the main loop

g_loop = threading.Thread(target=gobject.MainLoop().run)
g_loop.daemon = True
g_loop.start()