import xml.etree.ElementTree as ET
from quik import FileLoader


def gen():
    xmlTree = ET.parse('../../UserFiles/mapping.xml')
    root = xmlTree.getroot()

    # create a dictionary of list from mapping xml file
    mapping_dict = {}
    i = 0
    for element in root:
        if element.tag == 'process_mapping':
            mapping_dict[element.get('target')] = [element.get('target'), element.get('target').split('_')[1]]

    list_map = list(mapping_dict)
    downloadShell_prjs = []
    for i in range(len(list_map)):
            downloadShell_prjs.append({'nodeName': list_map[i],
                                       'elfName': list_map[i] + '.elf',
                                       'instanceID': list_map[i].split('_')[1]})
    loader = FileLoader('')
    template = loader.load_template('Templates/download_template.sh')

    with open('../../download.sh', 'w', encoding='utf-8') as f:
        f.write(template.render(locals()))
