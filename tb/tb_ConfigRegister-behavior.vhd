-------------------------------------------------------------------------------
-- Title      : Testbench for design "ConfigRegister"
-- Project    : 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;
library work;
use work.trfsmparts.all;
use work.tbfuncs.all;
use work.Config.all;

-------------------------------------------------------------------------------

entity tb_ConfigRegister is

end tb_ConfigRegister;

-------------------------------------------------------------------------------

architecture behavior of tb_ConfigRegister is

  constant CfgClkHalfPeriode   : time := 100 ns;
  constant CheckOutputDelay    : time :=  20 ns;
  constant SetupNextInputDelay : time :=  20 ns;

  -- component generics
  constant Width : integer range 1 to 256 := 29;  -- prime number :-)

  -- component ports
  signal Reset_n_i    : std_logic;
  signal Output_o     : std_logic_vector(Width-1 downto 0);
  signal CfgMode_i    : std_logic;
  signal CfgClk_i     : std_logic;
  signal CfgShift_i   : std_logic;
  signal CfgDataIn_i  : std_logic;
  signal CfgDataOut_o : std_logic;

  -- Configuration
  ---------------------------------------------------------------------------
  -- shift in the config bit stream with LSB first, the ConfigRegister will
  -- shift this from right to left (=MSB to LSB), so after everything is
  -- shifted, the bits have the same order as setup above and as visible at
  -- the screen.
  procedure Configure (
    constant NewBitStream : in  std_logic_vector;
    variable OldBitStream : out std_logic_vector;
    signal   CfgMode      : out std_logic;   -- TODO: remove this signal, not required here
    signal   CfgClk       : out std_logic;
    signal   CfgDataIn    : out std_logic;
    signal   CfgDataOut   : in  std_logic
  ) is
  begin  -- Configure
    for i in 0 to NewBitStream'length-1 loop
      CfgDataIn <= NewBitStream(i);
      OldBitStream(i) := CfgDataOut;
      wait for SetupNextInputDelay;
      CfgClk <= '1';
      wait for CfgClkHalfPeriode;
      CfgClk <= '0';
      wait for CfgClkHalfPeriode-SetupNextInputDelay;
    end loop;  -- i
  end Configure;

  -- purpose: Check the output of the ConfigRegister
  procedure CheckOutput (
    constant Nominal  : in std_logic_vector(Width-1 downto 0);
    signal   Output_o : in std_logic_vector(Width-1 downto 0)
  ) is
  begin  -- CheckOutput
    assert Output_o = Nominal report "Invalid output " & Vector2String(Output_o) & ", should be " & Vector2String(Nominal) severity error;
  end CheckOutput;

  -- purpose: Create a random bitstream
  function CreateBitStream (
    constant Width : natural;
    constant S1 : positive;
    constant S2 : positive
  ) return std_logic_vector is
    variable CfgValue : std_logic_vector(Width-1 downto 0);
    variable Seed1    : positive;
    variable Seed2    : positive;
    variable Rand     : real;
  begin  -- CreateBitStream
    Seed1 := S1;
    Seed2 := S2;
    for i in 0 to Width-1 loop
      uniform(Seed1,Seed2,Rand);
      CfgValue(i) := conv_std_logic_vector(integer(round(Rand)),1)(0);
    end loop;  -- i
    return CfgValue;
  end CreateBitStream;

