# -----------------------------------------------------------------
# synth_qsys.tcl
#
#
# Quartus synthesis post-flow script.
#
# This script generates the Qsys synthesis files.
#
# The script was created by copy-and-pasting the ip-generate
# command output in the Qsys "Generate" window after the message
#
#   Info: Starting: Create HDL design files for synthesis
#
# The arguments to ip-generate were then re-formatted, with
# several of the --report-file options removed, i.e., .html, .cmp,
# svd, .regmapfile, and .debuginfo.
#
# The script is modelled after the xx_make_qsys_seq.tcl script
# created by the Qsys DDR3 UniPHY core.
#
# A similar script can be created for simulation.
#
# -----------------------------------------------------------------

# Quartus 12.1, 13.0, 13.1, and 14.0 arguments
set arg_list [list]
lappend arg_list --project-directory=$qwork
lappend arg_list --output-directory=$qwork/qsys_system/synthesis
lappend arg_list --file-set=QUARTUS_SYNTH
lappend arg_list --report-file=sopcinfo:$qwork/qsys_system.sopcinfo
lappend arg_list --report-file=qip:$qwork/qsys_system/synthesis/qsys_system.qip
set device "Cyclone V"
lappend arg_list --system-info=DEVICE_FAMILY=$device
lappend arg_list --system-info=DEVICE=5CSEMA4U23C6
lappend arg_list --component-file=$qwork/qsys_system.qsys

# # Quartus 12.1 does not support the --language argument
# if {$qversion != 12.1} {
# 	lappend arg_list --language=VERILOG
# }

catch { eval [concat [list exec $quartus(quartus_rootpath)/sopc_builder/bin/ip-generate] $arg_list] } temp
puts $temp

