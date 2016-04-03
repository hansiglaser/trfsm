library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.trfsmparts.all;

use work.TRFSMParts.all;

entity LargeMux is
  generic (
    NumTransitionRows : integer range 1 to 1024;
    Width             : integer range 1 to 256
  );
  port (
    Select_i  : in  std_logic_vector(NumTransitionRows      -1 downto 0);
    Inputs_i  : in  std_logic_vector(NumTransitionRows*Width-1 downto 0);
    Output_o  : out std_logic_vector(Width-1 downto 0)
  );
end LargeMux;
