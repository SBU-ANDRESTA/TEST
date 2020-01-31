import os
import xml.etree.ElementTree as ET
from quik import FileLoader


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
        dirName = '../../packet_transaction_lib/inc/header_' + str(i)
        os.makedirs(dirName, exist_ok=True)
        file = open('../../packet_transaction_lib/inc/header_' + str(i) + '/packet_transaction_util.h', 'w')

        l1 = ['#include "altera_avalon_fifo_regs.h"\n',
              '#include "altera_avalon_fifo_util.h"\n',
              '#include "system.h"\n',
              '#include <stdlib.h>\n',
              '#include <stdbool.h>\n',
              '#include "ringbuffer_util.h"\n\n']

        l2 = ['#define FIFO_SINK_CSR\t\tFIFO_SINK_' + str(i) + '_IN_CSR_BASE\n',
              '#define FIFO_SOURCE_CSR\t\tFIFO_SOURCE_' + str(i) + '_IN_CSR_BASE\n',
              '#define FIFO_SINK_BASE\t\tFIFO_SINK_' + str(i) + '_OUT_BASE\n',
              '#define FIFO_SOURCE_BASE\t\tFIFO_SOURCE_' + str(i) + '_IN_BASE\n',
              '#define FIFO_STATUS\t\tALTERA_AVALON_FIFO_STATUS_ALL\n\n']

        l3 = []
        for process in processes:
            l_temp1 = []
            l_temp2 = []
            if process['source_file'] == str(i):
                l_temp1 = ['\n//proc '+process['process_name'].split('_')[1]+'\n',
                           '#define P'+process['process_name'].split('_')[1]+'_NUM_OF_INPS '+process['numOfInp']+'\n',
                           '#define P'+process['process_name'].split('_')[1]+'_NUM_OF_OUTS '+process['numOfOut']+'\n']
                l3 += l_temp1
                for port in process:
                    if isinstance(process[port], dict):
                        l_temp2 = ['#define P' + process['process_name'].split('_')[1] +
                                   '_'+process[port]['direction']+process[port]['ID'] +
                                   '_NUM_OF_TOKEN ' + process[port]['numOfToken']+' \n',
                                   '#define P' + process['process_name'].split('_')[1] +
                                   '_' + process[port]['direction'] + process[port]['ID'] +
                                   '_TYPE ' + process[port]['type'] + ' \n']
                        l3 += l_temp2
        l4 = ['\n\n\n#define BUFFER_SIZE 50\n\n'+
              '/******************** BUFFER *********************/\n']

        l5 = []
        for process in processes:
            l_temp1 = []
            if process['source_file'] == str(i):
                for port in process:
                    if isinstance(process[port], dict):
                        if process[port]['direction'] == 'INP':
                            l_temp1 = ['ring_buffer_t buff_'+process[port]['name']+';\n']
                            l5 += l_temp1

        l6 = ['/******************** BUFFER *********************/\n\n' +
              '/******************* Structure *******************/\n' +
              'struct Edge{\n' +
              '\tuint8_t node_src;\n' +
              '\tuint8_t node_dest;\n' +
              '\talt_u16 proc_src;\n' +
              '\talt_u16 proc_dest;\n' +
              '\tuint8_t num_of_inp_token;\n' +
              '\tuint8_t num_of_out_token;\n' +
              '\tuint8_t size_of_token_type;\n' +
              '\tring_buffer_t *buffer;\n' +
              '\tbool external;\n' +
              '};\n' +
              '/******************* Structure *******************/\n\n']

        l7 = ['struct Edge* get_edge(uint8_t proc_num, uint8_t port_num, uint8_t inout);\n\n',
              'ring_buffer_t* get_buffer(alt_u16 proc_src, alt_u16 proc_dest);\n\n',
              'void init_buffer();\n\n',
              'void init_structures();\n\n',
              'void send_packet(unsigned char node_src, unsigned char node_dest,\n',
              'alt_u16 proc_src, alt_u16 proc_dest, unsigned char packsize, unsigned char *payload);\n\n',
              'void receive_packet();\n\n',
              'bool receive_poll();\n']

        L = l1 + l2 + l3 + l4 + l5 + l6 + l7
        file.writelines(L)
