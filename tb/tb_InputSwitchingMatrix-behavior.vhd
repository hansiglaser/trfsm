-------------------------------------------------------------------------------
-- Title      : Testbench for design "InputSwitchingMatrix"
-- Project    : 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.tbfuncs.all;
use work.trfsmparts.all;

-------------------------------------------------------------------------------

entity tb_InputSwitchingMatrix is

end tb_InputSwitchingMatrix;

-------------------------------------------------------------------------------

architecture behavior of tb_InputSwitchingMatrix is
  constant InputWidth  : integer := 10;
  constant OutputWidth : integer := 4;

  constant CfgClkHalfPeriode   : time := 100 ns;
  constant CheckOutputDelay    : time := 20 ns;
  constant SetupNextInputDelay : time := 20 ns;

  signal Reset_n    : std_logic;
  signal Input      : std_logic_vector(InputWidth-1 downto 0);
  signal Output     : std_logic_vector(OutputWidth-1 downto 0);
  signal CfgMode    : std_logic;
  signal CfgClk     : std_logic;
  signal CfgShift   : std_logic;
  signal CfgDataIn  : std_logic;
  signal CfgDataOut : std_logic;

  -- Configuration
  ---------------------------------------------------------------------------
  -- shift in the config bit stream with LSB first, the ConfigRegister will
  -- shift this from right to left (=MSB to LSB), so after everything is
  -- shifted, the bits have the same order as setup above and as visible at
  -- the screen.
  procedure Configure (
    constant ConfigBitStream : in  std_logic_vector;
    signal   CfgMode         : out std_logic;
    signal   CfgClk          : out std_logic;
    signal   CfgShift        : out std_logic;
    signal   CfgDataIn       : out std_logic;
    signal   CfgDataOut      : in  std_logic
  ) is
  begin  -- Configure
    CfgMode  <= '1';
    CfgShift <= '1';
    for i in 0 to ConfigBitStream'length-1 loop
      CfgDataIn <= ConfigBitStream(i);
      wait for SetupNextInputDelay;
      CfgClk <= '1';
      wait for CfgClkHalfPeriode;
      CfgClk <= '0';
      wait for CfgClkHalfPeriode-SetupNextInputDelay;
    end loop;  -- i
    CfgMode  <= '0';
    CfgShift <= '0';
  end Configure;

  procedure CheckISM (
    constant Config          : in  std_logic_vector(InputWidth-1 downto 0);
    signal   Input           : out std_logic_vector(InputWidth-1 downto 0);
    signal   Output          : in  std_logic_vector(OutputWidth-1 downto 0);
    signal   CfgMode         : out std_logic;
    signal   CfgClk          : out std_logic;
    signal   CfgShift        : out std_logic;
    signal   CfgDataIn       : out std_logic;
    signal   CfgDataOut      : in  std_logic
  ) is
    variable Input_v  : std_logic_vector(InputWidth -1 downto 0);
    variable Output_v : std_logic_vector(OutputWidth-1 downto 0);
    variable OutPos   : integer;
    variable Errors   : integer;
  begin  -- CheckISM
    Configure(Config,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    Errors := 0;
    for i in 0 to 2**InputWidth-1 loop
      Input_v  := conv_std_logic_vector(i,InputWidth);
      -- construct right value of output
      Output_v := (others => '0');
      OutPos   := OutputWidth-1;
      for Pos in InputWidth-1 downto 0 loop
        if (Pos < OutputWidth-1) and (Pos < OutPos) then
          OutPos := Pos;
        end if;
        if Config(Pos) = '1' then
          Output_v(OutPos) := Input_v(Pos);
          OutPos := OutPos - 1;
        end if;
      end loop;  -- Pos
      -- setup input
      Input <= Input_v;
      wait for CheckOutputDelay;
      -- check output
      if Output /= Output_v then
        assert false
          report "Wrong Output " & Vector2String(Output) & " for Input " & Vector2String(Input_v) & ", should be " & Vector2String(Output_v)
          severity error;
        Errors := Errors + 1;
      end if;
      wait for SetupNextInputDelay;        
    end loop;  -- i
    assert false report "ISM with config pattern " & Vector2String(Config) & " had " & integer'image(Errors) & " errors" severity note;
  end CheckISM;

begin  -- behavior

  InputSwitchingMatrix_1: InputSwitchingMatrix
    generic map (
      InputWidth  => InputWidth,
      OutputWidth => OutputWidth)
    port map (
      Reset_n_i    => Reset_n,
      Input_i      => Input,
      Output_o     => Output,
      CfgMode_i    => CfgMode,
      CfgClk_i     => CfgClk,
      CfgShift_i   => CfgShift,
      CfgDataIn_i  => CfgDataIn,
      CfgDataOut_o => CfgDataOut);

  
  TestProc: process
  begin  -- process TestProc
    Input     <= (others => '0');
    CfgMode   <= '0';
    CfgClk    <= '0';
    CfgShift  <= '0';
    CfgDataIn <= '0';

    ---------------------------------------------------------------------------
    -- Reset
    ---------------------------------------------------------------------------
    Reset_n <= '0';
    wait for 1 us;
    Reset_n <= '1';
    wait for 1 ns;

    ---------------------------------------------------------------------------
    -- Action
    ---------------------------------------------------------------------------
    CheckISM("1111000000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000001111",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("1010101000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0001010101",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("1100000011",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0001111000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("1000000000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("1100000000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("1110000000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0100000000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0010000000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0001000000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000100000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000010000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000001000",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000000100",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000000010",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000000001",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000000011",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("0000000111",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("1000000001",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);
    CheckISM("1000100010",Input,Output,CfgMode,CfgClk,CfgShift,CfgDataIn,CfgDataOut);

    ---------------------------------------------------------------------------
    -- Simulation is finished
    ---------------------------------------------------------------------------
    assert 0 = 1
      report " simulation is finished "
      severity failure ;

  end process TestProc;
end behavior;
