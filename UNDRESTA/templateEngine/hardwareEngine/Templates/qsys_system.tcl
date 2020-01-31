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
set_project_property DEVICE_FAMILY {@project_properties.DEVICE_FAMILY}
set_project_property DEVICE {@project_properties.DEVICE}
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
	set_instance_parameter_value NoC {RowNo} {@NoC.RowNo}
	set_instance_parameter_value NoC {ColNo} {@NoC.ColNo}
	set_instance_parameter_value NoC {AddrWidth} {@NoC.AddrWidth}
	set_instance_parameter_value NoC {DataWidth} {@NoC.DataWidth}
	set_instance_parameter_value NoC {PackWidth} {@NoC.PackWidth}
	set_instance_parameter_value NoC {PhyCh} {@NoC.PhyCh}
	set_instance_parameter_value NoC {PhyChAddr} {@NoC.PhyChAddr}
	set_instance_parameter_value NoC {PhyRoCh} {@NoC.PhyRoCh}
	set_instance_parameter_value NoC {PhyRoChAddr} {@NoC.PhyRoChAddr}
	set_instance_parameter_value NoC {RoCh} {@NoC.RoCh}
	set_instance_parameter_value NoC {RoChAddr} {@NoC.RoChAddr}
	set_instance_parameter_value NoC {ViCh} {@NoC.ViCh}
	set_instance_parameter_value NoC {ViChAddr} {@NoC.ViChAddr}

	add_instance clk_0 clock_source 17.1
	set_instance_parameter_value clk_0 {clockFrequency} {50000000.0}
	set_instance_parameter_value clk_0 {clockFrequencyKnown} {1}
	set_instance_parameter_value clk_0 {resetSynchronousEdges} {NONE}


	#for @processor in @processors:

	add_instance data_mem_@processor.number altera_avalon_onchip_memory2 17.1
	set_instance_parameter_value data_mem_@processor.number {allowInSystemMemoryContentEditor} {0}
	set_instance_parameter_value data_mem_@processor.number {blockType} {AUTO}
	set_instance_parameter_value data_mem_@processor.number {copyInitFile} {0}
	set_instance_parameter_value data_mem_@processor.number {dataWidth} {32}
	set_instance_parameter_value data_mem_@processor.number {dataWidth2} {32}
	set_instance_parameter_value data_mem_@processor.number {dualPort} {0}
	set_instance_parameter_value data_mem_@processor.number {ecc_enabled} {0}
	set_instance_parameter_value data_mem_@processor.number {enPRInitMode} {0}
	set_instance_parameter_value data_mem_@processor.number {enableDiffWidth} {0}
	set_instance_parameter_value data_mem_@processor.number {initMemContent} {1}
	set_instance_parameter_value data_mem_@processor.number {initializationFileName} {onchip_mem.hex}
	set_instance_parameter_value data_mem_@processor.number {instanceID} {NONE}
	set_instance_parameter_value data_mem_@processor.number {memorySize} {@processor.memory_size}
	set_instance_parameter_value data_mem_@processor.number {readDuringWriteMode} {DONT_CARE}
	set_instance_parameter_value data_mem_@processor.number {resetrequest_enabled} {1}
	set_instance_parameter_value data_mem_@processor.number {simAllowMRAMContentsFile} {0}
	set_instance_parameter_value data_mem_@processor.number {simMemInitOnlyFilename} {0}
	set_instance_parameter_value data_mem_@processor.number {singleClockOperation} {0}
	set_instance_parameter_value data_mem_@processor.number {slave1Latency} {1}
	set_instance_parameter_value data_mem_@processor.number {slave2Latency} {1}
	set_instance_parameter_value data_mem_@processor.number {useNonDefaultInitFile} {0}
	set_instance_parameter_value data_mem_@processor.number {useShallowMemBlocks} {0}
	set_instance_parameter_value data_mem_@processor.number {writable} {1}

	#end

	#for @tile in @tiles:
	
	add_instance fifo_sink_@tile.number altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_sink_@tile.number {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_sink_@tile.number {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_sink_@tile.number {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_sink_@tile.number {channelWidth} {8}
	set_instance_parameter_value fifo_sink_@tile.number {errorWidth} {8}
	set_instance_parameter_value fifo_sink_@tile.number {fifoDepth} {@tile.fifo_out_depth}
	set_instance_parameter_value fifo_sink_@tile.number {fifoInputInterfaceOptions} {AVALONST_SINK}
	set_instance_parameter_value fifo_sink_@tile.number {fifoOutputInterfaceOptions} {AVALONMM_READ}
	set_instance_parameter_value fifo_sink_@tile.number {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_sink_@tile.number {singleClockMode} {1}
	set_instance_parameter_value fifo_sink_@tile.number {singleResetMode} {0}
	set_instance_parameter_value fifo_sink_@tile.number {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_sink_@tile.number {useBackpressure} {1}
	set_instance_parameter_value fifo_sink_@tile.number {useIRQ} {1}
	set_instance_parameter_value fifo_sink_@tile.number {usePacket} {0}
	set_instance_parameter_value fifo_sink_@tile.number {useReadControl} {0}
	set_instance_parameter_value fifo_sink_@tile.number {useRegister} {0}
	set_instance_parameter_value fifo_sink_@tile.number {useWriteControl} {1}

	#end


	#for @tile in @tiles:

	add_instance fifo_source_@tile.number altera_avalon_fifo 17.1
	set_instance_parameter_value fifo_source_@tile.number {avalonMMAvalonMMDataWidth} {32}
	set_instance_parameter_value fifo_source_@tile.number {avalonMMAvalonSTDataWidth} {32}
	set_instance_parameter_value fifo_source_@tile.number {bitsPerSymbol} {8}
	set_instance_parameter_value fifo_source_@tile.number {channelWidth} {8}
	set_instance_parameter_value fifo_source_@tile.number {errorWidth} {8}
	set_instance_parameter_value fifo_source_@tile.number {fifoDepth} {@tile.fifo_in_depth}
	set_instance_parameter_value fifo_source_@tile.number {fifoInputInterfaceOptions} {AVALONMM_WRITE}
	set_instance_parameter_value fifo_source_@tile.number {fifoOutputInterfaceOptions} {AVALONST_SOURCE}
	set_instance_parameter_value fifo_source_@tile.number {showHiddenFeatures} {0}
	set_instance_parameter_value fifo_source_@tile.number {singleClockMode} {1}
	set_instance_parameter_value fifo_source_@tile.number {singleResetMode} {0}
	set_instance_parameter_value fifo_source_@tile.number {symbolsPerBeat} {4}
	set_instance_parameter_value fifo_source_@tile.number {useBackpressure} {1}
	set_instance_parameter_value fifo_source_@tile.number {useIRQ} {1}
	set_instance_parameter_value fifo_source_@tile.number {usePacket} {0}
	set_instance_parameter_value fifo_source_@tile.number {useReadControl} {0}
	set_instance_parameter_value fifo_source_@tile.number {useRegister} {0}
	set_instance_parameter_value fifo_source_@tile.number {useWriteControl} {1}

	#end

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

	## must be completed......................
	## I have to compare both the economy and fast properties
	## write an if statement to determine whether the NIOS is fast or economy

	#for @processor in @processors:


	add_instance nios2_@processor.number altera_nios2_gen2 17.1
	set_instance_parameter_value nios2_@processor.number {bht_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_@processor.number {breakOffset} {32}
	set_instance_parameter_value nios2_@processor.number {breakSlave} {None}
	set_instance_parameter_value nios2_@processor.number {cdx_enabled} {0}
	set_instance_parameter_value nios2_@processor.number {cpuArchRev} {1}
	set_instance_parameter_value nios2_@processor.number {cpuID} {0}
	set_instance_parameter_value nios2_@processor.number {cpuReset} {0}
	set_instance_parameter_value nios2_@processor.number {data_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {data_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {data_master_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {data_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {dcache_bursts} {false}
	set_instance_parameter_value nios2_@processor.number {dcache_numTCDM} {0}
	set_instance_parameter_value nios2_@processor.number {dcache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_@processor.number {dcache_size} {2048}
	set_instance_parameter_value nios2_@processor.number {dcache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_@processor.number {dcache_victim_buf_impl} {ram}
	set_instance_parameter_value nios2_@processor.number {debug_OCIOnchipTrace} {_128}
	set_instance_parameter_value nios2_@processor.number {debug_assignJtagInstanceID} {0}
	set_instance_parameter_value nios2_@processor.number {debug_datatrigger} {0}
	set_instance_parameter_value nios2_@processor.number {debug_debugReqSignals} {0}
	set_instance_parameter_value nios2_@processor.number {debug_enabled} {1}
	set_instance_parameter_value nios2_@processor.number {debug_hwbreakpoint} {0}
	set_instance_parameter_value nios2_@processor.number {debug_jtagInstanceID} {0}
	set_instance_parameter_value nios2_@processor.number {debug_traceStorage} {onchip_trace}
	set_instance_parameter_value nios2_@processor.number {debug_traceType} {none}
	set_instance_parameter_value nios2_@processor.number {debug_triggerArming} {1}
	set_instance_parameter_value nios2_@processor.number {dividerType} {no_div}
	set_instance_parameter_value nios2_@processor.number {exceptionOffset} {32}
	set_instance_parameter_value nios2_@processor.number {exceptionSlave} {data_mem_@{processor.number}.s1}
	set_instance_parameter_value nios2_@processor.number {fa_cache_line} {2}
	set_instance_parameter_value nios2_@processor.number {fa_cache_linesize} {0}
	set_instance_parameter_value nios2_@processor.number {flash_instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {flash_instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {icache_burstType} {None}
	set_instance_parameter_value nios2_@processor.number {icache_numTCIM} {0}
	set_instance_parameter_value nios2_@processor.number {icache_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_@processor.number {icache_size} {4096}
	set_instance_parameter_value nios2_@processor.number {icache_tagramBlockType} {Automatic}
	set_instance_parameter_value nios2_@processor.number {impl} {Tiny}
	set_instance_parameter_value nios2_@processor.number {instruction_master_high_performance_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {instruction_master_high_performance_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {instruction_master_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {instruction_master_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {io_regionbase} {0}
	set_instance_parameter_value nios2_@processor.number {io_regionsize} {0}
	set_instance_parameter_value nios2_@processor.number {master_addr_map} {0}
	set_instance_parameter_value nios2_@processor.number {mmu_TLBMissExcOffset} {0}
	set_instance_parameter_value nios2_@processor.number {mmu_TLBMissExcSlave} {None}
	set_instance_parameter_value nios2_@processor.number {mmu_autoAssignTlbPtrSz} {1}
	set_instance_parameter_value nios2_@processor.number {mmu_enabled} {0}
	set_instance_parameter_value nios2_@processor.number {mmu_processIDNumBits} {8}
	set_instance_parameter_value nios2_@processor.number {mmu_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_@processor.number {mmu_tlbNumWays} {16}
	set_instance_parameter_value nios2_@processor.number {mmu_tlbPtrSz} {7}
	set_instance_parameter_value nios2_@processor.number {mmu_udtlbNumEntries} {6}
	set_instance_parameter_value nios2_@processor.number {mmu_uitlbNumEntries} {4}
	set_instance_parameter_value nios2_@processor.number {mpu_enabled} {0}
	set_instance_parameter_value nios2_@processor.number {mpu_minDataRegionSize} {12}
	set_instance_parameter_value nios2_@processor.number {mpu_minInstRegionSize} {12}
	set_instance_parameter_value nios2_@processor.number {mpu_numOfDataRegion} {8}
	set_instance_parameter_value nios2_@processor.number {mpu_numOfInstRegion} {8}
	set_instance_parameter_value nios2_@processor.number {mpu_useLimit} {0}
	set_instance_parameter_value nios2_@processor.number {mpx_enabled} {0}
	set_instance_parameter_value nios2_@processor.number {mul_32_impl} {2}
	set_instance_parameter_value nios2_@processor.number {mul_64_impl} {0}
	set_instance_parameter_value nios2_@processor.number {mul_shift_choice} {0}
	set_instance_parameter_value nios2_@processor.number {ocimem_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_@processor.number {ocimem_ramInit} {0}
	set_instance_parameter_value nios2_@processor.number {regfile_ramBlockType} {Automatic}
	set_instance_parameter_value nios2_@processor.number {register_file_por} {0}
	set_instance_parameter_value nios2_@processor.number {resetOffset} {0}
	set_instance_parameter_value nios2_@processor.number {resetSlave} {data_mem_@{processor.number}.s1}
	set_instance_parameter_value nios2_@processor.number {resetrequest_enabled} {1}
	set_instance_parameter_value nios2_@processor.number {setting_HBreakTest} {0}
	set_instance_parameter_value nios2_@processor.number {setting_HDLSimCachesCleared} {1}
	set_instance_parameter_value nios2_@processor.number {setting_activateMonitors} {1}
	set_instance_parameter_value nios2_@processor.number {setting_activateTestEndChecker} {0}
	set_instance_parameter_value nios2_@processor.number {setting_activateTrace} {0}
	set_instance_parameter_value nios2_@processor.number {setting_allow_break_inst} {0}
	set_instance_parameter_value nios2_@processor.number {setting_alwaysEncrypt} {1}
	set_instance_parameter_value nios2_@processor.number {setting_asic_add_scan_mode_input} {0}
	set_instance_parameter_value nios2_@processor.number {setting_asic_enabled} {0}
	set_instance_parameter_value nios2_@processor.number {setting_asic_synopsys_translate_on_off} {0}
	set_instance_parameter_value nios2_@processor.number {setting_asic_third_party_synthesis} {0}
	set_instance_parameter_value nios2_@processor.number {setting_avalonDebugPortPresent} {0}
	set_instance_parameter_value nios2_@processor.number {setting_bhtPtrSz} {8}
	set_instance_parameter_value nios2_@processor.number {setting_bigEndian} {0}
	set_instance_parameter_value nios2_@processor.number {setting_branchpredictiontype} {Dynamic}
	set_instance_parameter_value nios2_@processor.number {setting_breakslaveoveride} {0}
	set_instance_parameter_value nios2_@processor.number {setting_clearXBitsLDNonBypass} {1}
	set_instance_parameter_value nios2_@processor.number {setting_dc_ecc_present} {1}
	set_instance_parameter_value nios2_@processor.number {setting_disable_tmr_inj} {0}
	set_instance_parameter_value nios2_@processor.number {setting_disableocitrace} {0}
	set_instance_parameter_value nios2_@processor.number {setting_dtcm_ecc_present} {1}
	set_instance_parameter_value nios2_@processor.number {setting_ecc_present} {0}
	set_instance_parameter_value nios2_@processor.number {setting_ecc_sim_test_ports} {0}
	set_instance_parameter_value nios2_@processor.number {setting_exportHostDebugPort} {0}
	set_instance_parameter_value nios2_@processor.number {setting_exportPCB} {0}
	set_instance_parameter_value nios2_@processor.number {setting_export_large_RAMs} {0}
	set_instance_parameter_value nios2_@processor.number {setting_exportdebuginfo} {0}
	set_instance_parameter_value nios2_@processor.number {setting_exportvectors} {0}
	set_instance_parameter_value nios2_@processor.number {setting_fast_register_read} {0}
	set_instance_parameter_value nios2_@processor.number {setting_ic_ecc_present} {1}
	set_instance_parameter_value nios2_@processor.number {setting_interruptControllerType} {Internal}
	set_instance_parameter_value nios2_@processor.number {setting_itcm_ecc_present} {1}
	set_instance_parameter_value nios2_@processor.number {setting_mmu_ecc_present} {1}
	set_instance_parameter_value nios2_@processor.number {setting_oci_export_jtag_signals} {0}
	set_instance_parameter_value nios2_@processor.number {setting_oci_version} {1}
	set_instance_parameter_value nios2_@processor.number {setting_preciseIllegalMemAccessException} {0}
	set_instance_parameter_value nios2_@processor.number {setting_removeRAMinit} {0}
	set_instance_parameter_value nios2_@processor.number {setting_rf_ecc_present} {1}
	set_instance_parameter_value nios2_@processor.number {setting_shadowRegisterSets} {0}
	set_instance_parameter_value nios2_@processor.number {setting_showInternalSettings} {0}
	set_instance_parameter_value nios2_@processor.number {setting_showUnpublishedSettings} {0}
	set_instance_parameter_value nios2_@processor.number {setting_support31bitdcachebypass} {1}
	set_instance_parameter_value nios2_@processor.number {setting_tmr_output_disable} {0}
	set_instance_parameter_value nios2_@processor.number {setting_usedesignware} {0}
	set_instance_parameter_value nios2_@processor.number {shift_rot_impl} {1}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_data_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_data_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_data_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_data_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_data_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_data_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_data_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_data_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_instruction_master_0_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_instruction_master_0_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_instruction_master_1_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_instruction_master_1_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_instruction_master_2_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_instruction_master_2_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_instruction_master_3_paddr_base} {0}
	set_instance_parameter_value nios2_@processor.number {tightly_coupled_instruction_master_3_paddr_size} {0.0}
	set_instance_parameter_value nios2_@processor.number {tmr_enabled} {0}
	set_instance_parameter_value nios2_@processor.number {tracefilename} {}
	set_instance_parameter_value nios2_@processor.number {userDefinedSettings} {}

	#end

	

# Connections
# -----------
	#for @tile in @tiles:
	add_connection NoC.source_@tile.number fifo_sink_@{tile.number}.in avalon_streaming
	#end

	add_connection clk_0.clk NoC.clock clock

	#for @processor in @processors:
	add_connection clk_0.clk data_mem_@{processor.number}.clk1 clock
	#end

	#for @tile in @tiles:
	add_connection clk_0.clk fifo_sink_@{tile.number}.clk_in clock
	#end
	
	#for @tile in @tiles:
	add_connection clk_0.clk fifo_source_@{tile.number}.clk_in clock
	#end

	add_connection clk_0.clk jtag_uart_0.clk clock

	#for @processor in @processors:
	add_connection clk_0.clk nios2_@{processor.number}.clk clock
	#end

	add_connection clk_0.clk_reset NoC.reset reset

	#for @processor in @processors:
	add_connection clk_0.clk_reset data_mem_@{processor.number}.reset1 reset
	#end

	#for @tile in @tiles:
	add_connection clk_0.clk_reset fifo_sink_@{tile.number}.reset_in reset
	#end

	#for @tile in @tiles:
	add_connection clk_0.clk_reset fifo_source_@{tile.number}.reset_in reset
	#end

	add_connection clk_0.clk_reset jtag_uart_0.reset reset

	#for @processor in @processors:
	add_connection clk_0.clk_reset nios2_@{processor.number}.reset reset
	#end

	#for @tile in @tiles:
	add_connection fifo_source_@{tile.number}.out NoC.sink_@{tile.number} avalon_streaming
	#end
	

	#for @processor in @processors:
	add_connection nios2_@{processor.number}.data_master data_mem_@{processor.number}.s1 avalon
	set_connection_parameter_value nios2_@{processor.number}.data_master/data_mem_@{processor.number}.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.data_master/data_mem_@{processor.number}.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_@{processor.number}.data_master/data_mem_@{processor.number}.s1 defaultConnection {0}

	add_connection nios2_@{processor.number}.data_master fifo_sink_@{processor.number}.in_csr avalon
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_sink_@{processor.number}.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_sink_@{processor.number}.in_csr baseAddress {0x9020}
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_sink_@{processor.number}.in_csr defaultConnection {0}

	add_connection nios2_@{processor.number}.data_master fifo_sink_@{processor.number}.out avalon
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_sink_@{processor.number}.out arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_sink_@{processor.number}.out baseAddress {0x9040}
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_sink_@{processor.number}.out defaultConnection {0}

	add_connection nios2_@{processor.number}.data_master fifo_source_@{processor.number}.in avalon
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_source_@{processor.number}.in arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_source_@{processor.number}.in baseAddress {0x9048}
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_source_@{processor.number}.in defaultConnection {0}

	add_connection nios2_@{processor.number}.data_master fifo_source_@{processor.number}.in_csr avalon
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_source_@{processor.number}.in_csr arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_source_@{processor.number}.in_csr baseAddress {0x9000}
	set_connection_parameter_value nios2_@{processor.number}.data_master/fifo_source_@{processor.number}.in_csr defaultConnection {0}

	add_connection nios2_@{processor.number}.data_master jtag_uart_0.avalon_jtag_slave avalon
	set_connection_parameter_value nios2_@{processor.number}.data_master/jtag_uart_0.avalon_jtag_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.data_master/jtag_uart_0.avalon_jtag_slave baseAddress {0x9050}
	set_connection_parameter_value nios2_@{processor.number}.data_master/jtag_uart_0.avalon_jtag_slave defaultConnection {0}

	add_connection nios2_@{processor.number}.data_master nios2_@{processor.number}.debug_mem_slave avalon
	set_connection_parameter_value nios2_@{processor.number}.data_master/nios2_@{processor.number}.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.data_master/nios2_@{processor.number}.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_@{processor.number}.data_master/nios2_@{processor.number}.debug_mem_slave defaultConnection {0}

	add_connection nios2_@{processor.number}.debug_reset_request clk_0.clk_in_reset reset

	add_connection nios2_@{processor.number}.instruction_master data_mem_@{processor.number}.s1 avalon
	set_connection_parameter_value nios2_@{processor.number}.instruction_master/data_mem_@{processor.number}.s1 arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.instruction_master/data_mem_@{processor.number}.s1 baseAddress {0x4000}
	set_connection_parameter_value nios2_@{processor.number}.instruction_master/data_mem_@{processor.number}.s1 defaultConnection {0}

	add_connection nios2_@{processor.number}.instruction_master nios2_@{processor.number}.debug_mem_slave avalon
	set_connection_parameter_value nios2_@{processor.number}.instruction_master/nios2_@{processor.number}.debug_mem_slave arbitrationPriority {1}
	set_connection_parameter_value nios2_@{processor.number}.instruction_master/nios2_@{processor.number}.debug_mem_slave baseAddress {0x8800}
	set_connection_parameter_value nios2_@{processor.number}.instruction_master/nios2_@{processor.number}.debug_mem_slave defaultConnection {0}

	add_connection nios2_@{processor.number}.irq fifo_sink_@{processor.number}.in_irq interrupt
	set_connection_parameter_value nios2_@{processor.number}.irq/fifo_sink_@{processor.number}.in_irq irqNumber {0}

	add_connection nios2_@{processor.number}.irq fifo_source_@{processor.number}.in_irq interrupt
	set_connection_parameter_value nios2_@{processor.number}.irq/fifo_source_@{processor.number}.in_irq irqNumber {1}

	add_connection nios2_@{processor.number}.irq jtag_uart_0.irq interrupt
	set_connection_parameter_value nios2_@{processor.number}.irq/jtag_uart_0.irq irqNumber {2}

	#end

	#for @processor in @processors:
	auto_assign_base_addresses data_mem_@processor.number
	#end

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

