import xml.etree.ElementTree as ET
from quik import FileLoader
import shutil
import glob, os
from shutil import copyfile

def gen():
    src = r'../../UserFiles/process_codes'
    dest = r'../../templateEngine/applicationEngine'

    os.chdir(src)
    for file in glob.glob("*"):
        copyfile(src + "\\" + file, dest + "\\" + file)
    os.chdir('../../templateEngine/applicationEngine')
    xmlTree = ET.parse('../../UserFiles/hw_conf.xml')
    root = xmlTree.getroot()

    number_of_node = int(root[1][0].text) * int(root[1][1].text)

    xmlTree = ET.parse('../../UserFiles/application.xml')
    root = xmlTree.getroot()

    processes = []

    for element in root:
        if element.tag == 'process':
            temp = {}
            temp['process_name'] = element.get('name').split('_')[1]
            temp['numOfInp'] = element.get('numOfInp')
            temp['numOfOut'] = element.get('numOfOut')
            for subElement in element:
                temp2 = {}
                if subElement.tag == 'port':
                    temp2['ID'] = subElement.get('ID')
                    temp2['name'] = subElement.get('name')
                    temp2['type'] = subElement.get('type')
                    temp2['direction'] = subElement.get('direction')
                    temp2['direction_lowercase'] = subElement.get('direction').lower()
                    temp2['numOfToken'] = subElement.get('numOfToken')
                    temp2['process_name'] = element.get('name').split('_')[1]
                    if subElement.get('direction') == 'INP':
                        if subElement.get('init_val') != '':
                            k = 0
                            init_arr = []
                            for init_vall in subElement.get('init_val').split(','):
                                init_temp = {}
                                init_temp['index'] = k
                                init_temp['value'] = subElement.get('init_val').split(',')[k]
                                init_arr.append(init_temp)
                                k +=1
                            temp2.update({'initial_val': init_arr})
                            # temp2['init_val'] = subElement.get('init_val')
                    temp.update({subElement.get('name'): temp2})
                elif subElement.tag == 'source_file':
                    temp.update({'source_file': subElement.get('name').split('_')[1]})
            processes.append(temp)

    i = 0
    nodePR = []
    ports = []
    for i in range(number_of_node):
        nodePR = []
        ports = []
        for process in processes:
            if process['source_file'] == str(i):
                nodePR.append(process)
                for port in process:
                    if isinstance(process[port], dict):
                        ports.append(process[port])
        loader = FileLoader('')
        template = loader.load_template('Templates/node_template.c')
        with open('../../sw_sources/node_' + str(i) + '.c', 'w',encoding='utf-8') as f:
            L = ['#include "sys/alt_stdio.h"\n',
                 '#include "altera_avalon_fifo_regs.h"\n',
                 '#include "altera_avalon_fifo_util.h"\n',
                 '#include "sys/alt_irq.h"\n',
                 '#include <stdio.h>\n',
                 '#include <stdint.h>\n',
                 '#include "packet_transaction_util.h"\n',
                 '#include <unistd.h>\n\n',
                 '#define ALMOST_EMPTY 2\n',
                 '#define ALMOST_FULL 11\n']
            f.writelines(L)
            f.write(template.render(locals(), loader))