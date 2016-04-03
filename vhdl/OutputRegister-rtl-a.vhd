---------------------------------------------------------------------------
-- Output Register for Transition-Based Finite State Machine (TR-FSM)    --
--                                                                       --
-- Copyright (C) 2010-2013 Martin Schmölzer                              --
-- <martin.schmoelzer@student.tuwien.ac.at>                              --
--                                                                       --
-- This program is free software: you can redistribute it and/or modify  --
-- it under the terms of the GNU General Public License as published by  --
-- the Free Software Foundation, either version 3 of the License, or     --
-- (at your option) any later version.                                   --
--                                                                       --
-- This program is distributed in the hope that it will be useful,       --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of        --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         --
-- GNU General Public License for more details.                          --
--                                                                       --
-- You should have received a copy of the GNU General Public License     --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>. --
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.TRFSMParts.all;

architecture rtl of OutputRegister is
  signal UseRegOutputs : std_logic;
  signal RegOutputs    : std_logic_vector(Width-1 downto 0);

begin
  ConfigRegister_inst: ConfigRegister
    generic map (
      Width        => 1)
    port map (
      Reset_n_i    => Reset_n_i,
      Output_o(0)  => UseRegOutputs,
      CfgMode_i    => CfgMode_i,
      CfgClk_i     => CfgClk_i,
      CfgShift_i   => CfgShift_i,
      CfgDataIn_i  => CfgDataIn_i,
      CfgDataOut_o => CfgDataOut_o);

  SetValue: process (Clk_i, Reset_i)
  begin
    if Reset_n_i = '0' then           -- asynchronous reset (active low)
      RegOutputs <= (others => '0');
    elsif Clk_i'event and Clk_i = '1' then
      RegOutputs <= Value_i;
    end if;
  end process SetValue;

  Value_o <= RegOutputs when UseRegOutputs = '1'
    else Value_i;
end rtl;

-- vim: ff=unix:fenc=utf-8:ft=vhdl:tw=0:ts=2:ss=2:sw=2:ai:et:
