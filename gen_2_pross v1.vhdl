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
    MOS_DRIVER_OUT: std_logic_vector(3 downto 0);
  end record;

  component pulse_gen
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

  pulse_number: std_logic_vector(7 downto 0):=x"02";
  burst_number: std_logic_vector(7 downto 0):=x"03";

  pulse_pos_duration: std_logic_vector(15 downto 0):=x"0003";
  pause_mono_duration: std_logic_vector(15 downto 0):=x"0002";
  pause_burst_duration: std_logic_vector(15 downto 0):=x"0009"
);

port(
  clk: in std_logic;
  reset_n: in std_logic;
  sys_i: in pulse_in_type;
  sys_o: out pulse_out_type
);
end Pulse_Gen_Burst;

architecture Behavioral of Pulse_Gen_Burst is

  type state_type is (
      fsm_sleep,
      fsm_pos_gen,
      fsm_pause_mono,
      fsm_pause_burst
  );

  type reg_type is record
    state: state_type;
    state_counter, number_counter,burst_counter : std_logic_vector(15 downto 0); --duration of state counter
    state_done, number_done, burst_done: std_logic;
    drive: pulse_out_type;
  end record;

  constant init : reg_type := (
    state => fsm_sleep,
    state_counter => (others => '0'),
    state_done => '0',
    number_counter => (others => '0'),
    number_done => '0',
    burst_counter => (others => '0'),
    burst_done => '0',    
    drive => (
      GEN_END_OUT => '1',
      GEN_POS_PULSE => '0',
      GEN_NEG_PULSE => '0',
      MOS_DRIVER_OUT => "0000")
  );

  --main signals
  signal r, rin: reg_type := init;


  signal trigger_flag: std_logic :='0';
  signal trigger_start: std_logic :='0';
  
  subtype slv is std_logic_vector; -- abbreviation

begin

  --link the signals to outputs
  sys_o.GEN_END_OUT <= r.drive.GEN_END_OUT;
  sys_o.GEN_POS_PULSE <= r.drive.GEN_POS_PULSE;
  sys_o.GEN_NEG_PULSE <= r.drive.GEN_NEG_PULSE;
  sys_o.MOS_DRIVER_OUT <= r.drive.MOS_DRIVER_OUT;

  comb: process(reset_n, r, trigger_start)
  variable v: reg_type;
  begin
    --copy current state to variable
    v := r;
         
    -- state machine
    case r.state is
      when fsm_sleep =>
        v := init; --reset everything when we're in sleep mode
        if trigger_start = '1' then
          v.state := fsm_pos_gen; 
        end if;
      when fsm_pos_gen =>
        if r.state_counter < pulse_pos_duration then
          v.state_counter := slv(unsigned(v.state_counter) + 1); --increment counter
        else
          v.state_counter := (others => '0'); --reset counter for next state 
          v.number_counter := slv(unsigned(v.number_counter) + 1); --increment counter
          if r.number_counter < pulse_number then
            v.state := fsm_pause_mono;
          else
            v.state := fsm_sleep;
          end if;
        end if;
      when fsm_pause_mono =>
        if r.state_counter < pause_mono_duration  then
          v.state_counter := slv(unsigned(v.state_counter) + 1); --increment counter
        else
          v.state_counter := (others => '0'); --reset counter for next state 
          v.state := fsm_pos_gen;
        end if;      
      when others =>
        v := init;  
    end case;

    --reset system
    if reset_n = '0' then 
      v.state := fsm_sleep; 
    end if;
    
     case v.state is --determine outputs
      when fsm_sleep =>
        v.drive.GEN_END_OUT := '1';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_sleep2;
      when fsm_pos_gen =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '1';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_pos_gen;
      when fsm_pause_mono | fsm_pause_burst =>
        v.drive.GEN_END_OUT := '0';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_sleep;
      when others =>
        v.drive.GEN_END_OUT := '1';
        v.drive.GEN_POS_PULSE := '0';
        v.drive.GEN_NEG_PULSE := '0';
        v.drive.MOS_DRIVER_OUT := out_error;
    end case;
    
    rin <= v; --update next state
    
  end process comb;
----------------------------------------------------------------------------------------------------------------------------------------------------
  regs: process(clk)
  begin
    if rising_edge(clk) then
      r <= rin;
    end if;
  end process regs;
----------------------------------------------------------------------------------------------------------------------------------------------------
  one_shot: process(clk, reset_n, trigger_flag, sys_i.GEN_START)
  begin
    if rising_edge(clk) then
      trigger_flag <= sys_i.GEN_START;
      if reset_n = '0' then
        trigger_flag <= '0';
        trigger_start <= '0';
      elsif trigger_flag <= '0' AND sys_i.GEN_START = '1' then
        trigger_start <= '1';
      else
        trigger_start <= '0';
      end if;
    end if;
  end process one_shot;
end Behavioral;
