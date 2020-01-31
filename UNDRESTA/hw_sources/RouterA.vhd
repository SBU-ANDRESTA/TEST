library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity FIFO is--a320
	generic(InAddrLen: integer :=10;
			OutDataLen: integer :=4;
			Out2InAddrLen: integer :=3
			);
	port (	Clock: in std_logic;
			Reset: in std_logic;
			Write: in std_logic;
			Read: in std_logic;
			Input : in unsigned(OutDataLen*(2**Out2InAddrLen)-1 downto 0);
			Output : out unsigned(OutDataLen-1 downto 0);
			DataValid : out std_logic;
			Empty : out std_logic;
			Full : out std_logic
		);
end entity;


architecture behavioral of FIFO is
	
	constant InDataLen : integer := OutDataLen*(2**Out2InAddrLen);
	
	type MemType is array (2**InAddrLen-1 downto 0) of Unsigned(InDataLen-1 downto 0) ;
	signal Mem : MemType;	--For Faster Synthesis
	
	signal WriteAddr : unsigned(InAddrLen-1 downto 0);
	signal ReadAddr : unsigned(InAddrLen+Out2InAddrLen-1 downto 0);
	
	signal ReadMAddr : unsigned(InAddrLen-1 downto 0);
	signal ReadBSel : integer range 2**Out2InAddrLen-1 downto 0;
	
	signal EmptyFlag : std_logic;
	signal FullFlag : std_logic;

begin

	Empty <= EmptyFlag;
	Full <= FullFlag;
	
	ReadMAddr <= ReadAddr(InAddrLen+Out2InAddrLen-1 downto Out2InAddrLen);
	ReadBSel <= to_integer(ReadAddr(Out2InAddrLen-1 downto 0));
	
	FullFlag <= '1' when ReadMAddr=(WriteAddr+1) else '0';
	EmptyFlag <= '1' when ReadMAddr=WriteAddr else '0';
	
	fifo: process (Clock)
		--variable Mem : MemType; -- For Faster Simulation
	begin
		if(rising_edge(Clock)) then
			
			DataValid <= '0';
			
			if(Reset='1') then
				ReadAddr <= (others=>'0');
				WriteAddr <= (others=>'0');
			else
				if (Write='1' and FullFlag='0') then
					
					--Mem(WriteAddr) := Input; -- For Faster Simulation
					Mem(to_integer(WriteAddr)) <= Input;
					WriteAddr <= WriteAddr +1;
				end if;
				
				if (Read='1' and EmptyFlag='0') then

					Output <= Mem(to_integer(ReadMAddr))(OutDataLen*(ReadBSel+1)-1 downto OutDataLen*ReadBSel);
					ReadAddr <= ReadAddr +1;
					DataValid <= '1';
				end if;

			end if;
		end if;
	end process;

end;


Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.NUMERIC_STD.All;

Use Work.ConnectionPack.All;

entity Combiner is --a321
	generic(
		offset	: Integer := 1
	);
	port(
		Clk			: In  std_logic;
		Reset		: In  std_logic;
		PackCounter : In  Unsigned(PackWidth-1 Downto 0);		
		CmbData		: In  Signed(DataWidth-1 Downto 0);
		InpData		: In  Signed(DataWidth-1 Downto 0);
		InpEn		: In  Std_Logic;
		InpReady	: Out Std_Logic;
		OutpData	: Out Signed(DataWidth-1 Downto 0);
		OutpEn		: Out Std_Logic;
		OutpReady	: In  Std_Logic
	);
End;


Architecture behavioral of Combiner is
Begin
		
	OutpData 	<= CmbData When (PackCounter = offset) Else InpData;
	InpReady 	<= OutpReady;
	OutpEn 		<= InpEn;
	
End;




Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.NUMERIC_STD.All;

Use Work.ConnectionPack.All;

entity DeMux is --a322
	generic(
		DataWidth	: Integer := 8;
		ViChAddr	: Integer := 1;
		ViCh		: Integer := 2 -- 2**ViChAddr
	);
	port(
		Clk			: In  std_logic;
		Reset		: In  std_logic;
		Sel			: In  Unsigned(ViChAddr-1 Downto 0);
		
		InpData		: In  Signed(DataWidth-1 downto 0); 
		InpEn		: In  Std_Logic;
		InpReady	: Out Unsigned(ViCh-1 downto 0); --Std_Logic;

		OutpData	: Out SignedArrDW(ViCh-1 downto 0); --? DataWidth=8
		OutpEn		: Out Unsigned(ViCh-1 downto 0);
		OutpReady	: In  Unsigned(ViCh-1 downto 0)	
	);
