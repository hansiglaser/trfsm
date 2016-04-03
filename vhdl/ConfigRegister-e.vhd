library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Config.all;

-- used as Next State Register and as Output Pattern Register
entity ConfigRegister is
  generic (
    Width : integer range 1 to 65536
  );
  port (
    Reset_n_i    : in  std_logic;
    Output_o     : out std_logic_vector(Width-1 downto 0);
    -- Configuration
    CfgMode_i    : in  std_logic;
    CfgClk_i     : in  std_logic;
    CfgShift_i   : in  std_logic;
    CfgDataIn_i  : in  std_logic;
    CfgDataOut_o : out std_logic
  );
end ConfigRegister;
