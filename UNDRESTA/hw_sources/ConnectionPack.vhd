-- NOCSynSim
-- Network on a Chip Synthesisable and Simulation VHDL Model
-- Version: 1.0 
-- Last Update: 2006/10/04
-- Sharif University of Technology
-- Computer Department
-- High Performance Computing Group - Dr.Sarbazi Azad
-- Author: D.Rahmati

Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package ConnectionPack is
	
--Type IntVector is array (natural range <>) of integer;
-- Type SignedArr is array (natural range <>) of Signed(natural range <>); --(DataWidth-1 Downto 0);

Type UnsignedArr1 is array (natural range <>) of Unsigned(0 Downto 0);
Type UnsignedArr2 is array (natural range <>) of Unsigned(1 Downto 0);
Type UnsignedArr3 is array (natural range <>) of Unsigned(2 Downto 0);
Type UnsignedArr4 is array (natural range <>) of Unsigned(3 Downto 0);
Type UnSignedArr8 is array (natural range <>) of Unsigned(7 Downto 0);
Type UnsignedArr14 is array (natural range <>) of Unsigned(13 Downto 0);
Type UnsignedArr16 is array (natural range <>) of Unsigned(15 Downto 0);
Type UnsignedArr20 is array (natural range <>) of Unsigned(19 Downto 0);
Type UnsignedArr32 is array (natural range <>) of Unsigned(31 Downto 0);
--Type UnsignedArrMxN is array (natural range <>) of Unsigned(RowNo*ColNo-1 Downto 0);
	

Type SignedArr1 is array (natural range <>) of Signed(0 Downto 0);
Type SignedArr2 is array (natural range <>) of Signed(1 Downto 0);
Type SignedArr3 is array (natural range <>) of Signed(2 Downto 0);
Type SignedArr4 is array (natural range <>) of Signed(3 Downto 0);
Type SignedArr8 is array (natural range <>) of Signed(7 Downto 0);
Type SignedArr10 is array (natural range <>) of Signed(9 Downto 0);

Type BoolArr is array (natural range <>) of Boolean;

Type StrArr6 is Array(natural range <>) of String(6 Downto 1);

--Type UnsignedArr2Arr4 is array (natural range <>) of UnsignedArr2(3 Downto 0);
	
Constant RowNo : Integer := 2;	
Constant ColNo : Integer := 2;	
Constant DataWidth : Integer  :=8;
Constant PhyCh : Integer := 4;
Constant ViCh : Integer := 1;
Constant ViChAddr : Integer :=1;
Constant PackSize: Integer :=32;--32;

Constant RecePackIgnorePercent :Integer :=20; --20%
Constant DumpTimePackFile : Boolean := true;
Constant PackWidth	: Integer := 8;
Constant AddrWidth	: Integer := 2;	
Constant RoChAddr		: Integer := 1;
Constant PhyChAddr		: Integer := 2;
Constant PhyRoChAddr	: Integer := 2+1;
Constant RoCh			: Integer := 1;
Constant PhyRoCh		: Integer := 4+1;
Constant PoissonDelayStr : String(3 Downto 1):="200";
Constant DefExtData : Integer := 0;


Constant PackGenNum : Unsigned(15 Downto 0) := To_Unsigned(300,16);
--Constant PackGen 	: Unsigned(15 Downto 0) :="0000001111111111"; -- 15 ... 0
Constant PackGen 	: Unsigned(RowNo*ColNo-1 Downto 0) :=(Others=>'1'); -- 15 ... 0

Type UnsignedArrVCA is array (natural range <>) of Unsigned(ViChAddr-1 Downto 0); -- ViChAddr=1
Type SignedArrDW is array (natural range <>) of Signed(DataWidth-1 Downto 0); -- DataWidth=8
Type UnsignedArrPW is array (natural range <>) of Unsigned(PackWidth-1 Downto 0); -- PackWidth=8-->256 pack length

