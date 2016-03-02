# coding:utf-8
from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from urllib import unquote
import json
import os


class RequestHandler(BaseHTTPRequestHandler):
    def _writeheaders(self):
        print self.path
        print self.headers
        self.send_response(200);
        self.send_header('Content-type', 'text/html');
        self.end_headers()

    def do_Head(self):
        print "do_Head"
        self._writeheaders()

    def do_GET(self):
        try:
        self._writeheaders()
        self.wfile.write("""<!DOCTYPE HTML>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <title></title>
</head>
<body>
<p>You need POST data !!!</p>
</body>
</html>""" + str(self.headers))


    def do_POST(self):
        print  "post data"
        self._writeheaders()
        length = self.headers.getheader('content-length');
        nbytes = int(length)
        data = self.rfile.read(nbytes)
        # print "recv data"+ unquote(data)

        try:
            data_dict = json.loads(data)
            for key,value in data_dict.items():
                filename = key.replace("/","__")

            #    data_list = list()
            #    for i in value:
            #        data_list.append(unquote(i))

            data_json = dict()
            data_json[filename]=value

            ori_json = {}
            if os.path.exists(filename):
                with open(filename,"r") as f:
                    ori_json = json.load(f)

            print ori_json
            ori_json.update(data_json)
            print ori_json
            # exit(0)

            if os.path.exists("./FM_Log") is False:
                os.mkdir("./FM_Log")
            file_path = os.path.join("./FM_Log",filename)

            with open(file_path,"w") as f:
                json.dump(ori_json,f)
            print "write file : " + file_path

        except Exception as err:
            with open("error_file","a") as f:
                f.write(err)
        finally:
            pass


addr = ('', 8080)
server = HTTPServer(addr, RequestHandler)
server.serve_forever()
