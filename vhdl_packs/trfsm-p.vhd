-------------------------------------------------------------------------------
-- Title      : TRFSM Package
-- Project    :
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package TRFSMPkg is

  component TRFSM
    generic (
      InputWidth      : integer range 1 to 256;
      OutputWidth     : integer range 1 to 256;
      StateWidth      : integer range 1 to 8;
      NumRows0        : integer;
      NumRows1        : integer;
      NumRows2        : integer;
      NumRows3        : integer;
      NumRows4        : integer;
      NumRows5        : integer;
      NumRows6        : integer;
      NumRows7        : integer;
      NumRows8        : integer;
      NumRows9        : integer
    );
    port (
      Reset_n_i     : in  std_logic;
      Clk_i         : in  std_logic;
      Input_i       : in  std_logic_vector(InputWidth-1 downto 0);
      Output_o      : out std_logic_vector(OutputWidth-1 downto 0);
      -- Configuration
      CfgMode_i     : in  std_logic;
      CfgClk_i      : in  std_logic;
      CfgShift_i    : in  std_logic;
      CfgDataIn_i   : in  std_logic;
      CfgDataOut_o  : out std_logic
    );
  end component;

end TRFSMPkg;


package body TRFSMPkg is

end TRFSMPkg;
