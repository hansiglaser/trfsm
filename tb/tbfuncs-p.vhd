library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.std_logic_textio.all;

package tbfuncs is 

  function Vector2String(constant V : in std_logic_vector) return string;
  function Vector2String(constant V : in std_logic) return string;

  impure function CheckStdLogic (
    constant Value     : in std_logic;
    constant Reference : in std_logic;
    constant Name      : in string
    ) return boolean;

  impure function CheckStdLogicVector (
    constant Value     : in std_logic_vector;
    constant Reference : in std_logic_vector;
    constant Name      : in string
    ) return boolean;

end tbfuncs;

package body tbfuncs is 

  function Vector2String(constant V : in std_logic_vector) return string is
    variable i : integer;
    variable s : string(1 to V'length);
  begin
    s := (others => 'r');
    for i in V'high downto V'low loop
      case V(i) is
        when '0'    => s(V'high-i+1) := '0';
        when '1'    => s(V'high-i+1) := '1';
        when 'U'    => s(V'high-i+1) := 'U';
        when 'X'    => s(V'high-i+1) := 'X';
        when others => s(V'high-i+1) := '?';
      end case;
    end loop;
    return s;
  end Vector2String;
  
  function Vector2String(constant V : in std_logic) return string is
    variable s : string(1 to 1);
  begin
    s := (others => 'r');
    case V is
      when '0' => s(1) := '0';
      when '1' => s(1) := '1';
      when 'U' => s(1) := 'U';
      when 'X' => s(1) := 'X';
      when others => s(1) := '?';
    end case;
    return s;
  end Vector2String;

  impure function CheckStdLogic (
    constant Value     : in std_logic;
    constant Reference : in std_logic;
    constant Name      : in string
    ) return boolean is
    variable l : line;
  begin  -- CheckStdLogic
    if Value = Reference then
      return true;
    end if;
    write(l,Name);
    write(l,string'(" is wrong ("));
    write(l,Value);
    write(l,string'(") but should be "));
    Write(l,Reference);
    writeline(std.textio.output,l);
    return false;
  end CheckStdLogic;

  impure function CheckStdLogicVector (
    constant Value     : in std_logic_vector;
    constant Reference : in std_logic_vector;
    constant Name      : in string
    ) return boolean is
    variable l : line;
  begin  -- CheckStdLogic
    if Value = Reference then
      return true;
    end if;
    write(l,Name);
    write(l,string'(" is wrong ("));
    write(l,Value);
    write(l,string'(") but should be "));
    Write(l,Reference);
    writeline(std.textio.output,l);
    return false;
  end CheckStdLogicVector;

end tbfuncs;