End;


Architecture behavioral of DeMux is

Begin
--	Process(Sel,Reset,OutpReady)
--	Variable Tmp : Integer;
--	Begin
--		If (Reset='1') Then
--		Else	
--			For i In 0 To ViCh-1 Loop  
--				Full(i) <= '0';
--			End Loop;	
--		End If;	
--	End Process;

	Process(Sel,Reset,OutpReady,InpData,InpEn)
	Begin
		If (Reset='1') Then
			InpReady <= (Others=>'0');
			OutpData <= (Others=>(Others=>'0'));
			OutpEn <= (Others=>'0');
		Else	
			For i In 0 To ViCh-1 Loop  
				InpReady(i) <= OutpReady(i);
				OutpData(i) <= (Others=>'0');
				OutpEn(i) <= '0';
				If (Sel=i) Then
					OutpData(i) <= InpData;
					OutpEn(i) <= InpEn;
				End If;
			End Loop;	
		End If;	
	End Process;
	
--	Process (Clk)
--	Begin
--		If (Rising_Edge(Clk)) Then
--			If (Reset='1') Then
--				OutpData <= (Others=>(Others=>'0'));
--				OutpEn <= (Others=>'0');
--				--InpReady <= '0';
--			Else
--				For i In 0 To ViCh-1 Loop 
--					InpReady(i) <= OutpReady(i) Or ( Not Full(i));
--					If (Sel=i) Then
--						OutpData(i) <= InpData;
--						OutpEn(i) <= InpEn;
--						--InpReady <= OutpReady(i);
--					Else	
--						OutpData(i) <= (Others=>'0');
--						OutpEn(i) <= '0';
--					End If;
--				End Loop;	
--			End If;	
--		End If;			
--	End Process;
End;






 Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.NUMERIC_STD.All;

Use Work.ConnectionPack.All;

entity Reservator is --a323
	generic(
		--RoChAddr		: Integer := 1;
		--PhyChAddr		: Integer := 2;
		ViChAddr		: Integer := 1;
		PhyRoChAddr		: Integer := 2+1;
		CurNode			: Integer := 0;
		--
		--RoCh			: Integer := 1;
		--PhyCh			: Integer := 4;
		ViCh			: Integer := 1;
		PhyRoCh			: Integer := 4+1
	);
	port(
		Clk				: In  std_logic;
		Reset			: In  Std_logic;
		Receiver		: In  SignedArrDW(PhyRoCh*ViCh-1 downto 0);
		ExtData			: In  SignedArrDW(PhyRoCh*ViCh-1 downto 0);
		ValidPack		: In  Unsigned(PhyRoCh*ViCh-1 downto 0);
		ValidHeader		: In  Unsigned(PhyRoCh*ViCh-1 downto 0);

		PackOutPhCh		: Buffer UnsignedArr3(PhyRoCh*ViCh-1 downto 0); -- Array of inp channel and coresponding output ch
		PackOutViCh		: Buffer UnsignedArrVCA(PhyRoCh*ViCh-1 downto 0);
		InpChAssigned	: Buffer Unsigned(PhyRoCh*ViCh-1 downto 0);
		OutpChBusy		: Buffer Unsigned(PhyRoCh*ViCh-1 downto 0);
		CmbData			: Buffer SignedArrDW(PhyRoCh*ViCh-1 downto 0)
	);
End;


Architecture behavioral of Reservator is
Signal PreValidPack : Unsigned(PhyRoCh*ViCh-1 downto 0);
Begin

	Process (Clk)
	Variable	VarPackOutPhCh	: UnsignedArr3(PhyRoCh*ViCh-1 downto 0); -- Array of inp channel and coresponding output ch
	Variable	VarPackOutViCh	: UnsignedArrVCA(PhyRoCh*ViCh-1 downto 0);
	Variable	VarInpChAssigned: Unsigned(PhyRoCh*ViCh-1 downto 0);
	Variable	VarCmbData		: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
	Variable	VarOutpChBusy	: Unsigned(PhyRoCh*ViCh-1 downto 0);
	Begin
		If (Rising_Edge(Clk)) Then	
			PreValidPack <= ValidPack;					
			RoutingMechanism(	
							VarPackOutPhCh	,
							VarPackOutViCh	,
							VarInpChAssigned,
							VarCmbData		,
							VarOutpChBusy	,
							Reset			,
							InpChAssigned	,
							OutpChBusy 		,
							CurNode			,
							Receiver		,
							ExtData			,
							CmbData			,
							ValidHeader		,
							PackOutPhCh		,
							PackOutViCh		,
							ValidPack		,
							PreValidPack	);
		
		PackOutPhCh	  <=    VarPackOutPhCh	  ;
		PackOutViCh	  <=    VarPackOutViCh	  ;
		InpChAssigned <=    VarInpChAssigned  ;
		CmbData		  <=    VarCmbData		  ;
		OutpChBusy	  <=    VarOutpChBusy	  ;
		
		End If;			
	End Process;
