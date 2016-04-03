library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.tbfuncs.all;

package tb_trfsmpkg is 

  function CalcTRConfigLength (
    constant StateWidth      : integer;
    constant TotalInputWidth : integer;
    constant MyInputWidth    : integer;
    constant OutputWidth     : integer)
    return integer;

  function CalcTRFSMConfigLength (
    constant InputWidth      : integer;
    constant OutputWidth     : integer;
    constant StateWidth      : integer;
    constant UseCurrentState : integer;
    constant NumRows0        : integer;
    constant NumRows1        : integer;
    constant NumRows2        : integer;
    constant NumRows3        : integer;
    constant NumRows4        : integer;
    constant NumRows5        : integer;
    constant NumRows6        : integer;
    constant NumRows7        : integer;
    constant NumRows8        : integer;
    constant NumRows9        : integer)
    return integer;

  -- InputPattern: accepts a string with a comma (',') separated list of input
  --   patterns for which the transition rows should be activated. Each pattern
  --   has to contain exactly TotalInputWidth characters of which up to MyInputWidth
  --   are either '0' or '1', the others must be 'x'. The places of these must
  --   match for all patterns.
  function GenTRConfigBitStream (
    constant StateWidth      : integer;
    constant TotalInputWidth : integer;
    constant MyInputWidth    : integer;
    constant OutputWidth     : integer;
    constant InputPattern    : string; --InputPatterns_t;
    constant State           : std_logic_vector;
    constant NextState       : std_logic_vector;
    constant Output          : std_logic_vector)
    return std_logic_vector;

end tb_trfsmpkg;

