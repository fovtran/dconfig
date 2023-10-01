import os,sys

KSYMS_FILE='/opt/kernel.ksym'

def checkfile(F):
	return os.path.exists(F)

def file_contents(F):
	content = []
	f = open(F, 'r')
	line = f.readlines()
	for i, x in enumerate(line):
		if len(line[i])>2:
			line[i] = x.replace('\n', '')
		else:
			line.pop(i)
	return line

def verif_conf(CONF, KSYM):
	for c in CONF:
		if c[:len(KSYM)] == KSYM:
			print (KSYM, ' Found')
			return

def read_default_ksyms(KF):
	return file_contents(KF)

def check_empty(l):
	return len(l)>2

def check_config(l):
	return l[:6] =='CONFIG'

def check_disabled(l):
	return l[:2] == '# '

def print_contents(content):
	for idx, line in enumerate(content):
		if check_empty(line):
			if check_config(line):
				print(line)
			else:
				content.pop(idx)
		else:
			content.pop(idx)


	print('# ---------------')
	ksyms = read_default_ksyms(KSYMS_FILE)
	#print(ksyms)
	for ksym in ksyms:
		#print('Verifying ', ksym)
		verif_conf(content, ksym)

def main(F):
	parsed_file = file_contents(F)
	print_contents(parsed_file)
	return True


if __name__== '__main__':
	if len(sys.argv)>1:
		_FILE=sys.argv[1]
		if checkfile(_FILE):
			print('File %s accepted'% _FILE)
			main(_FILE)
		else:
			print('%s is not a file' % _FILE)
	else:	
		print("No arguments")

