module wrapper (
	clock,
	reset,

	#for @tile in @tiles:

	PE@{tile.number}_InpData	,
	PE@{tile.number}_InpEn		,
	PE@{tile.number}_InpReady	,
	PE@{tile.number}_InpSel		,

	PE@{tile.number}_OutpData	,
	PE@{tile.number}_OutpEn		,
	PE@{tile.number}_OutpReady	,
	#if (@tile.number == @numOfTiles - 1)
	PE@{tile.number}_OutpSel	
	#else
	PE@{tile.number}_OutpSel	,
	#end
	#end
	);

parameter RowNo       = 2;
parameter ColNo       = 2;
parameter PackWidth   = 8;
parameter DataWidth   = 8;
parameter AddrWidth   = 2;
parameter RoChAddr	  = 1;
parameter PhyChAddr	  = 2;
parameter ViChAddr	  = 1;
parameter PhyRoChAddr = 3;		
parameter RoCh		  = 1;
parameter PhyCh		  = 4;
parameter ViCh		  = 1;
parameter PhyRoCh	  = 5;

input clock, reset;

#for @tile in @tiles:

output 	[DataWidth - 1:0] PE@{tile.number}_InpData;
output 	PE@{tile.number}_InpEn;
input  	PE@{tile.number}_InpReady;
output 	[ViChAddr - 1:0] PE@{tile.number}_InpSel;

input 	[DataWidth - 1:0] PE@{tile.number}_OutpData;
input 	PE@{tile.number}_OutpEn;
output 	PE@{tile.number}_OutpReady;
input 	[ViChAddr - 1:0] PE@{tile.number}_OutpSel;

#end

NOC #(
	.RowNo(RowNo),
	.ColNo(ColNo),
	.PackWidth(PackWidth),
	.DataWidth(DataWidth),
	.AddrWidth(AddrWidth),
	.RoChAddr(RoChAddr),
	.PhyChAddr(PhyChAddr),
	.ViChAddr(ViChAddr),
	.PhyRoChAddr(PhyRoChAddr),
	.RoCh(RoCh),
	.PhyCh(PhyCh),
	.ViCh(ViCh),
	.PhyRoCh(PhyRoCh)
	)

	n1(
	.Clk(clock),
	.Reset(reset),

	#for @tile in @tiles:

	.PE@{tile.number}_InpData	(PE@{tile.number}_InpData),
	.PE@{tile.number}_InpEn		(PE@{tile.number}_InpEn),
	.PE@{tile.number}_InpReady	(PE@{tile.number}_InpReady),
	.PE@{tile.number}_InpSel	(PE@{tile.number}_InpSel),

	.PE@{tile.number}_OutpData	(PE@{tile.number}_OutpData),
	.PE@{tile.number}_OutpEn	(PE@{tile.number}_OutpEn),
	.PE@{tile.number}_OutpReady	(PE@{tile.number}_OutpReady),
	#if (@tile.number == @numOfTiles - 1)
	.PE@{tile.number}_OutpSel	(PE@{tile.number}_OutpSel)	
	#else
	.PE@{tile.number}_OutpSel	(PE@{tile.number}_OutpSel),
	#end
	#end
	);

endmodule 