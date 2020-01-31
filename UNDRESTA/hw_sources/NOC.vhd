-- NOCSynSim
-- Network on a Chip Synthesisable and Simulation VHDL Model
-- Version: 1.0 
-- Last Update: 2006/10/04
-- Sharif University of Technology
-- Computer Department
-- High Performance Computing Group - Dr.Sarbazi Azad
-- Author: D.Rahmati

Library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.FilePack.all;
Use Work.ConnectionPack.All;
use std.textio.all;



entity NOC is  --MeshMxN
Generic(
		RowNo		: Integer := 2;
		ColNo		: Integer := 2;

		PackWidth	: Integer := 8;
		DataWidth	: Integer := 8;
		AddrWidth	: Integer := 2;	

		RoChAddr		: Integer := 1;
		PhyChAddr		: Integer := 2;
		ViChAddr		: Integer := 1;
		PhyRoChAddr		: Integer := 3;
		RoCh			: Integer := 1;
		PhyCh			: Integer := 4;
		ViCh			: Integer := 1;
		PhyRoCh			: Integer := 5;
		PoissonDelayStr : String(3 Downto 1):="200";
		InpFileUniform  : StrArr6(0 to 4-1):=(
		
				
		"00.txt",
						
				
		"01.txt",
						
				
		"02.txt",
						
						"03.txt"
								);

		
 		PackGenNum : Unsigned(15 Downto 0) := To_Unsigned(300,16);
 		PackGen    : Unsigned(4-1 Downto 0):=(Others=>'1')
		);
	port (
		Clk				: In  std_logic;
		Reset			: In  std_logic;

		--SentCnt			: Out UnsignedArr16(RowNo*ColNo-1 Downto 0);
		--ReceCnt			: Out UnsignedArr16(RowNo*ColNo-1 Downto 0);
		--AveReceTime		: Out UnsignedArr20(RowNo*ColNo-1 Downto 0);
		--StopSim			: In Std_Logic
		

		PE0_InpData		: Out 	Signed(DataWidth-1 downto 0); 
		PE0_InpEn			: Out  	Std_Logic;
		PE0_InpReady		: In 	Unsigned(ViCh-1 downto 0);
		PE0_InpSel			: Out  	Unsigned(ViChAddr-1 downto 0);
		PE0_OutpData		: In 	Signed(DataWidth-1 downto 0); 
		PE0_OutpEn			: In 	Std_Logic;
		PE0_OutpReady		: Out  	Unsigned(ViCh-1 downto 0);
		
		PE0_OutpSel		: In 	Unsigned(ViChAddr-1 downto 0);
				

		PE1_InpData		: Out 	Signed(DataWidth-1 downto 0); 
		PE1_InpEn			: Out  	Std_Logic;
		PE1_InpReady		: In 	Unsigned(ViCh-1 downto 0);
		PE1_InpSel			: Out  	Unsigned(ViChAddr-1 downto 0);
		PE1_OutpData		: In 	Signed(DataWidth-1 downto 0); 
		PE1_OutpEn			: In 	Std_Logic;
		PE1_OutpReady		: Out  	Unsigned(ViCh-1 downto 0);
		
		PE1_OutpSel		: In 	Unsigned(ViChAddr-1 downto 0);
				

		PE2_InpData		: Out 	Signed(DataWidth-1 downto 0); 
		PE2_InpEn			: Out  	Std_Logic;
		PE2_InpReady		: In 	Unsigned(ViCh-1 downto 0);
		PE2_InpSel			: Out  	Unsigned(ViChAddr-1 downto 0);
		PE2_OutpData		: In 	Signed(DataWidth-1 downto 0); 
		PE2_OutpEn			: In 	Std_Logic;
		PE2_OutpReady		: Out  	Unsigned(ViCh-1 downto 0);
		
		PE2_OutpSel		: In 	Unsigned(ViChAddr-1 downto 0);
				

		PE3_InpData		: Out 	Signed(DataWidth-1 downto 0); 
		PE3_InpEn			: Out  	Std_Logic;
		PE3_InpReady		: In 	Unsigned(ViCh-1 downto 0);
		PE3_InpSel			: Out  	Unsigned(ViChAddr-1 downto 0);
		PE3_OutpData		: In 	Signed(DataWidth-1 downto 0); 
		PE3_OutpEn			: In 	Std_Logic;
		PE3_OutpReady		: Out  	Unsigned(ViCh-1 downto 0);
				PE3_OutpSel		: In 	Unsigned(ViChAddr-1 downto 0)
						);
end;


architecture behavioral of NOC is


Constant InpFilePoissonStr : String(4 Downto 1) := Str_Add(3,1,PoissonDelayStr,"-"); --"500-"
Constant PStr : String(5 Downto 1) :="Pack-";
Constant OutpFilePackStr   : String(9 Downto 1) := Str_Add(5,4,PStr,InpFilePoissonStr); --"Pack-500-"
Constant TStr : String(5 Downto 1) :="Time-";
Constant OutpFileTimeStr   : String(9 Downto 1) := Str_Add(5,4,TStr,InpFilePoissonStr); --"Time-500-";
									
Function Index(	j,i		: Integer;
				ColNo,RowNo	: Integer )
						return Integer Is
									
variable Res:	Integer;
variable ii,jj: Integer;
begin
	jj:=j;
	ii:=i;
	if (jj=-1) Then
		jj:=RowNo-1;
	End If;
	if (jj=RowNo) Then
		jj:=0;
	End If;
	if (ii=-1) Then
		ii:=ColNo-1;
	End If;
	if (ii=ColNo) Then
		ii:=0;
	End If;
	
	--Res := (j mod ColNo)*ColNo+(i mod ColNo); 
	Res := jj*ColNo+ii; 
	return Res;
end;								
		
Type UnsignedArrViChAddr is array (natural range <>) of Unsigned(ViChAddr-1 Downto 0);
Type UnsignedArrPhyxVi is array (natural range <>) of Unsigned(PhyCh*ViCh-1 Downto 0); --PhyCh*ViCh=4*1
Type SignedArrMNxPhyChxDataWidth is array(ColNo*RowNo-1 Downto 0) of SignedArrDW(PhyCh-1 downto 0);
Type UnsignedArrMNxPhyxViChAddr is array(ColNo*RowNo-1 Downto 0) of UnsignedArrVCA(PhyCh-1 downto 0);
Type UnsignedArrPhy is array (natural range <>) of Unsigned(PhyCh-1 Downto 0);

Signal	Data	: SignedArrMNxPhyChxDataWidth:=(Others=>(Others=>(Others=>'0'))); --? 8+2
Signal	Data2	: SignedArrMNxPhyChxDataWidth:=(Others=>(Others=>(Others=>'0'))); --? 8+2
Signal	En		: UnsignedArrPhy(ColNo*RowNo-1 downto 0):=(Others=>(Others=>'0'));
Signal	En2		: UnsignedArrPhy(ColNo*RowNo-1 downto 0):=(Others=>(Others=>'0'));
Signal	Ready	: UnsignedArrPhyxVi(ColNo*RowNo-1 downto 0):=(Others=>(Others=>'0')); --note: ViCh=1	->> 4=4*1(ViCh)
Signal	Ready2	: UnsignedArrPhyxVi(ColNo*RowNo-1 downto 0):=(Others=>(Others=>'0')); --note: ViCh=1
Signal	Sel		: UnsignedArrMNxPhyxViChAddr; --ers=>" ? ViChAddr=1
Signal	Sel2	: UnsignedArrMNxPhyxViChAddr; --ers=>" ? ViChAddr=1

begin 



--*************************************************************************************
	--*************************************************************************************
	-- j = 0, i = 0;
	--*************************************************************************************
	--*************************************************************************************
Data2(0*ColNo+0) <= (Data(Index(0+1,0,ColNo,RowNo))(1),Data(Index(0,0+1,ColNo,RowNo))(0)
						   ,Data(Index(0-1,0,ColNo,RowNo))(3),Data(Index(0,0-1,ColNo,RowNo))(2));
En2(0*ColNo+0) <= 	(En(Index(0+1,0,ColNo,RowNo))(1),En(Index(0,0+1,ColNo,RowNo))(0)
						   ,En(Index(0-1,0,ColNo,RowNo))(3),En(Index(0,0-1,ColNo,RowNo))(2));

ag0  : For k in 0 to ViCh-1 Generate
	Ready(Index(0+1,0,ColNo,RowNo))(1 *ViCh+k) 	<= Ready2(0*ColNo+0)(3 *ViCh+k);
	Ready(Index(0,0+1,ColNo,RowNo))(0 *ViCh+k) 	<= Ready2(0*ColNo+0)(2 *ViCh+k);
	Ready(Index(0-1,0,ColNo,RowNo))(3 *ViCh+k) 	<= Ready2(0*ColNo+0)(1 *ViCh+k);
	Ready(Index(0,0-1,ColNo,RowNo))(2 *ViCh+k) 	<= Ready2(0*ColNo+0)(0 *ViCh+k);
End Generate;	

Sel2(0*ColNo+0) <=	(Sel(Index(0+1,0,ColNo,RowNo))(1),Sel(Index(0,0+1,ColNo,RowNo))(0)
						   ,Sel(Index(0-1,0,ColNo,RowNo))(3),Sel(Index(0,0-1,ColNo,RowNo))(2));					   
m0: Entity Work.Node 
	Generic Map(
	
		InpFilePoisson	=> Str_Add(4,6,InpFilePoissonStr,InpFileUniform(0*ColNo+0))	,	
		InpFileUniform	=> InpFileUniform(0*ColNo+0)	,	
		OutpFilePack	=> Str_Add(9,6,OutpFilePackStr,InpFileUniform(0*ColNo+0))		 ,
		OutpFileTime	=> Str_Add(9,6,OutpFileTimeStr,InpFileUniform(0*ColNo+0))		,
	
		ViChAddr	=> ViChAddr		,
		PhyRoChAddr	=> PhyRoChAddr	,
		--			   --
		PhyCh		=> PhyCh		,
		ViCh		=> ViCh			,
		RoCh 		=> RoCh 		,
		PhyRoCh		=> PhyRoCh		,
		--			   --
		PackWidth	=> PackWidth	,
		DataWidth	=> DataWidth	,
		--			   --
		CurNode		=> 0*ColNo+0	,	
		PackGen		=> PackGen(0*ColNo+0) ,
		PackGenNum	=> PackGenNum
		)
	Port Map(
		Clk				=> Clk			,	
		Reset			=> Reset		,	

		InpData			=> Data2(0*ColNo+0)	,	
		InpEn			=> En2(0*ColNo+0)		,	
		InpReady		=> Ready2(0*ColNo+0)	,
		InpSel			=> Sel2(0*ColNo+0)		,		

		OutpData		=> Data(0*ColNo+0),
		OutpEn			=> En(0*ColNo+0)	,	
		OutpReady		=> Ready(0*ColNo+0)	,
		OutpSel			=> Sel(0*ColNo+0),

		PE_InpData		=> PE0_InpData,
		PE_InpEn		=> PE0_InpEn,
		PE_InpReady		=> PE0_InpReady,
		PE_InpSel		=> PE0_InpSel,

		PE_OutpData		=> PE0_OutpData,
		PE_OutpEn		=> PE0_OutpEn,
		PE_OutpReady 	=> PE0_OutpReady,
		PE_OutpSel		=> PE0_OutpSel					
	);



--*************************************************************************************
	--*************************************************************************************
	-- j = 0, i = 1;
	--*************************************************************************************
	--*************************************************************************************
