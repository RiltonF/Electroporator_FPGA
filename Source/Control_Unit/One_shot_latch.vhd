library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.generator.all;


entity One_Shot_Latch is
  port(
    clk, reset : in std_logic;
    sys_i : in latch_full_type;
    gen_mon_simple: out mon_simple_in_type;
    gen_mon_full: out mon_full_in_type;
    gen_bipol_simple: out bipol_simple_in_type;
    gen_bipol_full: out bipol_full_in_type;
    mux_select: out std_logic_vector(1 downto 0)
  );
end One_Shot_Latch;

architecture Behavioral of One_Shot_Latch is

  type reg_type is record
    -- load: std_logic;
    latched_outputs: latch_full_type;
    gen_mon_simple: mon_simple_in_type;
    gen_mon_full: mon_full_in_type;
    gen_bipol_simple: bipol_simple_in_type;
    gen_bipol_full: bipol_full_in_type;
    trigger_flag: std_logic;
    trigger_start: std_logic;
  end record;

  constant init_mon_simple: mon_simple_in_type := (
    GEN_START => '0',
    pulse_number => (others => '0'),
    burst_number => (others => '0'),
    pulse_pos_gen_duration => (others => '0'),
    pause_mono_duration => (others => '0'),
    pause_burst_duration => (others => '0')
  );
  constant init_mon_full: mon_full_in_type := (
    GEN_START => '0',
    pulse_number => (others => '0'),
    burst_number => (others => '0'),
    pulse_pos_prep_duration => (others => '0'),
    pulse_pos_gen_duration => (others => '0'),
    pulse_pos_dis_duration => (others => '0'),
    pause_mono_duration => (others => '0'),
    pause_burst_duration => (others => '0')
  );
  constant init_bipol_simple: bipol_simple_in_type := (
    GEN_START => '0',
    pulse_number => (others => '0'),
    burst_number => (others => '0'),
    pulse_pos_gen_duration => (others => '0'),
    pulse_neg_gen_duration => (others => '0'),
    pause_mono_duration => (others => '0'),
    pause_bipol_duration => (others => '0'),
    pause_burst_duration => (others => '0')
  );
  constant init_bipol_full: bipol_full_in_type := (
    GEN_START => '0',
    pulse_number => (others => '0'),
    burst_number => (others => '0'),
    pulse_pos_prep_duration => (others => '0'),
    pulse_pos_gen_duration => (others => '0'),
    pulse_pos_dis_duration => (others => '0'),
    pulse_neg_prep_duration => (others => '0'),
    pulse_neg_gen_duration => (others => '0'),
    pulse_neg_dis_duration => (others => '0'),
    pause_mono_duration => (others => '0'),
    pause_bipol_duration => (others => '0'),
    pause_burst_duration => (others => '0')
  );

  constant init: reg_type := (
    latched_outputs => (
      s => "00",
      GEN_START => '0',
      pulse_number => (others => '0'),
      burst_number => (others => '0'),
      pulse_pos_prep_duration => (others => '0'),
      pulse_pos_gen_duration => (others => '0'),
      pulse_pos_dis_duration => (others => '0'),
      pulse_neg_prep_duration => (others => '0'),
      pulse_neg_gen_duration => (others => '0'),
      pulse_neg_dis_duration => (others => '0'),
      pause_mono_duration => (others => '0'),
      pause_bipol_duration => (others => '0'),
      pause_burst_duration => (others => '0')
    ),
    gen_mon_simple => init_mon_simple,
    gen_mon_full => init_mon_full,
    gen_bipol_simple => init_bipol_simple,
    gen_bipol_full => init_bipol_full,
    trigger_flag => '0',
    trigger_start => '0'
  );

  signal r, rin : reg_type := init;

