library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.generator.all;

entity Monopolar_Simple is
--------------- WORK IN PROGRESS!!
  port (
    clk, reset : in std_logic;
    sys_i : in mon_simple_in_type;
    sys_o : out mon_simple_out_type
  );
end Monopolar_Simple;

architecture Behavioral of Monopolar_Simple is
 
  type reg_type is record
    state: state_type;
    counter_pos_gen: std_logic_vector(sys_i.pulse_pos_gen_duration'range);
    counter_pause_mono: std_logic_vector(sys_i.pause_mono_duration'range);
    counter_pause_burst: std_logic_vector(sys_i.pause_burst_duration'range);
    number_counter: std_logic_vector(sys_i.pulse_number'range);
    burst_counter : std_logic_vector(sys_i.burst_number'range);
    trigger_flag, trigger_start: std_logic;
  end record;

  constant init : reg_type := (
    state => fsm_sleep,
    counter_pos_gen => (others => '0'),
    counter_pause_mono => (others => '0'),
    counter_pause_burst => (others => '0'),
    number_counter => (others => '0'),
    burst_counter => (others => '0'),
    trigger_flag => '0',
    trigger_start => '0'
  );

  --main signals
  signal r, rin: reg_type := init;

  subtype slv is std_logic_vector; -- abbreviation

begin
----------------------------------------------------------------------------------------------------------------------------------------------------
  comb: process(reset, r, sys_i)
  variable v: reg_type;
  begin
  --================================================================================================================================================
    --Copy current state to variable
    v := r;
  --================================================================================================================================================
    --State Machine
    case r.state is
      --Sleep State
      when fsm_sleep =>
        if r.trigger_start = '1' then
          v.state := fsm_pos_gen;
        else
         v := init; --stay sleeping
        end if;
      --Positive Generation
      when fsm_pos_gen =>
        if signed(r.counter_pos_gen) >= signed(sys_i.pulse_pos_gen_duration) - 1 then
          v.counter_pos_gen := (others => '0');
          v.number_counter := slv(signed(v.number_counter) + 1); --increment counter in monopolar mode
          if signed(v.number_counter) >= signed(sys_i.pulse_number) then
            if signed(r.burst_counter) >= signed(sys_i.burst_number) - 1 then
              v.state := fsm_sleep;
            else
              v.state := fsm_pause_burst; --Don't like this------
            end if;
          else
            v.state := fsm_pause_mono;
          end if;
        else
          v.counter_pos_gen := slv(signed(v.counter_pos_gen) + 1); --increment state counter
        end if;
      --Pause Monopolar
      when fsm_pause_mono =>
        if signed(r.counter_pause_mono) >= signed(sys_i.pause_mono_duration) - 1 then
          v.counter_pause_mono := (others => '0');
          v.state := fsm_pos_gen;
        else
          v.counter_pause_mono := slv(signed(v.counter_pause_mono) + 1); --increment state counter
        end if;
      --Pause Burst
      when fsm_pause_burst =>
        if signed(r.counter_pause_burst) >= signed(sys_i.pause_burst_duration) - 1 then
          v.counter_pause_burst := (others => '0');
          v.number_counter := (others => '0');
          v.burst_counter := slv(signed(v.burst_counter) + 1); --increment burst counter
          v.state := fsm_pos_gen;
        else
          v.counter_pause_burst := slv(signed(v.counter_pause_burst) + 1); --increment state counter
        end if;
      --Should never come here.
      when others =>
        null;
    end case;
  --================================================================================================================================================
    --One-shot trigger
    if r.trigger_flag = '0' AND sys_i.GEN_START = '1' then
      v.trigger_start := '1';
    else
      v.trigger_start := '0';
    end if;
  --================================================================================================================================================
    --reset system
    if reset = '1' then
      v := init;
    end if;
  --================================================================================================================================================
    sys_o.state_out <= r.state; --set output
    rin <= v; --update next state
  --================================================================================================================================================
  end process comb;
----------------------------------------------------------------------------------------------------------------------------------------------------
  regs: process(clk)
  begin
    if rising_edge(clk) then
      r <= rin;
      r.trigger_flag <= sys_i.GEN_START;
    end if;
  end process regs;
----------------------------------------------------------------------------------------------------------------------------------------------------

end Behavioral;
