library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package pulse_gen_comp is
  --inputs
  type pulse_in_type is record
    GEN_START: std_logic;
  end record;
  --outputs
  type pulse_out_type is record
    GEN_END_OUT: std_logic;
    GEN_POS_PULSE: std_logic;
    GEN_NEG_PULSE: std_logic;
    MOS_DRIVER_OUT: std_logic_vector;
--    MOS_DRIVER_OUT: std_logic_vector(3 downto 0);
  end record;

  component pulse_gen
    generic (val:integer:=4);
    port(
      clk: in std_logic;
      reset_n: in std_logic;
      sys_i: in pulse_in_type;
      sys_o: in pulse_out_type
    );
  end component;
end package;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_arith.all;
use work.pulse_gen_comp.all;

entity Pulse_Gen_Burst is

generic (
  out_sleep: std_logic_vector(3 downto 0):= "0000";
  out_pos_prep: std_logic_vector(3 downto 0):= "0010";
  out_pos_gen: std_logic_vector(3 downto 0):= "1010";
  out_pos_dis: std_logic_vector(3 downto 0):= "0011";
  out_neg_prep: std_logic_vector(3 downto 0):= "0001";
  out_neg_gen: std_logic_vector(3 downto 0):= "0101";
  out_neg_dis: std_logic_vector(3 downto 0):= "0011";
  out_sleep2: std_logic_vector(3 downto 0):= "1111";
  out_error: std_logic_vector(3 downto 0):= "0111";

  bipolar_gen_enable: std_logic :='1';
  pre_post_states_enable: std_logic :='1';

  pulse_number: std_logic_vector(7 downto 0):=x"02";
  burst_number: std_logic_vector(7 downto 0):=x"02";

  pulse_pos_duration: std_logic_vector(15 downto 0):=x"0003";
  pulse_neg_duration: std_logic_vector(15 downto 0):=x"0005";

  positive_prep_duration:std_logic_vector(15 downto 0):=x"0002";
  positive_dis_duration: std_logic_vector(15 downto 0):=x"0002";
  negative_prep_duration: std_logic_vector(15 downto 0):=x"0002";
  negative_dis_duration: std_logic_vector(15 downto 0):=x"0002";

  pause_mono_duration: std_logic_vector(15 downto 0):=x"0002";
  pause_bipol_duration: std_logic_vector(15 downto 0):=x"0004";
  pause_burst_duration: std_logic_vector(15 downto 0):=x"0010";

  mylen: integer := 4

);

port(
  clk: in std_logic;
  reset_n: in std_logic;
  sys_i: in pulse_in_type;
  sys_o: out pulse_out_type(MOS_DRIVER_OUT((mylen-1) downto 0))
);
end Pulse_Gen_Burst;

architecture Behavioral of Pulse_Gen_Burst is

--subtype pulse_out_type is pulse_out_type(MOS_DRIVER_OUT((mylen-1) downto 0));


  type state_type is (
      fsm_sleep,
      fsm_pos_prep,
      fsm_pos_gen,
      fsm_pos_dis,
      fsm_pause_mono,
      fsm_neg_prep,
      fsm_neg_gen,
      fsm_neg_dis,
      fsm_pause_bipol,
      fsm_pause_burst
  );

  type reg_type is record
    state: state_type;
    state_counter, number_counter, burst_counter : std_logic_vector(15 downto 0); --duration of state counter
    drive: pulse_out_type;
    trigger_flag, trigger_start: std_logic;
  end record;

  constant init : reg_type := (
    state => fsm_sleep,
    state_counter => (others => '0'),
    number_counter => (others => '0'),
    burst_counter => (others => '0'),
    drive => (
      GEN_END_OUT => '1',
      GEN_POS_PULSE => '0',
      GEN_NEG_PULSE => '0',
      MOS_DRIVER_OUT => out_sleep),
    trigger_flag => '0',
    trigger_start => '0'
  );

  --main signals
  signal r, rin: reg_type := init;

  subtype slv is std_logic_vector; -- abbreviation

begin
----------------------------------------------------------------------------------------------------------------------------------------------------
  --link the signals to outputs
  sys_o.GEN_END_OUT <= r.drive.GEN_END_OUT;
  sys_o.GEN_POS_PULSE <= r.drive.GEN_POS_PULSE;
  sys_o.GEN_NEG_PULSE <= r.drive.GEN_NEG_PULSE;
  sys_o.MOS_DRIVER_OUT <= r.drive.MOS_DRIVER_OUT;
