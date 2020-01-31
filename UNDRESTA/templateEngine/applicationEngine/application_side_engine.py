import os

import download_engine
import node_engine
import packet_transaction_c_engine
import packet_transaction_h_engine
import sw_script_engine

# This is top script which calls other scripts and results in *.sh files

os.chdir('../../')
dirName = 'sw_scripts'
if not os.path.exists(dirName):
    os.mkdir(dirName)
    print("Directory "+dirName+" Created ")
else:
    print("Directory "+dirName+" already exists")


dirName = 'packet_transaction_lib'
if not os.path.exists(dirName):
    os.mkdir(dirName)
    print("Directory "+dirName+" Created ")
else:
    print("Directory "+dirName+" already exists")

os.chdir('templateEngine/applicationEngine')
packet_transaction_h_engine.gen()
packet_transaction_c_engine.gen()
node_engine.gen()
download_engine.gen()
sw_script_engine.gen()
