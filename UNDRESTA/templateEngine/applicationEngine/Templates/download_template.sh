# Download .sof file on board
# number 2 is for downloading .sof on fpga
cd quartus
nios2-configure-sof -d 2

# Download .elf file on processors
#for @prj in @downloadShell_prjs:
#if( @prj.instanceID == '0' )
cd software/@prj.nodeName
#else
cd ../@prj.nodeName
#end
nios2-download -g @prj.elfName --instance @prj.instanceID
#end