End;



Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.NUMERIC_STD.All;

Use Work.ConnectionPack.All;

entity Selector is --a324
	generic(
		ViChAddr	: Integer := 1;
		ViCh		: Integer := 2 -- 2**ViChAddr
	);
	port(
		Clk			: In  std_logic;
		Reset		: In  std_logic;
		Sel			: Buffer Unsigned(ViChAddr-1 Downto 0):=(Others=>'0');
		InpEn		: In  Unsigned(ViCh-1 downto 0);
		OutpReady	: In  Unsigned(ViCh-1 downto 0) --Std_Logic
	);
End;


Architecture behavioral of Selector is
Signal Flag : Unsigned(2 Downto 0);
Begin
	--Sel <= (Others=>'0');
	
	Process (Clk)
	Variable Assigned : Std_Logic;
	Variable SelV : Integer;
	Begin
	
		If (Rising_Edge(Clk)) Then
			If (Reset='1') Then
				Sel <= (Others=>'0');
				Flag <= (Others=>'0');
			Else
				If (InpEn(To_Integer(Sel))='0') Or (OutpReady(To_Integer(Sel))='0')  Then
					Sel <= Sel+1;
					If (sel=ViCh-1) Then
						sel <= (Others=>'0');
					End If;						
				End If;	
			End If;
		End If;


--		If (Rising_Edge(Clk)) Then
--			Sel <= Sel+1;
--		End If;

------------------------------------------

--		If (Rising_Edge(Clk)) Then
--			If (Reset='1') Then
--				Sel <= (Others=>'0');
--				Flag <= (Others=>'0');
--			Else
--				--If (InpEn(To_Integer(Sel))='0') Or (OutpReady(To_Integer(Sel))='0')  Then
--				If (InpEn(To_Integer(Sel))='0') Then
--					Flag <= Flag+1;
--				End If;
--				If (Flag>=3) And (InpEn(To_Integer(Sel))='0') Then
--					Flag <= (Others=>'0');
--					Assigned:='0';
--					Sel <= (Others=>'Z');
--					For i In 1 To ViCh-1 Loop 
--						SelV:= 0;--To_Integer(Sel)+i;
--						--If (SelV>ViCh-1) Then
--						--	SelV := SelV - ViCh;
--						--End If;	
--						If (OutpReady(SelV)='1') And (Assigned='0') Then	
--							Sel<=To_Unsigned(SelV,ViChAddr);
--							Assigned:='1';
--						End If;
--					End Loop;
--				End If;	
--			End If;	
--		End If;			
	End Process;
End;


Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.NUMERIC_STD.All;

Use Work.ConnectionPack.All;

entity Switch is --a325
	generic(
		DataWidth	: Integer := 8;
		PhyCh		: Integer := 4;
		ViCh		: Integer := 1;
		RoCh 		: Integer := 1;
		PhyRoCh		: Integer := 4+1
	);
	port(
		Clk			: In  std_logic;
		Reset		: In  std_logic;
		
		InpData		: In  SignedArrDW(PhyRoCh*ViCh-1 downto 0); --? DataWidth=8
		InpEn		: In  Unsigned(PhyRoCh*ViCh-1 downto 0);
		InpReady	: Buffer Unsigned(PhyRoCh*ViCh-1 downto 0);

		OutpData	: Out SignedArrDW(PhyRoCh*ViCh-1 downto 0); --? DataWidth=8
		OutpEn		: Buffer Unsigned(PhyRoCh*ViCh-1 downto 0);
		OutpReady	: In  Unsigned(PhyRoCh*ViCh-1 downto 0);
		
		PackOutPhCh	: In UnsignedArr3(PhyRoCh*ViCh-1 downto 0); -- Array of inp channel and coresponding output ch
		PackOutViCh	: In UnsignedArrVCA(PhyRoCh*ViCh-1 downto 0);
		InpChAssigned	: In Unsigned(PhyRoCh*ViCh-1 downto 0)
	);
End;