begin
  comb: process(sys_i, r, reset)
  variable v : reg_type;
  begin
    v := r;
  --================================================================================================================================================
    --One-shot trigger
    if r.trigger_flag = '0' AND sys_i.GEN_START = '1' then
      v.trigger_start := '1';
    else
      v.trigger_start := '0';
    end if;
  --================================================================================================================================================
    --latch the values
    
    if r.trigger_start = '1' then
      v.latched_outputs := sys_i;
      v.latched_outputs.GEN_START := '1'; --for redundancy in case GEN_START goes low very quickly.
    else
      v.latched_outputs := v.latched_outputs;
      v.latched_outputs.GEN_START := '0'; --need this for consecutive Generations.  
    end if;
  --================================================================================================================================================
    --reset system
    if reset = '1' then
      v := init;
    end if;
  --================================================================================================================================================
    mux_select <= r.latched_outputs.s;
    case( r.latched_outputs.s) is
      when "00" => --Monopolar simple
        --set gen values
        v.gen_mon_simple.GEN_START := r.latched_outputs.GEN_START;
        v.gen_mon_simple.pulse_number := r.latched_outputs.pulse_number;
        v.gen_mon_simple.burst_number := r.latched_outputs.burst_number;
        v.gen_mon_simple.pulse_pos_gen_duration := r.latched_outputs.pulse_pos_gen_duration;
        v.gen_mon_simple.pause_mono_duration := r.latched_outputs.pause_mono_duration;
        v.gen_mon_simple.pause_burst_duration := r.latched_outputs.pause_burst_duration;
        --zero others
        v.gen_mon_full := init_mon_full;
        v.gen_bipol_simple := init_bipol_simple;
        v.gen_bipol_full := init_bipol_full;
      when "01" => --Monopolar full
        --set gen values
        v.gen_mon_full.GEN_START := r.latched_outputs.GEN_START;
        v.gen_mon_full.pulse_number := r.latched_outputs.pulse_number;
        v.gen_mon_full.burst_number := r.latched_outputs.burst_number;
        v.gen_mon_full.pulse_pos_prep_duration := r.latched_outputs.pulse_pos_prep_duration;
        v.gen_mon_full.pulse_pos_gen_duration := r.latched_outputs.pulse_pos_gen_duration;
        v.gen_mon_full.pulse_pos_dis_duration := r.latched_outputs.pulse_pos_dis_duration;
        v.gen_mon_full.pause_mono_duration := r.latched_outputs.pause_mono_duration;
        v.gen_mon_full.pause_burst_duration := r.latched_outputs.pause_burst_duration;
        --zero others
        v.gen_mon_simple := init_mon_simple;
        v.gen_bipol_simple := init_bipol_simple;
        v.gen_bipol_full := init_bipol_full;
      when "10" => --Bipolar simple
        --set gen values
        v.gen_bipol_simple.GEN_START := r.latched_outputs.GEN_START;
        v.gen_bipol_simple.pulse_number := r.latched_outputs.pulse_number;
        v.gen_bipol_simple.burst_number := r.latched_outputs.burst_number;
        v.gen_bipol_simple.pulse_pos_gen_duration := r.latched_outputs.pulse_pos_gen_duration;
        v.gen_bipol_simple.pulse_neg_gen_duration := r.latched_outputs.pulse_neg_gen_duration;
        v.gen_bipol_simple.pause_mono_duration := r.latched_outputs.pause_mono_duration;
        v.gen_bipol_simple.pause_bipol_duration := r.latched_outputs.pause_bipol_duration;
        v.gen_bipol_simple.pause_burst_duration := r.latched_outputs.pause_burst_duration;
        --zero others
        v.gen_mon_simple := init_mon_simple;
        v.gen_mon_full := init_mon_full;
        v.gen_bipol_full := init_bipol_full;
      when "11" => --Bipolar full
        --set gen values
        v.gen_bipol_full.GEN_START := r.latched_outputs.GEN_START;
        v.gen_bipol_full.pulse_number := r.latched_outputs.pulse_number;
        v.gen_bipol_full.burst_number := r.latched_outputs.burst_number;
        v.gen_bipol_full.pulse_pos_prep_duration := r.latched_outputs.pulse_pos_prep_duration;
        v.gen_bipol_full.pulse_pos_gen_duration := r.latched_outputs.pulse_pos_gen_duration;
        v.gen_bipol_full.pulse_pos_dis_duration := r.latched_outputs.pulse_pos_dis_duration;
        v.gen_bipol_full.pulse_neg_prep_duration := r.latched_outputs.pulse_neg_prep_duration;
        v.gen_bipol_full.pulse_neg_gen_duration := r.latched_outputs.pulse_neg_gen_duration;
        v.gen_bipol_full.pulse_neg_dis_duration := r.latched_outputs.pulse_neg_dis_duration;
        v.gen_bipol_full.pause_mono_duration := r.latched_outputs.pause_mono_duration;
        v.gen_bipol_full.pause_bipol_duration := r.latched_outputs.pause_bipol_duration;
        v.gen_bipol_full.pause_burst_duration := r.latched_outputs.pause_burst_duration;
        --zero others
        v.gen_mon_simple := init_mon_simple;
        v.gen_mon_full := init_mon_full;
        v.gen_bipol_simple := init_bipol_simple;
      when others =>
        v.gen_mon_simple := init_mon_simple;
        v.gen_mon_full := init_mon_full;
        v.gen_bipol_simple := init_bipol_simple;
        v.gen_bipol_full := init_bipol_full;
    end case;

    gen_mon_simple <= r.gen_mon_simple;
    gen_mon_full <= r.gen_mon_full;
    gen_bipol_simple <= r.gen_bipol_simple;
    gen_bipol_full <= r.gen_bipol_full;
    rin <= v;
  end process;

  reg: process(clk)
  begin
    if rising_edge(clk) then
      r <= rin;
      r.trigger_flag <= sys_i.GEN_START; --update the init trigger

    end if;
  end process;

end Behavioral;
