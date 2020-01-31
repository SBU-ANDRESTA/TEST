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
		RowNo		: Integer := @NoC.RowNo;
		ColNo		: Integer := @NoC.ColNo;

		PackWidth	: Integer := @NoC.PackWidth;
		DataWidth	: Integer := @NoC.DataWidth;
		AddrWidth	: Integer := @NoC.AddrWidth;	

		RoChAddr		: Integer := @NoC.RoChAddr;
		PhyChAddr		: Integer := @NoC.PhyChAddr;
		ViChAddr		: Integer := @NoC.ViChAddr;
		PhyRoChAddr		: Integer := @NoC.PhyRoChAddr;
		RoCh			: Integer := @NoC.RoCh;
		PhyCh			: Integer := @NoC.PhyCh;
		ViCh			: Integer := @NoC.ViCh;
		PhyRoCh			: Integer := @NoC.PhyRoCh;
		PoissonDelayStr : String(3 Downto 1):="200";
		InpFileUniform  : StrArr6(0 to @numOfTiles-1):=(
		#for @tile in @tiles:
		#if (@tile.number < 10)
		#if (@tile.number == @numOfTiles - 1)
		"0@{tile.number}.txt"
		#else
		"0@{tile.number}.txt",
		#end
		#else
		#if (@tile.number == @numOfTiles - 1)
		"@{tile.number}.txt"
		#else
		"@{tile.number}.txt",
		#end
		#end
		#end
		);

		
 		PackGenNum : Unsigned(15 Downto 0) := To_Unsigned(300,16);
 		PackGen    : Unsigned(@numOfTiles-1 Downto 0):=(Others=>'1')
		);
	port (
		Clk				: In  std_logic;
		Reset			: In  std_logic;

		--SentCnt			: Out UnsignedArr16(RowNo*ColNo-1 Downto 0);
		--ReceCnt			: Out UnsignedArr16(RowNo*ColNo-1 Downto 0);
		--AveReceTime		: Out UnsignedArr20(RowNo*ColNo-1 Downto 0);
		--StopSim			: In Std_Logic
		#for @tile in @tiles:

		PE@{tile.number}_InpData		: Out 	Signed(DataWidth-1 downto 0); 
		PE@{tile.number}_InpEn			: Out  	Std_Logic;
		PE@{tile.number}_InpReady		: In 	Unsigned(ViCh-1 downto 0);
		PE@{tile.number}_InpSel			: Out  	Unsigned(ViChAddr-1 downto 0);
		PE@{tile.number}_OutpData		: In 	Signed(DataWidth-1 downto 0); 
		PE@{tile.number}_OutpEn			: In 	Std_Logic;
		PE@{tile.number}_OutpReady		: Out  	Unsigned(ViCh-1 downto 0);
		#if (@tile.number == @numOfTiles - 1)
		PE@{tile.number}_OutpSel		: In 	Unsigned(ViChAddr-1 downto 0)
		#else
		PE@{tile.number}_OutpSel		: In 	Unsigned(ViChAddr-1 downto 0);
		#end
		#end
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

#for @tile in @tiles:

--*************************************************************************************
	--*************************************************************************************
	-- j = @{tile.j}, i = @{tile.i};
	--*************************************************************************************
	--*************************************************************************************
Data2(@{tile.j}*ColNo+@{tile.i}) <= (Data(Index(@{tile.j}+1,@{tile.i},ColNo,RowNo))(1),Data(Index(@{tile.j},@{tile.i}+1,ColNo,RowNo))(0)
						   ,Data(Index(@{tile.j}-1,@{tile.i},ColNo,RowNo))(3),Data(Index(@{tile.j},@{tile.i}-1,ColNo,RowNo))(2));
En2(@{tile.j}*ColNo+@{tile.i}) <= 	(En(Index(@{tile.j}+1,@{tile.i},ColNo,RowNo))(1),En(Index(@{tile.j},@{tile.i}+1,ColNo,RowNo))(0)
						   ,En(Index(@{tile.j}-1,@{tile.i},ColNo,RowNo))(3),En(Index(@{tile.j},@{tile.i}-1,ColNo,RowNo))(2));

ag@tile.number  : For k in 0 to ViCh-1 Generate
	Ready(Index(@{tile.j}+1,@{tile.i},ColNo,RowNo))(1 *ViCh+k) 	<= Ready2(@{tile.j}*ColNo+@{tile.i})(3 *ViCh+k);
	Ready(Index(@{tile.j},@{tile.i}+1,ColNo,RowNo))(0 *ViCh+k) 	<= Ready2(@{tile.j}*ColNo+@{tile.i})(2 *ViCh+k);
	Ready(Index(@{tile.j}-1,@{tile.i},ColNo,RowNo))(3 *ViCh+k) 	<= Ready2(@{tile.j}*ColNo+@{tile.i})(1 *ViCh+k);
	Ready(Index(@{tile.j},@{tile.i}-1,ColNo,RowNo))(2 *ViCh+k) 	<= Ready2(@{tile.j}*ColNo+@{tile.i})(0 *ViCh+k);
End Generate;	

Sel2(@{tile.j}*ColNo+@{tile.i}) <=	(Sel(Index(@{tile.j}+1,@{tile.i},ColNo,RowNo))(1),Sel(Index(@{tile.j},@{tile.i}+1,ColNo,RowNo))(0)
						   ,Sel(Index(@{tile.j}-1,@{tile.i},ColNo,RowNo))(3),Sel(Index(@{tile.j},@{tile.i}-1,ColNo,RowNo))(2));					   
m@{tile.number}: Entity Work.Node 
	Generic Map(
	
		InpFilePoisson	=> Str_Add(4,6,InpFilePoissonStr,InpFileUniform(@{tile.j}*ColNo+@{tile.i}))	,	
		InpFileUniform	=> InpFileUniform(@{tile.j}*ColNo+@{tile.i})	,	
		OutpFilePack	=> Str_Add(9,6,OutpFilePackStr,InpFileUniform(@{tile.j}*ColNo+@{tile.i}))		 ,
		OutpFileTime	=> Str_Add(9,6,OutpFileTimeStr,InpFileUniform(@{tile.j}*ColNo+@{tile.i}))		,
	
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
		CurNode		=> @{tile.j}*ColNo+@{tile.i}	,	
		PackGen		=> PackGen(@{tile.j}*ColNo+@{tile.i}) ,
		PackGenNum	=> PackGenNum
		)
	Port Map(
		Clk				=> Clk			,	
		Reset			=> Reset		,	

		InpData			=> Data2(@{tile.j}*ColNo+@{tile.i})	,	
		InpEn			=> En2(@{tile.j}*ColNo+@{tile.i})		,	
		InpReady		=> Ready2(@{tile.j}*ColNo+@{tile.i})	,
		InpSel			=> Sel2(@{tile.j}*ColNo+@{tile.i})		,		

		OutpData		=> Data(@{tile.j}*ColNo+@{tile.i}),
		OutpEn			=> En(@{tile.j}*ColNo+@{tile.i})	,	
		OutpReady		=> Ready(@{tile.j}*ColNo+@{tile.i})	,
		OutpSel			=> Sel(@{tile.j}*ColNo+@{tile.i}),

		PE_InpData		=> PE@{tile.number}_InpData,
		PE_InpEn		=> PE@{tile.number}_InpEn,
		PE_InpReady		=> PE@{tile.number}_InpReady,
		PE_InpSel		=> PE@{tile.number}_InpSel,

		PE_OutpData		=> PE@{tile.number}_OutpData,
		PE_OutpEn		=> PE@{tile.number}_OutpEn,
		PE_OutpReady 	=> PE@{tile.number}_OutpReady,
		PE_OutpSel		=> PE@{tile.number}_OutpSel					
	);

#end

End;
