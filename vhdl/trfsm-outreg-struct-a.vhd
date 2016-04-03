architecture struct of trfsm is

  constant MaxRowWidth : integer := 9;  -- sync with entity generics "NumRowsX"
  type NumRows_t is array (0 to MaxRowWidth) of integer;
  constant NumRows   : NumRows_t := (NumRows0,NumRows1,NumRows2,NumRows3,NumRows4,NumRows5,NumRows6,NumRows7,NumRows8,NumRows9);
  constant RowOffset : NumRows_t := (0,
                                     NumRows0,
                                     NumRows0+NumRows1,
                                     NumRows0+NumRows1+NumRows2,
                                     NumRows0+NumRows1+NumRows2+NumRows3,
                                     NumRows0+NumRows1+NumRows2+NumRows3+NumRows4,
                                     NumRows0+NumRows1+NumRows2+NumRows3+NumRows4+NumRows5,
                                     NumRows0+NumRows1+NumRows2+NumRows3+NumRows4+NumRows5+NumRows6,
                                     NumRows0+NumRows1+NumRows2+NumRows3+NumRows4+NumRows5+NumRows6+NumRows7,
                                     NumRows0+NumRows1+NumRows2+NumRows3+NumRows4+NumRows5+NumRows6+NumRows7+NumRows8
                                     );

  constant NumTransitionRows_c : integer := NumRows0+NumRows1+NumRows2+NumRows3+NumRows4+NumRows5+NumRows6+NumRows7+NumRows8+NumRows9;

  type NextState_t is array (0 to NumTransitionRows_c-1) of std_logic_vector(StateWidth-1 downto 0);
  type Output_t    is array (0 to NumTransitionRows_c-1) of std_logic_vector(OutputWidth-1 downto 0);

  signal RowMatch_s         : std_logic_vector(NumTransitionRows_c-1 downto 0);
  signal RowNextState_s     : NextState_t;
  signal RowNextStateVec_s  : std_logic_vector(NumTransitionRows_c*StateWidth-1 downto 0);
  signal RowOutput_s        : Output_t;
  signal RowOutputVec_s     : std_logic_vector(NumTransitionRows_c*OutputWidth-1 downto 0);
  signal State_s            : std_logic_vector(StateWidth-1 downto 0);
  signal NextState_s        : std_logic_vector(StateWidth-1 downto 0);
  signal CfgData            : std_logic_vector(NumTransitionRows_c + 1 downto 0);
  signal OutputMux          : std_logic_vector(OutputWidth-1 downto 0);

begin -- struct

  GenerateTransitionRowsOfWidth: for RowWidth in 0 to 9 generate

    GenerateTransitionRows: for i in 0 to NumRows(RowWidth)-1 generate

      TransitionRow_inst: TransitionRow
        generic map (
          TotalInputWidth => InputWidth,
          MyInputWidth    => RowWidth,
          StateWidth      => StateWidth,
          OutputWidth     => OutputWidth)
        port map (
          Reset_n_i    => Reset_n_i,
          Input_i      => Input_i,
          State_i      => State_s,
          Match_o      => RowMatch_s    (RowOffset(RowWidth)+i),
          NextState_o  => RowNextState_s(RowOffset(RowWidth)+i),
          Output_o     => RowOutput_s   (RowOffset(RowWidth)+i),
          CfgMode_i    => CfgMode_i,
          CfgClk_i     => CfgClk_i,
          CfgShift_i   => CfgShift_i,
          CfgDataIn_i  => CfgData(1 + RowOffset(RowWidth)+i),  -- serial connection of all rows
          CfgDataOut_o => CfgData(1 + RowOffset(RowWidth)+i+1));

      RowNextStateVec_s((RowOffset(RowWidth)+i+1)*StateWidth-1  downto (RowOffset(RowWidth)+i)*StateWidth ) <= RowNextState_s(RowOffset(RowWidth)+i);
      RowOutputVec_s   ((RowOffset(RowWidth)+i+1)*OutputWidth-1 downto (RowOffset(RowWidth)+i)*OutputWidth) <= RowOutput_s   (RowOffset(RowWidth)+i);
    end generate GenerateTransitionRows;

  end generate GenerateTransitionRowsOfWidth;

  CfgData(0)   <= CfgDataIn_i;
  CfgDataOut_o <= CfgData(NumTransitionRows_c);

  SelectNextState_inst: LargeMux
    generic map (
      NumTransitionRows => NumTransitionRows_c,
      Width             => StateWidth)
    port map (
      Select_i  => RowMatch_s,
      Inputs_i  => RowNextStateVec_s,
      Output_o  => NextState_s);

  StateRegister_1: StateRegister
    generic map (
      StateWidth => StateWidth)
    port map (
      Reset_n_i   => Reset_n_i,
      Clk_i       => Clk_i,
      State_o     => State_s,
      NextState_i => NextState_s);

  SelectOutput_inst: LargeMux
    generic map (
      NumTransitionRows => NumTransitionRows_c,
      Width             => OutputWidth)
    port map (
      Select_i  => RowMatch_s,
      Inputs_i  => RowOutputVec_s,
      Output_o  => OutputMux);

  OutputRegister_inst: OutputRegister
    generic map (
      Width        => OutputWidth)
    port map (
      Clk_i        => Clk_i,
      Reset_n_i    => Reset_n_i,
      Value_i      => OutputMux,
      Value_o      => Output_o,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgData(0),
      CfgDataOut_o => CfgData(1));

end struct;  -- of trfsm
