import sys
import re
import requests
import webbrowser
import time

def get_num(x):
    return int(''.join(ele for ele in x if ele.isdigit()))

add = 'http://10.97.11.100:8090/tasks/create/url'

data = {
'url': sys.argv[1],
'options': 'tor=yes',
'machine': 'sandbox-win7-01'
}

r = requests.post(add, data=data)

task = get_num(r.text)

report = 'https://10.97.11.100/analysis/' + str(task) + '/'

count = 0

while count < 9:
	r = requests.get("http://10.97.11.100:8090/tasks/view/" + str(task))
	o = r.text.split('\n')
	print count
	for i in xrange(0,len(o)):
		if "reported" in o[i]:
			count = 10
			break
	time.sleep(23)
	count = count + 1

webbrowser.open_new(report)