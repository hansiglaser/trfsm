library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.trfsmparts.all;
use work.trfsmpkg.all;
use work.tb_trfsmpkg.all;
use work.tbfuncs.all;

entity tb_trfsm is
  
end tb_trfsm;

architecture behavior of tb_trfsm is

  constant InputWidth      : integer range 1 to 256 := 10;
  constant OutputWidth     : integer range 1 to 256 := 7;
  constant StateWidth      : integer range 1 to   8 := 5;
  constant UseCurrentState : integer range 0 to   1 := 1;
  constant NumRows0        : integer                := 3;
  constant NumRows1        : integer                := 2;
  constant NumRows2        : integer                := 6;
  constant NumRows3        : integer                := 6;
  constant NumRows4        : integer                := 9;
  constant NumRows5        : integer                := 0;
  constant NumRows6        : integer                := 0;
  constant NumRows7        : integer                := 0;
  constant NumRows8        : integer                := 0;
  constant NumRows9        : integer                := 0;

  constant ConfigLength : integer := CalcTRFSMConfigLength(InputWidth,OutputWidth,StateWidth,UseCurrentState,NumRows0,NumRows1,NumRows2,NumRows3,NumRows4,NumRows5,NumRows6,NumRows7,NumRows8,NumRows9);
  
  -- Attention: don't make symmetric values because otherwise we can't find
  -- problems with the order

  constant CBS_S0_S1: std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "1010xxxxxx","00000","00001","1100110");
  constant CBS_S0_S2 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "1111xxxxxx","00000","00010","0011001");
  constant CBS_S0_S3 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "0000xxxxxx","00000","00011","0110011");
  constant CBS_S0_S0 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "!1010xxxxxx,1111xxxxxx,0000xxxxxx","00000","00000","1111111");

  constant CBS_S1_S6 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "1100xxxxxx","00001","00110","1111111");
  constant CBS_S1_S7 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "0011xxxxxx","00001","00111","1011101");
  constant CBS_S1_S1 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "!1100xxxxxx,0011xxxxxx","00001","00001","0111110");

  constant CBS_S2_S3 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,2,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,2,OutputWidth,
      "xxxx1xxxxx","00010","00011","1111000");
  constant CBS_S2_S5 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,3,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,3,OutputWidth,
      "xxxx0xxxxx","00010","00101","0001111");

  constant CBS_S3_S4 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,1,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,1,OutputWidth,
      "xxxxxxxxx1","00011","00100","1110001");
  constant CBS_S3_S5 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,1,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,1,OutputWidth,
      "xxxxxxxxx0","00011","00101","1100011");
    
  constant CBS_S4_S1 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,2,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,2,OutputWidth,
      "xx01xxxxxx","00100","00001","0111000");
  constant CBS_S4_S5 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,2,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,2,OutputWidth,
      "xx10xxxxxx","00100","00101","1000111");
  constant CBS_S4_S4 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "!xx01xxxxxx,xx10xxxxxx","00100","00100","1111100");

  constant CBS_S5_S6 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,3,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,3,OutputWidth,
      "xxxxxxx111","00101","00110","1100010");
  constant CBS_S5_S0 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,3,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,3,OutputWidth,
      "xxxxxxx000","00101","00000","1100111");
  constant CBS_S5_S5 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,3,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,3,OutputWidth,
      "!xxxxxxx111,xxxxxxx000","00101","00101","0000000");

  constant CBS_S6_S0 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,4,OutputWidth,
      "xxxxxxx110","00110","00000","1010101");
  constant CBS_S6_S5 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,3,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,3,OutputWidth,
      "xxxxxxx010","00110","00101","0101010");
  constant CBS_S6_S6 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,3,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,3,OutputWidth,
      "!xxxxxxx110,xxxxxxx010","00110","00110","1101111");

  constant CBS_S7_S8 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,0,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,0,OutputWidth,
      "","00111","01000","1011110");

  constant CBS_S8_S9 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,0,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,0,OutputWidth,
      "","01000","01001","1011111");

  constant CBS_S9_S2 : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,2,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,2,OutputWidth,
      "!","01001","00010","1011100");

  -- use an unused state to disable this TR
  constant CBS_0_unused : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,0,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,0,OutputWidth,
      "","11111","00000","1010101");

  -- use a used state but set the IPG to "0000" to disable this TR
  constant CBS_2_unused_noinput : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,2,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,2,OutputWidth,
      "","00001","00000","1010110");

  -- use an unused state to disable this TR but set the IPG to "1111"
  constant CBS_2_unused_nostate : std_logic_vector(CalcTRConfigLength(StateWidth,InputWidth,2,OutputWidth)-1 downto 0) := 
    GenTRConfigBitStream(StateWidth,InputWidth,2,OutputWidth,
      "!","11110","00000","1010111");

  -- important: the LSBs of this vector are assiciated with the low-input TRs
  constant ConfigBitStream : std_logic_vector(ConfigLength-1 downto 0) :=
    -- Width = 0
    CBS_S7_S8 &
    CBS_S8_S9 &
    CBS_0_unused &
    -- Width = 1
    CBS_S3_S4 &
    CBS_S3_S5 &
    -- Width = 2
    CBS_S2_S3 &
    CBS_S4_S1 &
    CBS_S4_S5 &
    CBS_S9_S2 &
    CBS_2_unused_noinput &
    CBS_2_unused_nostate &
    -- Width = 3
    CBS_S2_S5 &
    CBS_S5_S6 &
    CBS_S5_S0 &
    CBS_S5_S5 &
    CBS_S6_S5 &
    CBS_S6_S6 &
    -- Width = 4
    CBS_S0_S1 &
    CBS_S0_S2 &
    CBS_S0_S3 &
    CBS_S0_S0 &
    CBS_S1_S6 &
    CBS_S1_S7 &
    CBS_S1_S1 &
    CBS_S4_S4 &
    CBS_S6_S0;

  constant CfgClkHalfPeriode   : time := 100 ns;
  constant CheckOutputDelay    : time := 20 ns;
  constant SetupNextInputDelay : time := 20 ns;

  signal Reset_n_i    : std_logic;
  signal Clk_i        : std_logic;
  signal Input_i      : std_logic_vector(InputWidth-1 downto 0);
  signal Output_o     : std_logic_vector(OutputWidth-1 downto 0);
  signal CfgMode_i    : std_logic;
  signal CfgClk_i     : std_logic;
  signal CfgShift_i   : std_logic;
  signal CfgDataIn_i  : std_logic;
  signal CfgDataOut_o : std_logic;

  procedure CheckTRFSM (
    constant Input    : in  std_logic_vector(InputWidth-1 downto 0);
    constant Output   : in  std_logic_vector(OutputWidth-1 downto 0);
    signal   Input_i  : out std_logic_vector(InputWidth-1 downto 0);
    signal   Output_o : in  std_logic_vector(OutputWidth-1 downto 0)
  ) is
    variable l : line;
  begin
    Input_i <= Input;
    write(l,string'("Input = "));
    write(l,Input);
    wait for CheckOutputDelay;
    write(l,string'(" => Output = "));
    write(l,Output_o);
    if Output_o = Output then
      write(l,string'(" OK "));
    else
      write(l,string'(" ERROR: should be "));
      write(l,Output);
    end if;
    writeline(std.textio.output,l);
    wait for SetupNextInputDelay;
  end CheckTRFSM;

  procedure ClkCycle (
    signal Clk_i : out std_logic
  ) is
  begin
    Clk_i <= '1';
    wait for CfgClkHalfPeriode;
    Clk_i <= '0';
    wait for CfgClkHalfPeriode;
  end ClkCycle;
      
begin  -- behavior

  TRFSM_1: TRFSM
    generic map (
      InputWidth      => InputWidth,
      OutputWidth     => OutputWidth,
      StateWidth      => StateWidth,
      NumRows0        => NumRows0,
      NumRows1        => NumRows1,
      NumRows2        => NumRows2,
      NumRows3        => NumRows3,
      NumRows4        => NumRows4,
      NumRows5        => NumRows5,
      NumRows6        => NumRows6,
      NumRows7        => NumRows7,
      NumRows8        => NumRows8,
      NumRows9        => NumRows9)
    port map (
      Reset_n_i    => Reset_n_i,
      Clk_i        => Clk_i,
      Input_i      => Input_i,
      Output_o     => Output_o,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIn_i,
      CfgDataOut_o => CfgDataOut_o);

  Check: process
  begin  -- process Check
    -- set all inputs
    Clk_i <= '0';
    Input_i <= (others => '0');
    CfgMode_i <= '0';
    CfgClk_i <= '0';
    CfgShift_i <= '0';
    CfgDataIn_i <= '0';              

    ---------------------------------------------------------------------------
    -- Reset
    ---------------------------------------------------------------------------
    Reset_n_i <= '0';
    wait for 1 us;
    Reset_n_i <= '1';
    wait for 1 ns;

    ---------------------------------------------------------------------------
    -- Configuration
    ---------------------------------------------------------------------------
    -- shift in the config bit stream with LSB first, the ConfigRegister will
    -- shift this from right to left (=MSB to LSB), so after everything is
    -- shifted, the bits have the same order as setup above and as visible at
    -- the screen.
    
    -- assert false report "ConfigBitStream = " & Vector2String(ConfigBitStream) severity note;
    CfgMode_i <= '1';
    CfgShift_i <= '1';
    wait for CfgClkHalfPeriode;
    for i in 0 to ConfigLength-1 loop
      CfgDataIn_i <= ConfigBitStream(i);
      wait for SetupNextInputDelay;
      CfgClk_i <= '1';
      wait for CfgClkHalfPeriode;
      CfgClk_i <= '0';
      wait for CfgClkHalfPeriode-SetupNextInputDelay;
    end loop;  -- i
    CfgMode_i <= '0';
    CfgShift_i <= '0';
    wait for CheckOutputDelay;

    assert false report "### Configuration done" severity note;
    -- 127129ns
    
    ---------------------------------------------------------------------------
    -- Action
    ---------------------------------------------------------------------------

    -- State 0, test all transitions
    CheckTRFSM("1010000000","1100110",Input_i,Output_o);  -- to S1
    CheckTRFSM("1010111111","1100110",Input_i,Output_o);  -- to S1
    CheckTRFSM("1010110011","1100110",Input_i,Output_o);  -- to S1
    CheckTRFSM("1010010101","1100110",Input_i,Output_o);  -- to S1
    CheckTRFSM("1010101010","1100110",Input_i,Output_o);  -- to S1
    CheckTRFSM("1111000000","0011001",Input_i,Output_o);  -- to S2
    CheckTRFSM("1111111111","0011001",Input_i,Output_o);  -- to S2
    CheckTRFSM("1111001100","0011001",Input_i,Output_o);  -- to S2
    CheckTRFSM("1111101010","0011001",Input_i,Output_o);  -- to S2
    CheckTRFSM("1111010111","0011001",Input_i,Output_o);  -- to S2
    CheckTRFSM("0000000000","0110011",Input_i,Output_o);  -- to S3
    CheckTRFSM("0000111111","0110011",Input_i,Output_o);  -- to S3
    CheckTRFSM("0000101010","0110011",Input_i,Output_o);  -- to S3
    CheckTRFSM("0000010101","0110011",Input_i,Output_o);  -- to S3
    CheckTRFSM("0000110111","0110011",Input_i,Output_o);  -- to S3
    CheckTRFSM("1110000000","1111111",Input_i,Output_o);  -- stay
    CheckTRFSM("1110111011","1111111",Input_i,Output_o);  -- stay
    CheckTRFSM("0010000000","1111111",Input_i,Output_o);  -- stay
    CheckTRFSM("0101000000","1111111",Input_i,Output_o);  -- stay
    ClkCycle(Clk_i);
    -- State 0 again
    CheckTRFSM("1010110111","1100110",Input_i,Output_o);  -- to S1
    ClkCycle(Clk_i);
    -- State 1
    CheckTRFSM("1100110111","1111111",Input_i,Output_o);  -- to S6
    CheckTRFSM("1100111111","1111111",Input_i,Output_o);  -- to S6
    CheckTRFSM("1100000000","1111111",Input_i,Output_o);  -- to S6
    CheckTRFSM("0011000000","1011101",Input_i,Output_o);  -- to S7
    CheckTRFSM("0011111111","1011101",Input_i,Output_o);  -- to S7
    CheckTRFSM("0011010101","1011101",Input_i,Output_o);  -- to S7
    CheckTRFSM("1111110111","0111110",Input_i,Output_o);  -- stay
    CheckTRFSM("0000000000","0111110",Input_i,Output_o);  -- stay
    CheckTRFSM("0010010101","0111110",Input_i,Output_o);  -- stay
    ClkCycle(Clk_i);
    -- State 1 again
    CheckTRFSM("1100011001","1111111",Input_i,Output_o);  -- to S6
    ClkCycle(Clk_i);
    -- State 6
    CheckTRFSM("0000000110","1010101",Input_i,Output_o);  -- to S0
    CheckTRFSM("0000000010","0101010",Input_i,Output_o);  -- to S5
    CheckTRFSM("0000000111","1101111",Input_i,Output_o);  -- stay
    ClkCycle(Clk_i);
    -- State 1 again
    CheckTRFSM("1111111010","0101010",Input_i,Output_o);  -- to S5
    ClkCycle(Clk_i);
    -- State 5
    CheckTRFSM("0000000111","1100010",Input_i,Output_o);  -- to S6
    CheckTRFSM("1010111000","1100111",Input_i,Output_o);  -- to S0
    ClkCycle(Clk_i);
    -- State 0
    CheckTRFSM("1111110111","0011001",Input_i,Output_o);  -- to S2
    ClkCycle(Clk_i);
    -- State 2
    CheckTRFSM("0000100000","1111000",Input_i,Output_o);  -- to S3
    CheckTRFSM("0001110000","1111000",Input_i,Output_o);  -- to S3
    CheckTRFSM("1111011111","0001111",Input_i,Output_o);  -- to S5
    CheckTRFSM("1110001111","0001111",Input_i,Output_o);  -- to S5
    CheckTRFSM("0001110011","1111000",Input_i,Output_o);  -- to S3
    ClkCycle(Clk_i);
    -- State 3
    CheckTRFSM("0000000001","1110001",Input_i,Output_o);  -- to S4
    CheckTRFSM("1010101011","1110001",Input_i,Output_o);  -- to S4
    CheckTRFSM("0000000000","1100011",Input_i,Output_o);  -- to S5
    CheckTRFSM("0101010100","1100011",Input_i,Output_o);  -- to S5
    CheckTRFSM("0011100111","1110001",Input_i,Output_o);  -- to S4
    ClkCycle(Clk_i);
    -- State 4
    CheckTRFSM("0001000000","0111000",Input_i,Output_o);  -- to S1
    CheckTRFSM("1101111111","0111000",Input_i,Output_o);  -- to S1
    CheckTRFSM("0010000000","1000111",Input_i,Output_o);  -- to S5
    CheckTRFSM("1110111111","1000111",Input_i,Output_o);  -- to S5
    CheckTRFSM("1111111111","1111100",Input_i,Output_o);  -- stay
    CheckTRFSM("1100111111","1111100",Input_i,Output_o);  -- stay
    ClkCycle(Clk_i);
    -- State 1 again
    CheckTRFSM("1010101010","1000111",Input_i,Output_o);  -- to S5
    ClkCycle(Clk_i);
    -- State 5
    CheckTRFSM("1111111111","1100010",Input_i,Output_o);  -- to S6
    ClkCycle(Clk_i);
    -- State 6
    CheckTRFSM("0000000110","1010101",Input_i,Output_o);  -- to S0
    ClkCycle(Clk_i);
    -- State 0
    CheckTRFSM("1111110111","0011001",Input_i,Output_o);  -- to S2
    ClkCycle(Clk_i);
    -- State 2
    CheckTRFSM("1110001111","0001111",Input_i,Output_o);  -- to S5
    ClkCycle(Clk_i);
    -- State 5
    CheckTRFSM("1010111000","1100111",Input_i,Output_o);  -- to S0
    ClkCycle(Clk_i);
    -- State 0
    CheckTRFSM("0000011010","0110011",Input_i,Output_o);  -- to S3
    ClkCycle(Clk_i);
    -- State 3
    CheckTRFSM("1111111110","1100011",Input_i,Output_o);  -- to S5
    ClkCycle(Clk_i);
    -- State 5
    CheckTRFSM("0010011111","1100010",Input_i,Output_o);  -- to S6
    CheckTRFSM("0101010000","1100111",Input_i,Output_o);  -- to S0
    ClkCycle(Clk_i);
    -- State 0
    CheckTRFSM("1010011010","1100110",Input_i,Output_o);  -- to S1
    ClkCycle(Clk_i);
    -- State 1
    CheckTRFSM("0011000000","1011101",Input_i,Output_o);  -- to S7
    ClkCycle(Clk_i);
    -- State 7
    CheckTRFSM("0000000000","1011110",Input_i,Output_o);  -- to S8
    CheckTRFSM("1111111111","1011110",Input_i,Output_o);  -- to S8
    CheckTRFSM("1010101010","1011110",Input_i,Output_o);  -- to S8
    CheckTRFSM("0101010101","1011110",Input_i,Output_o);  -- to S8
    CheckTRFSM("1100110011","1011110",Input_i,Output_o);  -- to S8
    CheckTRFSM("0011001100","1011110",Input_i,Output_o);  -- to S8
    ClkCycle(Clk_i);
    -- State 8
    CheckTRFSM("0000000000","1011111",Input_i,Output_o);  -- to S9
    CheckTRFSM("1111111111","1011111",Input_i,Output_o);  -- to S9
    CheckTRFSM("1010101010","1011111",Input_i,Output_o);  -- to S9
    CheckTRFSM("0101010101","1011111",Input_i,Output_o);  -- to S9
    CheckTRFSM("1100110011","1011111",Input_i,Output_o);  -- to S9
    CheckTRFSM("0011001100","1011111",Input_i,Output_o);  -- to S9
    ClkCycle(Clk_i);
    -- State 9
    CheckTRFSM("0000000000","1011100",Input_i,Output_o);  -- to S2
    CheckTRFSM("1111111111","1011100",Input_i,Output_o);  -- to S2
    CheckTRFSM("1010101010","1011100",Input_i,Output_o);  -- to S2
    CheckTRFSM("0101010101","1011100",Input_i,Output_o);  -- to S2
    CheckTRFSM("1100110011","1011100",Input_i,Output_o);  -- to S2
    CheckTRFSM("0011001100","1011100",Input_i,Output_o);  -- to S2
    ClkCycle(Clk_i);
    -- State 2
    CheckTRFSM("1110001111","0001111",Input_i,Output_o);  -- to S5

    ---------------------------------------------------------------------------
    -- Simulation is finished
    ---------------------------------------------------------------------------
    assert 0 = 1
      report " simulation is finished "
      severity failure ;

  end process Check;
  
end behavior;
