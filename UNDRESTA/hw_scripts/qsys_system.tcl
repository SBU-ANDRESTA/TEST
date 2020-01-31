# -----------------------------------------------------------------
# qsys_system.tcl


# This Tcl script is used to generate the Quartus II version
# specific XML file qsys_system.qsys via

#    qsys-script \
#      --cmd="set quartus_version 14.0" \
#      --script=qsys_system.tcl

# -----------------------------------------------------------------
# Tcl->Qsys Script Creation
# --------------------------

# Qsys systems can be converted to, or generated from, Tcl
# scripts via the qsys-script procedure which is briefly descibed
# on the AlteraWiki

#  http://www.alterawiki.com/wiki/Qsys_Scripts

# The Qsys to Tcl generation script from the Wiki was modified to
# use qsys 14.0 and to generate the connections in alphabetical
# order (making file-differencing easier).

# The Tcl script generation procedure is as follows;

# 1. Create the Qsys system via the Qsys GUI and save
#    the XML file, eg., qsys_system.sys

# 2. Convert the .qsys file to .tcl via

#    qsys-script \
#      --cmd="set system_name qsys_system" \
#      --script=save_script.tcl \
#      --system-file=qsys_system.qsys

# 3. Conversely, you can convert .tcl to .qsys via

#    qsys-script --script=qsys_system.tcl

# The .qsys file can be edited in the GUI, and then converted
# to Tcl, and any changes used to update the .tcl file.

# This Tcl script was created by first creating a Qsys system
# in Quartus 14.0 and then converting that to .tcl. The generation
# script was then tested under 14.0, 13.0sp1, and 12.0.

# The qsys-script application is not a "true" Tcl application
# (its likely a Java Jacl-based implementation). The tool
# does not report its name via the Tcl command
# [info nameofexecutable], packages are not available,
# eg., "package require hdl" does not work, and the global variable
# quartus does not exist, so $quartus(version) cannot be used.
# For these reasons, the script parameters are passed via the
# qsys-script --cmd= option.

# -----------------------------------------------------------------
# Notes
# -----

# 1. add_instance version numbers

#    The add_instance procedure takes an optional version
#    parameter. Unfortunately the version number does not match
#    the Quartus version, so its not possible to simply pass
#    $quartus_version for the parameter, eg., under 13.0sp1
#    the SDRAM controller version is 13.0.1.99.2, whereas the
#    clock source and JTAG master versions are 13.0.

# -----------------------------------------------------------------

# -----------------------------------------------------------------
# Script Arguments/Defaults
# -----------------------------------------------------------------

if {![info exists quartus_version]} {
	set quartus_version 14.0
}

# -----------------------------------------------------------------
# Tcl Packages
# -----------------------------------------------------------------
#
package require -exact qsys $quartus_version

# -----------------------------------------------------------------
# Qsys system
# -----------------------------------------------------------------
#
# Module properties
# -----------------
set_module_property NAME {qsys_system}

# Project properties
# ------------------
set_project_property DEVICE_FAMILY {Cyclone V}
set_project_property DEVICE {5CSEMA4U23C6}
set_project_property HIDE_FROM_IP_CATALOG {false}

