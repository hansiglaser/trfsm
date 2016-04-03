-------------------------------------------------------------------------------
-- Title      : Testbench for design "LargeMux"
-- Project    : 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;
use work.tbfuncs.all;
use work.trfsmparts.all;

-------------------------------------------------------------------------------

entity tb_LargeMux is

end tb_LargeMux;

-------------------------------------------------------------------------------

architecture behavior of tb_LargeMux is

  constant CheckOutputDelay    : time := 20 ns;
  constant SetupNextInputDelay : time := 20 ns;

  -- component generics
  constant NumTransitionRows : integer range 1 to 1024 := 10;
  constant Width             : integer range 1 to  256 := 10;

  -- component ports
  signal Select_i  : std_logic_vector(NumTransitionRows -1 downto 0);
  signal Inputs_i  : std_logic_vector(NumTransitionRows*Width-1 downto 0);
  signal Output_o  : std_logic_vector(Width-1 downto 0);

  type Input_t is array (0 to NumTransitionRows-1) of std_logic_vector(Width-1 downto 0);

  -- purpose: Check a LargeMux
  procedure CheckLargeMux (
    constant SelectI   : in  std_logic_vector(Width-1 downto 0);
    signal   Inputs_i  : out std_logic_vector(NumTransitionRows*Width-1 downto 0);
    signal   Output_o  : in  std_logic_vector(Width-1 downto 0);
    signal   Select_i  : out std_logic_vector(NumTransitionRows -1 downto 0)
  ) is
    variable Inputs  : Input_t;
    variable Output  : std_logic_vector(Width-1 downto 0);
    variable Seed1   : positive;
    variable Seed2   : positive;
    variable Rand    : real;
  begin  -- CheckLargeMux
    Seed1 := 273956345;
    Seed2 := 94729405;
    for i in 0 to 1000 loop
      -- input test patterns
      for InputIdx in 0 to NumTransitionRows-1 loop
        uniform(Seed1,Seed2,Rand); Inputs(InputIdx) := conv_std_logic_vector(integer(Rand*real(2**Width-1)),Width);
      end loop;  -- InputIdx
      uniform(Seed1,Seed2,Rand); Output := conv_std_logic_vector(integer(Rand*real(2**Width-1)),Width);
      Output := (others => '0');
      for InputIdx in 0 to NumTransitionRows-1 loop
        if SelectI(InputIdx) = '1' then
          -- OR all inputs
          Output := Output or Inputs(InputIdx);
        end if;
      end loop;  -- InputIdx
      -- set input signals
      for InputIdx in NumTransitionRows-1 downto 0 loop
        Inputs_i((InputIdx+1)*Width-1 downto InputIdx*Width) <= Inputs(InputIdx);
      end loop;  -- InputIdx
      Select_i  <= SelectI;
      -- check output
      wait for CheckOutputDelay;
      assert Output_o = Output report "Wrong Output " & Vector2String(Output_o) & ", should be " & Vector2String(Output) severity error;
      wait for SetupNextInputDelay;
    end loop;  -- i
  end CheckLargeMux;

begin  -- behavior

  -- component instantiation
  DUT: LargeMux
    generic map (
      NumTransitionRows => NumTransitionRows,
      Width             => Width)
    port map (
      Select_i  => Select_i,
      Inputs_i  => Inputs_i,
      Output_o  => Output_o);

  -- waveform generation
  WaveGen_Proc: process
  begin
    ---------------------------------------------------------------------------
    -- Action
    ---------------------------------------------------------------------------
    -- test default
    CheckLargeMux("1000000000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0100000000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0010000000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0001000000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0000100000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0000010000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0000001000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0000000100",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0000000010",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0000000001",Inputs_i,Output_o,Select_i);

    CheckLargeMux("0001000001",Inputs_i,Output_o,Select_i);
    CheckLargeMux("1000010000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0011100000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("1001110001",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0101011000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0010010000",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0001000001",Inputs_i,Output_o,Select_i);
    CheckLargeMux("0110010001",Inputs_i,Output_o,Select_i);

    CheckLargeMux("0000000000",Inputs_i,Output_o,Select_i);

    ---------------------------------------------------------------------------
    -- Simulation is finished
    ---------------------------------------------------------------------------
    assert 0 = 1
      report "### simulation is finished ###"
      severity failure;

  end process WaveGen_Proc;

end behavior;

-------------------------------------------------------------------------------

configuration tb_LargeMux_behavior_cfg of tb_LargeMux is
  for behavior
  end for;
end tb_LargeMux_behavior_cfg;

-------------------------------------------------------------------------------
