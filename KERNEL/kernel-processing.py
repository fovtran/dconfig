#!/usr/bin/env python
from xml.dom.minidom import parse, parseString
import encodings
import argparse
import sys,os

MAIN_PATH = os.path.abspath(os.path.dirname(__name__))

sys.path.append(MAIN_PATH)
print('sys.path', sys.path)

from utils4 import *

version = "0.1.2"
usage = """
kernel-processing.py -h
"""

def parseparse_feed(data):
	dom3 = parseString(data)
	rss = dom3.getElementsByTagName("rss")
	items = rss[0].getElementsByTagName("item")
	kernel = {}
	for item in items:
		kdata = item.childNodes[0].firstChild.nodeValue
		title = kdata.split()[0].replace(":",'')
		build_type = kdata.split()[1]
		link = item.childNodes[1].firstChild.nodeValue
		desc = item.childNodes[2].firstChild.nodeValue
		pubdate = item.childNodes[3].firstChild.nodeValue
		guid = item.childNodes[4].firstChild.nodeValue
		_desc = parseString(desc)
		href = _desc.getElementsByTagName("td")

		try:
			xz = parseString(href[2].toxml()).firstChild.childNodes[0].attributes['href'].value
			sign = parseString(href[3].toxml()).firstChild.childNodes[0].attributes['href'].value
			patch = parseString(href[4].toxml()).firstChild.childNodes[0].attributes['href'].value
			logs = parseString(href[5].toxml()).firstChild.childNodes[0].attributes['href'].value
		except:
			continue
		kernel[title] = {
			"title": title, "type": build_type, "pubdate": pubdate, 
			"xz": xz, 
			"file": xz.split('/')[-1],
			"sign": sign, 
			"patch": patch,
			"changelog": logs}

	return kernel

def parse_kdist():
	feed = 'https://www.kernel.org/feeds/kdist.xml'
	otherfeed = 'https://www.kernel.org/feeds/all.atom.xml'
	maillists = 'https://lore.kernel.org/'
	maillist_atoms = 'https://lore.kernel.org/linux-mm/new.atom'
	repos = 'https://git.kernel.org/'
	patchwork = 'https://patchwork.kernel.org/'
	mirrors = 'https://mirrors.kernel.org/'
	data = get_feed_data(feed)
	if data:
		kernels = parseparse_feed(data)
		return kernels
	else:
		return None


def listall_kernels():
	return parse_kdist()

def print_kernel_list(kernel_list):
	KL = kernel_list.__reversed__()
	for idx, release in enumerate(KL):
		k = kernel_list[release]
		print('Build: ' + k['title'])
		print('Type: ' + k['type'])
		print('Published: ' + k['pubdate'])
		data = [ k['xz'], k['sign'], k['patch'], k['changelog']]
		print("Files: " + str(data))
		print("")

def show_changelog(k):
	print("Downloading changelog %s" % k)
	kernel_list = parse_kdist()
	kernel  = kernel_list[k.changelog]

	http = PoolManager()
	r = http.request("GET", kernel['changelog'])
	if r.status==200:
		print("%s - OK" % kernel['changelog'])
		for line in str(r.data).split(r'\n'):
			print(line)

def download(k):
	print("Downloading %s" % k)
	kernel_list = parse_kdist()
	kernel  = kernel_list[k]
	K = kernel['xz']
	filename = download_file(K)
	print(f"OK - ${filename}")

	http = PoolManager()
	if False:
		r = http.request("GET", kernel['patch'])
		if r.status==200:
			print("%s - OK"% kernel['patch'])

	r = http.request("GET", kernel['sign'])
	if r.status==200:
		print("%s - OK"% kernel['sign'])

def removeKernel(kernelnumber):
	#kernel.pop(kernelnumber)
	pass

def download_kernel(args):
	kernelnumber = args.download
	download(kernelnumber)

def get_changelog(save=False):
	pass

if __name__ == '__main__':
	parser = argparse.ArgumentParser(prog='this',description = 'kernel-proc: does something')
	parser.add_argument('-l', '-list', action='store_true', dest='listkernels', help="List some stable kernels")	
	parser.add_argument('-ll', '-listlocal', action='store_true', dest='listlocal', help="List installed source kernels")	
	parser.add_argument('-c', '-changelog', dest='changelog', help="Read specific Changelog")
	parser.add_argument('-d', '-download', dest='download', help="Download specific kernel")
	parser.add_argument('-v', '--version', action='version', version=version)
	parser.add_argument('-D', '--directory', dest="destdir", help='directory to be cleaned')
	args = parser.parse_args()

	if args.listkernels:
		print("Listing Kernels")		
		kernel_list = listall_kernels()
		print_kernel_list(kernel_list)
	
	elif args.download:
		download_kernel(args)

	elif args.changelog:
		show_changelog(args)

	elif args.listlocal:
		path = os.environ['HOME'] + '/downloads/'
		x = os.path.expanduser('~/Downloads')
		path = '/usr/src/'
		files = glob.glob(path + '*.meta')

	else:
		print(usage)
		