-------------------------------------------------------
Constant MaxCol : Integer := 8; 
Constant MaxRow : Integer := 8; 
Constant InpFileUniform :StrArr6(0 to MaxCol*MaxRow-1):=(
								"00.txt",
								"01.txt",
								"02.txt",
								"03.txt",
								"04.txt",
								"05.txt",
								"06.txt",
								"07.txt",
								"08.txt",
								"09.txt",
								"10.txt",
								"11.txt",
								"12.txt",
								"13.txt",
								"14.txt",
								"15.txt",																
								"16.txt",
								"17.txt",
								"18.txt",
								"19.txt",
								"20.txt",
								"21.txt",
								"22.txt",
								"23.txt",
								"24.txt",
								"25.txt",
								"26.txt",
								"27.txt",
								"28.txt",
								"29.txt",
								"30.txt",
								"31.txt",																
								"32.txt",
								"33.txt",
								"34.txt",
								"35.txt",
								"36.txt",
								"37.txt",
								"38.txt",
								"39.txt",
								"40.txt",
								"41.txt",
								"42.txt",
								"43.txt",
								"44.txt",
								"45.txt",
								"46.txt",
								"47.txt",																
								"48.txt",
								"49.txt",
								"50.txt",
								"51.txt",
								"52.txt",
								"53.txt",
								"54.txt",
								"55.txt",
								"56.txt",
								"57.txt",
								"58.txt",
								"59.txt",
								"60.txt",
								"61.txt",
								"62.txt",
								"63.txt"													
								); 
								

	Function  HasFreeAdapViCh(
							IsOutpChBusy			: Unsigned(PhyRoCh*ViCh-1 downto 0);
							PhyIndex				: Integer )Return Integer;
								
	Procedure RoutingFunc(	OutPackPhCh		: Out Integer;
							OutPackViCh		: Out Integer;
							InpChAssigned	: Out Std_Logic;
							CombinedDataOut	: Out Unsigned(DataWidth-1 downto 0);
							IsOutpChBusy	: Unsigned(PhyRoCh*ViCh-1 downto 0);
							CurNode			: Unsigned(DataWidth-1 downto 0);
							Receiver		: Unsigned(DataWidth-1 downto 0);
							ExtDataIn		: Unsigned(DataWidth-1 downto 0) );

	Procedure RoutingMechanism(	
							PackOutPhChOut	: Out UnsignedArr3(PhyRoCh*ViCh-1 downto 0); -- Array of inp channel and coresponding output ch
							PackOutViChOut	: Out UnsignedArrVCA(PhyRoCh*ViCh-1 downto 0);
							InpChAssignedOut: Out Unsigned(PhyRoCh*ViCh-1 downto 0);
							CmbDataOut		: Out SignedArrDW(PhyRoCh*ViCh-1 downto 0);
							OutpChBusyOut 	: Out Unsigned(PhyRoCh*ViCh-1 downto 0);
							Reset			: Std_Logic;
							InpChAssigned	: Unsigned(PhyRoCh*ViCh-1 downto 0);
							OutpChBusy 		: Unsigned(PhyRoCh*ViCh-1 downto 0);
							CurNode			: Integer;
							Receiver		: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
							ExtData			: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
							CmbData			: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
							ValidHeader		: Unsigned(PhyRoCh*ViCh-1 downto 0);
							PackOutPhCh		: UnsignedArr3(PhyRoCh*ViCh-1 downto 0); -- Array of inp channel and coresponding output ch
							PackOutViCh		: UnsignedArrVCA(PhyRoCh*ViCh-1 downto 0);
							ValidPack		: Unsigned(PhyRoCh*ViCh-1 downto 0);
							PreValidPack	: Unsigned(PhyRoCh*ViCh-1 downto 0))   ;
							
-- User Defined Constants
Constant NumOfAdapViCh : Integer := 3;

end;