package body tb_trfsmpkg is 

  function CalcTRConfigLength (
    constant StateWidth      : integer;
    constant TotalInputWidth : integer;
    constant MyInputWidth    : integer;
    constant OutputWidth     : integer)
    return integer is
    variable ISMplusIPG : integer;
  begin
    if MyInputWidth > 0 then
      ISMplusIPG := 
        TotalInputWidth +                   -- Input Switching Matrix
        2**MyInputWidth;                    -- Input Pattern Gate
    else
      ISMplusIPG := 0;
    end if;
    return
      StateWidth +                        -- State Selection Gate
      ISMplusIPG +
      StateWidth +                        -- Next State Register
      OutputWidth;                        -- Output Pattern Gate    
  end CalcTRConfigLength;

  function CalcTRFSMConfigLength (
    constant InputWidth      : integer;
    constant OutputWidth     : integer;
    constant StateWidth      : integer;
    constant UseCurrentState : integer;
    constant NumRows0        : integer;
    constant NumRows1        : integer;
    constant NumRows2        : integer;
    constant NumRows3        : integer;
    constant NumRows4        : integer;
    constant NumRows5        : integer;
    constant NumRows6        : integer;
    constant NumRows7        : integer;
    constant NumRows8        : integer;
    constant NumRows9        : integer)
    return integer is
  begin
    return
      NumRows0*CalcTRConfigLength(StateWidth,InputWidth,0,OutputWidth) + 
      NumRows1*CalcTRConfigLength(StateWidth,InputWidth,1,OutputWidth) + 
      NumRows2*CalcTRConfigLength(StateWidth,InputWidth,2,OutputWidth) + 
      NumRows3*CalcTRConfigLength(StateWidth,InputWidth,3,OutputWidth) + 
      NumRows4*CalcTRConfigLength(StateWidth,InputWidth,4,OutputWidth) + 
      NumRows5*CalcTRConfigLength(StateWidth,InputWidth,5,OutputWidth) + 
      NumRows6*CalcTRConfigLength(StateWidth,InputWidth,6,OutputWidth) + 
      NumRows7*CalcTRConfigLength(StateWidth,InputWidth,7,OutputWidth) + 
      NumRows8*CalcTRConfigLength(StateWidth,InputWidth,8,OutputWidth) + 
      NumRows9*CalcTRConfigLength(StateWidth,InputWidth,9,OutputWidth);
  end CalcTRFSMConfigLength;

  function GenTRConfigBitStream (
    constant StateWidth      : integer;
    constant TotalInputWidth : integer;
    constant MyInputWidth    : integer;
    constant OutputWidth     : integer;
    constant InputPattern    : string;
    constant State           : std_logic_vector;
    constant NextState       : std_logic_vector;
    constant Output          : std_logic_vector
  ) return std_logic_vector is
    variable CfgOurState     : std_logic_vector(StateWidth-1 downto 0);
    variable CfgInputSelect  : std_logic_vector(TotalInputWidth-1 downto 0);
    variable CfgInputPattern : std_logic_vector(2**MyInputWidth-1 downto 0);
    variable CfgNextState    : std_logic_vector(StateWidth-1 downto 0);
    variable CfgOutput       : std_logic_vector(OutputWidth-1 downto 0);
    variable InputPatternCondensed : std_logic_vector(MyInputWidth-1 downto 0);
    variable IPGInputIdx : integer;
    variable PatternIdx  : integer;
    variable Inverted    : boolean;
  begin
    assert false report "GenTRConfigBitStream: InputPattern = " & InputPattern & ", State = " & Vector2String(State) & ", NextState = " & Vector2String(NextState) & ", Output = " & Vector2String(Output) severity note;
    CfgOurState := State;
    CfgInputPattern := (others => '0');
    CfgInputSelect  := (others => '0');
    if (InputPattern'length > 0) and (InputPattern(1) = '!') then
      Inverted   := true;
      PatternIdx := 2;
    else
      Inverted   := false;
      PatternIdx := 1;
    end if;
    while InputPattern'length >= PatternIdx loop -- should be "true" but we spare the "if InputPattern'length > 0 then" around this loop
      IPGInputIdx := MyInputWidth-1;
      InputPatternCondensed := (others => '0');  -- fill with zeros because if we have an unused input, it will be 0 from the ISM
      for ISMInputIdx in TotalInputWidth-1 downto 0 loop
        if InputPattern(PatternIdx) /= 'x' then
          -- enable this output for the ISM
          CfgInputSelect(ISMInputIdx) := '1';
          -- correct IPGInputIdx if we select an input at the right end where we can spare switches
          if (ISMInputIdx < (MyInputWidth-1)) and (IPGInputIdx > ISMInputIdx) then
            IPGInputIdx := ISMInputIdx;
          end if;
          -- copy this state to the IPG input pattern
          case InputPattern(PatternIdx) is
            when '0' => InputPatternCondensed(IPGInputIdx) := '0';
            when '1' => InputPatternCondensed(IPGInputIdx) := '1';
            when others => assert false report "Invalid input character " & InputPattern(ISMInputIdx) & " at " & integer'image(PatternIdx) severity failure;
          end case;
          IPGInputIdx := IPGInputIdx - 1;
          -- ensure that we have at most MyInputWidth '0's and '1's
          assert IPGInputIdx >= -1 report "Input pattern has too many sensitive bits at " & integer'image(PatternIdx) severity failure;
        end if;
        PatternIdx := PatternIdx + 1;
      end loop;  -- ISMInputIdx
      assert false report "Condensed = " & Vector2String(InputPatternCondensed) severity note;
      assert false report "PatternIdx = " & integer'image(PatternIdx) severity note;
      CfgInputPattern(conv_integer(InputPatternCondensed)) := '1';
      if PatternIdx >= InputPattern'length then
        exit;                           -- leave this loop
      end if;
      assert InputPattern(PatternIdx) = ',' report "Invalid character '" & InputPattern(PatternIdx) & "' in InputPattern at " & integer'image(PatternIdx) severity failure;
      PatternIdx := PatternIdx + 1;
    end loop;
    if Inverted then
      CfgInputPattern := not CfgInputPattern;
    end if;
    CfgNextState := NextState;
    CfgOutput := Output;
    -- special case: MyInputWidth = 0
    if MyInputWidth = 0 then
      return
        CfgOurState &
        CfgNextState &
        CfgOutput;
    end if;
    -- general case: MyInputWidth > 0
    assert false report "CfgInputSelect = " & Vector2String(CfgInputSelect) severity note;
    assert false report "CfgInputPattern = " & Vector2String(CfgInputPattern) severity note;
    return
       CfgOurState &
       CfgInputSelect &
       CfgInputPattern &
       CfgNextState &
       CfgOutput;
  end GenTRConfigBitStream;

end tb_trfsmpkg;
