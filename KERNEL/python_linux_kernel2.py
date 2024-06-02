#!/usr/bin/env python3
from urllib3 import PoolManager
from xml.dom.minidom import parse, parseString
import encodings

feed = "https://www.kernel.org/feeds/kdist.xml"
http = PoolManager()
r = http.request("GET", feed)
if r.status == 200:
	print("Status: 200 OK")
	data = r.data
else:
	print("Status: Error")
	exit(1)
	
dom3 = parseString(data)
rss = dom3.getElementsByTagName("rss")
items = rss[0].getElementsByTagName("item")
kernel = {}
for item in items:
	kdata = item.childNodes[0].firstChild.nodeValue
	title = kdata.split()[0].replace(":",'')
	type = kdata.split()[1]
	link = item.childNodes[1].firstChild.nodeValue
	desc = item.childNodes[2].firstChild.nodeValue
	pubdate = item.childNodes[3].firstChild.nodeValue
	guid = item.childNodes[4].firstChild.nodeValue
	_desc = parseString(desc)
	href = _desc.getElementsByTagName("td")
	#print(title, pubdate, desc)
	try:
		xz = parseString(href[2].toxml()).firstChild.childNodes[0].attributes['href'].value
		sign = parseString(href[3].toxml()).firstChild.childNodes[0].attributes['href'].value
		patch = parseString(href[4].toxml()).firstChild.childNodes[0].attributes['href'].value
		logs = parseString(href[5].toxml()).firstChild.childNodes[0].attributes['href'].value
	except:
		continue
	kernel[title] = {"title": title, "type": type, "pubdate": pubdate, "xz": xz,"sign": sign,"patch": patch,"changelog": logs}

def displayall():
	for kr in kernel:
		k = kernel[kr]
		print(k['type'] + " - " + k['pubdate'])
		print("\t" + k['title'])
		print("\t\t" + k['xz'])
		print("\t\t" + k['sign'])
		print("\t\t" + k['patch'])
		print("\t\t" + k['changelog'])
		print("")

def savefile(k, data):
	f = open(k, 'wb+')
	f.write(data)
	f.close

def download(k):
	print("Downloading %s" % k['title'])
	http = PoolManager()
	r = http.request("GET", k['xz'])
	if r.status==200:
		print("%s - OK"% k['xz'])
		savefile(k['xz'], r.data())
	if False:
		r = http.request("GET", k['patch'])
		if r.status==200:
			print("%s - OK"% k['patch'])

	r = http.request("GET", k['sign'])
	if r.status==200:
		print("%s - OK"% k['sign'])
	r = http.request("GET", k['changelog'])
	if r.status==200:
		print("%s - OK" % k['changelog'])

def removeKernel(kernelnumber):
	kernel.pop(kernelnumber)

#removeKernel('linux-next')
removeKernel('3.16.63')
removeKernel('4.14.101')
removeKernel('4.4.174')
removeKernel('3.18.134')
removeKernel('4.19.23')
removeKernel('4.9.158')

displayall()

for kernelnumber in kernel:
	c = kernel[kernelnumber]
	download(c)
