architecture struct of TransitionRow is
  signal StateMatch_s     : std_logic;
  -- SelectedInputs_s should be (MyInputWidth-1 downto 0), but DC complains
  --   Error: ... Direction ('to' or 'downto') does not agree with 'first' and 'last' values in range.
  -- for MyInputWidth = 0
  signal SelectedInputs_s : std_logic_vector(TotalInputWidth-1 downto 0);

  signal CfgDataSSG2ISM_s : std_logic;
  signal CfgDataISM2IPG_s : std_logic;
  signal CfgDataIPG2NSR_s : std_logic;
  signal CfgDataNSR2OPR_s : std_logic;
begin -- struct

  StateSelectionGate_inst: StateSelectionGate
    generic map (
      StateWidth => StateWidth)
    port map (
      Reset_n_i    => Reset_n_i,
      State_i      => State_i,
      Match_o      => StateMatch_s,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIn_i,
      CfgDataOut_o => CfgDataSSG2ISM_s);

  -- zero MyInputWidth: we don't need an ISM and IPG, but we directly forward
  -- SSG.Match_o to our Match_o
  GenNoISMIPG: if MyInputWidth = 0 generate
    CfgDataISM2IPG_s <= CfgDataSSG2ISM_s;
    CfgDataIPG2NSR_s <= CfgDataISM2IPG_s;
    Match_o <= StateMatch_s;
  end generate GenNoISMIPG;

  -- non-zero MyInputWidth: we need an ISM and an IPG
  GenISMIPG: if MyInputWidth > 0 generate

    InputSwitchingMatrix_inst: InputSwitchingMatrix
      generic map (
        InputWidth  => TotalInputWidth,
        OutputWidth => MyInputWidth)
      port map (
        Reset_n_i    => Reset_n_i,
        Input_i      => Input_i,
        Output_o     => SelectedInputs_s(MyInputWidth-1 downto 0),
        CfgMode_i    => CfgMode_i,
        CfgClk_i     => CfgClk_i,
        CfgShift_i   => CfgShift_i,
        CfgDataIn_i  => CfgDataSSG2ISM_s,
        CfgDataOut_o => CfgDataISM2IPG_s);

    InputPatternGate_inst: InputPatternGate
      generic map (
        InputWidth => MyInputWidth)
      port map (
        Reset_n_i    => Reset_n_i,
        Enable_i     => StateMatch_s,
        Input_i      => SelectedInputs_s(MyInputWidth-1 downto 0),
        Match_o      => Match_o,
        CfgMode_i    => CfgMode_i,
        CfgClk_i     => CfgClk_i,
        CfgShift_i   => CfgShift_i,
        CfgDataIn_i  => CfgDataISM2IPG_s,
        CfgDataOut_o => CfgDataIPG2NSR_s);

  end generate GenISMIPG;

  NextStateRegister_inst: ConfigRegister
    generic map (
      Width => StateWidth)
    port map (
      Reset_n_i    => Reset_n_i,
      Output_o     => NextState_o,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIPG2NSR_s,
      CfgDataOut_o => CfgDataNSR2OPR_s);

  OutputPatternRegister_inst: ConfigRegister
    generic map (
      Width => OutputWidth)
    port map (
      Reset_n_i    => Reset_n_i,
      Output_o     => Output_o,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataNSR2OPR_s,
      CfgDataOut_o => CfgDataOut_o);

end struct;  -- of TransitionRow
