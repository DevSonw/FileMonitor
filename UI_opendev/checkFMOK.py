__author__ = 'panda'
# coding:utf-8

import time
import subprocess
import os
import urllib2
import httplib

def internet_on():
    try:
        try:
            response = urllib2.urlopen('http://127.0.0.1:8080', timeout=1)
            return True
        except urllib2.URLError:
            return False
    except httplib.BadStatusLine:
        return  False


if __name__ == "__main__":
    while (1):
        if internet_on():
            print "internet_on"
            # output = subprocess.check_output("ps aux |grep \"/usr/bin/python FMTest.py\"|grep -v grep |awk '{print $2}'",shell=True)
            # print output
        else:
            print "internet_off"
            # ps aux |grep "/usr/bin/python FMTest.py"|grep -v grep |awk '{print $2}'

            pid = subprocess.check_output("ps aux |grep \"/usr/bin/python FMTest.py\"|grep -v grep |awk '{print $2}'",shell=True)
            if pid:
                print "Ready to killall pid = " + str(pid)
                subprocess.check_output("kill {}".format(pid),shell=True)
                print "killall %s over" % str(pid).strip()

            print "start service"


            subprocess.Popen("python FMTest.py > ./FMTest.log",shell=True)
            time.sleep(3600)