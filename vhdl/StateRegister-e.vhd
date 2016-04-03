library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity StateRegister is
  generic (
    StateWidth : integer range 1 to 10
  );
  port (
    Reset_n_i   : in  std_logic;
    Clk_i       : in  std_logic;
    -- states
    State_o     : out std_logic_vector(StateWidth-1 downto 0);
    NextState_i : in  std_logic_vector(StateWidth-1 downto 0)
  );
end StateRegister;
