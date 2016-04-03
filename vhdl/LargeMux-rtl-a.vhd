architecture rtl of LargeMux is
  type Input_t is array (0 to NumTransitionRows-1) of std_logic_vector(Width-1 downto 0);
  signal Inputs     : Input_t;
  signal InputAnd_s : Input_t;
begin -- rtl

  TypeCast: for InputNum in 0 to NumTransitionRows-1 generate
    Inputs(InputNum) <= Inputs_i((InputNum+1)*Width-1 downto InputNum*Width);
  end generate TypeCast;

  AndStruct: for i in 0 to NumTransitionRows-1 generate
    InputAnd_s(i) <= Inputs(i) when Select_i(i) = '1' else (others => '0');
  end generate AndStruct;

  OrStruct: process (InputAnd_s)
    variable result : std_logic;
  begin  -- process OrStruct
    for i in Width-1 downto 0 loop
      result := '0';
      for TR in 0 to NumTransitionRows-1 loop
        result := result or InputAnd_s(TR)(i);
      end loop;  -- TR
      Output_o(i) <= result;
    end loop;  -- i
  end process OrStruct;
  
end rtl;  -- of LargeMux
