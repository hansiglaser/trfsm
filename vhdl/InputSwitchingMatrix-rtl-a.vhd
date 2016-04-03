architecture rtl of InputSwitchingMatrix is
  signal CfgValue : std_logic_vector(InputWidth-1 downto 0);
begin -- rtl

  Cfg : ConfigRegister
    generic map (
      Width => InputWidth)
    port map (
      Reset_n_i    => Reset_n_i,
      Output_o     => CfgValue,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIn_i,
      CfgDataOut_o => CfgDataOut_o);

  --         InputWidth = 10
  --             Input_i
  --  /--------------------------\
  --
  --  9  8  7  6  5  4  3  2  1  0
  --  |  |  |  |  |  |  |  |  |  |
  --  v  v  v  v  v  v  v  v  v  v
  --  |  |  |  |  |  |  |  |  |  |
  --  X--X--X--X--X--X--X--+--+--+---> 3  \
  --  |  |  |  |  |  |  |  |  |  |        |
  --  +--X--X--X--X--X--X--X--+--+---> 2  |
  --  |  |  |  |  |  |  |  |  |  |        | Output_o
  --  +--+--X--X--X--X--X--X--X--+---> 1  | OutputWidth = 4
  --  |  |  |  |  |  |  |  |  |  |        |
  --  +--+--+--X--X--X--X--X--X--X---> 0  /

  InputSwitching: process (Input_i,CfgValue)
    type UsedArr_t is array (OutputWidth-1 downto 0) of std_logic_vector(InputWidth   downto 0);
    type DoneArr_t is array (OutputWidth   downto 0) of std_logic_vector(InputWidth-1 downto 0);
    type FullArr_t is array (OutputWidth-1 downto 0) of std_logic_vector(InputWidth-1 downto 0);
    variable Enable : std_logic;
    variable Used : UsedArr_t;
    variable Done : DoneArr_t;
    variable OutputPre : FullArr_t;
  begin  -- process InputSwitching
    Used := (others => (others => '0'));
    Done := (others => (others => '0'));
    for OutputNr in OutputWidth-1 downto 0 loop
      for InputNr in InputWidth-1 downto 0 loop
        Enable := CfgValue(InputNr) and (not Done(OutputNr+1)(InputNr)) and (not Used(OutputNr)(InputNr+1));
        OutputPre(OutputNr)(InputNr) := Enable and Input_i(InputNr);
        Used     (OutputNr)(InputNr) := Enable or Used(OutputNr)(InputNr+1);
        Done     (OutputNr)(InputNr) := Enable or Done(OutputNr+1)(InputNr);
        if InputNr = OutputNr then
          Used(OutputNr)(InputNr) := '1';
        end if;
      end loop;  -- InputNr
      Output_o(OutputNr) <= or_reduce(OutputPre(OutputNr));
    end loop;  -- OutputNr
  end process InputSwitching;

  CheckConfig: process (CfgValue)
    variable NumOutputs : integer;
  begin  -- process CheckConfig
    NumOutputs := 0;
    for i in InputWidth-1 downto 0 loop
      if CfgValue(i) = '1' then
        NumOutputs := NumOutputs + 1;
      end if;
    end loop;
    -- check if we have too many 1s
--    assert NumOutputs <= OutputWidth
--      report "FATAL: InputSwitchingMatrix with InputWidth = " & integer'image(InputWidth) & " and OutputWidth = " & integer'image(OutputWidth) & " has too many outputs configured (" & integer'image(NumOutputs) & ")"
--      severity failure;
  end process CheckConfig;

end rtl;  -- of InputSwitchingMatrix
