architecture rtl of StateSelectionGate is
  signal CfgValue : std_logic_vector(StateWidth-1 downto 0);
begin -- rtl

  Cfg : ConfigRegister
    generic map (
      Width => StateWidth)
    port map (
      Reset_n_i    => Reset_n_i,
      Output_o     => CfgValue,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIn_i,
      CfgDataOut_o => CfgDataOut_o);

  Match_o <= '1' when State_i = CfgValue else '0';

end rtl;  -- of StateSelectionGate
