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

entity OutputRegister is
  generic (
    Width        : integer range 1 to 256
  );
  port (
    Clk_i        : in  std_logic;
    Reset_n_i    : in  std_logic;
    Value_i      : in  std_logic_vector(Width-1 downto 0);
    Value_o      : out std_logic_vector(Width-1 downto 0);
    -- Configuration
    CfgMode_i    : in  std_logic;
    CfgClk_i     : in  std_logic;
    CfgShift_i   : in  std_logic;
    CfgDataIn_i  : in  std_logic;
    CfgDataOut_o : out std_logic
  );
end OutputRegister;

-- vim: ff=unix:fenc=utf-8:ft=vhdl:tw=0:ts=2:ss=2:sw=2:ai:et:
