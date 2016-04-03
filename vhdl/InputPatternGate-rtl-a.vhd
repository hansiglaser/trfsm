
architecture rtl of InputPatternGate is
  signal CfgValue : std_logic_vector(2**InputWidth-1 downto 0);
begin -- rtl

  Cfg : ConfigRegister
    generic map (
      Width => 2**InputWidth)
    port map (
      Reset_n_i    => Reset_n_i,
      Output_o     => CfgValue,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIn_i,
      CfgDataOut_o => CfgDataOut_o);

  Match_o <= Enable_i and CfgValue(conv_integer(Input_i));

end rtl;  -- of InputPatternGate
