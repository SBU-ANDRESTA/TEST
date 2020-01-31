# -----------------------------------------------------------------
#
# The Tcl procedures in this constraints file can be used by
# project synthesis files to setup the default device constraints
# and pinout.
#


# -----------------------------------------------------------------
# Device assignment
# -----------------------------------------------------------------
#
proc set_device_assignment {} {

	set_global_assignment -name FAMILY "@{project_properties.DEVICE_FAMILY}"
	set_global_assignment -name DEVICE @{project_properties.DEVICE}
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim (Verilog)"
	set_global_assignment -name EDA_NETLIST_WRITER_OUTPUT_DIR simulation/modelsim -section_id eda_simulation
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation

}

# -----------------------------------------------------------------
# Default assignments
# -----------------------------------------------------------------
#
proc set_default_assignments {} {

	# Tri-state unused pins
	set_global_assignment -name RESERVE_ALL_UNUSED_PINS_WEAK_PULLUP "AS INPUT TRI-STATED WITH WEAK PULL-UP"

	# Set the default I/O logic standard to 3.3V
	set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "3.3-V LVTTL"

	return
}

# -----------------------------------------------------------------
# Pin constraints
# -----------------------------------------------------------------
#
# The pin constraints can be displayed in Tcl using;
#
# tcl> get_pin_constraints pin
# tcl> parray pin
#
# The pin constraints for each pin (port) on the design are
# specified as a comma separated list of {key = value} pairs.
# The procedure set_pin_constraints converts those pairs
# into Altera Tcl constraints.
#
proc get_pin_constraints {arg} {

	# Make the input argument 'arg' visible as pin
	upvar $arg pin
	
	# -------------------------------------------------------------
	# Global Clocks
	# -------------------------------------------------------------
	#
	# Input
	set pin(clk_clk) {PIN = V11}

	# -------------------------------------------------------------
	# Push buttons
	# -------------------------------------------------------------
	#
	# Reset (KEY0, DEV_CLRn)
	###set pin(ext_rstN)	{PIN = J15, IOSTD = "3.3-V LVTTL"}

	# Push button (KEY1)
	###set pin(pb) 		{PIN = E1 , IOSTD = "3.3-V LVTTL"}

	# -------------------------------------------------------------
	# Switches
	# -------------------------------------------------------------
	#
	# Inputs
	###set pin(sw[0])    {PIN = M1 , IOSTD = "3.3-V LVTTL"}
	###set pin(sw[1])    {PIN = T8 , IOSTD = "3.3-V LVTTL"}
	###set pin(sw[2])    {PIN = B9 , IOSTD = "3.3-V LVTTL"}
	###set pin(sw[3])    {PIN = M15, IOSTD = "3.3-V LVTTL"}

	# -------------------------------------------------------------
	# LEDs
	# -------------------------------------------------------------
	#
	# The LEDs use "3.3-V LVTTL" rather than "3.3-V LVCMOS" as 
	# the Pin Planner shows that LVTTL has 8mA maximum current,
	# whereas LVCMOS is only 2mA.
	#
	# Outputs
	###set pin(led[0])	{PIN = A15, IOSTD = "3.3-V LVTTL", DRIVE = "MAXIMUM CURRENT", SLEW = 2}
	###set pin(led[1])	{PIN = A13, IOSTD = "3.3-V LVTTL", DRIVE = "MAXIMUM CURRENT", SLEW = 2}
	###set pin(led[2])	{PIN = B13, IOSTD = "3.3-V LVTTL", DRIVE = "MAXIMUM CURRENT", SLEW = 2}
	###set pin(led[3])	{PIN = A11, IOSTD = "3.3-V LVTTL", DRIVE = "MAXIMUM CURRENT", SLEW = 2}
	###set pin(led[4])	{PIN = D1 , IOSTD = "3.3-V LVTTL", DRIVE = "MAXIMUM CURRENT", SLEW = 2}
	###set pin(led[5])	{PIN = F3 , IOSTD = "3.3-V LVTTL", DRIVE = "MAXIMUM CURRENT", SLEW = 2}
	###set pin(led[6])	{PIN = B1 , IOSTD = "3.3-V LVTTL", DRIVE = "MAXIMUM CURRENT", SLEW = 2}
	###set pin(led[7])	{PIN = L3 , IOSTD = "3.3-V LVTTL", DRIVE = "MAXIMUM CURRENT", SLEW = 2}

	return
}

# -----------------------------------------------------------------
# Set Quartus pin assignments
# -----------------------------------------------------------------
#
# This procedure parses the entries in the Tcl pin constraints
# array and issues Quartus Tcl constraints commands.
#
proc set_pin_constraints {} {

	# Get the pin and I/O standard assignments
	get_pin_constraints pin
	
	# Loop over each pin in the design
	foreach port [array names pin] {
	
		# Convert the pin assignments into an options list, 
		# eg., {PIN = AV22} { IOSTD = LVDS}
		set options [split $pin($port) ,]
		foreach option $options {
		
			# Split each option into a key/value pair
			set keyval [split $option =]
			set key [lindex $keyval 0]
			set val [lindex $keyval 1]
				
			# Strip leading and trailing whitespace
			# and force to uppercase
			set key [string toupper [string trim $key]]
			set val [string toupper [string trim $val]]
	
			# Make the Quartus assignments
			#
			# The keys used in the assignments list are an abbreviation of
			# the Quartus setting name. The abbreviations supported are;
			#
			#   DRIVE   = drive current
			#   HOLD    = bus hold (ON/OFF)
			#   IOSTD   = I/O standard
			#   PIN     = pin number/name
			#   PULLUP  = weak pull-up (ON/OFF)
			#   SLEW    = slew rate (a number between 0 and 3)
			#   TERMIN  = input termination (string value)
			#   TERMOUT = output termination (string value)
			#
			switch $key {
				DRIVE   {set_instance_assignment -name CURRENT_STRENGTH_NEW $val -to $port}
				HOLD    {set_instance_assignment -name ENABLE_BUS_HOLD_CIRCUITRY $val -to $port}				
				IOSTD   {set_instance_assignment -name IO_STANDARD $val -to $port}
				PIN     {set_location_assignment -to $port "Pin_$val"}
				PULLUP  {set_instance_assignment -name WEAK_PULL_UP_RESISTOR $val -to $port}				
				SLEW    {set_instance_assignment -name SLEW_RATE $val -to $port}
				TERMIN  {set_instance_assignment -name INPUT_TERMINATION $val -to $port}
				TERMOUT {set_instance_assignment -name OUTPUT_TERMINATION $val -to $port}				
				default {error "Unknown setting: KEY = '$key', VALUE = '$val'"}
			}
		}
	}
}

# -----------------------------------------------------------------
# Set the default constraints
# -----------------------------------------------------------------
#
proc set_default_constraints {} {
	set_device_assignment
	set_default_assignments
	set_pin_constraints
}

