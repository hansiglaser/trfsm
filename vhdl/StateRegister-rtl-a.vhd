architecture rtl of StateRegister is
begin -- rtl

  StoreState: process (Clk_i, Reset_n_i)
  begin  -- process StoreState
    if Reset_n_i = '0' then               -- asynchronous reset (active low)
      State_o <= (others => '0');
    elsif Clk_i'event and Clk_i = '1' then  -- rising clock edge
      State_o <= NextState_i;
    end if;
  end process StoreState;

end rtl;  -- of StateRegister
