import xml.etree.ElementTree as ET
from quik import FileLoader
import os

def gen():
    xmlTree = ET.parse('../../UserFiles/hw_conf.xml')
    root = xmlTree.getroot()

    number_of_node = int(root[1][0].text) * int(root[1][1].text)

    xmlTree = ET.parse('../../UserFiles/application.xml')
    root = xmlTree.getroot()

    processes = []

    for element in root:
        if element.tag == 'process':
            temp = {}
            temp['process_name'] = element.get('name')
            temp['numOfInp'] = element.get('numOfInp')
            temp['numOfOut'] = element.get('numOfOut')
            for subElement in element:
                temp2 = {}
                if subElement.tag == 'port':
                    temp2['ID'] = subElement.get('ID')
                    temp2['name'] = subElement.get('name')
                    temp2['type'] = subElement.get('type')
                    temp2['direction'] = subElement.get('direction')
                    temp2['numOfToken'] = subElement.get('numOfToken')
                    temp.update({subElement.get('name'): temp2})
                elif subElement.tag == 'source_file':
                    temp.update({'source_file': subElement.get('name').split('_')[1]})
            processes.append(temp)

    i = 0
    for i in range(number_of_node):
        edges = []
        edges2 = []
        input_edges = []
        output_edges = []
        num_of_edges = 0
        flag = 0
        buffers = []
        temp1 = {}
        temp2 = {}
        temp3 = {}
        temp4 = {}
        counter = 0
        dirName = '../../packet_transaction_lib/src/src_' + str(i)
        os.makedirs(dirName, exist_ok=True)


        for process in processes:
            if process['source_file'] == str(i):
                for port in process:
                    if isinstance(process[port], dict):
                        if process[port]['direction'] == 'INP':
                            temp3 = {}
                            temp3['name'] = process[port]['name']
                            buffers.append(temp3)
                        num_of_edges += 1
                        temp1 = {}
                        temp2 = {}
                        temp1['name'] = process[port]['name']
                        for edge in edges:
                            flag = 0
                            if edge['name'] == temp1['name']:
                                if process[port]['direction'] == 'INP':
                                    temp4 = {}
                                    temp4['proc_num'] = process['process_name'].split('_')[1]
                                    temp4['port_num'] = process[port]['ID']
                                    temp4['name'] = process[port]['name']
                                    input_edges.append(temp4)
                                num_of_edges -= 1
                                flag = 1
                                continue
                        if flag == 1:
                            continue
                        edges.append(temp1)
                        # edges['name'] = process[port]['name']
                        if process[port]['direction'] == 'INP':
                            temp2['proc_num'] = process['process_name'].split('_')[1]
                            temp2['port_num'] = process[port]['ID']
                            temp2['name'] = process[port]['name']
                            input_edges.append(temp2)
                        elif process[port]['direction'] == 'OUT':
                            temp2['proc_num'] = process['process_name'].split('_')[1]
                            temp2['port_num'] = process[port]['ID']
                            temp2['name'] = process[port]['name']
                            output_edges.append(temp2)


        counter = 0
        flag = 0
        edges2 = []
        temp = {}
        for process in processes:
            if process['source_file'] == str(i):
                for port in process:
                    if isinstance(process[port], dict):
                        temp = {}
                        temp['num_of_inp_token'] = None
                        temp['num_of_out_token'] = None
                        temp['counter'] = counter
                        counter += 1
                        temp['name'] = process[port]['name']

                        for edge in edges2:
                            flag = 0
                            if edge['name'] == temp['name']:
                                if process[port]['direction'] == 'INP':
                                    edge['num_of_inp_token'] = 'P'+process['process_name'].split('_')[1]+'_INP'+process[port]['ID']+'_NUM_OF_TOKEN'
                                    edge['size_of_token_type'] = 'P'+process['process_name'].split('_')[1]+'_INP'+process[port]['ID']+'_TYPE'
                                    edge['buffer'] = process[port]['name']
                                elif process[port]['direction'] == 'OUT':
                                    edge['num_of_out_token'] = 'P'+process['process_name'].split('_')[1]+'_OUT'+process[port]['ID']+'_NUM_OF_TOKEN'
                                counter -= 1
                                flag = 1
                                continue
                        if flag == 1:
                            continue

                        temp['proc_src'] = process[port]['name'].split('_')[0][1]
                        temp['proc_dest'] = process[port]['name'].split('_')[1][1]
                        if process[port]['direction'] == 'INP':
                            temp['num_of_inp_token'] = 'P'+process['process_name'].split('_')[1]+'_INP'+process[port]['ID']+'_NUM_OF_TOKEN'
                            temp['size_of_token_type'] = 'P'+process['process_name'].split('_')[1]+'_INP'+process[port]['ID']+'_TYPE'
                            temp['node_dest'] = process['source_file']
                            temp['buffer'] = process[port]['name']
                        if process[port]['direction'] == 'OUT':
                            temp['num_of_out_token'] = 'P'+process['process_name'].split('_')[1]+'_OUT'+process[port]['ID']+'_NUM_OF_TOKEN'
                            temp['size_of_token_type'] = 'P'+process['process_name'].split('_')[1]+'_OUT'+process[port]['ID'] + '_TYPE'
                            temp['node_src'] = process['source_file']
                        for process2 in processes:
                            for port2 in process2:
                                if isinstance(process2[port2], dict):
                                    if process2[port2]['name'] == temp['name'] and process['process_name'] != process2['process_name']:
                                        if process2[port2]['direction'] == 'INP':
                                            temp['node_dest'] = process2['source_file']
                                        elif process2[port2]['direction'] == 'OUT':
                                            temp['node_src'] = process2['source_file']
                        temp['external'] = 0
                        for process2 in processes:
                            for port2 in process2:
                                if isinstance(process2[port2], dict):
                                    if process2[port2]['name'] == temp['name'] and process['source_file'] != process2['source_file']:
                                        temp['external'] = 1
                        edges2.append(temp)

        loader = FileLoader('')
        template = loader.load_template('Templates/packet_transaction_util_template.c')
        with open('../../packet_transaction_lib/src/src_'+str(i)+'/packet_transaction_util.c', 'w', encoding='utf-8') as f:
            L = ['#include "packet_transaction_util.h"\n',
                 '#include "packet_transaction.h"\n\n']
            f.writelines(L)
            f.write(template.render(locals()))