----------------------------------------------------------------------------------------------------------------------------------------------------
  comb: process(reset_n, r, sys_i.GEN_START)
  variable v: reg_type;
  begin
    --copy current state to variable
    v := r;
    v.state_counter := slv(unsigned(v.state_counter) + 1); --increment state counter

    -- if r.state /= fsm_pause_burst then
    --   v.burst_counter := (others => '0');
    -- end if;

    --one-shot trigger
    if r.trigger_flag = '0' AND sys_i.GEN_START = '1' then
      v.trigger_start := '1';
    else
      v.trigger_start := '0';
    end if;

    -- state machine
    case r.state is
      when fsm_sleep =>
        if v.trigger_start = '1' AND pre_post_states_enable = '0' then
          v.state := fsm_pos_gen;
        elsif v.trigger_start = '1' AND pre_post_states_enable = '1' then
          v.state := fsm_pos_prep;
        else
          v := init; --reset everything when we're in sleep mode
        end if;
      --Positive Preparation
      when fsm_pos_prep =>
        if unsigned(v.state_counter) >= unsigned(positive_prep_duration) then
          v.state := fsm_pos_gen;
        end if;
      --Positive Generation
      when fsm_pos_gen =>
        if unsigned(v.state_counter) >= unsigned(pulse_pos_duration) then
          if pre_post_states_enable = '1' then
            v.state := fsm_pos_dis;
          else
            v.state := fsm_pause_mono;
          end if;
          if bipolar_gen_enable = '0' AND pre_post_states_enable = '0' then --we go to sleep if we reached number of pulses on monopolar mode
            v.number_counter := slv(unsigned(v.number_counter) + 1); --increment counter in monopolar mode
            if unsigned(v.number_counter) >= unsigned(pulse_number) then
              if unsigned(v.burst_counter) >= unsigned(burst_number) - 1 then
                v.state := fsm_sleep;
              else
                v.state := fsm_pause_burst; --Don't like this------
              end if;
            end if;
          end if;
        end if;
      --Positive Discharge
      when fsm_pos_dis =>
        if unsigned(v.state_counter) >= unsigned(positive_dis_duration) then
          if bipolar_gen_enable = '0' then --we go to sleep if we reached number of pulses on monopolar mode
            v.number_counter := slv(unsigned(v.number_counter) + 1); --increment counter in monopolar mode
            if unsigned(v.number_counter) >= unsigned(pulse_number)then
              if unsigned(v.burst_counter) >= unsigned(burst_number) - 1 then
                v.state := fsm_sleep;
              else
                v.state := fsm_pause_burst; --Don't like this------
              end if;
            else
              v.state := fsm_pause_mono;--don't like this
            end if;
          else
            v.state := fsm_pause_mono;
          end if;
        end if;
      --Pause Monopolar
      when fsm_pause_mono =>
        if unsigned(v.state_counter) >= unsigned(pause_mono_duration) then
          if bipolar_gen_enable = '1' AND pre_post_states_enable = '1' then
            v.state := fsm_neg_prep;
          elsif bipolar_gen_enable = '1' AND pre_post_states_enable = '0' then
            v.state := fsm_neg_gen;
          elsif bipolar_gen_enable = '0' AND pre_post_states_enable = '1' then
            v.state := fsm_pos_prep;
          else
            v.state := fsm_pos_gen;
          end if;
        end if;
      --Negative Preparation
      when fsm_neg_prep =>
        if unsigned(v.state_counter) >= unsigned(positive_prep_duration) then
          v.state := fsm_neg_gen;
        end if;
      --Negative Generation
      when fsm_neg_gen =>
        if unsigned(v.state_counter) >= unsigned(pulse_neg_duration) then
          if pre_post_states_enable = '1' then
            v.state := fsm_neg_dis;
          else
            v.state := fsm_pause_bipol;
          end if;
          if pre_post_states_enable = '0' then
            v.number_counter := slv(unsigned(v.number_counter) + 1); --increment counter in bipolar mode
            if unsigned(v.number_counter) >= unsigned(pulse_number) then
              if unsigned(v.burst_counter) >= unsigned(burst_number) - 1 then
                v.state := fsm_sleep;
              else
                v.state := fsm_pause_burst; --Don't like this------
              end if;
            end if;
          end if;
        end if;
      --Negative Discharge
      when fsm_neg_dis =>
        if unsigned(v.state_counter) >= unsigned(positive_prep_duration) then
          v.number_counter := slv(unsigned(v.number_counter) + 1); --increment counter in bipolar mode
          if unsigned(v.number_counter) >= unsigned(pulse_number) then
            if unsigned(v.burst_counter) >= unsigned(burst_number) - 1 then
              v.state := fsm_sleep;
            else
              v.state := fsm_pause_burst; --Don't like this------
            end if;
          else
            v.state := fsm_pause_bipol;
          end if;
        end if;
      --Pause Bipolar
      when fsm_pause_bipol =>
        if unsigned(v.state_counter) >= unsigned(pause_bipol_duration) then
          if pre_post_states_enable = '1' then
            v.state := fsm_pos_prep;
          else
            v.state := fsm_pos_gen;
          end if;
        end if;
      --Pause Burst
      when fsm_pause_burst =>
        if unsigned(v.state_counter) >= unsigned(pause_burst_duration) then
          v.number_counter := (others => '0');
          v.burst_counter := slv(unsigned(v.burst_counter) + 1); --increment burst counter
          if pre_post_states_enable = '1' then
            v.state := fsm_pos_prep;
          else
            v.state := fsm_pos_gen;
          end if;
        end if;
      when others =>
        v := init;
    end case;

    if r.state /= v.state then
      v.state_counter := (others => '0'); --reset counter for next state
    end if;


    --reset system
    if reset_n = '0' then
      v := init;
    end if;

    case v.state is --determine outputs
      when fsm_sleep =>
        v.drive.GEN_END_OUT := '1';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_sleep2;
      when fsm_pos_prep =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_pos_prep;
      when fsm_pos_gen =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '1';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_pos_gen;
      when fsm_pos_dis =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_pos_dis;
      when fsm_neg_prep =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_neg_prep;
      when fsm_neg_gen =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '1';
        v.drive.MOS_DRIVER_OUT := out_neg_gen;
      when fsm_neg_dis =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_neg_dis;
      when fsm_pause_bipol | fsm_pause_mono | fsm_pause_burst =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_sleep;
      when others =>
        null;
    end case;

    rin <= v; --update next state

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
