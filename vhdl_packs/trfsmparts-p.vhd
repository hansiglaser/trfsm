library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

package TRFSMParts is

  component StateSelectionGate
    generic (
      StateWidth : integer range 1 to 10);
    port (
      Reset_n_i    : in  std_logic;
      State_i      : in  std_logic_vector(StateWidth-1 downto 0);
      Match_o      : out std_logic;
      CfgMode_i    : in  std_logic;
      CfgClk_i     : in  std_logic;
      CfgShift_i   : in  std_logic;
      CfgDataIn_i  : in  std_logic;
      CfgDataOut_o : out std_logic);
  end component;

  component InputSwitchingMatrix
    generic (
      InputWidth  : integer range 1 to 256;
      OutputWidth : integer range 1 to 256);
    port (
      Reset_n_i    : in  std_logic;
      Input_i      : in  std_logic_vector(InputWidth-1 downto 0);
      Output_o     : out std_logic_vector(OutputWidth-1 downto 0);
      CfgMode_i    : in  std_logic;
      CfgClk_i     : in  std_logic;
      CfgShift_i   : in  std_logic;
      CfgDataIn_i  : in  std_logic;
      CfgDataOut_o : out std_logic);
  end component;

  component InputPatternGate
    generic (
      InputWidth : integer range 1 to 10);
    port (
      Reset_n_i    : in  std_logic;
      Enable_i     : in  std_logic;
      Input_i      : in  std_logic_vector(InputWidth-1 downto 0);
      Match_o      : out std_logic;
      CfgMode_i    : in  std_logic;
      CfgClk_i     : in  std_logic;
      CfgShift_i   : in  std_logic;
      CfgDataIn_i  : in  std_logic;
      CfgDataOut_o : out std_logic);
  end component;

  component ConfigRegister
    generic (
      Width : integer range 1 to 1024);
    port (
      Reset_n_i    : in  std_logic;
      Output_o     : out std_logic_vector(Width-1 downto 0);
      CfgMode_i    : in  std_logic;
      CfgClk_i     : in  std_logic;
      CfgShift_i   : in  std_logic;
      CfgDataIn_i  : in  std_logic;
      CfgDataOut_o : out std_logic);
  end component;

  component TransitionRow
    generic (
      TotalInputWidth : integer range 1 to 256;
      MyInputWidth    : integer range 0 to 10;
      StateWidth      : integer range 1 to 10;
      OutputWidth     : integer range 1 to 256);
    port (
      Reset_n_i    : in  std_logic;
      Input_i      : in  std_logic_vector(TotalInputWidth-1 downto 0);
      State_i      : in  std_logic_vector(StateWidth-1 downto 0);
      Match_o      : out std_logic;
      NextState_o  : out std_logic_vector(StateWidth-1 downto 0);
      Output_o     : out std_logic_vector(OutputWidth-1 downto 0);
      CfgMode_i    : in  std_logic;
      CfgClk_i     : in  std_logic;
      CfgShift_i   : in  std_logic;
      CfgDataIn_i  : in  std_logic;
      CfgDataOut_o : out std_logic);
  end component;

  component LargeMux
    generic (
      NumTransitionRows : integer;
      Width             : integer);
    port (
      Select_i  : in  std_logic_vector(NumTransitionRows -1 downto 0);
      Inputs_i  : in  std_logic_vector(NumTransitionRows*Width-1 downto 0);
      Output_o  : out std_logic_vector(Width-1 downto 0));
  end component;

  component StateRegister
    generic (
      StateWidth : integer range 1 to 8);
    port (
      Reset_n_i   : in  std_logic;
      Clk_i       : in  std_logic;
      State_o     : out std_logic_vector(StateWidth-1 downto 0);
      NextState_i : in  std_logic_vector(StateWidth-1 downto 0));
  end component;

end TRFSMParts;

package body TRFSMParts is

end TRFSMParts;
