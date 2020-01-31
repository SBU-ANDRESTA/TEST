import xml.etree.ElementTree as ET
from quik import FileLoader


def gen():
    xmlTree = ET.parse('../../UserFiles/hw_conf.xml')
    root = xmlTree.getroot()

    number_of_node = int(root[1][0].text) * int(root[1][1].text)

    xmlTree = ET.parse('../../UserFiles/mapping.xml')
    root = xmlTree.getroot()

    # create a dictionary of list from mapping xml file
    mapping_dict = {}
    for element in root:
        if element.tag == 'process_mapping':
            mapping_dict[element.get('target')] = [element.get('target'), element.get('target').split('_')[1]]

    list_map = list(mapping_dict)
    i = 0
    sw_scripts = []
    for i in range(len(list_map)):
        sw_scripts.clear()
        sw_scripts.append({'nodeName': list_map[i], 'cpuName': 'nios2_'+list_map[i].split('_')[1], 'index': list_map[i].split('_')[1]})
        loader = FileLoader('')
        template = loader.load_template('Templates/sw_script_template.sh')
        with open('../../sw_scripts/create_' + list_map[i] + '.sh', 'w', encoding='utf-8') as f:
            f.write(template.render(locals()))