Architecture behavioral of Switch is
Signal Flag:Unsigned(PhyRoCh*ViCh-1 Downto 0);
Begin

	-- bug: Process(InpChAssigned,InpEn,OutpReady)
	Process(InpChAssigned,InpEn,OutpReady,OutpEn,PackOutPhCh,PackOutViCh)
	Variable Tmp : Integer;
	Begin
		If (Reset='1') Then
			InpReady <= (Others=>'0');
		Else	
			For i In 0 To PhyRoCh*ViCh-1 Loop --loop on all ph+vi Inp ch 
				Tmp := To_Integer(PackOutPhCh(i)*ViCh+PackOutViCh(i));
				----InpReady(i) <= InpChAssigned(i) And InpEn(i) And OutpReady(Tmp); 
				--InpReady(i) <= InpChAssigned(i) And OutpReady(Tmp); 
				InpReady(i) <= InpChAssigned(i) And ((Not OutpEn(Tmp)) Or OutpReady(Tmp)); 
			End Loop;	
		End If;	
	End Process;
	
	Process (Clk)
	Variable Tmp : Integer;
	Begin
		If (Rising_Edge(Clk)) Then
			If (Reset='1') Then
				OutpEn <= (Others=>'0');
				Flag <= (Others=>'0');
				OutpData <= (Others=>(Others=>'0'));
			Else
			
			
				For i In 0 To PhyRoCh*ViCh-1 Loop --loop on all ph+vi outp ch 
					--If (OutpReady(i)='1') And (Flag(i)='1') Then
					If (OutpReady(i)='1') Then
						OutpEn(i) <= '0';					
						OutpData(i) <= (Others => 'Z');
						Flag(i) <= '0';
					End If;
				End Loop;	

				For i In 0 To PhyRoCh*ViCh-1 Loop --loop on all ph+vi Inp ch 
					Tmp := To_Integer(PackOutPhCh(i)*ViCh+PackOutViCh(i));
					If ((InpEn(i)='1') And (InpReady(i)='1')) Then
						OutpEn(Tmp) <= '1';
						OutpData(Tmp) <= InpData(i);
						--Flag(i) <= '1';
						Flag(Tmp) <= '1';
					--Elsif (OutpReady(Tmp)='1') And (Flag(i)='1') Then
					--	OutpEn(Tmp) <= '0';					
					--	OutpData(Tmp) <= (Others => 'Z');
					--	Flag(i) <= '0';
					End If;
				End Loop;	
			End If;	
		End If;			
	End Process;
End;



Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.NUMERIC_STD.All;

Use Work.ConnectionPack.All;

entity AddressExt is --a326
	generic(
		PackWidth	: Integer := 8;
		DataWidth	: Integer := 8;
		CorWidth	: Integer := 4;
		Delay		: Integer := 2;
		--X			: Integer := 0;
		--Y			: Integer := 0;
		CurNode		: Integer := 0
		);
	port(
		Clk			: In  std_logic;
		Reset		: In Std_Logic;
		
		InpData		: In  signed(DataWidth-1 downto 0);
		InpEn		: In  std_logic;
		InpReady	: Buffer  Std_Logic;

		OutpData	: Out signed(DataWidth-1 downto 0);
		OutpEn		: Buffer std_logic;		
		Receiver	: Out signed(DataWidth-1 downto 0);
		ExtData		: Out signed(DataWidth-1 downto 0);
		ValidPack	: Buffer Std_Logic;
		OutpReady	: In Std_Logic;
		ValidHeader : Out Std_Logic;
		
		PackCounter : Out Unsigned(PackWidth-1 Downto 0)

	);
End;


Architecture behavioral of AddressExt is