package body ConnectionPack is

	Function  HasFreeAdapViCh(
							IsOutpChBusy			: Unsigned(PhyRoCh*ViCh-1 downto 0);
							PhyIndex				: Integer )Return Integer Is
	Variable Ind : Integer;
	Variable HasFreeViCh : Integer;
	Begin	
			HasFreeViCh := -1;
			For j In 0 To NumOfAdapViCh-1 Loop 
				Ind := PhyIndex*ViCh+j;
				If (IsOutpChBusy(Ind)='0') And (HasFreeViCh=-1) Then
					HasFreeViCh := j;
				End If;
			End Loop;	
			Return HasFreeViCh;	
	End Function;
							
	Procedure RoutingFunc(	OutPackPhCh		: Out Integer;
							OutPackViCh		: Out Integer;
							InpChAssigned	: Out Std_Logic;
							CombinedDataOut	: Out Unsigned(DataWidth-1 downto 0);
							IsOutpChBusy	: Unsigned(PhyRoCh*ViCh-1 downto 0);
							CurNode			: Unsigned(DataWidth-1 downto 0);
							Receiver		: Unsigned(DataWidth-1 downto 0);
							ExtDataIn		: Unsigned(DataWidth-1 downto 0) ) is
	variable CurX,CurY :Integer;
	variable DestX,DestY :Integer;
	variable XDiff,YDiff :Integer;
	Variable Ind : Integer;
	Variable Left : Integer;
	Variable Up : Integer;
	Variable Right : Integer;
	Variable Down : Integer;
	Variable Ejec : Integer;
	Variable PhyChAssigned : Integer;
	Variable IsInpChAssigned : Std_Logic;
	begin
			--===================== Description
			-- Deterministic Mesh Routing 
			-- Vi channels 0,1 Adaptive
			-- Check if available adaptive channel otherwise deterministic routing is used			
			
			-- ============ Physical Channel Selection
			CurX := To_Integer(CurNode Mod ColNo); --x
			CurY := To_Integer(CurNode / ColNo); --y
			DestX := To_Integer(Receiver Mod ColNo); --x
			DestY := To_Integer(Receiver / ColNo); --y
			XDiff := DestX - CurX;
			YDiff := DestY - CurY;

			If (XDiff < 0) Then
				PhyChAssigned := 0; -- "000"
			ElsIf (XDiff > 0) Then
				PhyChAssigned := 2; -- "001"
			ElsIf (YDiff < 0) Then
				PhyChAssigned := 1; -- "010"
			ElsIf (YDiff > 0) Then
				PhyChAssigned := 3; -- "011"
			Else
				PhyChAssigned := 4; -- "100"       ejection ch	--2**PhyRoChAddr-1; --"111" ejection ch
			End If;	
			OutPackPhCh := PhyChAssigned;
			-- ============ Virtual Channel Selection
			IsInpChAssigned := '0';
			OutPackViCh := -1;
			For j In 0 To ViCh-1 Loop --loop vi outp ch
				Ind := PhyChAssigned*ViCh+j;
				If (IsOutpChBusy(Ind)='0') And (IsInpChAssigned='0') Then
					IsInpChAssigned := '1';
					OutPackViCh := j;
				End If;
			End Loop;	
			InpChAssigned := IsInpChAssigned;
			-- =========== Preparing the data to be wriiten in the packet
			CombinedDataOut := X"AC";
	end;

		Procedure RoutingMechanism(	
									PackOutPhChOut	: Out UnsignedArr3(PhyRoCh*ViCh-1 downto 0); -- Array of inp channel and coresponding output ch
									PackOutViChOut	: Out UnsignedArrVCA(PhyRoCh*ViCh-1 downto 0);
									InpChAssignedOut: Out Unsigned(PhyRoCh*ViCh-1 downto 0);
									CmbDataOut		: Out SignedArrDW(PhyRoCh*ViCh-1 downto 0);
									OutpChBusyOut 	: Out Unsigned(PhyRoCh*ViCh-1 downto 0);
									Reset			: Std_Logic;
									InpChAssigned	: Unsigned(PhyRoCh*ViCh-1 downto 0);
									OutpChBusy 		: Unsigned(PhyRoCh*ViCh-1 downto 0);
									CurNode			: Integer;
									Receiver		: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
									ExtData			: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
									CmbData			: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
									ValidHeader		: Unsigned(PhyRoCh*ViCh-1 downto 0);
									PackOutPhCh		: UnsignedArr3(PhyRoCh*ViCh-1 downto 0); -- Array of inp channel and coresponding output ch
									PackOutViCh		: UnsignedArrVCA(PhyRoCh*ViCh-1 downto 0);
									ValidPack		: Unsigned(PhyRoCh*ViCh-1 downto 0);
									PreValidPack	: Unsigned(PhyRoCh*ViCh-1 downto 0)) Is
		Variable PhChAssigned : Integer;
		Variable ViChAssigned : Integer;
		Variable Ind : Integer;
		Variable CombinedDataOut : Unsigned(DataWidth-1 downto 0);
		Variable IsInpChAssigned : Std_Logic;
		Variable OutpChBusyVar 	: Unsigned(PhyRoCh*ViCh-1 downto 0);
		begin
				If (Reset='1') Then	
					CmbDataOut 		:= (Others=>X"00");	
					InpChAssignedOut:= (Others=>'0');
					PackOutPhChOut 	:= (Others=>(Others=>'0'));
					PackOutViChOut 	:= (Others=>(Others=>'0'));
					OutpChBusyOut 	:= (Others=>'0');
				Else
					OutpChBusyVar := OutpChBusy;
					OutpChBusyOut := OutpChBusy;
					InpChAssignedOut := InpChAssigned;
					PackOutPhChOut := PackOutPhCh;				
					PackOutViChOut := PackOutViCh;	
					CmbDataOut := CmbData;
					For i In 0 To PhyRoCh*ViCh-1 Loop --loop on all ph+vi inp ch
						If (InpChAssigned(i)='0' And ValidHeader(i)='1') Then				
							RoutingFunc(PhChAssigned, ViChAssigned, IsInpChAssigned, CombinedDataOut, OutpChBusyVar, To_Unsigned(CurNode,DataWidth), Unsigned(Receiver(i)),Unsigned(ExtData(i)));
							-- bug res: OutpChBusy is used for a single clock with 2 inp pack 
							If (IsInpChAssigned='1') Then
								Ind := PhChAssigned*ViCh + ViChAssigned;
								PackOutPhChOut(i) := To_Unsigned(PhChAssigned,PhyRoChAddr);
								PackOutViChOut(i) := To_Unsigned(ViChAssigned,ViChAddr);
								CmbDataOut(i) := Signed(CombinedDataOut);		
								OutpChBusyVar(Ind) := '1'; -- because of, use in loop
								OutpChBusyOut(Ind) := '1';
								InpChAssignedOut(i) := '1';
							End If;
						ElsIf (InpChAssigned(i)='1' And PreValidPack(i)='1' And ValidPack(i)='0') Then
							-- bug fixed: 2 pack were sticky in dest.
							Ind := To_Integer(PackOutPhCh(i)*ViCh + PackOutViCh(i));
							InpChAssignedOut(i) := '0';
							OutpChBusyVar(Ind) := '0'; -- should be with each other, because of use in loop
							OutpChBusyOut(Ind) := '0';
							-- bug fixed: PackOutPhCh and PackOutViCh become 0 soon in switch use
						End If;
					End Loop;			
				End If;	
		end;

end;





