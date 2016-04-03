
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.trfsmparts.all;
use work.tb_trfsmpkg.all;
use work.tbfuncs.all;

entity tb_transitionrow is
  
end tb_transitionrow;

architecture behavior of tb_transitionrow is
  constant TotalInputWidth : integer := 10;
  constant MyInputWidth    : integer := 5;
  constant StateWidth      : integer := 5;
  constant OutputWidth     : integer := 7;

  constant ConfigLength : integer := CalcTRConfigLength(StateWidth,TotalInputWidth,MyInputWidth,OutputWidth);

  -- Attention: don't make symmetric values because otherwise we can't find
  -- problems with the order
  constant CfgOurState     : std_logic_vector(StateWidth-1 downto 0)      := "10111";
--  constant CfgInputSelect  : std_logic_vector(TotalInputWidth-1 downto 0) := "1001110010";
--  constant CfgInputPattern : std_logic_vector(2**MyInputWidth-1 downto 0) := "00000010000010000000000000000000";
  constant CfgNextState    : std_logic_vector(StateWidth-1 downto 0)      := "01011";
  constant CfgOutput       : std_logic_vector(OutputWidth-1 downto 0)     := "1100110";
  constant ConfigBitStream : std_logic_vector(ConfigLength-1 downto 0)
    := GenTRConfigBitStream(StateWidth,TotalInputWidth,MyInputWidth,OutputWidth,
                            "1xx001xx1x,1xx100xx1x",CfgOurState,CfgNextState,CfgOutput);

  constant CfgClkHalfPeriode   : time := 100 ns;
  constant CheckOutputDelay    : time := 20 ns;
  constant SetupNextInputDelay : time := 20 ns;

  signal Reset_n_i    : std_logic;
  signal Input_i      : std_logic_vector(TotalInputWidth-1 downto 0);
  signal State_i      : std_logic_vector(StateWidth-1 downto 0);
  signal Match_o      : std_logic;
  signal NextState_o  : std_logic_vector(StateWidth-1 downto 0);
  signal Output_o     : std_logic_vector(OutputWidth-1 downto 0);
  signal CfgMode_i    : std_logic;
  signal CfgClk_i     : std_logic;
  signal CfgShift_i   : std_logic;
  signal CfgDataIn_i  : std_logic;
  signal CfgDataOut_o : std_logic;


  -- purpose: Set inputs and check outputs
  procedure CheckTransitionRow (
    constant Input     : in  std_logic_vector(TotalInputWidth-1 downto 0);
    constant State     : in  std_logic_vector(StateWidth-1 downto 0);
    constant Match     : in  std_logic;
    constant NextState : in  std_logic_vector(StateWidth-1 downto 0);
    constant Output    : in  std_logic_vector(OutputWidth-1 downto 0);
    signal Input_i     : out std_logic_vector(TotalInputWidth-1 downto 0);
    signal State_i     : out std_logic_vector(StateWidth-1 downto 0);
    signal Match_o     : in  std_logic;
    signal NextState_o : in  std_logic_vector(StateWidth-1 downto 0);
    signal Output_o    : in  std_logic_vector(OutputWidth-1 downto 0)
    ) is
    variable l : line;
  begin  -- CheckTransitionRow
    Input_i <= Input;
    State_i <= State;
    write(l,string'("Input = "));
    write(l,Input);
    write(l,string'(", State = "));
    write(l,State);
    wait for CheckOutputDelay;
    if CheckStdLogic      (Match_o,    Match,    "Match") and
       CheckStdLogicVector(NextState_o,NextState,"NextState") and
       CheckStdLogicVector(Output_o,   Output,   "Output") then
      write(l,string'(": OK!"));
    end if;
    writeline(std.textio.output,l);
    wait for SetupNextInputDelay;
  end CheckTransitionRow;

begin  -- behavior

  TransitionRow_1: TransitionRow
    generic map (
      TotalInputWidth => TotalInputWidth,
      MyInputWidth    => MyInputWidth,
      StateWidth      => StateWidth,
      OutputWidth     => OutputWidth)
    port map (
      Reset_n_i    => Reset_n_i,
      Input_i      => Input_i,
      State_i      => State_i,
      Match_o      => Match_o,
      NextState_o  => NextState_o,
      Output_o     => Output_o,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIn_i,
      CfgDataOut_o => CfgDataOut_o);

  Check: process
  begin  -- process Check
    Input_i <= (others => '0');
    State_i <= (others => '0');
    CfgMode_i   <= '0';
    CfgClk_i    <= '0';
    CfgShift_i  <= '0';
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
    CfgMode_i  <= '1';
    CfgShift_i <= '1';
    for i in 0 to ConfigLength-1 loop
      CfgDataIn_i <= ConfigBitStream(i);
      wait for SetupNextInputDelay;
      CfgClk_i <= '1';
      wait for CfgClkHalfPeriode;
      CfgClk_i <= '0';
      wait for CfgClkHalfPeriode-SetupNextInputDelay;
    end loop;  -- i
    CfgMode_i  <= '0';
    CfgShift_i <= '0';

    ---------------------------------------------------------------------------
    -- Action
    ---------------------------------------------------------------------------
    -- CfgInputSelect = "1001110010" -> 1,4,5,6,9 are sensitive
    -- CfgInputPattern = "00000010000010000000000000000000";   -> 19 = 10011, 25 = 11001
    -- -> 1xx001xx1x, 1xx100xx1x
    -- Test with wrong current states and wrong inputs
    for i in 0 to 2**StateWidth-1 loop
      if i /= conv_integer(CfgOurState) then
        CheckTransitionRow("0000000000",conv_std_logic_vector(i,StateWidth),'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
        CheckTransitionRow("1111111111",conv_std_logic_vector(i,StateWidth),'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
        CheckTransitionRow("1000010011",conv_std_logic_vector(i,StateWidth),'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
        CheckTransitionRow("1101000010",conv_std_logic_vector(i,StateWidth),'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
      end if;
    end loop;  -- i
    -- Test matching state but wrong inputs
    CheckTransitionRow("0000000000",CfgOurState,'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
    CheckTransitionRow("1111111111",CfgOurState,'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
    CheckTransitionRow("1000110010",CfgOurState,'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
    CheckTransitionRow("1001100010",CfgOurState,'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
    -- Test wrong current states but matching inputs
    CheckTransitionRow("1000010010","00000",'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
    CheckTransitionRow("1001000010","00000",'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
    for i in 0 to 2**StateWidth-1 loop
      if i /= conv_integer(CfgOurState) then
        CheckTransitionRow("1000010010",conv_std_logic_vector(i,StateWidth),'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
        CheckTransitionRow("1001000010",conv_std_logic_vector(i,StateWidth),'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
        CheckTransitionRow("1110011111",conv_std_logic_vector(i,StateWidth),'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
        CheckTransitionRow("1111001111",conv_std_logic_vector(i,StateWidth),'0',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
      end if;
    end loop;  -- i
    -- Test matching state and inputs
    CheckTransitionRow("1000010010",CfgOurState,'1',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);
    CheckTransitionRow("1001000010",CfgOurState,'1',CfgNextState,CfgOutput,Input_i,State_i,Match_o,NextState_o,Output_o);

    ---------------------------------------------------------------------------
    -- Simulation is finished
    ---------------------------------------------------------------------------
    assert 0 = 1
      report " simulation is finished "
      severity failure ;

  end process Check;

end behavior;
