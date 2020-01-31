# Download .sof file on board
# number 2 is for downloading .sof on fpga
cd quartus
nios2-configure-sof -d 2

# Download .elf file on processors

cd software/node_0
nios2-download -g node_0.elf --instance 0


cd ../node_1
nios2-download -g node_1.elf --instance 1


cd ../node_3
nios2-download -g node_3.elf --instance 3


cd ../node_2
nios2-download -g node_2.elf --instance 2