--Type SignedArr is array (natural range <>) of Signed(DataWidth-1 Downto 0);
Signal PackCounterInp : Unsigned(PackWidth-1 Downto 0):=(Others=>'0');
Signal PackCounterOut : Unsigned(PackWidth-1 Downto 0):=(Others=>'0');
Signal Full, Empty, Write, Read, ValidSize, ValidPackInp, ValidPackInpPre, ValidPackOut, OutpE : Std_Logic:='0';
Signal PackSize : Unsigned(PackWidth-1 Downto 0):=(Others=>'0');
Signal OData	: Unsigned(DataWidth-1 downto 0);
Signal ValidHeaderDown : Std_Logic;
Signal Flag,OrFlag,PreOutpReady,LastPhitMiss: Std_Logic;
Begin

	PackCounter <= PackCounterOut;
	c1: entity work.Fifo
		generic map(
				InAddrLen 		=> 3, 		
				OutDataLen 		=> DataWidth, 		
				Out2InAddrLen	=> 0	
						)
				port map(	
						Clock 		=> Clk,
						Reset		=> Reset,
						Write		=> Write,
						Read		=> Read,
						Input		=> Unsigned(InpData),
						Output		=> OData,
						DataValid	=> OutpE,
						Empty	 	=> Empty,
						Full	 	=> Full
		);
		

	-- new bug InpReady <= Not Full;
	InpReady <= (Not Full) When ((PackCounterInp/=PackSize) Or (ValidSize='0')) Else '0';
	-- new bug Write <= InpEn And (Not Full);
	Write <= InpEn And InpReady;
	--------Read <= OutpReady And (Not Empty);-- for delay amy be used
	--------Read <= (OutpReady And (Not Flag)) And (Not Empty);-- for delay amy be used
	--------bug
	
	--Read <= (OutpReady And (Not Flag)) And (Not Empty) When (PackCounterOut/=PackSize-1) Else '0';-- for delay amy be used
	-- bug bug
	-- Read <= OutpReady And (Not Empty) When (PackCounterOut/=PackSize-1) Else '0';-- for delay amy be used
	--- bug bug
	Read <= OutpReady And (Not Empty) When ((PackCounterOut/=PackSize-1) or (LastPhitMiss='1')) Else '0';-- for delay amy be used
	
	--
	OutpData <= Signed(OData);

	--OutpEn <= OutpE; 
	--bug---
	OutpEn <= OutpE Or OrFlag; 
	--
	ValidPack <= ValidPackOut Or OutpE; -- because of first clock phit data output 
	ValidHeader <= ValidHeaderDown ;
	-----bug resolve1
	process (Clk)
	Begin
		If (Rising_Edge(Clk)) Then
			If (Reset='1') Then
				Flag <='0';
				--OrFlag <= '0';
			Else	
				PreOutpReady <= OutpReady;
				--OrFlag <= '0';
				--If (PreOutpReady='1') And (OutpReady='0') And (PackCounterOut/=0) Then
				If (PreOutpReady='1') And (OutpReady='0') And (OutpE='1') Then
					Flag <= '1';
				Elsif (PreOutpReady='0') And (OutpReady='1') And (Flag='1') Then
					Flag <= '0';
				--	OrFlag <= '1';
				End If;
			End If;	
		End If;
	End Process;
	OrFlag <= (Not PreOutpReady) And OutpReady And Flag;
	-----
	process (Clk)
	Begin
		If (Rising_Edge(Clk)) Then
			ValidPackInpPre <= ValidPackInp;
			If (ValidPackInp='0' And ValidPackInpPre='1') Then
				ValidHeaderDown <= '0';
				--ValidSize <= '0';
			End If;	
			If (Reset='1') Then
				PackCounterInp <= (Others=>'0');
				ValidPackInp <= '0';
				ValidSize <= '0';
				ValidHeaderDown <= '0';
			-- new bug Elsif (InpEn='1' And Full='0') Then
			Elsif (InpEn='1' And InpReady='1') Then
				PackCounterInp <= PackCounterInp+1;
				
				--- 
				If (PackCounterInp>=PackSize And ValidSize='1') Then --?
					PackCounterInp <= To_Unsigned(0,PackWidth);	
				
				Elsif (PackCounterInp=0)  Then
				---
				
				--If ((PackCounterInp=0) Or (PackCounterInp>=PackSize And ValidSize='1')) Then
					PackCounterInp <= To_Unsigned(1,PackWidth);	
					-- 05, Aug 2006 topology globalization by D.R.	
					-- XDiff <= InpData(CorWidth-1 Downto 0) - X;
					Receiver <= InpData;
					ValidPackInp <= '1';
					ValidSize <= '0'; --?
					ValidHeaderDown <= '0'; --?
				Elsif (PackCounterInp=1) Then
					ExtData <= InpData;
				Elsif (PackCounterInp=2) Then
					PackSize <= Unsigned(InpData(PackWidth-1 Downto 0));
					ValidSize<='1';
					ValidHeaderDown <= '1';
				Elsif (PackCounterInp=PackSize-1  And ValidSize='1') Then -- last phit 
					ValidPackInp <= '0';
				End If;
			Elsif (PackCounterInp>=PackSize And ValidSize='1') Then
					PackCounterInp <= (Others=>'0');
					-- pack finished
			End If;
				
			--If ((PackCounterInp=0) Or (PackCounterInp>=PackSize And ValidSize='1')) Then
			--		ValidSize <= '0';
			--		ValidHeader <= '0';
			--End If;
			
			If (Reset='1') Then
				PackCounterOut <= (Others=>'0');
				ValidPackOut <= '0';
			-- bug count: Elsif (OutpE='1') Then
			Elsif (OutpEn='1') Then
				If (OutpReady='1') Then 
				--If (OutpReady='1') And (Read='1')  Then
					PackCounterOut <= PackCounterOut+1;
					-- bug bug
					If(PackCounterOut=PackSize-2) And (Read='0') Then
						LastPhitMiss <= '1'; 
					End If;
					--- bug bug
				End If;	
				------------If ((PackCounterOut=0) Or (PackCounterOut>=PackSize And ValidSize='1')) Then
				--If ((PackCounterOut=0) Or (PackCounterOut>=PackSize )) Then
				If (PackCounterOut=0) Then
					-- bug bug
					LastPhitMiss <= '0';
					--- bug bug
					--PackCounterOut <= To_Unsigned(1,PackWidth);
					ValidPackOut <= '1';
				-------------Elsif (PackCounterOut=PackSize-1  And ValidSize='1') Then -- last phit 
				-- bug Elsif (PackCounterOut>=PackSize-1) Then -- last phit 
				Elsif (PackCounterOut>=PackSize-1)And (OutpReady='1') Then -- last phit 
					ValidPackOut <= '0';
					PackCounterOut <= (Others=>'0');
				End If;
			Elsif (PackCounterOut>=PackSize And ValidSize='1') Then
					PackCounterOut <= (Others=>'0');
			End If;
		End If;			
	End Process;
