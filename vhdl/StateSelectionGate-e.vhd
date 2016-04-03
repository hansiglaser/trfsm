library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.trfsmparts.all;

entity StateSelectionGate is
  generic (
    StateWidth : integer range 1 to 10
  );
  port (
    Reset_n_i    : in  std_logic;
    State_i      : in  std_logic_vector(StateWidth-1 downto 0);
    Match_o      : out std_logic;
    -- Configuration
    CfgMode_i    : in  std_logic;
    CfgClk_i     : in  std_logic;
    CfgShift_i   : in  std_logic;
    CfgDataIn_i  : in  std_logic;
    CfgDataOut_o : out std_logic
  );
end StateSelectionGate;
