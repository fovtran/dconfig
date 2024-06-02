python -c "import urllib;from xml.dom import minidom;a=urllib.urlopen('https://mobile.twitter.com/search?q=big+data').read();doc=minidom.parse(a);xml=doc.documentElement;print(xml.getElementsByTagName('body'))"