begin  -- behavior

  -- component instantiation
  DUT: ConfigRegister
    generic map (
      Width => Width)
    port map (
      Reset_n_i    => Reset_n_i,
      Output_o     => Output_o,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIn_i,
      CfgDataOut_o => CfgDataOut_o);

  -- waveform generation
  WaveGen_Proc: process
    variable OutputA : std_logic_vector(Width-1 downto 0);
    variable OutputB : std_logic_vector(Width-1 downto 0);
    variable OutputC : std_logic_vector(Width-1 downto 0);
  begin
    CfgMode_i   <= '0';
    CfgClk_i    <= '0';
    CfgShift_i  <= '0';
    CfgDataIn_i <= '0';
    
    ---------------------------------------------------------------------------
    -- Reset
    ---------------------------------------------------------------------------
    Reset_n_i <= '1';
    wait for 1 us;
    Reset_n_i <= '0';
    wait for 1 us;
    Reset_n_i <= '1';
    wait for 1 ns;

    ---------------------------------------------------------------------------
    -- Action
    ---------------------------------------------------------------------------
    -- all zero after reset
    OutputA := (others => '0');
    CheckOutput(OutputA,Output_o);
    -- set CfgMode_i = '1', still the same value
    CfgMode_i <= '1';
    wait for CheckOutputDelay;
    CheckOutput(OutputA,Output_o);
    OutputB := CreateBitStream(Width,8395931,123456789);
    if not CfgClkGating then
      -- shift in the config bit stream without CfgShift_i, Output_o must stay the same
      Configure(OutputB,OutputC,CfgMode_i,CfgClk_i,CfgDataIn_i,CfgDataOut_o);
      assert OutputC = OutputA report "Shifted out some bit stream " & Vector2String(OutputC) & ", should be " & Vector2String(OutputA) severity error;
      CfgMode_i <= '0';
      wait for CheckOutputDelay;
      CheckOutput(OutputA,Output_o);   -- should still be old value
      CfgMode_i  <= '1';
    end if;
    CfgShift_i <= '1';   -- now for real
    -- shift in the config bit stream, Output_o must stay the same
    Configure(OutputB,OutputC,CfgMode_i,CfgClk_i,CfgDataIn_i,CfgDataOut_o);
    assert OutputC = OutputA report "Shifted out wrong bit stream " & Vector2String(OutputC) & ", should be " & Vector2String(OutputA) severity error;
    CheckOutput(OutputA,Output_o);
    -- set CfgMode_i = '0', new value
    CfgMode_i <= '0';
    wait for CheckOutputDelay;
    CheckOutput(OutputB,Output_o);
    if not CfgClkGating then
      -- assert CfgClk -> nothing should change
      CfgClk_i <= '1';
      wait for CfgClkHalfPeriode;
      CheckOutput(OutputB,Output_o);
      CfgClk_i <= '0';
      wait for CfgClkHalfPeriode;
      CheckOutput(OutputB,Output_o);
    end if;
    -- Reset => everything 0
    Reset_n_i <= '0';
    wait for 1 us;
    CheckOutput(OutputA,Output_o);
    Reset_n_i <= '1';
    wait for 1 us;
    CheckOutput(OutputA,Output_o);

    -- shift in new bit stream
    OutputB := CreateBitStream(Width,98765432,98765432);
    CfgMode_i <= '1';
    wait for CheckOutputDelay;
    CheckOutput(OutputA,Output_o);
    Configure(OutputB,OutputC,CfgMode_i,CfgClk_i,CfgDataIn_i,CfgDataOut_o);
    assert OutputC = OutputA report "Shifted out wrong bit stream " & Vector2String(OutputC) & ", should be " & Vector2String(OutputA) severity error;
    -- set CfgMode_i = '0', new value
    CfgMode_i <= '0';
    wait for CheckOutputDelay;
    CheckOutput(OutputB,Output_o);

    -- shift in new bit stream
    OutputC := CreateBitStream(Width,178192753,1111122222);
    CfgMode_i <= '1';
    wait for CheckOutputDelay;
    CheckOutput(OutputA,Output_o);
    Configure(OutputC,OutputA,CfgMode_i,CfgClk_i,CfgDataIn_i,CfgDataOut_o);
    -- check output
    CfgMode_i <= '0';
    wait for CheckOutputDelay;
    CheckOutput(OutputC,Output_o);
    -- check shifted out bits, must be the same as previous bit stream
    assert OutputA = OutputB report "Shifted out wrong bit stream " & Vector2String(OutputC) & ", should be " & Vector2String(OutputA) severity error;

    ---------------------------------------------------------------------------
    -- Simulation is finished
    ---------------------------------------------------------------------------
    assert false
      report "### simulation is finished ###"
      severity failure;

  end process WaveGen_Proc;

end behavior;

-------------------------------------------------------------------------------

configuration tb_ConfigRegister_behavior_cfg of tb_ConfigRegister is
  for behavior
  end for;
end tb_ConfigRegister_behavior_cfg;

-------------------------------------------------------------------------------
