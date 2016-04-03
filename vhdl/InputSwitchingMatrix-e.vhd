library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;            -- or_reduce()
use work.trfsmparts.all;

entity InputSwitchingMatrix is
  generic (
    InputWidth  : integer range 1 to 256;
    OutputWidth : integer range 1 to 256
  );
  port (
    Reset_n_i    : in  std_logic;
    Input_i      : in  std_logic_vector(InputWidth-1 downto 0);
    Output_o     : out std_logic_vector(OutputWidth-1 downto 0);
    -- Configuration
    CfgMode_i    : in  std_logic;
    CfgClk_i     : in  std_logic;
    CfgShift_i   : in  std_logic;
    CfgDataIn_i  : in  std_logic;
    CfgDataOut_o : out std_logic
  );
end InputSwitchingMatrix;
