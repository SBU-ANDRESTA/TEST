import xml.etree.ElementTree as ET
from quik import FileLoader

tree = ET.parse('../../UserFiles/hw_conf.xml')
root = tree.getroot()

project_properties = {'DEVICE_FAMILY': root[0][0].text, 'DEVICE': root[0][1].text}
NoC = {'RowNo':         root[1][0].text,
       'ColNo':         root[1][1].text,
       'AddrWidth':     root[1][2].text,
       'DataWidth':     root[1][3].text,
       'PackWidth':     root[1][4].text,
       'PhyCh':         root[1][5].text,
       'PhyChAddr':     root[1][6].text,
       'PhyRoCh':       root[1][7].text,
       'PhyRoChAddr':   root[1][8].text,
       'RoCh':          root[1][9].text,
       'RoChAddr':      root[1][10].text,
       'ViCh':          root[1][11].text,
       'ViChAddr':      root[1][12].text
       }


tiles = []
processors = []
numOfTiles = int(NoC['RowNo'])*int(NoC['ColNo'])

RowNoList = []
ColNoList = []
for i in range(0,int(NoC['RowNo'])):
    RowNoList.insert(i, i)
for i in range(0, int(NoC['ColNo'])):
    ColNoList.insert(i, i)

# must change
# needs to insert the number of processors in Project-Properties
numOfProcessors = numOfTiles

# default values for tiles
for j in range(0, int(NoC['RowNo'])):
    for i in range(0, int(NoC['ColNo'])):
        tiles.insert(j*int(NoC['ColNo'])+i, {'j': j, 'i': i, 'number': j*int(NoC['ColNo'])+i    , 'node_type': 'processor', 'node_name': 'NIOS II/e', 'memory_size': '16384.0',
                         'fifo_in_depth': '16', 'fifo_out_depth': '16'})

# default values for processors
for i in range(0, numOfProcessors):
    processors.insert(i, {'number': str(i), 'node_type': 'processor', 'node_name': 'NIOS II/e', 'memory_size': '16384.0', 'fifo_in_depth': '16', 'fifo_out_depth': '16'})

# change the values of tiles and processors, if it needs
for tile in root[2]:
    if tile[0].text == "processor":
        for child in tile:
            processors[int(tile[0].attrib['number'])][child.tag] = child.text
    for child in tile:
        tiles[int(tile.attrib['number'])][child.tag] = child.text

loader = FileLoader('Templates')

# generate qsys_system.tcl
template = loader.load_template('qsys_system.tcl')
with open("../../hw_scripts/qsys_system.tcl", 'w', encoding = 'utf-8') as f:
    f.write(template.render(locals()))

# generate NoC.vhd
template = loader.load_template('NOC.vhd')
with open("../../hw_sources/NOC.vhd", 'w', encoding = 'utf-8') as f:
    f.write(template.render(locals()))

# generate NoC_hw.tcl
template = loader.load_template('NoC_hw.tcl')
with open("../../hw_scripts/NoC_hw.tcl", 'w', encoding = 'utf-8') as f:
    f.write(template.render(locals()))

# generate synth_qsys.tcl
template = loader.load_template('synth_qsys.tcl')
with open("../../hw_scripts/synth_qsys.tcl", 'w', encoding = 'utf-8') as f:
    f.write(template.render(locals()))

# generate wrapper.v
template = loader.load_template('constraints.tcl')
with open("../../hw_scripts/constraints.tcl", 'w', encoding = 'utf-8') as f:
    f.write(template.render(locals()))

# generate wrapper.v
template = loader.load_template('wrapper.v')
with open("../../hw_sources/wrapper.v", 'w', encoding = 'utf-8') as f:
    f.write(template.render(locals()))
