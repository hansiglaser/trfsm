library ieee;
use ieee.std_logic_1164.all;

use work.TRFSMParts.all;

entity TransitionRow is
  generic (
    TotalInputWidth : integer range 1 to 256;
    MyInputWidth    : integer range 0 to 10;
    StateWidth      : integer range 1 to 10;
    OutputWidth     : integer range 1 to 256
  );
  port (
    Reset_n_i    : in  std_logic;
    Input_i      : in  std_logic_vector(TotalInputWidth-1 downto 0);
    State_i      : in  std_logic_vector(StateWidth-1 downto 0);
    Match_o      : out std_logic;
    NextState_o  : out std_logic_vector(StateWidth-1 downto 0);
    Output_o     : out std_logic_vector(OutputWidth-1 downto 0);
    -- Configuration
    CfgMode_i    : in  std_logic;
    CfgClk_i     : in  std_logic;
    CfgShift_i   : in  std_logic;
    CfgDataIn_i  : in  std_logic;
    CfgDataOut_o : out std_logic
  );
end TransitionRow;