End;


Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.NUMERIC_STD.All;

Use Work.ConnectionPack.All;

entity Mux is --a327
	generic(
		DataWidth	: Integer := 8;
		ViChAddr	: Integer := 1;
		ViCh		: Integer := 2 -- 2**ViChAddr
	);
	port(
		Clk			: In  std_logic;
		Reset		: In  std_logic;
		Sel			: Buffer Unsigned(ViChAddr-1 Downto 0);
		
		InpData		: In  SignedArrDW(ViCh-1 downto 0); --? DataWidth=8
		InpEn		: In  Unsigned(ViCh-1 downto 0);
		InpReady	: Out Unsigned(ViCh-1 downto 0);	

		OutpData	: Out Signed(DataWidth-1 downto 0); 
		OutpEn		: Out Std_Logic;
		OutpReady	: In  Unsigned(ViCh-1 downto 0) --Std_Logic
	);
End;


Architecture behavioral of Mux is
Signal Sel_Int : Unsigned(ViChAddr-1 Downto 0);
Begin

	Process(Sel_Int,Reset,OutpReady)
	Variable Tmp : Integer;
	Begin
		If (Reset='1') Then
			InpReady <= (Others=>'0');
		Else	
			For i In 0 To ViCh-1 Loop  
				InpReady(i) <= '0';
				If (Sel_Int=i) Then
					InpReady(i) <= OutpReady(i);
				End If;
			End Loop;	
		End If;	
	End Process;
	
	Process (Sel_Int,Reset,OutpReady,InpEn,InpData)
	Begin
		If (Reset='1') Then
			OutpData <= (Others=>'0');
			OutpEn <= '0';
		Else
			OutpData <= (Others=>'Z');
			OutpEn <= '0';						
			For i In 0 To ViCh-1 Loop
--				If (Sel_Int=i) And (InpEn(i)='1') And (OutpReady(i)='1')Then
				If (Sel_Int=i) And (InpEn(i)='1') Then
					OutpData <= InpData(i);
					OutpEn <= '1';			
				End If;
			End Loop;	
		End If;
	End Process;
	Sel <= Sel_Int;

--	Process (Clk)
--	Variable PreInd : Integer:=0;
--	Begin
--		If (Rising_Edge(Clk)) Then
--			If (Reset='1') Then
--				OutpData <= (Others=>'0');
--				OutpEn <= '0';
--				Sel <= (Others=>'0');
--			Else
--				Sel <= Sel_Int;
--				OutpData <= (Others=>'Z');
--				OutpEn <= '0';						
--				For i In 0 To ViCh-1 Loop
--					If (Sel_Int=i) And (InpEn(i)='1') Then
--						OutpData <= InpData(i);
--						OutpEn <= '1';			
--					End If;
--				End Loop;	
--			End If;
--		End If;			
--	End Process;
	
	c1:Entity Work.Selector 
		Generic Map(
			ViChAddr	,
			ViCh		
		)
		Port Map(
			Clk			,
			Reset		,
			Sel_Int		,
			InpEn		,
			OutpReady	
	);