# Components
# ----------
#
# The order the components are created here, matches the order
# they are displayed in the Qsys GUI.
#
# Instances and instance parameters
# (disabled instances are intentionally culled)
	add_instance NoC NoC 1.0
	set_instance_parameter_value NoC {RowNo} {2}
	set_instance_parameter_value NoC {ColNo} {2}
	set_instance_parameter_value NoC {AddrWidth} {2}
	set_instance_parameter_value NoC {DataWidth} {8}
	set_instance_parameter_value NoC {PackWidth} {8}
	set_instance_parameter_value NoC {PhyCh} {4}
	set_instance_parameter_value NoC {PhyChAddr} {2}
	set_instance_parameter_value NoC {PhyRoCh} {5}
	set_instance_parameter_value NoC {PhyRoChAddr} {3}
	set_instance_parameter_value NoC {RoCh} {1}
	set_instance_parameter_value NoC {RoChAddr} {1}
	set_instance_parameter_value NoC {ViCh} {1}
	set_instance_parameter_value NoC {ViChAddr} {1}

	add_instance clk_0 clock_source 17.1
	set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
	set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
	set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}


	

	add_instance data_mem_0 altera_avalon_onchip_memory2 17.1
	set_instance_parameter_value data_mem_0 {allowInSystemMemoryContentEditor} {0}
	set_instance_parameter_value data_mem_0 {blockType} {AUTO}
	set_instance_parameter_value data_mem_0 {copyInitFile} {0}
	set_instance_parameter_value data_mem_0 {dataWidth} {32}
	set_instance_parameter_value data_mem_0 {dataWidth2} {32}
	set_instance_parameter_value data_mem_0 {dualPort} {0}
	set_instance_parameter_value data_mem_0 {ecc_enabled} {0}
	set_instance_parameter_value data_mem_0 {enPRInitMode} {0}
	set_instance_parameter_value data_mem_0 {enableDiffWidth} {0}
	set_instance_parameter_value data_mem_0 {initMemContent} {1}
	set_instance_parameter_value data_mem_0 {initializationFileName} {onchip_mem.hex}
	set_instance_parameter_value data_mem_0 {instanceID} {NONE}
	set_instance_parameter_value data_mem_0 {memorySize} {24576.0}
	set_instance_parameter_value data_mem_0 {readDuringWriteMode} {DONT_CARE}
	set_instance_parameter_value data_mem_0 {resetrequest_enabled} {1}
	set_instance_parameter_value data_mem_0 {simAllowMRAMContentsFile} {0}
	set_instance_parameter_value data_mem_0 {simMemInitOnlyFilename} {0}
	set_instance_parameter_value data_mem_0 {singleClockOperation} {0}
	set_instance_parameter_value data_mem_0 {slave1Latency} {1}
	set_instance_parameter_value data_mem_0 {slave2Latency} {1}
	set_instance_parameter_value data_mem_0 {useNonDefaultInitFile} {0}
	set_instance_parameter_value data_mem_0 {useShallowMemBlocks} {0}
	set_instance_parameter_value data_mem_0 {writable} {1}

	

	add_instance data_mem_1 altera_avalon_onchip_memory2 17.1
	set_instance_parameter_value data_mem_1 {allowInSystemMemoryContentEditor} {0}
	set_instance_parameter_value data_mem_1 {blockType} {AUTO}
	set_instance_parameter_value data_mem_1 {copyInitFile} {0}
	set_instance_parameter_value data_mem_1 {dataWidth} {32}
	set_instance_parameter_value data_mem_1 {dataWidth2} {32}
	set_instance_parameter_value data_mem_1 {dualPort} {0}
	set_instance_parameter_value data_mem_1 {ecc_enabled} {0}
	set_instance_parameter_value data_mem_1 {enPRInitMode} {0}
	set_instance_parameter_value data_mem_1 {enableDiffWidth} {0}
	set_instance_parameter_value data_mem_1 {initMemContent} {1}
	set_instance_parameter_value data_mem_1 {initializationFileName} {onchip_mem.hex}
	set_instance_parameter_value data_mem_1 {instanceID} {NONE}
	set_instance_parameter_value data_mem_1 {memorySize} {24576.0}
	set_instance_parameter_value data_mem_1 {readDuringWriteMode} {DONT_CARE}
	set_instance_parameter_value data_mem_1 {resetrequest_enabled} {1}
	set_instance_parameter_value data_mem_1 {simAllowMRAMContentsFile} {0}
	set_instance_parameter_value data_mem_1 {simMemInitOnlyFilename} {0}
	set_instance_parameter_value data_mem_1 {singleClockOperation} {0}
	set_instance_parameter_value data_mem_1 {slave1Latency} {1}
	set_instance_parameter_value data_mem_1 {slave2Latency} {1}
	set_instance_parameter_value data_mem_1 {useNonDefaultInitFile} {0}
	set_instance_parameter_value data_mem_1 {useShallowMemBlocks} {0}
	set_instance_parameter_value data_mem_1 {writable} {1}

	

	add_instance data_mem_2 altera_avalon_onchip_memory2 17.1
	set_instance_parameter_value data_mem_2 {allowInSystemMemoryContentEditor} {0}
	set_instance_parameter_value data_mem_2 {blockType} {AUTO}
	set_instance_parameter_value data_mem_2 {copyInitFile} {0}
	set_instance_parameter_value data_mem_2 {dataWidth} {32}
	set_instance_parameter_value data_mem_2 {dataWidth2} {32}
	set_instance_parameter_value data_mem_2 {dualPort} {0}
	set_instance_parameter_value data_mem_2 {ecc_enabled} {0}
	set_instance_parameter_value data_mem_2 {enPRInitMode} {0}
	set_instance_parameter_value data_mem_2 {enableDiffWidth} {0}
	set_instance_parameter_value data_mem_2 {initMemContent} {1}
	set_instance_parameter_value data_mem_2 {initializationFileName} {onchip_mem.hex}
	set_instance_parameter_value data_mem_2 {instanceID} {NONE}
	set_instance_parameter_value data_mem_2 {memorySize} {24576.0}
	set_instance_parameter_value data_mem_2 {readDuringWriteMode} {DONT_CARE}
	set_instance_parameter_value data_mem_2 {resetrequest_enabled} {1}
	set_instance_parameter_value data_mem_2 {simAllowMRAMContentsFile} {0}
	set_instance_parameter_value data_mem_2 {simMemInitOnlyFilename} {0}
	set_instance_parameter_value data_mem_2 {singleClockOperation} {0}
	set_instance_parameter_value data_mem_2 {slave1Latency} {1}
	set_instance_parameter_value data_mem_2 {slave2Latency} {1}
	set_instance_parameter_value data_mem_2 {useNonDefaultInitFile} {0}
	set_instance_parameter_value data_mem_2 {useShallowMemBlocks} {0}
	set_instance_parameter_value data_mem_2 {writable} {1}

	

	add_instance data_mem_3 altera_avalon_onchip_memory2 17.1
	set_instance_parameter_value data_mem_3 {allowInSystemMemoryContentEditor} {0}
	set_instance_parameter_value data_mem_3 {blockType} {AUTO}
	set_instance_parameter_value data_mem_3 {copyInitFile} {0}
	set_instance_parameter_value data_mem_3 {dataWidth} {32}
	set_instance_parameter_value data_mem_3 {dataWidth2} {32}
	set_instance_parameter_value data_mem_3 {dualPort} {0}
	set_instance_parameter_value data_mem_3 {ecc_enabled} {0}
	set_instance_parameter_value data_mem_3 {enPRInitMode} {0}
	set_instance_parameter_value data_mem_3 {enableDiffWidth} {0}
	set_instance_parameter_value data_mem_3 {initMemContent} {1}
	set_instance_parameter_value data_mem_3 {initializationFileName} {onchip_mem.hex}
	set_instance_parameter_value data_mem_3 {instanceID} {NONE}
	set_instance_parameter_value data_mem_3 {memorySize} {24576.0}
	set_instance_parameter_value data_mem_3 {readDuringWriteMode} {DONT_CARE}
	set_instance_parameter_value data_mem_3 {resetrequest_enabled} {1}
	set_instance_parameter_value data_mem_3 {simAllowMRAMContentsFile} {0}
	set_instance_parameter_value data_mem_3 {simMemInitOnlyFilename} {0}
	set_instance_parameter_value data_mem_3 {singleClockOperation} {0}
	set_instance_parameter_value data_mem_3 {slave1Latency} {1}
	set_instance_parameter_value data_mem_3 {slave2Latency} {1}
	set_instance_parameter_value data_mem_3 {useNonDefaultInitFile} {0}
	set_instance_parameter_value data_mem_3 {useShallowMemBlocks} {0}
	set_instance_parameter_value data_mem_3 {writable} {1}

	
	
	
	add_instance fifo_sink_0 altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_sink_0 {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_sink_0 {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_sink_0 {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_sink_0 {channelWidth} {8}
	set_instance_parameter_value fifo_sink_0 {errorWidth} {8}
	set_instance_parameter_value fifo_sink_0 {fifoDepth} {16}
	set_instance_parameter_value fifo_sink_0 {fifoInputInterfaceOptions} {AVALONST_SINK}
	set_instance_parameter_value fifo_sink_0 {fifoOutputInterfaceOptions} {AVALONMM_READ}
	set_instance_parameter_value fifo_sink_0 {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_sink_0 {singleClockMode} {1}
	set_instance_parameter_value fifo_sink_0 {singleResetMode} {0}
	set_instance_parameter_value fifo_sink_0 {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_sink_0 {useBackpressure} {1}
	set_instance_parameter_value fifo_sink_0 {useIRQ} {1}
	set_instance_parameter_value fifo_sink_0 {usePacket} {0}
	set_instance_parameter_value fifo_sink_0 {useReadControl} {0}
	set_instance_parameter_value fifo_sink_0 {useRegister} {0}
	set_instance_parameter_value fifo_sink_0 {useWriteControl} {1}

	
	
	add_instance fifo_sink_1 altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_sink_1 {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_sink_1 {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_sink_1 {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_sink_1 {channelWidth} {8}
	set_instance_parameter_value fifo_sink_1 {errorWidth} {8}
	set_instance_parameter_value fifo_sink_1 {fifoDepth} {16}
	set_instance_parameter_value fifo_sink_1 {fifoInputInterfaceOptions} {AVALONST_SINK}
	set_instance_parameter_value fifo_sink_1 {fifoOutputInterfaceOptions} {AVALONMM_READ}
	set_instance_parameter_value fifo_sink_1 {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_sink_1 {singleClockMode} {1}
	set_instance_parameter_value fifo_sink_1 {singleResetMode} {0}
	set_instance_parameter_value fifo_sink_1 {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_sink_1 {useBackpressure} {1}
	set_instance_parameter_value fifo_sink_1 {useIRQ} {1}
	set_instance_parameter_value fifo_sink_1 {usePacket} {0}
	set_instance_parameter_value fifo_sink_1 {useReadControl} {0}
	set_instance_parameter_value fifo_sink_1 {useRegister} {0}
	set_instance_parameter_value fifo_sink_1 {useWriteControl} {1}

	
	
	add_instance fifo_sink_2 altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_sink_2 {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_sink_2 {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_sink_2 {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_sink_2 {channelWidth} {8}
	set_instance_parameter_value fifo_sink_2 {errorWidth} {8}
	set_instance_parameter_value fifo_sink_2 {fifoDepth} {16}
	set_instance_parameter_value fifo_sink_2 {fifoInputInterfaceOptions} {AVALONST_SINK}
	set_instance_parameter_value fifo_sink_2 {fifoOutputInterfaceOptions} {AVALONMM_READ}
	set_instance_parameter_value fifo_sink_2 {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_sink_2 {singleClockMode} {1}
	set_instance_parameter_value fifo_sink_2 {singleResetMode} {0}
	set_instance_parameter_value fifo_sink_2 {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_sink_2 {useBackpressure} {1}
	set_instance_parameter_value fifo_sink_2 {useIRQ} {1}
	set_instance_parameter_value fifo_sink_2 {usePacket} {0}
	set_instance_parameter_value fifo_sink_2 {useReadControl} {0}
	set_instance_parameter_value fifo_sink_2 {useRegister} {0}
	set_instance_parameter_value fifo_sink_2 {useWriteControl} {1}

	
	
	add_instance fifo_sink_3 altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_sink_3 {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_sink_3 {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_sink_3 {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_sink_3 {channelWidth} {8}
	set_instance_parameter_value fifo_sink_3 {errorWidth} {8}
	set_instance_parameter_value fifo_sink_3 {fifoDepth} {16}
	set_instance_parameter_value fifo_sink_3 {fifoInputInterfaceOptions} {AVALONST_SINK}
	set_instance_parameter_value fifo_sink_3 {fifoOutputInterfaceOptions} {AVALONMM_READ}
	set_instance_parameter_value fifo_sink_3 {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_sink_3 {singleClockMode} {1}
	set_instance_parameter_value fifo_sink_3 {singleResetMode} {0}
	set_instance_parameter_value fifo_sink_3 {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_sink_3 {useBackpressure} {1}
	set_instance_parameter_value fifo_sink_3 {useIRQ} {1}
	set_instance_parameter_value fifo_sink_3 {usePacket} {0}
	set_instance_parameter_value fifo_sink_3 {useReadControl} {0}
	set_instance_parameter_value fifo_sink_3 {useRegister} {0}
	set_instance_parameter_value fifo_sink_3 {useWriteControl} {1}

	

	

	add_instance fifo_source_0 altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_source_0 {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_source_0 {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_source_0 {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_source_0 {channelWidth} {8}
	set_instance_parameter_value fifo_source_0 {errorWidth} {8}
	set_instance_parameter_value fifo_source_0 {fifoDepth} {16}
	set_instance_parameter_value fifo_source_0 {fifoInputInterfaceOptions} {AVALONMM_WRITE}
	set_instance_parameter_value fifo_source_0 {fifoOutputInterfaceOptions} {AVALONST_SOURCE}
	set_instance_parameter_value fifo_source_0 {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_source_0 {singleClockMode} {1}
	set_instance_parameter_value fifo_source_0 {singleResetMode} {0}
	set_instance_parameter_value fifo_source_0 {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_source_0 {useBackpressure} {1}
	set_instance_parameter_value fifo_source_0 {useIRQ} {1}
	set_instance_parameter_value fifo_source_0 {usePacket} {0}
	set_instance_parameter_value fifo_source_0 {useReadControl} {0}
	set_instance_parameter_value fifo_source_0 {useRegister} {0}
	set_instance_parameter_value fifo_source_0 {useWriteControl} {1}

	

	add_instance fifo_source_1 altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_source_1 {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_source_1 {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_source_1 {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_source_1 {channelWidth} {8}
	set_instance_parameter_value fifo_source_1 {errorWidth} {8}
	set_instance_parameter_value fifo_source_1 {fifoDepth} {16}
	set_instance_parameter_value fifo_source_1 {fifoInputInterfaceOptions} {AVALONMM_WRITE}
	set_instance_parameter_value fifo_source_1 {fifoOutputInterfaceOptions} {AVALONST_SOURCE}
	set_instance_parameter_value fifo_source_1 {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_source_1 {singleClockMode} {1}
	set_instance_parameter_value fifo_source_1 {singleResetMode} {0}
	set_instance_parameter_value fifo_source_1 {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_source_1 {useBackpressure} {1}
	set_instance_parameter_value fifo_source_1 {useIRQ} {1}
	set_instance_parameter_value fifo_source_1 {usePacket} {0}
	set_instance_parameter_value fifo_source_1 {useReadControl} {0}
	set_instance_parameter_value fifo_source_1 {useRegister} {0}
	set_instance_parameter_value fifo_source_1 {useWriteControl} {1}

	

	add_instance fifo_source_2 altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_source_2 {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_source_2 {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_source_2 {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_source_2 {channelWidth} {8}
	set_instance_parameter_value fifo_source_2 {errorWidth} {8}
	set_instance_parameter_value fifo_source_2 {fifoDepth} {16}
	set_instance_parameter_value fifo_source_2 {fifoInputInterfaceOptions} {AVALONMM_WRITE}
	set_instance_parameter_value fifo_source_2 {fifoOutputInterfaceOptions} {AVALONST_SOURCE}
	set_instance_parameter_value fifo_source_2 {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_source_2 {singleClockMode} {1}
	set_instance_parameter_value fifo_source_2 {singleResetMode} {0}
	set_instance_parameter_value fifo_source_2 {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_source_2 {useBackpressure} {1}
	set_instance_parameter_value fifo_source_2 {useIRQ} {1}
	set_instance_parameter_value fifo_source_2 {usePacket} {0}
	set_instance_parameter_value fifo_source_2 {useReadControl} {0}
	set_instance_parameter_value fifo_source_2 {useRegister} {0}
	set_instance_parameter_value fifo_source_2 {useWriteControl} {1}

	

	add_instance fifo_source_3 altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_source_3 {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_source_3 {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_source_3 {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_source_3 {channelWidth} {8}
	set_instance_parameter_value fifo_source_3 {errorWidth} {8}
	set_instance_parameter_value fifo_source_3 {fifoDepth} {16}
	set_instance_parameter_value fifo_source_3 {fifoInputInterfaceOptions} {AVALONMM_WRITE}
	set_instance_parameter_value fifo_source_3 {fifoOutputInterfaceOptions} {AVALONST_SOURCE}
	set_instance_parameter_value fifo_source_3 {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_source_3 {singleClockMode} {1}
	set_instance_parameter_value fifo_source_3 {singleResetMode} {0}
	set_instance_parameter_value fifo_source_3 {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_source_3 {useBackpressure} {1}
	set_instance_parameter_value fifo_source_3 {useIRQ} {1}
	set_instance_parameter_value fifo_source_3 {usePacket} {0}
	set_instance_parameter_value fifo_source_3 {useReadControl} {0}
	set_instance_parameter_value fifo_source_3 {useRegister} {0}
	set_instance_parameter_value fifo_source_3 {useWriteControl} {1}

	
	add_instance jtag_uart_0 altera_avalon_jtag_uart 17.1
	set_instance_parameter_value jtag_uart_0 {allowMultipleConnections} {0}
	set_instance_parameter_value jtag_uart_0 {hubInstanceID} {0}
	set_instance_parameter_value jtag_uart_0 {readBufferDepth} {64}
	set_instance_parameter_value jtag_uart_0 {readIRQThreshold} {8}
	set_instance_parameter_value jtag_uart_0 {simInputCharacterStream} {}
	set_instance_parameter_value jtag_uart_0 {simInteractiveOptions} {NO_INTERACTIVE_WINDOWS}
	set_instance_parameter_value jtag_uart_0 {useRegistersForReadBuffer} {0}
	set_instance_parameter_value jtag_uart_0 {useRegistersForWriteBuffer} {0}
	set_instance_parameter_value jtag_uart_0 {useRelativePathForSimFile} {0}
	set_instance_parameter_value jtag_uart_0 {writeBufferDepth} {64}
	set_instance_parameter_value jtag_uart_0 {writeIRQThreshold} {8}

			
	


	add_instance nios2_0 altera_nios2_gen2 17.1
	set_instance_parameter_value nios2_0 {bht_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_0 {breakOffset} {32}
	set_instance_parameter_value nios2_0 {breakSlave} {None}
	set_instance_parameter_value nios2_0 {cdx_enabled} {0}
	set_instance_parameter_value nios2_0 {cpuArchRev} {1}
	set_instance_parameter_value nios2_0 {cpuID} {0}
	set_instance_parameter_value nios2_0 {cpuReset} {0}
	set_instance_parameter_value nios2_0 {data_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_0 {data_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {data_master_paddr_base} {0}
	set_instance_parameter_value nios2_0 {data_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {dcache_bursts} {false}
	set_instance_parameter_value nios2_0 {dcache_numTCDM} {0}
	set_instance_parameter_value nios2_0 {dcache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_0 {dcache_size} {2048}
	set_instance_parameter_value nios2_0 {dcache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_0 {dcache_victim_buf_impl} {ram}
	set_instance_parameter_value nios2_0 {debug_OCIOnchipTrace} {_128}
	set_instance_parameter_value nios2_0 {debug_assignJtagInstanceID} {0}
	set_instance_parameter_value nios2_0 {debug_datatrigger} {0}
	set_instance_parameter_value nios2_0 {debug_debugReqSignals} {0}
	set_instance_parameter_value nios2_0 {debug_enabled} {1}
	set_instance_parameter_value nios2_0 {debug_hwbreakpoint} {0}
	set_instance_parameter_value nios2_0 {debug_jtagInstanceID} {0}
	set_instance_parameter_value nios2_0 {debug_traceStorage} {onchip_trace}
	set_instance_parameter_value nios2_0 {debug_traceType} {none}
	set_instance_parameter_value nios2_0 {debug_triggerArming} {1}
	set_instance_parameter_value nios2_0 {dividerType} {no_div}
	set_instance_parameter_value nios2_0 {exceptionOffset} {32}
	set_instance_parameter_value nios2_0 {exceptionSlave} {data_mem_0.s1}
	set_instance_parameter_value nios2_0 {fa_cache_line} {2}
	set_instance_parameter_value nios2_0 {fa_cache_linesize} {0}
	set_instance_parameter_value nios2_0 {flash_instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_0 {flash_instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {icache_burstType} {None}
	set_instance_parameter_value nios2_0 {icache_numTCIM} {0}
	set_instance_parameter_value nios2_0 {icache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_0 {icache_size} {4096}
	set_instance_parameter_value nios2_0 {icache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_0 {impl} {Tiny}
	set_instance_parameter_value nios2_0 {instruction_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_0 {instruction_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_0 {instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {io_regionbase} {0}
	set_instance_parameter_value nios2_0 {io_regionsize} {0}
	set_instance_parameter_value nios2_0 {master_addr_map} {0}
	set_instance_parameter_value nios2_0 {mmu_TLBMissExcOffset} {0}
	set_instance_parameter_value nios2_0 {mmu_TLBMissExcSlave} {None}
	set_instance_parameter_value nios2_0 {mmu_autoAssignTlbPtrSz} {1}
	set_instance_parameter_value nios2_0 {mmu_enabled} {0}
	set_instance_parameter_value nios2_0 {mmu_processIDNumBits} {8}
	set_instance_parameter_value nios2_0 {mmu_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_0 {mmu_tlbNumWays} {16}
	set_instance_parameter_value nios2_0 {mmu_tlbPtrSz} {7}
	set_instance_parameter_value nios2_0 {mmu_udtlbNumEntries} {6}
	set_instance_parameter_value nios2_0 {mmu_uitlbNumEntries} {4}
	set_instance_parameter_value nios2_0 {mpu_enabled} {0}
	set_instance_parameter_value nios2_0 {mpu_minDataRegionSize} {12}
	set_instance_parameter_value nios2_0 {mpu_minInstRegionSize} {12}
	set_instance_parameter_value nios2_0 {mpu_numOfDataRegion} {8}
	set_instance_parameter_value nios2_0 {mpu_numOfInstRegion} {8}
	set_instance_parameter_value nios2_0 {mpu_useLimit} {0}
	set_instance_parameter_value nios2_0 {mpx_enabled} {0}
	set_instance_parameter_value nios2_0 {mul_32_impl} {2}
	set_instance_parameter_value nios2_0 {mul_64_impl} {0}
	set_instance_parameter_value nios2_0 {mul_shift_choice} {0}
	set_instance_parameter_value nios2_0 {ocimem_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_0 {ocimem_ramInit} {0}
	set_instance_parameter_value nios2_0 {regfile_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_0 {register_file_por} {0}
	set_instance_parameter_value nios2_0 {resetOffset} {0}
	set_instance_parameter_value nios2_0 {resetSlave} {data_mem_0.s1}
	set_instance_parameter_value nios2_0 {resetrequest_enabled} {1}
	set_instance_parameter_value nios2_0 {setting_HBreakTest} {0}
	set_instance_parameter_value nios2_0 {setting_HDLSimCachesCleared} {1}
	set_instance_parameter_value nios2_0 {setting_activateMonitors} {1}
	set_instance_parameter_value nios2_0 {setting_activateTestEndChecker} {0}
	set_instance_parameter_value nios2_0 {setting_activateTrace} {0}
	set_instance_parameter_value nios2_0 {setting_allow_break_inst} {0}
	set_instance_parameter_value nios2_0 {setting_alwaysEncrypt} {1}
	set_instance_parameter_value nios2_0 {setting_asic_add_scan_mode_input} {0}
	set_instance_parameter_value nios2_0 {setting_asic_enabled} {0}
	set_instance_parameter_value nios2_0 {setting_asic_synopsys_translate_on_off} {0}
	set_instance_parameter_value nios2_0 {setting_asic_third_party_synthesis} {0}
	set_instance_parameter_value nios2_0 {setting_avalonDebugPortPresent} {0}
	set_instance_parameter_value nios2_0 {setting_bhtPtrSz} {8}
	set_instance_parameter_value nios2_0 {setting_bigEndian} {0}
	set_instance_parameter_value nios2_0 {setting_branchpredictiontype} {Dynamic}
	set_instance_parameter_value nios2_0 {setting_breakslaveoveride} {0}
	set_instance_parameter_value nios2_0 {setting_clearXBitsLDNonBypass} {1}
	set_instance_parameter_value nios2_0 {setting_dc_ecc_present} {1}
	set_instance_parameter_value nios2_0 {setting_disable_tmr_inj} {0}
	set_instance_parameter_value nios2_0 {setting_disableocitrace} {0}
	set_instance_parameter_value nios2_0 {setting_dtcm_ecc_present} {1}
	set_instance_parameter_value nios2_0 {setting_ecc_present} {0}
	set_instance_parameter_value nios2_0 {setting_ecc_sim_test_ports} {0}
	set_instance_parameter_value nios2_0 {setting_exportHostDebugPort} {0}
	set_instance_parameter_value nios2_0 {setting_exportPCB} {0}
	set_instance_parameter_value nios2_0 {setting_export_large_RAMs} {0}
	set_instance_parameter_value nios2_0 {setting_exportdebuginfo} {0}
	set_instance_parameter_value nios2_0 {setting_exportvectors} {0}
	set_instance_parameter_value nios2_0 {setting_fast_register_read} {0}
	set_instance_parameter_value nios2_0 {setting_ic_ecc_present} {1}
	set_instance_parameter_value nios2_0 {setting_interruptControllerType} {Internal}
	set_instance_parameter_value nios2_0 {setting_itcm_ecc_present} {1}
	set_instance_parameter_value nios2_0 {setting_mmu_ecc_present} {1}
	set_instance_parameter_value nios2_0 {setting_oci_export_jtag_signals} {0}
	set_instance_parameter_value nios2_0 {setting_oci_version} {1}
	set_instance_parameter_value nios2_0 {setting_preciseIllegalMemAccessException} {0}
	set_instance_parameter_value nios2_0 {setting_removeRAMinit} {0}
	set_instance_parameter_value nios2_0 {setting_rf_ecc_present} {1}
	set_instance_parameter_value nios2_0 {setting_shadowRegisterSets} {0}
	set_instance_parameter_value nios2_0 {setting_showInternalSettings} {0}
	set_instance_parameter_value nios2_0 {setting_showUnpublishedSettings} {0}
	set_instance_parameter_value nios2_0 {setting_support31bitdcachebypass} {1}
	set_instance_parameter_value nios2_0 {setting_tmr_output_disable} {0}
	set_instance_parameter_value nios2_0 {setting_usedesignware} {0}
	set_instance_parameter_value nios2_0 {shift_rot_impl} {1}
	set_instance_parameter_value nios2_0 {tightly_coupled_data_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_0 {tightly_coupled_data_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {tightly_coupled_data_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_0 {tightly_coupled_data_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {tightly_coupled_data_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_0 {tightly_coupled_data_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {tightly_coupled_data_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_0 {tightly_coupled_data_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {tightly_coupled_instruction_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_0 {tightly_coupled_instruction_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {tightly_coupled_instruction_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_0 {tightly_coupled_instruction_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {tightly_coupled_instruction_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_0 {tightly_coupled_instruction_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {tightly_coupled_instruction_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_0 {tightly_coupled_instruction_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_0 {tmr_enabled} {0}
	set_instance_parameter_value nios2_0 {tracefilename} {}
	set_instance_parameter_value nios2_0 {userDefinedSettings} {}

	


	add_instance nios2_1 altera_nios2_gen2 17.1
	set_instance_parameter_value nios2_1 {bht_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_1 {breakOffset} {32}
	set_instance_parameter_value nios2_1 {breakSlave} {None}
	set_instance_parameter_value nios2_1 {cdx_enabled} {0}
	set_instance_parameter_value nios2_1 {cpuArchRev} {1}
	set_instance_parameter_value nios2_1 {cpuID} {0}
	set_instance_parameter_value nios2_1 {cpuReset} {0}
	set_instance_parameter_value nios2_1 {data_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_1 {data_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {data_master_paddr_base} {0}
	set_instance_parameter_value nios2_1 {data_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {dcache_bursts} {false}
	set_instance_parameter_value nios2_1 {dcache_numTCDM} {0}
	set_instance_parameter_value nios2_1 {dcache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_1 {dcache_size} {2048}
	set_instance_parameter_value nios2_1 {dcache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_1 {dcache_victim_buf_impl} {ram}
	set_instance_parameter_value nios2_1 {debug_OCIOnchipTrace} {_128}
	set_instance_parameter_value nios2_1 {debug_assignJtagInstanceID} {0}
	set_instance_parameter_value nios2_1 {debug_datatrigger} {0}
	set_instance_parameter_value nios2_1 {debug_debugReqSignals} {0}
	set_instance_parameter_value nios2_1 {debug_enabled} {1}
	set_instance_parameter_value nios2_1 {debug_hwbreakpoint} {0}
	set_instance_parameter_value nios2_1 {debug_jtagInstanceID} {0}
	set_instance_parameter_value nios2_1 {debug_traceStorage} {onchip_trace}
	set_instance_parameter_value nios2_1 {debug_traceType} {none}
	set_instance_parameter_value nios2_1 {debug_triggerArming} {1}
	set_instance_parameter_value nios2_1 {dividerType} {no_div}
	set_instance_parameter_value nios2_1 {exceptionOffset} {32}
	set_instance_parameter_value nios2_1 {exceptionSlave} {data_mem_1.s1}
	set_instance_parameter_value nios2_1 {fa_cache_line} {2}
	set_instance_parameter_value nios2_1 {fa_cache_linesize} {0}
	set_instance_parameter_value nios2_1 {flash_instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_1 {flash_instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {icache_burstType} {None}
	set_instance_parameter_value nios2_1 {icache_numTCIM} {0}
	set_instance_parameter_value nios2_1 {icache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_1 {icache_size} {4096}
	set_instance_parameter_value nios2_1 {icache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_1 {impl} {Tiny}
	set_instance_parameter_value nios2_1 {instruction_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_1 {instruction_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_1 {instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {io_regionbase} {0}
	set_instance_parameter_value nios2_1 {io_regionsize} {0}
	set_instance_parameter_value nios2_1 {master_addr_map} {0}
	set_instance_parameter_value nios2_1 {mmu_TLBMissExcOffset} {0}
	set_instance_parameter_value nios2_1 {mmu_TLBMissExcSlave} {None}
	set_instance_parameter_value nios2_1 {mmu_autoAssignTlbPtrSz} {1}
	set_instance_parameter_value nios2_1 {mmu_enabled} {0}
	set_instance_parameter_value nios2_1 {mmu_processIDNumBits} {8}
	set_instance_parameter_value nios2_1 {mmu_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_1 {mmu_tlbNumWays} {16}
	set_instance_parameter_value nios2_1 {mmu_tlbPtrSz} {7}
	set_instance_parameter_value nios2_1 {mmu_udtlbNumEntries} {6}
	set_instance_parameter_value nios2_1 {mmu_uitlbNumEntries} {4}
	set_instance_parameter_value nios2_1 {mpu_enabled} {0}
	set_instance_parameter_value nios2_1 {mpu_minDataRegionSize} {12}
	set_instance_parameter_value nios2_1 {mpu_minInstRegionSize} {12}
	set_instance_parameter_value nios2_1 {mpu_numOfDataRegion} {8}
	set_instance_parameter_value nios2_1 {mpu_numOfInstRegion} {8}
	set_instance_parameter_value nios2_1 {mpu_useLimit} {0}
	set_instance_parameter_value nios2_1 {mpx_enabled} {0}
	set_instance_parameter_value nios2_1 {mul_32_impl} {2}
	set_instance_parameter_value nios2_1 {mul_64_impl} {0}
	set_instance_parameter_value nios2_1 {mul_shift_choice} {0}
	set_instance_parameter_value nios2_1 {ocimem_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_1 {ocimem_ramInit} {0}
	set_instance_parameter_value nios2_1 {regfile_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_1 {register_file_por} {0}
	set_instance_parameter_value nios2_1 {resetOffset} {0}
	set_instance_parameter_value nios2_1 {resetSlave} {data_mem_1.s1}
	set_instance_parameter_value nios2_1 {resetrequest_enabled} {1}
	set_instance_parameter_value nios2_1 {setting_HBreakTest} {0}
	set_instance_parameter_value nios2_1 {setting_HDLSimCachesCleared} {1}
	set_instance_parameter_value nios2_1 {setting_activateMonitors} {1}
	set_instance_parameter_value nios2_1 {setting_activateTestEndChecker} {0}
	set_instance_parameter_value nios2_1 {setting_activateTrace} {0}
	set_instance_parameter_value nios2_1 {setting_allow_break_inst} {0}
	set_instance_parameter_value nios2_1 {setting_alwaysEncrypt} {1}
	set_instance_parameter_value nios2_1 {setting_asic_add_scan_mode_input} {0}
	set_instance_parameter_value nios2_1 {setting_asic_enabled} {0}
	set_instance_parameter_value nios2_1 {setting_asic_synopsys_translate_on_off} {0}
	set_instance_parameter_value nios2_1 {setting_asic_third_party_synthesis} {0}
	set_instance_parameter_value nios2_1 {setting_avalonDebugPortPresent} {0}
	set_instance_parameter_value nios2_1 {setting_bhtPtrSz} {8}
	set_instance_parameter_value nios2_1 {setting_bigEndian} {0}
	set_instance_parameter_value nios2_1 {setting_branchpredictiontype} {Dynamic}
	set_instance_parameter_value nios2_1 {setting_breakslaveoveride} {0}
	set_instance_parameter_value nios2_1 {setting_clearXBitsLDNonBypass} {1}
	set_instance_parameter_value nios2_1 {setting_dc_ecc_present} {1}
	set_instance_parameter_value nios2_1 {setting_disable_tmr_inj} {0}
	set_instance_parameter_value nios2_1 {setting_disableocitrace} {0}
	set_instance_parameter_value nios2_1 {setting_dtcm_ecc_present} {1}
	set_instance_parameter_value nios2_1 {setting_ecc_present} {0}
	set_instance_parameter_value nios2_1 {setting_ecc_sim_test_ports} {0}
	set_instance_parameter_value nios2_1 {setting_exportHostDebugPort} {0}
	set_instance_parameter_value nios2_1 {setting_exportPCB} {0}
	set_instance_parameter_value nios2_1 {setting_export_large_RAMs} {0}
	set_instance_parameter_value nios2_1 {setting_exportdebuginfo} {0}
	set_instance_parameter_value nios2_1 {setting_exportvectors} {0}
	set_instance_parameter_value nios2_1 {setting_fast_register_read} {0}
	set_instance_parameter_value nios2_1 {setting_ic_ecc_present} {1}
	set_instance_parameter_value nios2_1 {setting_interruptControllerType} {Internal}
	set_instance_parameter_value nios2_1 {setting_itcm_ecc_present} {1}
	set_instance_parameter_value nios2_1 {setting_mmu_ecc_present} {1}
	set_instance_parameter_value nios2_1 {setting_oci_export_jtag_signals} {0}
	set_instance_parameter_value nios2_1 {setting_oci_version} {1}
	set_instance_parameter_value nios2_1 {setting_preciseIllegalMemAccessException} {0}
	set_instance_parameter_value nios2_1 {setting_removeRAMinit} {0}
	set_instance_parameter_value nios2_1 {setting_rf_ecc_present} {1}
	set_instance_parameter_value nios2_1 {setting_shadowRegisterSets} {0}
	set_instance_parameter_value nios2_1 {setting_showInternalSettings} {0}
	set_instance_parameter_value nios2_1 {setting_showUnpublishedSettings} {0}
	set_instance_parameter_value nios2_1 {setting_support31bitdcachebypass} {1}
	set_instance_parameter_value nios2_1 {setting_tmr_output_disable} {0}
	set_instance_parameter_value nios2_1 {setting_usedesignware} {0}
	set_instance_parameter_value nios2_1 {shift_rot_impl} {1}
	set_instance_parameter_value nios2_1 {tightly_coupled_data_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_1 {tightly_coupled_data_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {tightly_coupled_data_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_1 {tightly_coupled_data_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {tightly_coupled_data_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_1 {tightly_coupled_data_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {tightly_coupled_data_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_1 {tightly_coupled_data_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {tightly_coupled_instruction_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_1 {tightly_coupled_instruction_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {tightly_coupled_instruction_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_1 {tightly_coupled_instruction_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {tightly_coupled_instruction_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_1 {tightly_coupled_instruction_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {tightly_coupled_instruction_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_1 {tightly_coupled_instruction_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_1 {tmr_enabled} {0}
	set_instance_parameter_value nios2_1 {tracefilename} {}
	set_instance_parameter_value nios2_1 {userDefinedSettings} {}

	


	add_instance nios2_2 altera_nios2_gen2 17.1
	set_instance_parameter_value nios2_2 {bht_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_2 {breakOffset} {32}
	set_instance_parameter_value nios2_2 {breakSlave} {None}
	set_instance_parameter_value nios2_2 {cdx_enabled} {0}
	set_instance_parameter_value nios2_2 {cpuArchRev} {1}
	set_instance_parameter_value nios2_2 {cpuID} {0}
	set_instance_parameter_value nios2_2 {cpuReset} {0}
	set_instance_parameter_value nios2_2 {data_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_2 {data_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {data_master_paddr_base} {0}
	set_instance_parameter_value nios2_2 {data_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {dcache_bursts} {false}
	set_instance_parameter_value nios2_2 {dcache_numTCDM} {0}
	set_instance_parameter_value nios2_2 {dcache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_2 {dcache_size} {2048}
	set_instance_parameter_value nios2_2 {dcache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_2 {dcache_victim_buf_impl} {ram}
	set_instance_parameter_value nios2_2 {debug_OCIOnchipTrace} {_128}
	set_instance_parameter_value nios2_2 {debug_assignJtagInstanceID} {0}
	set_instance_parameter_value nios2_2 {debug_datatrigger} {0}
	set_instance_parameter_value nios2_2 {debug_debugReqSignals} {0}
	set_instance_parameter_value nios2_2 {debug_enabled} {1}
	set_instance_parameter_value nios2_2 {debug_hwbreakpoint} {0}
	set_instance_parameter_value nios2_2 {debug_jtagInstanceID} {0}
	set_instance_parameter_value nios2_2 {debug_traceStorage} {onchip_trace}
	set_instance_parameter_value nios2_2 {debug_traceType} {none}
	set_instance_parameter_value nios2_2 {debug_triggerArming} {1}
	set_instance_parameter_value nios2_2 {dividerType} {no_div}
	set_instance_parameter_value nios2_2 {exceptionOffset} {32}
	set_instance_parameter_value nios2_2 {exceptionSlave} {data_mem_2.s1}
	set_instance_parameter_value nios2_2 {fa_cache_line} {2}
	set_instance_parameter_value nios2_2 {fa_cache_linesize} {0}
	set_instance_parameter_value nios2_2 {flash_instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_2 {flash_instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {icache_burstType} {None}
	set_instance_parameter_value nios2_2 {icache_numTCIM} {0}
	set_instance_parameter_value nios2_2 {icache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_2 {icache_size} {4096}
	set_instance_parameter_value nios2_2 {icache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_2 {impl} {Tiny}
	set_instance_parameter_value nios2_2 {instruction_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_2 {instruction_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_2 {instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {io_regionbase} {0}
	set_instance_parameter_value nios2_2 {io_regionsize} {0}
	set_instance_parameter_value nios2_2 {master_addr_map} {0}
	set_instance_parameter_value nios2_2 {mmu_TLBMissExcOffset} {0}
	set_instance_parameter_value nios2_2 {mmu_TLBMissExcSlave} {None}
	set_instance_parameter_value nios2_2 {mmu_autoAssignTlbPtrSz} {1}
	set_instance_parameter_value nios2_2 {mmu_enabled} {0}
	set_instance_parameter_value nios2_2 {mmu_processIDNumBits} {8}
	set_instance_parameter_value nios2_2 {mmu_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_2 {mmu_tlbNumWays} {16}
	set_instance_parameter_value nios2_2 {mmu_tlbPtrSz} {7}
	set_instance_parameter_value nios2_2 {mmu_udtlbNumEntries} {6}
	set_instance_parameter_value nios2_2 {mmu_uitlbNumEntries} {4}
	set_instance_parameter_value nios2_2 {mpu_enabled} {0}
	set_instance_parameter_value nios2_2 {mpu_minDataRegionSize} {12}
	set_instance_parameter_value nios2_2 {mpu_minInstRegionSize} {12}
	set_instance_parameter_value nios2_2 {mpu_numOfDataRegion} {8}
	set_instance_parameter_value nios2_2 {mpu_numOfInstRegion} {8}
	set_instance_parameter_value nios2_2 {mpu_useLimit} {0}
	set_instance_parameter_value nios2_2 {mpx_enabled} {0}
	set_instance_parameter_value nios2_2 {mul_32_impl} {2}
	set_instance_parameter_value nios2_2 {mul_64_impl} {0}
	set_instance_parameter_value nios2_2 {mul_shift_choice} {0}
	set_instance_parameter_value nios2_2 {ocimem_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_2 {ocimem_ramInit} {0}
	set_instance_parameter_value nios2_2 {regfile_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_2 {register_file_por} {0}
	set_instance_parameter_value nios2_2 {resetOffset} {0}
	set_instance_parameter_value nios2_2 {resetSlave} {data_mem_2.s1}
	set_instance_parameter_value nios2_2 {resetrequest_enabled} {1}
	set_instance_parameter_value nios2_2 {setting_HBreakTest} {0}
	set_instance_parameter_value nios2_2 {setting_HDLSimCachesCleared} {1}
	set_instance_parameter_value nios2_2 {setting_activateMonitors} {1}
	set_instance_parameter_value nios2_2 {setting_activateTestEndChecker} {0}
	set_instance_parameter_value nios2_2 {setting_activateTrace} {0}
	set_instance_parameter_value nios2_2 {setting_allow_break_inst} {0}
	set_instance_parameter_value nios2_2 {setting_alwaysEncrypt} {1}
	set_instance_parameter_value nios2_2 {setting_asic_add_scan_mode_input} {0}
	set_instance_parameter_value nios2_2 {setting_asic_enabled} {0}
	set_instance_parameter_value nios2_2 {setting_asic_synopsys_translate_on_off} {0}
	set_instance_parameter_value nios2_2 {setting_asic_third_party_synthesis} {0}
	set_instance_parameter_value nios2_2 {setting_avalonDebugPortPresent} {0}
	set_instance_parameter_value nios2_2 {setting_bhtPtrSz} {8}
	set_instance_parameter_value nios2_2 {setting_bigEndian} {0}
	set_instance_parameter_value nios2_2 {setting_branchpredictiontype} {Dynamic}
	set_instance_parameter_value nios2_2 {setting_breakslaveoveride} {0}
	set_instance_parameter_value nios2_2 {setting_clearXBitsLDNonBypass} {1}
	set_instance_parameter_value nios2_2 {setting_dc_ecc_present} {1}
	set_instance_parameter_value nios2_2 {setting_disable_tmr_inj} {0}
	set_instance_parameter_value nios2_2 {setting_disableocitrace} {0}
	set_instance_parameter_value nios2_2 {setting_dtcm_ecc_present} {1}
	set_instance_parameter_value nios2_2 {setting_ecc_present} {0}
	set_instance_parameter_value nios2_2 {setting_ecc_sim_test_ports} {0}
	set_instance_parameter_value nios2_2 {setting_exportHostDebugPort} {0}
	set_instance_parameter_value nios2_2 {setting_exportPCB} {0}
	set_instance_parameter_value nios2_2 {setting_export_large_RAMs} {0}
	set_instance_parameter_value nios2_2 {setting_exportdebuginfo} {0}
	set_instance_parameter_value nios2_2 {setting_exportvectors} {0}
	set_instance_parameter_value nios2_2 {setting_fast_register_read} {0}
	set_instance_parameter_value nios2_2 {setting_ic_ecc_present} {1}
	set_instance_parameter_value nios2_2 {setting_interruptControllerType} {Internal}
	set_instance_parameter_value nios2_2 {setting_itcm_ecc_present} {1}
	set_instance_parameter_value nios2_2 {setting_mmu_ecc_present} {1}
	set_instance_parameter_value nios2_2 {setting_oci_export_jtag_signals} {0}
	set_instance_parameter_value nios2_2 {setting_oci_version} {1}
	set_instance_parameter_value nios2_2 {setting_preciseIllegalMemAccessException} {0}
	set_instance_parameter_value nios2_2 {setting_removeRAMinit} {0}
	set_instance_parameter_value nios2_2 {setting_rf_ecc_present} {1}
	set_instance_parameter_value nios2_2 {setting_shadowRegisterSets} {0}
	set_instance_parameter_value nios2_2 {setting_showInternalSettings} {0}
	set_instance_parameter_value nios2_2 {setting_showUnpublishedSettings} {0}
	set_instance_parameter_value nios2_2 {setting_support31bitdcachebypass} {1}
	set_instance_parameter_value nios2_2 {setting_tmr_output_disable} {0}
	set_instance_parameter_value nios2_2 {setting_usedesignware} {0}
	set_instance_parameter_value nios2_2 {shift_rot_impl} {1}
	set_instance_parameter_value nios2_2 {tightly_coupled_data_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_2 {tightly_coupled_data_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {tightly_coupled_data_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_2 {tightly_coupled_data_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {tightly_coupled_data_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_2 {tightly_coupled_data_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {tightly_coupled_data_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_2 {tightly_coupled_data_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {tightly_coupled_instruction_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_2 {tightly_coupled_instruction_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {tightly_coupled_instruction_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_2 {tightly_coupled_instruction_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {tightly_coupled_instruction_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_2 {tightly_coupled_instruction_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {tightly_coupled_instruction_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_2 {tightly_coupled_instruction_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_2 {tmr_enabled} {0}
	set_instance_parameter_value nios2_2 {tracefilename} {}
	set_instance_parameter_value nios2_2 {userDefinedSettings} {}

	


	add_instance nios2_3 altera_nios2_gen2 17.1
	set_instance_parameter_value nios2_3 {bht_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_3 {breakOffset} {32}
	set_instance_parameter_value nios2_3 {breakSlave} {None}
	set_instance_parameter_value nios2_3 {cdx_enabled} {0}
	set_instance_parameter_value nios2_3 {cpuArchRev} {1}
	set_instance_parameter_value nios2_3 {cpuID} {0}
	set_instance_parameter_value nios2_3 {cpuReset} {0}
	set_instance_parameter_value nios2_3 {data_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_3 {data_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {data_master_paddr_base} {0}
	set_instance_parameter_value nios2_3 {data_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {dcache_bursts} {false}
	set_instance_parameter_value nios2_3 {dcache_numTCDM} {0}
	set_instance_parameter_value nios2_3 {dcache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_3 {dcache_size} {2048}
	set_instance_parameter_value nios2_3 {dcache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_3 {dcache_victim_buf_impl} {ram}
	set_instance_parameter_value nios2_3 {debug_OCIOnchipTrace} {_128}
	set_instance_parameter_value nios2_3 {debug_assignJtagInstanceID} {0}
	set_instance_parameter_value nios2_3 {debug_datatrigger} {0}
	set_instance_parameter_value nios2_3 {debug_debugReqSignals} {0}
	set_instance_parameter_value nios2_3 {debug_enabled} {1}
	set_instance_parameter_value nios2_3 {debug_hwbreakpoint} {0}
	set_instance_parameter_value nios2_3 {debug_jtagInstanceID} {0}
	set_instance_parameter_value nios2_3 {debug_traceStorage} {onchip_trace}
	set_instance_parameter_value nios2_3 {debug_traceType} {none}
	set_instance_parameter_value nios2_3 {debug_triggerArming} {1}
	set_instance_parameter_value nios2_3 {dividerType} {no_div}
	set_instance_parameter_value nios2_3 {exceptionOffset} {32}
	set_instance_parameter_value nios2_3 {exceptionSlave} {data_mem_3.s1}
	set_instance_parameter_value nios2_3 {fa_cache_line} {2}
	set_instance_parameter_value nios2_3 {fa_cache_linesize} {0}
	set_instance_parameter_value nios2_3 {flash_instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_3 {flash_instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {icache_burstType} {None}
	set_instance_parameter_value nios2_3 {icache_numTCIM} {0}
	set_instance_parameter_value nios2_3 {icache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_3 {icache_size} {4096}
	set_instance_parameter_value nios2_3 {icache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_3 {impl} {Tiny}
	set_instance_parameter_value nios2_3 {instruction_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_3 {instruction_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_3 {instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {io_regionbase} {0}
	set_instance_parameter_value nios2_3 {io_regionsize} {0}
	set_instance_parameter_value nios2_3 {master_addr_map} {0}
	set_instance_parameter_value nios2_3 {mmu_TLBMissExcOffset} {0}
	set_instance_parameter_value nios2_3 {mmu_TLBMissExcSlave} {None}
	set_instance_parameter_value nios2_3 {mmu_autoAssignTlbPtrSz} {1}
	set_instance_parameter_value nios2_3 {mmu_enabled} {0}
	set_instance_parameter_value nios2_3 {mmu_processIDNumBits} {8}
	set_instance_parameter_value nios2_3 {mmu_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_3 {mmu_tlbNumWays} {16}
	set_instance_parameter_value nios2_3 {mmu_tlbPtrSz} {7}
	set_instance_parameter_value nios2_3 {mmu_udtlbNumEntries} {6}
	set_instance_parameter_value nios2_3 {mmu_uitlbNumEntries} {4}
	set_instance_parameter_value nios2_3 {mpu_enabled} {0}
	set_instance_parameter_value nios2_3 {mpu_minDataRegionSize} {12}
	set_instance_parameter_value nios2_3 {mpu_minInstRegionSize} {12}
	set_instance_parameter_value nios2_3 {mpu_numOfDataRegion} {8}
	set_instance_parameter_value nios2_3 {mpu_numOfInstRegion} {8}
	set_instance_parameter_value nios2_3 {mpu_useLimit} {0}
	set_instance_parameter_value nios2_3 {mpx_enabled} {0}
	set_instance_parameter_value nios2_3 {mul_32_impl} {2}
	set_instance_parameter_value nios2_3 {mul_64_impl} {0}
	set_instance_parameter_value nios2_3 {mul_shift_choice} {0}
	set_instance_parameter_value nios2_3 {ocimem_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_3 {ocimem_ramInit} {0}
	set_instance_parameter_value nios2_3 {regfile_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_3 {register_file_por} {0}
	set_instance_parameter_value nios2_3 {resetOffset} {0}
	set_instance_parameter_value nios2_3 {resetSlave} {data_mem_3.s1}
	set_instance_parameter_value nios2_3 {resetrequest_enabled} {1}
	set_instance_parameter_value nios2_3 {setting_HBreakTest} {0}
	set_instance_parameter_value nios2_3 {setting_HDLSimCachesCleared} {1}
	set_instance_parameter_value nios2_3 {setting_activateMonitors} {1}
	set_instance_parameter_value nios2_3 {setting_activateTestEndChecker} {0}
	set_instance_parameter_value nios2_3 {setting_activateTrace} {0}
	set_instance_parameter_value nios2_3 {setting_allow_break_inst} {0}
	set_instance_parameter_value nios2_3 {setting_alwaysEncrypt} {1}
	set_instance_parameter_value nios2_3 {setting_asic_add_scan_mode_input} {0}
	set_instance_parameter_value nios2_3 {setting_asic_enabled} {0}
	set_instance_parameter_value nios2_3 {setting_asic_synopsys_translate_on_off} {0}
	set_instance_parameter_value nios2_3 {setting_asic_third_party_synthesis} {0}
	set_instance_parameter_value nios2_3 {setting_avalonDebugPortPresent} {0}
	set_instance_parameter_value nios2_3 {setting_bhtPtrSz} {8}
	set_instance_parameter_value nios2_3 {setting_bigEndian} {0}
	set_instance_parameter_value nios2_3 {setting_branchpredictiontype} {Dynamic}
	set_instance_parameter_value nios2_3 {setting_breakslaveoveride} {0}
	set_instance_parameter_value nios2_3 {setting_clearXBitsLDNonBypass} {1}
	set_instance_parameter_value nios2_3 {setting_dc_ecc_present} {1}
	set_instance_parameter_value nios2_3 {setting_disable_tmr_inj} {0}
	set_instance_parameter_value nios2_3 {setting_disableocitrace} {0}
	set_instance_parameter_value nios2_3 {setting_dtcm_ecc_present} {1}
	set_instance_parameter_value nios2_3 {setting_ecc_present} {0}
	set_instance_parameter_value nios2_3 {setting_ecc_sim_test_ports} {0}
	set_instance_parameter_value nios2_3 {setting_exportHostDebugPort} {0}
	set_instance_parameter_value nios2_3 {setting_exportPCB} {0}
	set_instance_parameter_value nios2_3 {setting_export_large_RAMs} {0}
	set_instance_parameter_value nios2_3 {setting_exportdebuginfo} {0}
	set_instance_parameter_value nios2_3 {setting_exportvectors} {0}
	set_instance_parameter_value nios2_3 {setting_fast_register_read} {0}
	set_instance_parameter_value nios2_3 {setting_ic_ecc_present} {1}
	set_instance_parameter_value nios2_3 {setting_interruptControllerType} {Internal}
	set_instance_parameter_value nios2_3 {setting_itcm_ecc_present} {1}
	set_instance_parameter_value nios2_3 {setting_mmu_ecc_present} {1}
	set_instance_parameter_value nios2_3 {setting_oci_export_jtag_signals} {0}
	set_instance_parameter_value nios2_3 {setting_oci_version} {1}
	set_instance_parameter_value nios2_3 {setting_preciseIllegalMemAccessException} {0}
	set_instance_parameter_value nios2_3 {setting_removeRAMinit} {0}
	set_instance_parameter_value nios2_3 {setting_rf_ecc_present} {1}
	set_instance_parameter_value nios2_3 {setting_shadowRegisterSets} {0}
	set_instance_parameter_value nios2_3 {setting_showInternalSettings} {0}
	set_instance_parameter_value nios2_3 {setting_showUnpublishedSettings} {0}
	set_instance_parameter_value nios2_3 {setting_support31bitdcachebypass} {1}
	set_instance_parameter_value nios2_3 {setting_tmr_output_disable} {0}
	set_instance_parameter_value nios2_3 {setting_usedesignware} {0}
	set_instance_parameter_value nios2_3 {shift_rot_impl} {1}
	set_instance_parameter_value nios2_3 {tightly_coupled_data_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_3 {tightly_coupled_data_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {tightly_coupled_data_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_3 {tightly_coupled_data_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {tightly_coupled_data_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_3 {tightly_coupled_data_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {tightly_coupled_data_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_3 {tightly_coupled_data_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {tightly_coupled_instruction_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_3 {tightly_coupled_instruction_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {tightly_coupled_instruction_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_3 {tightly_coupled_instruction_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {tightly_coupled_instruction_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_3 {tightly_coupled_instruction_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {tightly_coupled_instruction_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_3 {tightly_coupled_instruction_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_3 {tmr_enabled} {0}
	set_instance_parameter_value nios2_3 {tracefilename} {}
	set_instance_parameter_value nios2_3 {userDefinedSettings} {}

	
	

# Connections
# -----------
	
	add_connection NoC.source_0 fifo_sink_0.in avalon_streaming
	
	add_connection NoC.source_1 fifo_sink_1.in avalon_streaming
	
	add_connection NoC.source_2 fifo_sink_2.in avalon_streaming
	
	add_connection NoC.source_3 fifo_sink_3.in avalon_streaming
	
	add_connection clk_0.clk NoC.clock clock

	
	add_connection clk_0.clk data_mem_0.clk1 clock
	
	add_connection clk_0.clk data_mem_1.clk1 clock
	
	add_connection clk_0.clk data_mem_2.clk1 clock
	
	add_connection clk_0.clk data_mem_3.clk1 clock
	
	
	add_connection clk_0.clk fifo_sink_0.clk_in clock
	
	add_connection clk_0.clk fifo_sink_1.clk_in clock
	
	add_connection clk_0.clk fifo_sink_2.clk_in clock
	
	add_connection clk_0.clk fifo_sink_3.clk_in clock
		
	
	add_connection clk_0.clk fifo_source_0.clk_in clock
	
	add_connection clk_0.clk fifo_source_1.clk_in clock
	
	add_connection clk_0.clk fifo_source_2.clk_in clock
	
	add_connection clk_0.clk fifo_source_3.clk_in clock
	
	add_connection clk_0.clk jtag_uart_0.clk clock

	
	add_connection clk_0.clk nios2_0.clk clock
	
	add_connection clk_0.clk nios2_1.clk clock
	
	add_connection clk_0.clk nios2_2.clk clock
	
	add_connection clk_0.clk nios2_3.clk clock
	
	add_connection clk_0.clk_reset NoC.reset reset

	
	add_connection clk_0.clk_reset data_mem_0.reset1 reset
	
	add_connection clk_0.clk_reset data_mem_1.reset1 reset
	
	add_connection clk_0.clk_reset data_mem_2.reset1 reset
	
	add_connection clk_0.clk_reset data_mem_3.reset1 reset
	
	
	add_connection clk_0.clk_reset fifo_sink_0.reset_in reset
	
	add_connection clk_0.clk_reset fifo_sink_1.reset_in reset
	
	add_connection clk_0.clk_reset fifo_sink_2.reset_in reset
	
	add_connection clk_0.clk_reset fifo_sink_3.reset_in reset
	
	
	add_connection clk_0.clk_reset fifo_source_0.reset_in reset
	
	add_connection clk_0.clk_reset fifo_source_1.reset_in reset
	
	add_connection clk_0.clk_reset fifo_source_2.reset_in reset
	
	add_connection clk_0.clk_reset fifo_source_3.reset_in reset
	
	add_connection clk_0.clk_reset jtag_uart_0.reset reset

	
	add_connection clk_0.clk_reset nios2_0.reset reset
	
	add_connection clk_0.clk_reset nios2_1.reset reset
	
	add_connection clk_0.clk_reset nios2_2.reset reset
	
	add_connection clk_0.clk_reset nios2_3.reset reset
	
	
	add_connection fifo_source_0.out NoC.sink_0 avalon_streaming
	
	add_connection fifo_source_1.out NoC.sink_1 avalon_streaming
	
	add_connection fifo_source_2.out NoC.sink_2 avalon_streaming
	
	add_connection fifo_source_3.out NoC.sink_3 avalon_streaming
		

	
	add_connection nios2_0.data_master data_mem_0.s1 avalon
	set_connection_parameter_value nios2_0.data_master/data_mem_0.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_0.data_master/data_mem_0.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_0.data_master/data_mem_0.s1 defaultConnection {0}

	add_connection nios2_0.data_master fifo_sink_0.in_csr avalon
	set_connection_parameter_value nios2_0.data_master/fifo_sink_0.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_0.data_master/fifo_sink_0.in_csr baseAddress {0x9020}
	set_connection_parameter_value nios2_0.data_master/fifo_sink_0.in_csr defaultConnection {0}

	add_connection nios2_0.data_master fifo_sink_0.out avalon
	set_connection_parameter_value nios2_0.data_master/fifo_sink_0.out arbitrationPriority {1}
	set_connection_parameter_value nios2_0.data_master/fifo_sink_0.out baseAddress {0x9040}
	set_connection_parameter_value nios2_0.data_master/fifo_sink_0.out defaultConnection {0}

	add_connection nios2_0.data_master fifo_source_0.in avalon
	set_connection_parameter_value nios2_0.data_master/fifo_source_0.in arbitrationPriority {1}
	set_connection_parameter_value nios2_0.data_master/fifo_source_0.in baseAddress {0x9048}
	set_connection_parameter_value nios2_0.data_master/fifo_source_0.in defaultConnection {0}

	add_connection nios2_0.data_master fifo_source_0.in_csr avalon
	set_connection_parameter_value nios2_0.data_master/fifo_source_0.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_0.data_master/fifo_source_0.in_csr baseAddress {0x9000}
	set_connection_parameter_value nios2_0.data_master/fifo_source_0.in_csr defaultConnection {0}

	add_connection nios2_0.data_master jtag_uart_0.avalon_jtag_slave avalon
	set_connection_parameter_value nios2_0.data_master/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_0.data_master/jtag_uart_0.avalon_jtag_slave baseAddress {0x9050}
	set_connection_parameter_value nios2_0.data_master/jtag_uart_0.avalon_jtag_slave defaultConnection {0}

	add_connection nios2_0.data_master nios2_0.debug_mem_slave avalon
	set_connection_parameter_value nios2_0.data_master/nios2_0.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_0.data_master/nios2_0.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_0.data_master/nios2_0.debug_mem_slave defaultConnection {0}

	add_connection nios2_0.debug_reset_request clk_0.clk_in_reset reset

	add_connection nios2_0.instruction_master data_mem_0.s1 avalon
	set_connection_parameter_value nios2_0.instruction_master/data_mem_0.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_0.instruction_master/data_mem_0.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_0.instruction_master/data_mem_0.s1 defaultConnection {0}

	add_connection nios2_0.instruction_master nios2_0.debug_mem_slave avalon
	set_connection_parameter_value nios2_0.instruction_master/nios2_0.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_0.instruction_master/nios2_0.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_0.instruction_master/nios2_0.debug_mem_slave defaultConnection {0}

	add_connection nios2_0.irq fifo_sink_0.in_irq interrupt
	set_connection_parameter_value nios2_0.irq/fifo_sink_0.in_irq irqNumber {0}

	add_connection nios2_0.irq fifo_source_0.in_irq interrupt
	set_connection_parameter_value nios2_0.irq/fifo_source_0.in_irq irqNumber {1}

	add_connection nios2_0.irq jtag_uart_0.irq interrupt
	set_connection_parameter_value nios2_0.irq/jtag_uart_0.irq irqNumber {2}

	
	add_connection nios2_1.data_master data_mem_1.s1 avalon
	set_connection_parameter_value nios2_1.data_master/data_mem_1.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_1.data_master/data_mem_1.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_1.data_master/data_mem_1.s1 defaultConnection {0}

	add_connection nios2_1.data_master fifo_sink_1.in_csr avalon
	set_connection_parameter_value nios2_1.data_master/fifo_sink_1.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_1.data_master/fifo_sink_1.in_csr baseAddress {0x9020}
	set_connection_parameter_value nios2_1.data_master/fifo_sink_1.in_csr defaultConnection {0}

	add_connection nios2_1.data_master fifo_sink_1.out avalon
	set_connection_parameter_value nios2_1.data_master/fifo_sink_1.out arbitrationPriority {1}
	set_connection_parameter_value nios2_1.data_master/fifo_sink_1.out baseAddress {0x9040}
	set_connection_parameter_value nios2_1.data_master/fifo_sink_1.out defaultConnection {0}

	add_connection nios2_1.data_master fifo_source_1.in avalon
	set_connection_parameter_value nios2_1.data_master/fifo_source_1.in arbitrationPriority {1}
	set_connection_parameter_value nios2_1.data_master/fifo_source_1.in baseAddress {0x9048}
	set_connection_parameter_value nios2_1.data_master/fifo_source_1.in defaultConnection {0}

	add_connection nios2_1.data_master fifo_source_1.in_csr avalon
	set_connection_parameter_value nios2_1.data_master/fifo_source_1.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_1.data_master/fifo_source_1.in_csr baseAddress {0x9000}
	set_connection_parameter_value nios2_1.data_master/fifo_source_1.in_csr defaultConnection {0}

	add_connection nios2_1.data_master jtag_uart_0.avalon_jtag_slave avalon
	set_connection_parameter_value nios2_1.data_master/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_1.data_master/jtag_uart_0.avalon_jtag_slave baseAddress {0x9050}
	set_connection_parameter_value nios2_1.data_master/jtag_uart_0.avalon_jtag_slave defaultConnection {0}

	add_connection nios2_1.data_master nios2_1.debug_mem_slave avalon
	set_connection_parameter_value nios2_1.data_master/nios2_1.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_1.data_master/nios2_1.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_1.data_master/nios2_1.debug_mem_slave defaultConnection {0}

	add_connection nios2_1.debug_reset_request clk_0.clk_in_reset reset

	add_connection nios2_1.instruction_master data_mem_1.s1 avalon
	set_connection_parameter_value nios2_1.instruction_master/data_mem_1.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_1.instruction_master/data_mem_1.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_1.instruction_master/data_mem_1.s1 defaultConnection {0}

	add_connection nios2_1.instruction_master nios2_1.debug_mem_slave avalon
	set_connection_parameter_value nios2_1.instruction_master/nios2_1.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_1.instruction_master/nios2_1.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_1.instruction_master/nios2_1.debug_mem_slave defaultConnection {0}

	add_connection nios2_1.irq fifo_sink_1.in_irq interrupt
	set_connection_parameter_value nios2_1.irq/fifo_sink_1.in_irq irqNumber {0}

	add_connection nios2_1.irq fifo_source_1.in_irq interrupt
	set_connection_parameter_value nios2_1.irq/fifo_source_1.in_irq irqNumber {1}

	add_connection nios2_1.irq jtag_uart_0.irq interrupt
	set_connection_parameter_value nios2_1.irq/jtag_uart_0.irq irqNumber {2}

	
	add_connection nios2_2.data_master data_mem_2.s1 avalon
	set_connection_parameter_value nios2_2.data_master/data_mem_2.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_2.data_master/data_mem_2.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_2.data_master/data_mem_2.s1 defaultConnection {0}

	add_connection nios2_2.data_master fifo_sink_2.in_csr avalon
	set_connection_parameter_value nios2_2.data_master/fifo_sink_2.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_2.data_master/fifo_sink_2.in_csr baseAddress {0x9020}
	set_connection_parameter_value nios2_2.data_master/fifo_sink_2.in_csr defaultConnection {0}

	add_connection nios2_2.data_master fifo_sink_2.out avalon
	set_connection_parameter_value nios2_2.data_master/fifo_sink_2.out arbitrationPriority {1}
	set_connection_parameter_value nios2_2.data_master/fifo_sink_2.out baseAddress {0x9040}
	set_connection_parameter_value nios2_2.data_master/fifo_sink_2.out defaultConnection {0}

	add_connection nios2_2.data_master fifo_source_2.in avalon
	set_connection_parameter_value nios2_2.data_master/fifo_source_2.in arbitrationPriority {1}
	set_connection_parameter_value nios2_2.data_master/fifo_source_2.in baseAddress {0x9048}
	set_connection_parameter_value nios2_2.data_master/fifo_source_2.in defaultConnection {0}

	add_connection nios2_2.data_master fifo_source_2.in_csr avalon
	set_connection_parameter_value nios2_2.data_master/fifo_source_2.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_2.data_master/fifo_source_2.in_csr baseAddress {0x9000}
	set_connection_parameter_value nios2_2.data_master/fifo_source_2.in_csr defaultConnection {0}

	add_connection nios2_2.data_master jtag_uart_0.avalon_jtag_slave avalon
	set_connection_parameter_value nios2_2.data_master/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_2.data_master/jtag_uart_0.avalon_jtag_slave baseAddress {0x9050}
	set_connection_parameter_value nios2_2.data_master/jtag_uart_0.avalon_jtag_slave defaultConnection {0}

	add_connection nios2_2.data_master nios2_2.debug_mem_slave avalon
	set_connection_parameter_value nios2_2.data_master/nios2_2.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_2.data_master/nios2_2.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_2.data_master/nios2_2.debug_mem_slave defaultConnection {0}

	add_connection nios2_2.debug_reset_request clk_0.clk_in_reset reset

	add_connection nios2_2.instruction_master data_mem_2.s1 avalon
	set_connection_parameter_value nios2_2.instruction_master/data_mem_2.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_2.instruction_master/data_mem_2.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_2.instruction_master/data_mem_2.s1 defaultConnection {0}

	add_connection nios2_2.instruction_master nios2_2.debug_mem_slave avalon
	set_connection_parameter_value nios2_2.instruction_master/nios2_2.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_2.instruction_master/nios2_2.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_2.instruction_master/nios2_2.debug_mem_slave defaultConnection {0}

	add_connection nios2_2.irq fifo_sink_2.in_irq interrupt
	set_connection_parameter_value nios2_2.irq/fifo_sink_2.in_irq irqNumber {0}

	add_connection nios2_2.irq fifo_source_2.in_irq interrupt
	set_connection_parameter_value nios2_2.irq/fifo_source_2.in_irq irqNumber {1}

	add_connection nios2_2.irq jtag_uart_0.irq interrupt
	set_connection_parameter_value nios2_2.irq/jtag_uart_0.irq irqNumber {2}

	
	add_connection nios2_3.data_master data_mem_3.s1 avalon
	set_connection_parameter_value nios2_3.data_master/data_mem_3.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_3.data_master/data_mem_3.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_3.data_master/data_mem_3.s1 defaultConnection {0}

	add_connection nios2_3.data_master fifo_sink_3.in_csr avalon
	set_connection_parameter_value nios2_3.data_master/fifo_sink_3.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_3.data_master/fifo_sink_3.in_csr baseAddress {0x9020}
	set_connection_parameter_value nios2_3.data_master/fifo_sink_3.in_csr defaultConnection {0}

	add_connection nios2_3.data_master fifo_sink_3.out avalon
	set_connection_parameter_value nios2_3.data_master/fifo_sink_3.out arbitrationPriority {1}
	set_connection_parameter_value nios2_3.data_master/fifo_sink_3.out baseAddress {0x9040}
	set_connection_parameter_value nios2_3.data_master/fifo_sink_3.out defaultConnection {0}

	add_connection nios2_3.data_master fifo_source_3.in avalon
	set_connection_parameter_value nios2_3.data_master/fifo_source_3.in arbitrationPriority {1}
	set_connection_parameter_value nios2_3.data_master/fifo_source_3.in baseAddress {0x9048}
	set_connection_parameter_value nios2_3.data_master/fifo_source_3.in defaultConnection {0}

	add_connection nios2_3.data_master fifo_source_3.in_csr avalon
	set_connection_parameter_value nios2_3.data_master/fifo_source_3.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_3.data_master/fifo_source_3.in_csr baseAddress {0x9000}
	set_connection_parameter_value nios2_3.data_master/fifo_source_3.in_csr defaultConnection {0}

	add_connection nios2_3.data_master jtag_uart_0.avalon_jtag_slave avalon
	set_connection_parameter_value nios2_3.data_master/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_3.data_master/jtag_uart_0.avalon_jtag_slave baseAddress {0x9050}
	set_connection_parameter_value nios2_3.data_master/jtag_uart_0.avalon_jtag_slave defaultConnection {0}

	add_connection nios2_3.data_master nios2_3.debug_mem_slave avalon
	set_connection_parameter_value nios2_3.data_master/nios2_3.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_3.data_master/nios2_3.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_3.data_master/nios2_3.debug_mem_slave defaultConnection {0}

	add_connection nios2_3.debug_reset_request clk_0.clk_in_reset reset

	add_connection nios2_3.instruction_master data_mem_3.s1 avalon
	set_connection_parameter_value nios2_3.instruction_master/data_mem_3.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_3.instruction_master/data_mem_3.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_3.instruction_master/data_mem_3.s1 defaultConnection {0}

	add_connection nios2_3.instruction_master nios2_3.debug_mem_slave avalon
	set_connection_parameter_value nios2_3.instruction_master/nios2_3.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_3.instruction_master/nios2_3.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_3.instruction_master/nios2_3.debug_mem_slave defaultConnection {0}

	add_connection nios2_3.irq fifo_sink_3.in_irq interrupt
	set_connection_parameter_value nios2_3.irq/fifo_sink_3.in_irq irqNumber {0}

	add_connection nios2_3.irq fifo_source_3.in_irq interrupt
	set_connection_parameter_value nios2_3.irq/fifo_source_3.in_irq irqNumber {1}

	add_connection nios2_3.irq jtag_uart_0.irq interrupt
	set_connection_parameter_value nios2_3.irq/jtag_uart_0.irq irqNumber {2}

	
	
	auto_assign_base_addresses data_mem_0
	
	auto_assign_base_addresses data_mem_1
	
	auto_assign_base_addresses data_mem_2
	
	auto_assign_base_addresses data_mem_3
	
# Exported interfaces
# -------------------
#
# Top-level entity ports
#
	add_interface clk clock sink
	set_interface_property clk EXPORT_OF clk_0.clk_in

# interconnect requirements
    set_interconnect_requirement {$system} {qsys_mm.clockCrossingAdapter} {HANDSHAKE}
    set_interconnect_requirement {$system} {qsys_mm.enableEccProtection} {FALSE}
    set_interconnect_requirement {$system} {qsys_mm.insertDefaultSlave} {FALSE}
    set_interconnect_requirement {$system} {qsys_mm.maxAdditionalLatency} {1}

# Save the system
# ---------------
save_system "qsys_system.qsys"

