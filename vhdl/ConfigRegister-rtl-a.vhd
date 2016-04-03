
architecture rtl of ConfigRegister is
  signal ValueShift : std_logic_vector(Width-1 downto 0);-- := (others => '0');
begin -- rtl

  CfgClkGatingOff: if not CfgClkGating generate
    -- no clock gating: use CfgMode_i and CfgShift_i to enable shifting

    SetValue: process (CfgClk_i, Reset_n_i)
    begin  -- process SetValue
      if Reset_n_i = '0' then               -- asynchronous reset (active low)
        ValueShift <= (others => '0');
      elsif CfgClk_i'event and CfgClk_i = '1' then  -- rising clock edge
        if CfgMode_i = '1' and CfgShift_i = '1' then
          if Width > 1 then
            -- special case: if Width = 1 we shouldn't do this
            ValueShift(Width-2 downto 0) <= ValueShift(Width-1 downto 1);
          end if;
          ValueShift(Width-1)          <= CfgDataIn_i;
        end if;
      end if;
    end process SetValue;
    
  end generate CfgClkGatingOff;

  CfgClkGatingOn: if CfgClkGating generate
    -- clock gating enabled: CfgClk_i toggles only when we have to shift

    SetValue: process (CfgClk_i, Reset_n_i)
    begin  -- process SetValue
      if Reset_n_i = '0' then               -- asynchronous reset (active low)
        ValueShift <= (others => '0');
      elsif CfgClk_i'event and CfgClk_i = '1' then  -- rising clock edge
        if Width > 1 then
          -- special case: if Width = 1 we shouldn't do this
          ValueShift(Width-2 downto 0) <= ValueShift(Width-1 downto 1);
        end if;
        ValueShift(Width-1)          <= CfgDataIn_i
-- synopsys translate_off
                                                   'delayed(1 ps)
-- synopsys translate_on
                                                                 ;
      end if;
    end process SetValue;

  end generate CfgClkGatingOn;

  CfgDataOut_o <= ValueShift(0);

  Output_o <= ValueShift when CfgMode_i = '0' else
              (others => '0');

end rtl;  -- of ConfigRegister
