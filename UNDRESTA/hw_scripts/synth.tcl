# -----------------------------------------------------------------
#
# Quartus synthesis script.
#
# -----------------------------------------------------------------
# Usage
# -----
#
# 1. From within Quartus, change to the project folder, and type
#
#    source scripts/synth.tcl
#
# 2. Command-line processing. Change to the project folder,
#    and type either;
#
#    a) quartus_sh -s
#       tcl> source scripts/synth.tcl
#
#    b)  quartus_sh -t scripts/synth.tcl
#
# -----------------------------------------------------------------

puts ""
puts "Synthesizing the SBU_DFT design"
puts "----------------------------------------"

# -----------------------------------------------------------------
# Tcl packages
# -----------------------------------------------------------------

package require ::quartus::project
package require ::quartus::flow

# -----------------------------------------------------------------
# Design paths
# -----------------------------------------------------------------

# Design parameters
set board      SBU_DFT
set design     SBU_DFT

# Design paths
set top         [pwd]
set scripts     $top/hw_scripts
set src         $top/hw_sources
set constraints $scripts/constraints.tcl

# -----------------------------------------------------------------
# Quartus work
# -----------------------------------------------------------------

global quartus
puts " - Quartus $quartus(version)"

# Parse the version number
if {[regexp {^Version (\d+[.]\d+)} $quartus(version) match qversion] != 1} {
	error "Error: Quartus version parsing failed"
}

# Build directory
set qwork  $top/quartus

if {![file exists $qwork]} {
    puts " - Creating the Quartus work directory"
    puts "   * $qwork"
    file mkdir $qwork

    puts " - Creating the IP directory"
    file mkdir $qwork/ip/NoC
    file copy hw_scripts/NoC_hw.tcl $qwork/ip/NoC
    file copy hw_sources $qwork/ip/NoC
}

# Create all the generated files in the work directory
cd $qwork

# -----------------------------------------------------------------
# Quartus project
# -----------------------------------------------------------------

puts " - Create the project '$board'"

# Close any open project
# * since all the projects are named after the board, close
#   the current project to clear the files list. This avoids the
#   top-level files from another project being picked
#   up if the previous project was not closed.
#
if {[is_project_open]} {
	puts "   * close the project"
	project_close
}

# Best to name the project your "top" component name.
#
#  * $quartus(project) contains the project name
#  * project_exist $board returns 1 only in the work directory,
#    since that is where the Quartus project file is located
#
if {[project_exists $board]} {
	puts "   * open the existing $board project"
	project_open -revision $board $board
} else {
	puts "   * create a new $board project"
	project_new -revision $board $board
}

# -----------------------------------------------------------------
# Design constraints
# -----------------------------------------------------------------

puts " - Applying constraints"
source $constraints
set_default_constraints

# SDC constraints
###set_global_assignment -name SDC_FILE $scripts/de0_nano.sdc

# -----------------------------------------------------------------
# VHDL files
# -----------------------------------------------------------------

# puts " - Creating the VHDL files list"

# # Create a list of VHDL files to build
# set vfiles [list]

# # Add the design files
# lappend vfiles $src/pll.vhd
# lappend vfiles $src/sync.vhd
# lappend vfiles $src/de0_nano.vhd

# # Pass the VHDL files list to Quartus
# foreach vfile $vfiles {
#     set_global_assignment -name VHDL_FILE $vfile
# }

# -----------------------------------------------------------------
# Qsys system
# -----------------------------------------------------------------

puts " - Generate the Qsys system"

# Convert qsys_system.tcl to qsys_system.qsys
proc qsys_create {} {
	global scripts qversion quartus

	puts "   * Tcl-to-Qsys generation for Quartus version $qversion"
	set arg_list [list]
	set cmd "set quartus_version $qversion"
	lappend arg_list --cmd=$cmd
	lappend arg_list --script=$scripts/qsys_system.tcl

	catch { eval [concat [list exec $quartus(quartus_rootpath)/sopc_builder/bin/qsys-script] $arg_list] } temp

	# Create a timestamp file
	close [open "qsys_system.timestamp" w]

	return
}

# Qsys .qsys file generation
# --------------------------
#
if {![file exists $qwork/qsys_system.qsys]} {

	# 1) The .qsys file does not exist
	#
	#    - Convert qsys_system.tcl to qsys_system.qsys
	#    - Create the .qsys file in the work folder so that when
	#      you use the Qsys GUI, the .qsys file is visible without
	#      having to navigate to the $scripts folder
	#
	puts "   * creating the Qsys file in the work directory"
	qsys_create

} else {

	# 2) The .qsys file already exists
	#
	#    - Check if the Qsys system files have been edited
	#
	set qsys_tcl  [file mtime $scripts/qsys_system.tcl]
	set qsys_time [file mtime $qwork/qsys_system.timestamp]
	set qsys_work [file mtime $qwork/qsys_system.qsys]

	if {$qsys_work < $qsys_tcl} {
		# qsys_system.tcl is newer, so over-write the existing .qsys file
		puts "   * Note: qsys_system.tcl has been modified"
		puts "   * creating the (updated) Qsys file in the work directory"
		qsys_create
	} elseif {$qsys_work > $qsys_time} {
		# Check to see if the Qsys GUI was used to modify the .qsys file
		puts "   * Note: the Qsys file in the work folder has been edited."
		puts "     If you want to keep these changes, remember to update the Tcl generator file"
	}
}

# Build the Qsys system?
set qsys_file $qwork/qsys_system.qsys
set qip_file  $qwork/qsys_system/synthesis/qsys_system.qip
set qsys_generate 0
if {![file exists $qip_file]} {
	set qsys_generate 1
} else {

	# See if the system file is newer than the Qsys system
	# * the QIP file does not always update, so check the qsys_system.v file
	set qsys_time [file mtime $qsys_file]
	set qip_time  [file mtime $qwork/qsys_system/synthesis/qsys_system.v]

	if {$qsys_time > $qip_time} {
		# This message is redundant due to the message above
#		puts "   * The Qsys system has been edited"
		set qsys_generate 1
	} else {
		puts "   * the Qsys system is up-to-date"
	}
}

if {$qsys_generate} {
	puts "   * generating the Qsys system (please wait)"
	# NOTE: this script uses the qversion variable
	source $scripts/synth_qsys.tcl
}

if {![file exists $qip_file]} {
	puts "Error: Qsys generation failed"
	return
}

# Add the Qsys IP file (which adds all the required files)
set_global_assignment -name QIP_FILE $qip_file

# -----------------------------------------------------------------
# Process the design
# -----------------------------------------------------------------

puts " - Processing the design"

set_global_assignment -name TOP_LEVEL_ENTITY qsys_system

execute_flow -compile

# Use one of the following to save the settings
#project_close
export_assignments

# Return to the top directory
cd $top

puts " - Processing completed"
puts ""