Data2(0*ColNo+1) <= (Data(Index(0+1,1,ColNo,RowNo))(1),Data(Index(0,1+1,ColNo,RowNo))(0)
						   ,Data(Index(0-1,1,ColNo,RowNo))(3),Data(Index(0,1-1,ColNo,RowNo))(2));
En2(0*ColNo+1) <= 	(En(Index(0+1,1,ColNo,RowNo))(1),En(Index(0,1+1,ColNo,RowNo))(0)
						   ,En(Index(0-1,1,ColNo,RowNo))(3),En(Index(0,1-1,ColNo,RowNo))(2));

ag1  : For k in 0 to ViCh-1 Generate
	Ready(Index(0+1,1,ColNo,RowNo))(1 *ViCh+k) 	<= Ready2(0*ColNo+1)(3 *ViCh+k);
	Ready(Index(0,1+1,ColNo,RowNo))(0 *ViCh+k) 	<= Ready2(0*ColNo+1)(2 *ViCh+k);
	Ready(Index(0-1,1,ColNo,RowNo))(3 *ViCh+k) 	<= Ready2(0*ColNo+1)(1 *ViCh+k);
	Ready(Index(0,1-1,ColNo,RowNo))(2 *ViCh+k) 	<= Ready2(0*ColNo+1)(0 *ViCh+k);
End Generate;	

Sel2(0*ColNo+1) <=	(Sel(Index(0+1,1,ColNo,RowNo))(1),Sel(Index(0,1+1,ColNo,RowNo))(0)
						   ,Sel(Index(0-1,1,ColNo,RowNo))(3),Sel(Index(0,1-1,ColNo,RowNo))(2));					   
m1: Entity Work.Node 
	Generic Map(
	
		InpFilePoisson	=> Str_Add(4,6,InpFilePoissonStr,InpFileUniform(0*ColNo+1))	,	
		InpFileUniform	=> InpFileUniform(0*ColNo+1)	,	
		OutpFilePack	=> Str_Add(9,6,OutpFilePackStr,InpFileUniform(0*ColNo+1))		 ,
		OutpFileTime	=> Str_Add(9,6,OutpFileTimeStr,InpFileUniform(0*ColNo+1))		,
	
		ViChAddr	=> ViChAddr		,
		PhyRoChAddr	=> PhyRoChAddr	,
		--			   --
		PhyCh		=> PhyCh		,
		ViCh		=> ViCh			,
		RoCh 		=> RoCh 		,
		PhyRoCh		=> PhyRoCh		,
		--			   --
		PackWidth	=> PackWidth	,
		DataWidth	=> DataWidth	,
		--			   --
		CurNode		=> 0*ColNo+1	,	
		PackGen		=> PackGen(0*ColNo+1) ,
		PackGenNum	=> PackGenNum
		)
	Port Map(
		Clk				=> Clk			,	
		Reset			=> Reset		,	

		InpData			=> Data2(0*ColNo+1)	,	
		InpEn			=> En2(0*ColNo+1)		,	
		InpReady		=> Ready2(0*ColNo+1)	,
		InpSel			=> Sel2(0*ColNo+1)		,		

		OutpData		=> Data(0*ColNo+1),
		OutpEn			=> En(0*ColNo+1)	,	
		OutpReady		=> Ready(0*ColNo+1)	,
		OutpSel			=> Sel(0*ColNo+1),

		PE_InpData		=> PE1_InpData,
		PE_InpEn		=> PE1_InpEn,
		PE_InpReady		=> PE1_InpReady,
		PE_InpSel		=> PE1_InpSel,

		PE_OutpData		=> PE1_OutpData,
		PE_OutpEn		=> PE1_OutpEn,
		PE_OutpReady 	=> PE1_OutpReady,
		PE_OutpSel		=> PE1_OutpSel					
	);



--*************************************************************************************
	--*************************************************************************************
	-- j = 1, i = 0;
	--*************************************************************************************
	--*************************************************************************************
Data2(1*ColNo+0) <= (Data(Index(1+1,0,ColNo,RowNo))(1),Data(Index(1,0+1,ColNo,RowNo))(0)
						   ,Data(Index(1-1,0,ColNo,RowNo))(3),Data(Index(1,0-1,ColNo,RowNo))(2));
En2(1*ColNo+0) <= 	(En(Index(1+1,0,ColNo,RowNo))(1),En(Index(1,0+1,ColNo,RowNo))(0)
						   ,En(Index(1-1,0,ColNo,RowNo))(3),En(Index(1,0-1,ColNo,RowNo))(2));

ag2  : For k in 0 to ViCh-1 Generate
	Ready(Index(1+1,0,ColNo,RowNo))(1 *ViCh+k) 	<= Ready2(1*ColNo+0)(3 *ViCh+k);
	Ready(Index(1,0+1,ColNo,RowNo))(0 *ViCh+k) 	<= Ready2(1*ColNo+0)(2 *ViCh+k);
	Ready(Index(1-1,0,ColNo,RowNo))(3 *ViCh+k) 	<= Ready2(1*ColNo+0)(1 *ViCh+k);
	Ready(Index(1,0-1,ColNo,RowNo))(2 *ViCh+k) 	<= Ready2(1*ColNo+0)(0 *ViCh+k);
End Generate;	

Sel2(1*ColNo+0) <=	(Sel(Index(1+1,0,ColNo,RowNo))(1),Sel(Index(1,0+1,ColNo,RowNo))(0)
						   ,Sel(Index(1-1,0,ColNo,RowNo))(3),Sel(Index(1,0-1,ColNo,RowNo))(2));					   
m2: Entity Work.Node 
	Generic Map(
	
		InpFilePoisson	=> Str_Add(4,6,InpFilePoissonStr,InpFileUniform(1*ColNo+0))	,	
		InpFileUniform	=> InpFileUniform(1*ColNo+0)	,	
		OutpFilePack	=> Str_Add(9,6,OutpFilePackStr,InpFileUniform(1*ColNo+0))		 ,
		OutpFileTime	=> Str_Add(9,6,OutpFileTimeStr,InpFileUniform(1*ColNo+0))		,
	
		ViChAddr	=> ViChAddr		,
		PhyRoChAddr	=> PhyRoChAddr	,
		--			   --
		PhyCh		=> PhyCh		,
		ViCh		=> ViCh			,
		RoCh 		=> RoCh 		,
		PhyRoCh		=> PhyRoCh		,
		--			   --
		PackWidth	=> PackWidth	,
		DataWidth	=> DataWidth	,
		--			   --
		CurNode		=> 1*ColNo+0	,	
		PackGen		=> PackGen(1*ColNo+0) ,
		PackGenNum	=> PackGenNum
		)
	Port Map(
		Clk				=> Clk			,	
		Reset			=> Reset		,	

		InpData			=> Data2(1*ColNo+0)	,	
		InpEn			=> En2(1*ColNo+0)		,	
		InpReady		=> Ready2(1*ColNo+0)	,
		InpSel			=> Sel2(1*ColNo+0)		,		

		OutpData		=> Data(1*ColNo+0),
		OutpEn			=> En(1*ColNo+0)	,	
		OutpReady		=> Ready(1*ColNo+0)	,
		OutpSel			=> Sel(1*ColNo+0),

		PE_InpData		=> PE2_InpData,
		PE_InpEn		=> PE2_InpEn,
		PE_InpReady		=> PE2_InpReady,
		PE_InpSel		=> PE2_InpSel,

		PE_OutpData		=> PE2_OutpData,
		PE_OutpEn		=> PE2_OutpEn,
		PE_OutpReady 	=> PE2_OutpReady,
		PE_OutpSel		=> PE2_OutpSel					
	);