End;



Library IEEE;
Use IEEE.STD_LOGIC_1164.All;
Use IEEE.NUMERIC_STD.All;

Use Work.ConnectionPack.All;

entity Router is
	generic(
		ViChAddr	: Integer := 1;
		PhyRoChAddr	: Integer := 2+1;
		--
		PhyCh		: Integer := 3;
		ViCh		: Integer := 1;
		RoCh 		: Integer := 1;
		PhyRoCh		: Integer := 3+1;
		--
		PackWidth	: Integer := 8;
		DataWidth	: Integer := 8;
		CorWidth	: Integer := 4;
		--
		--X			: Integer := 0;
		--Y			: Integer := 0;
		CurNode		: Integer := 0
	);
	Port(
		Clk				: In  std_logic;
		Reset			: In  std_logic;

		InpData			: In  SignedArrDW(PhyRoCh-1 downto 0); --? 8+2
		InpEn			: In  Unsigned(PhyRoCh-1 downto 0);
		InpReady		: Out Unsigned(PhyRoCh*ViCh-1 downto 0);
		InpSel			: In  UnsignedArrVCA(PhyRoCh-1 downto 0); -- ? ViChAddr=1

		OutpData		: Out SignedArrDW(PhyRoCh-1 downto 0); --? 8+2
		OutpEn			: Out Unsigned(PhyRoCh-1 downto 0);
		OutpReady		: In  Unsigned(PhyRoCh*ViCh-1 downto 0);
		OutpSel			: Out UnsignedArrVCA(PhyRoCh-1 downto 0) -- ? ViChAddr=1
	);
End;


Architecture behavioral of Router is

Signal	DeMuxOutpData	: SignedArrDW(PhyRoCh*ViCh-1 downto 0); --? 8+2
Signal	DeMuxOutpEn		: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	DeMuxOutpReady	: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	ExtOutpData		: SignedArrDW(PhyRoCh*ViCh-1 downto 0); --? 8+2
Signal	ExtOutpEn		: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	ExtOutpReady	: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	CmbOutpData		: SignedArrDW(PhyRoCh*ViCh-1 downto 0); --? 8+2
Signal	CmbOutpEn		: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	CmbOutpReady	: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	ReceiverArr		: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
Signal	ExtDataArr		: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
Signal	ValidPackArr	: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	ValidHeaderArr	: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	PackOutPhChArr	: UnsignedArr3(PhyRoCh*ViCh-1 downto 0); 
Signal	PackOutViChArr	: UnsignedArrVCA(PhyRoCh*ViCh-1 downto 0);
Signal 	InpChAssignedArr: Unsigned(PhyRoCh*ViCh-1 downto 0);	

Signal	OutpDataArr		: SignedArrDW(PhyRoCh*ViCh-1 downto 0); --? 8+2
Signal	OutpEnArr		: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal	OutpReadyArr	: Unsigned(PhyRoCh*ViCh-1 downto 0);
Signal 	CmbDataArr		: SignedArrDW(PhyRoCh*ViCh-1 downto 0);
Signal 	PackCounterArr	: UnsignedArrPW(PhyRoCh*ViCh-1 downto 0);

Begin

rg1: For i in 0 to PhyRoCh*ViCh-1 Generate

r1:Entity Work.AddressExt 
	Generic Map(
		PackWidth	=> PackWidth	,
		DataWidth	=> DataWidth	,
		CorWidth	=> CorWidth		,
		Delay		=> 2			,
		CurNode		=> CurNode	
		--Y			=> Y						
	)
	Port Map(
		Clk			=> Clk			,	
		Reset		=> Reset		,	
					
		InpData		=> DeMuxOutpData(i)	,	
		InpEn		=> DeMuxOutpEn(i)	,	
		InpReady	=> DeMuxOutpReady(i),	

		OutpData	=> ExtOutpData(i)	,	
		OutpEn		=> ExtOutpEn(i)	,			
		Receiver	=> ReceiverArr(i)		,	
		ExtData		=> ExtDataArr(i)		,		
		ValidPack	=> ValidPackArr(i)	,	
		OutpReady	=> ExtOutpReady(i)	,	
		ValidHeader	=> ValidHeaderArr(i),
		PackCounter => PackCounterArr(i)
	);


