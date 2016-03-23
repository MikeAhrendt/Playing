import sys
import re
import requests
import webbrowser

def get_num(x):
    return int(''.join(ele for ele in x if ele.isdigit()))

task = get_num('44')

report = "https://10.97.11.100/analysis/" + str(task) + "/"

while True:
	r = requests.get("http://10.97.11.100:8090/tasks/view/" + str(task))
	o = r.text.split('\n')
	for i in xrange(0,len(o)):
		if "status" in o[i] and "reported" in o[i]:
			webbrowser.open_new(report)
		
	break
	
print report
 	

