library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.generator.all;


entity State_Decoder is
  -- generic(
  --  out_sleep: std_logic_vector(3 downto 0):= "0000";
  --  out_pos_prep: std_logic_vector(3 downto 0):= "0010";
  --  out_pos_gen: std_logic_vector(3 downto 0):= "1010";
  --  out_pos_dis: std_logic_vector(3 downto 0):= "0011";
  --  out_neg_prep: std_logic_vector(3 downto 0):= "0001";
  --  out_neg_gen: std_logic_vector(3 downto 0):= "0101";
  --  out_neg_dis: std_logic_vector(3 downto 0):= "0011"
  -- );
  port(
    clk, reset : in std_logic;
    sys_i: in decoder_in_type;
    sys_o: out decoder_out_type
  );
end State_Decoder;

architecture Behavioral of State_Decoder is
 
  type reg_type is record
    state_load: state_type;
    out_buff: decoder_out_type;
    ICE_trigger: std_logic;
  end record;

  constant init: reg_type := (
    state_load => fsm_sleep,
    out_buff => (
      GEN_END_OUT => '0',
      GEN_POS_PULSE => '0',
      GEN_NEG_PULSE => '0',
      MOS_DRIVER_OUT => out_sleep
    ),
    ICE_trigger => '0'
  );

  signal r, rin : reg_type := init;
begin
----------------------------------------------------------------------------------------------------------------------------------------------------
  comb: process(sys_i, r, reset)
  variable v : reg_type;
  begin
  --================================================================================================================================================
    v := r;
  --================================================================================================================================================
    if reset = '1' then
      v := init;
    elsif r.ICE_trigger = '1' then
      v.state_load := fsm_ICE;
    else
      v.state_load := sys_i.state_load;
    end if;
  --================================================================================================================================================
    if sys_i.ICE = '1' then
      v.ICE_trigger := '1';
      v.state_load := fsm_ICE;
    end if;
  --================================================================================================================================================
    case r.state_load is --determine outputs
      when fsm_sleep =>
        v.out_buff.GEN_END_OUT := '1';
        v.out_buff.GEN_POS_PULSE := '0';
        v.out_buff.GEN_NEG_PULSE := '0';
        v.out_buff.MOS_DRIVER_OUT := out_sleep;
      when fsm_pos_prep =>
        v.out_buff.GEN_END_OUT := '0';
        v.out_buff.GEN_POS_PULSE := '0';
        v.out_buff.GEN_NEG_PULSE := '0';
        v.out_buff.MOS_DRIVER_OUT := out_pos_prep;
      when fsm_pos_gen =>
        v.out_buff.GEN_END_OUT := '0';
        v.out_buff.GEN_POS_PULSE := '1';
        v.out_buff.GEN_NEG_PULSE := '0';
        v.out_buff.MOS_DRIVER_OUT := out_pos_gen;
      when fsm_pos_dis =>
        v.out_buff.GEN_END_OUT := '0';
        v.out_buff.GEN_POS_PULSE := '0';
        v.out_buff.GEN_NEG_PULSE := '0';
        v.out_buff.MOS_DRIVER_OUT := out_pos_dis;
      when fsm_neg_prep =>
        v.out_buff.GEN_END_OUT := '0';
        v.out_buff.GEN_POS_PULSE := '0';
        v.out_buff.GEN_NEG_PULSE := '0';
        v.out_buff.MOS_DRIVER_OUT := out_neg_prep;
      when fsm_neg_gen =>
        v.out_buff.GEN_END_OUT := '0';
        v.out_buff.GEN_POS_PULSE := '0';
        v.out_buff.GEN_NEG_PULSE := '1';
        v.out_buff.MOS_DRIVER_OUT := out_neg_gen;
      when fsm_neg_dis =>
        v.out_buff.GEN_END_OUT := '0';
        v.out_buff.GEN_POS_PULSE := '0';
        v.out_buff.GEN_NEG_PULSE := '0';
        v.out_buff.MOS_DRIVER_OUT := out_neg_dis;
      when fsm_pause_bipol | fsm_pause_mono | fsm_pause_burst =>
        v.out_buff.GEN_END_OUT := '0';
        v.out_buff.GEN_POS_PULSE := '0';
        v.out_buff.GEN_NEG_PULSE := '0';
        v.out_buff.MOS_DRIVER_OUT := out_sleep;
      when fsm_ICE =>
        v.out_buff.GEN_END_OUT := '1';
        v.out_buff.GEN_POS_PULSE := '0';
        v.out_buff.GEN_NEG_PULSE := '0';
        v.out_buff.MOS_DRIVER_OUT := out_ICE;
      when others =>
        null;
    end case;
  --================================================================================================================================================
    sys_o <= r.out_buff;
    rin <= v;
  --================================================================================================================================================
  end process;
----------------------------------------------------------------------------------------------------------------------------------------------------
  reg: process(clk)
  begin
  --================================================================================================================================================
    if rising_edge(clk) then
      r <= rin;
    end if;
  --================================================================================================================================================
  end process;
----------------------------------------------------------------------------------------------------------------------------------------------------

end Behavioral;
