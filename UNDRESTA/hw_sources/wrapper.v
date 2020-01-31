module wrapper (
	clock,
	reset,

	

	PE0_InpData	,
	PE0_InpEn		,
	PE0_InpReady	,
	PE0_InpSel		,

	PE0_OutpData	,
	PE0_OutpEn		,
	PE0_OutpReady	,
	
	PE0_OutpSel	,
		

	PE1_InpData	,
	PE1_InpEn		,
	PE1_InpReady	,
	PE1_InpSel		,

	PE1_OutpData	,
	PE1_OutpEn		,
	PE1_OutpReady	,
	
	PE1_OutpSel	,
		

	PE2_InpData	,
	PE2_InpEn		,
	PE2_InpReady	,
	PE2_InpSel		,

	PE2_OutpData	,
	PE2_OutpEn		,
	PE2_OutpReady	,
	
	PE2_OutpSel	,
		

	PE3_InpData	,
	PE3_InpEn		,
	PE3_InpReady	,
	PE3_InpSel		,

	PE3_OutpData	,
	PE3_OutpEn		,
	PE3_OutpReady	,
		PE3_OutpSel	
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



output 	[DataWidth - 1:0] PE0_InpData;
output 	PE0_InpEn;
input  	PE0_InpReady;
output 	[ViChAddr - 1:0] PE0_InpSel;

input 	[DataWidth - 1:0] PE0_OutpData;
input 	PE0_OutpEn;
output 	PE0_OutpReady;
input 	[ViChAddr - 1:0] PE0_OutpSel;



output 	[DataWidth - 1:0] PE1_InpData;
output 	PE1_InpEn;
input  	PE1_InpReady;
output 	[ViChAddr - 1:0] PE1_InpSel;

input 	[DataWidth - 1:0] PE1_OutpData;
input 	PE1_OutpEn;
output 	PE1_OutpReady;
input 	[ViChAddr - 1:0] PE1_OutpSel;



output 	[DataWidth - 1:0] PE2_InpData;
output 	PE2_InpEn;
input  	PE2_InpReady;
output 	[ViChAddr - 1:0] PE2_InpSel;

input 	[DataWidth - 1:0] PE2_OutpData;
input 	PE2_OutpEn;
output 	PE2_OutpReady;
input 	[ViChAddr - 1:0] PE2_OutpSel;



output 	[DataWidth - 1:0] PE3_InpData;
output 	PE3_InpEn;
input  	PE3_InpReady;
output 	[ViChAddr - 1:0] PE3_InpSel;

input 	[DataWidth - 1:0] PE3_OutpData;
input 	PE3_OutpEn;
output 	PE3_OutpReady;
input 	[ViChAddr - 1:0] PE3_OutpSel;


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

	

	.PE0_InpData	(PE0_InpData),
	.PE0_InpEn		(PE0_InpEn),
	.PE0_InpReady	(PE0_InpReady),
	.PE0_InpSel	(PE0_InpSel),

	.PE0_OutpData	(PE0_OutpData),
	.PE0_OutpEn	(PE0_OutpEn),
	.PE0_OutpReady	(PE0_OutpReady),
	
	.PE0_OutpSel	(PE0_OutpSel),
		

	.PE1_InpData	(PE1_InpData),
	.PE1_InpEn		(PE1_InpEn),
	.PE1_InpReady	(PE1_InpReady),
	.PE1_InpSel	(PE1_InpSel),

	.PE1_OutpData	(PE1_OutpData),
	.PE1_OutpEn	(PE1_OutpEn),
	.PE1_OutpReady	(PE1_OutpReady),
	
	.PE1_OutpSel	(PE1_OutpSel),
		

	.PE2_InpData	(PE2_InpData),
	.PE2_InpEn		(PE2_InpEn),
	.PE2_InpReady	(PE2_InpReady),
	.PE2_InpSel	(PE2_InpSel),

	.PE2_OutpData	(PE2_OutpData),
	.PE2_OutpEn	(PE2_OutpEn),
	.PE2_OutpReady	(PE2_OutpReady),
	
	.PE2_OutpSel	(PE2_OutpSel),
		

	.PE3_InpData	(PE3_InpData),
	.PE3_InpEn		(PE3_InpEn),
	.PE3_InpReady	(PE3_InpReady),
	.PE3_InpSel	(PE3_InpSel),

	.PE3_OutpData	(PE3_OutpData),
	.PE3_OutpEn	(PE3_OutpEn),
	.PE3_OutpReady	(PE3_OutpReady),
		.PE3_OutpSel	(PE3_OutpSel)	
			);

endmodule 