--*************************************************************************************
	--*************************************************************************************
	-- j = 1, i = 1;
	--*************************************************************************************
	--*************************************************************************************
Data2(1*ColNo+1) <= (Data(Index(1+1,1,ColNo,RowNo))(1),Data(Index(1,1+1,ColNo,RowNo))(0)
						   ,Data(Index(1-1,1,ColNo,RowNo))(3),Data(Index(1,1-1,ColNo,RowNo))(2));
En2(1*ColNo+1) <= 	(En(Index(1+1,1,ColNo,RowNo))(1),En(Index(1,1+1,ColNo,RowNo))(0)
						   ,En(Index(1-1,1,ColNo,RowNo))(3),En(Index(1,1-1,ColNo,RowNo))(2));

ag3  : For k in 0 to ViCh-1 Generate
	Ready(Index(1+1,1,ColNo,RowNo))(1 *ViCh+k) 	<= Ready2(1*ColNo+1)(3 *ViCh+k);
	Ready(Index(1,1+1,ColNo,RowNo))(0 *ViCh+k) 	<= Ready2(1*ColNo+1)(2 *ViCh+k);
	Ready(Index(1-1,1,ColNo,RowNo))(3 *ViCh+k) 	<= Ready2(1*ColNo+1)(1 *ViCh+k);
	Ready(Index(1,1-1,ColNo,RowNo))(2 *ViCh+k) 	<= Ready2(1*ColNo+1)(0 *ViCh+k);
End Generate;	

Sel2(1*ColNo+1) <=	(Sel(Index(1+1,1,ColNo,RowNo))(1),Sel(Index(1,1+1,ColNo,RowNo))(0)
						   ,Sel(Index(1-1,1,ColNo,RowNo))(3),Sel(Index(1,1-1,ColNo,RowNo))(2));					   
m3: Entity Work.Node 
	Generic Map(
	
		InpFilePoisson	=> Str_Add(4,6,InpFilePoissonStr,InpFileUniform(1*ColNo+1))	,	
		InpFileUniform	=> InpFileUniform(1*ColNo+1)	,	
		OutpFilePack	=> Str_Add(9,6,OutpFilePackStr,InpFileUniform(1*ColNo+1))		 ,
		OutpFileTime	=> Str_Add(9,6,OutpFileTimeStr,InpFileUniform(1*ColNo+1))		,
	
		ViChAddr	=> ViChAddr		,
		PhyRoChAddr	=> PhyRoChAddr	,
		--			   --
		PhyCh		=> PhyCh		,
		ViCh		=> ViCh			,
		RoCh 		=> RoCh 		,
		PhyRoCh		=> PhyRoCh		,
		--			   --
		PackWidth	=> PackWidth	,
		DataWidth	=> DataWidth	,
		--			   --
		CurNode		=> 1*ColNo+1	,	
		PackGen		=> PackGen(1*ColNo+1) ,
		PackGenNum	=> PackGenNum
		)
	Port Map(
		Clk				=> Clk			,	
		Reset			=> Reset		,	

		InpData			=> Data2(1*ColNo+1)	,	
		InpEn			=> En2(1*ColNo+1)		,	
		InpReady		=> Ready2(1*ColNo+1)	,
		InpSel			=> Sel2(1*ColNo+1)		,		

		OutpData		=> Data(1*ColNo+1),
		OutpEn			=> En(1*ColNo+1)	,	
		OutpReady		=> Ready(1*ColNo+1)	,
		OutpSel			=> Sel(1*ColNo+1),

		PE_InpData		=> PE3_InpData,
		PE_InpEn		=> PE3_InpEn,
		PE_InpReady		=> PE3_InpReady,
		PE_InpSel		=> PE3_InpSel,

		PE_OutpData		=> PE3_OutpData,
		PE_OutpEn		=> PE3_OutpEn,
		PE_OutpReady 	=> PE3_OutpReady,
		PE_OutpSel		=> PE3_OutpSel					
	);


End;
