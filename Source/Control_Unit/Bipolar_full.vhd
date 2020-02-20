library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.generator.ALL;

entity Bipolar_full is
--------------- WORK IN PROGRESS!!
  port(
    clk, reset : in std_logic;
    sys_i : in bipol_full_in_type;
    sys_o : out bipol_full_out_type
  );
end Bipolar_full;

architecture Behavioral of Bipolar_full is
 
  type reg_type is record
  state: state_type;
  counter_pos_prep: std_logic_vector(sys_i.pulse_pos_prep_duration'range);
  counter_pos_gen: std_logic_vector(sys_i.pulse_pos_gen_duration'range);
  counter_pos_dis: std_logic_vector(sys_i.pulse_pos_dis_duration'range);
  counter_neg_prep: std_logic_vector(sys_i.pulse_neg_prep_duration'range);
  counter_neg_gen: std_logic_vector(sys_i.pulse_neg_gen_duration'range);
  counter_neg_dis: std_logic_vector(sys_i.pulse_neg_dis_duration'range);
  counter_pause_mono: std_logic_vector(sys_i.pause_mono_duration'range);
  counter_pause_bipol: std_logic_vector(sys_i.pause_mono_duration'range);
  counter_pause_burst: std_logic_vector(sys_i.pause_burst_duration'range);
  number_counter: std_logic_vector(sys_i.pulse_number'range);
  burst_counter : std_logic_vector(sys_i.burst_number'range);
  trigger_flag, trigger_start: std_logic;
  end record;

  constant init : reg_type := (
    state => fsm_sleep,
    counter_pos_gen => (others => '0'),
    counter_pos_prep => (others => '0'),
    counter_pos_dis => (others => '0'),
    counter_neg_gen => (others => '0'),
    counter_neg_prep => (others => '0'),
    counter_neg_dis => (others => '0'),
    counter_pause_mono => (others => '0'),
    counter_pause_bipol => (others => '0'),
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
            v.state := fsm_pos_prep;
          else
           v := init; --stay sleeping
          end if;
        --Positive Preparation
        when fsm_pos_prep =>
          if unsigned(r.counter_pos_prep) >= unsigned(sys_i.pulse_pos_prep_duration) - 1 then
            v.counter_pos_prep := (others => '0');
            v.state := fsm_pos_gen;
          else
            v.counter_pos_prep := slv(signed(v.counter_pos_prep) + 1); --increment state counter
          end if;
        --Positive Generation
        when fsm_pos_gen =>
          if signed(r.counter_pos_gen) >= signed(sys_i.pulse_pos_gen_duration) - 1 then
            v.counter_pos_gen := (others => '0');
            v.state := fsm_pos_dis;
          else
            v.counter_pos_gen := slv(signed(v.counter_pos_gen) + 1); --increment state counter
          end if;
        --Positive Discharge
        when fsm_pos_dis =>
          if signed(r.counter_pos_dis) >= signed(sys_i.pulse_pos_dis_duration) - 1 then
            v.counter_pos_dis := (others => '0');
            v.state := fsm_pause_mono;
          else
            v.counter_pos_dis := slv(signed(v.counter_pos_dis) + 1); --increment state counter
          end if;
        --Pause Monopolar
        when fsm_pause_mono =>
          if signed(r.counter_pause_mono) >= signed(sys_i.pause_mono_duration) - 1 then
            v.counter_pause_mono := (others => '0');
            v.state := fsm_neg_prep;
          else
            v.counter_pause_mono := slv(signed(v.counter_pause_mono) + 1); --increment state counter
          end if;
        --Negative Preparation
        when fsm_neg_prep =>
          if unsigned(r.counter_neg_prep) >= unsigned(sys_i.pulse_neg_prep_duration) - 1 then
            v.counter_neg_prep := (others => '0');
            v.state := fsm_neg_gen;
          else
            v.counter_neg_prep := slv(signed(v.counter_neg_prep) + 1); --increment state counter
          end if;
        --Negative Generation
        when fsm_neg_gen =>
          if signed(r.counter_neg_gen) >= signed(sys_i.pulse_neg_gen_duration) - 1 then
            v.counter_neg_gen := (others => '0');
            v.state := fsm_neg_dis;
          else
            v.counter_neg_gen := slv(signed(v.counter_neg_gen) + 1); --increment state counter
          end if;
        --Negative Discharge
        when fsm_neg_dis =>
          if signed(r.counter_neg_dis) >= signed(sys_i.pulse_neg_dis_duration) - 1 then
            v.counter_neg_dis := (others => '0');
            v.number_counter := slv(signed(v.number_counter) + 1); --increment counter in monopolar mode
            if signed(v.number_counter) >= signed(sys_i.pulse_number) then
              if signed(r.burst_counter) >= signed(sys_i.burst_number) - 1 then
                v.state := fsm_sleep;
              else
                v.state := fsm_pause_burst; --Don't like this------
              end if;
            else
              v.state := fsm_pause_bipol;
            end if;
          else
            v.counter_neg_dis := slv(signed(v.counter_neg_dis) + 1); --increment state counter
          end if;
        --Pause Bipolar
        when fsm_pause_bipol =>
          if signed(r.counter_pause_bipol) >= signed(sys_i.pause_bipol_duration) - 1 then
            v.counter_pause_bipol := (others => '0');
            v.state := fsm_pos_prep;
          else
            v.counter_pause_bipol := slv(signed(v.counter_pause_bipol) + 1); --increment state counter
          end if;
        --Pause Burst
        when fsm_pause_burst =>
          if signed(r.counter_pause_burst) >= signed(sys_i.pause_burst_duration) - 1 then
            v.counter_pause_burst := (others => '0');
            v.number_counter := (others => '0');
            v.burst_counter := slv(signed(v.burst_counter) + 1); --increment burst counter
            v.state := fsm_pos_prep;
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
      sys_o.state_out <= r.state;
      rin <= v; --update next state
    --================================================================================================================================================
    end process comb;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
    regs: process(clk)
    begin
    --================================================================================================================================================
      if rising_edge(clk) then
        r <= rin;
        r.trigger_flag <= sys_i.GEN_START;
      end if;
    --================================================================================================================================================
    end process regs;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  end Behavioral;