rc:Entity Work.Combiner 
	Generic Map(
		offset	=> 1	
	)
	Port Map(
		Clk			=> Clk					,	
		Reset		=> Reset				,	
		PackCounter => PackCounterArr(i)	,			
		CmbData		=> CmbDataArr(i)		,
		InpData		=> ExtOutpData(i)		,
		InpEn		=> ExtOutpEn(i)			,
		InpReady	=> ExtOutpReady(i)		,
		OutpData	=> CmbOutpData(i)		,
		OutpEn		=> CmbOutpEn(i)			,
		OutpReady	=> CmbOutpReady(i)	
	);
	
End Generate;	

r2:Entity Work.Reservator 
	Generic Map(
		--RoChAddr		=> --RoChAddr		,
		--PhyChAddr		=> --PhyChAddr		,
		ViChAddr		=> ViChAddr			,
		PhyRoChAddr		=> PhyRoChAddr		,
		--				   --
		CurNode			=> CurNode			,
		--RoCh			=> --RoCh			,
		--PhyCh			=> --PhyCh			,
		ViCh			=> ViCh				,
		PhyRoCh			=> PhyRoCh			
	)
	Port Map(
		Clk				=> Clk				,
		Reset			=> Reset			,
		Receiver		=> ReceiverArr		,
		ExtData			=> ExtDataArr		,
		ValidPack		=> ValidPackArr		,
		ValidHeader		=> ValidHeaderArr	,

		PackOutPhCh		=> PackOutPhChArr	,
		PackOutViCh		=> PackOutViChArr	,
		InpChAssigned	=> InpChAssignedArr	,
		OutpChBusy		=> Open				,
		CmbData			=> CmbDataArr	

	);
	
r3:	Entity Work.Switch 
		Generic Map(
			DataWidth	=> DataWidth	,
			PhyCh		=> PhyCh		,
			ViCh		=> ViCh			,
			RoCh 		=> RoCh 		,
			PhyRoCh		=> PhyRoCh		
		)
		Port Map(
			Clk				=>	Clk				,
			Reset			=>	Reset			,
												
			InpData			=>	CmbOutpData		,
			InpEn			=>	CmbOutpEn		,
			InpReady		=>	CmbOutpReady	,
		
			OutpData		=>	OutpDataArr		 ,
			OutpEn			=>	OutpEnArr		 ,
			OutpReady		=>	OutpReadyArr	 ,
						
			PackOutPhCh		=>	PackOutPhChArr	  ,
			PackOutViCh		=>	PackOutViChArr	  ,
			InpChAssigned	=>	InpChAssignedArr  
	);

rg2: For j in 0 to PhyRoCh-1 Generate	
	
r4:Entity Work.Mux 
	Generic Map(
		DataWidth	=>  DataWidth	,
		ViChAddr	=> 	ViChAddr	,
		ViCh		=> 	ViCh		 -- 2**ViChAddr
	)
	Port Map(
		Clk			=>	 	Clk		   						,
		Reset		=>	 	Reset	   						,
		Sel			=>	 	OutpSel(j)	   						,
		
		InpData		=>	 	OutpDataArr(j*ViCh+ViCh-1 Downto j*ViCh) 	,
		InpEn		=>	 	OutpEnArr(j*ViCh+ViCh-1 Downto j*ViCh)	  	,
		InpReady	=>	 	OutpReadyArr(j*ViCh+ViCh-1 Downto j*ViCh)	,

		OutpData	=>	 	OutpData(j)						,
		OutpEn		=>	 	OutpEn(j)  						,
		OutpReady	=>	 	OutpReady(j*ViCh+ViCh-1 Downto j*ViCh)  					
	);

End Generate;	
	
rg3: For k in 0 to PhyRoCh-1 Generate	
	
r5:Entity Work.DeMux 
	Generic Map(
		DataWidth	=>	 DataWidth	,
		ViChAddr	=>	 ViChAddr	,
		ViCh		=>	 ViCh		 -- 2**ViChAddr
	)
	Port Map(
		Clk			=>	Clk			,
		Reset		=>	Reset		,
		Sel			=>	InpSel(k)	,
		
		InpData		=>	InpData(k)	, 
		InpEn		=>	InpEn(k)	,
		InpReady	=>	InpReady(k*ViCh+ViCh-1 Downto k*ViCh)	, 
													  
		OutpData	=>	DeMuxOutpData(k*ViCh+ViCh-1 Downto k*ViCh)		, 
		OutpEn		=>	DeMuxOutpEn(k*ViCh+ViCh-1 Downto k*ViCh)		,
		OutpReady	=>	DeMuxOutpReady(k*ViCh+ViCh-1 Downto k*ViCh)		
	);
End Generate;
	
End;