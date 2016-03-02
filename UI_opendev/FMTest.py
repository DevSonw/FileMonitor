__author__ = 'panda'


import flask

from flask import Flask
from flask import request
import json
import os
import time

app=Flask(__name__)

BAD_RET     = 402
SUCCESS_RET = 200
GETNULL_RET = 403


@app.route('/',methods=['GET','POST'])
def GetInfo():
    # print "FM_GET_INFO"
    if request.method == "GET":
        return "Hello Panda! Please POST data!"
    elif request.method == "POST":
        try:
            # print dir(request)
            # print "request.data" + request.data
            # print "request.form"
            # print request.form.to_dict(True)
            # print "request.get_json(force=True)" + request.get_json(force=True)
            #werkzeug.datastructures.ImmutableMultiDict

            # print "request.json"
            # print request.json
            # print "request.data"
            # print request.data


            # import pdb
            # pdb.set_trace()
            try:
                print "request.get_data()"
                request.get_data()
            except Exception as err:
                with open("error_file","a") as f:
                    f.write("request.get_data() error~")
                    return "flask failed",BAD_RET


            if request.data == "":
                return "flask get null",GETNULL_RET
            try:
                data_dict = json.loads(request.data)
            except Exception as err:
                with open("error_file","a") as f:
                    errorMSG = "\n json.loads " + str(request.data) + "\n"
                    print errorMSG
                    f.write(errorMSG)
                    return "flask failed",BAD_RET
            try:
                for key,value in data_dict.items():
                    filename = key.replace("/","__")
            except Exception as err:
                with open("error_file","a") as f:
                    errorMSG = "\n key.replace " + str(request.data) + "\n"
                    print errorMSG
                    f.write(errorMSG)
                    return "flask failed",BAD_RET


            data_json = dict()
            data_json[filename] = value

            try:
                ori_json = {}
                if os.path.exists(filename):
                    with open(filename,"r") as f:
                        ori_json = json.load(f)
            except Exception as err:
                with open("error_file","a") as f:
                    errorMSG = "\n ori_json " + str(request.data) + "\n"
                    print errorMSG
                    f.write(errorMSG)
                    return "flask failed",BAD_RET

            ori_json.update(data_json)
            print ori_json

            path = os.path.join("./FM_Log",time.strftime("%Y-%m-%d",time.localtime()))

            if os.path.exists(path) is False:
                print path
                os.mkdir(path)


            file_path = os.path.join(path,filename)

            try:
                with open(file_path,"w") as f:
                    json.dump(ori_json,f)
                print "write file : " + file_path
                return "flask success",SUCCESS_RET
            except Exception as err:
                with open("error_file","a") as f:
                    errorMSG = "\n write file " + str(request.data) + "\n"
                    print errorMSG
                    f.write(errorMSG)
                    return "flask failed",BAD_RET

        except Exception as err:
            with open("error_file","a") as f:
                f.write("global error~")
            return "flask failed",BAD_RET
        finally:
            pass

if __name__ == '__main__':
    app.debug = True
    print flask.__version__
    app.run(host="0.0.0.0",port=8080)