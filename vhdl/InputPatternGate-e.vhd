library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.trfsmparts.all;

entity InputPatternGate is
  generic (
    InputWidth : integer range 1 to 10
  );
  port (
    Reset_n_i    : in  std_logic;
    Enable_i     : in  std_logic;
    Input_i      : in  std_logic_vector(InputWidth-1 downto 0);
    Match_o      : out std_logic;
    -- Configuration
    CfgMode_i    : in  std_logic;
    CfgClk_i     : in  std_logic;
    CfgShift_i   : in  std_logic;
    CfgDataIn_i  : in  std_logic;
    CfgDataOut_o : out std_logic
  );
end InputPatternGate;
