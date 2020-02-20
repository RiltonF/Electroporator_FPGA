library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package generator is

--  generic(
-- --    state_counter_length: integer := 16;
-- --    number_counter_length: integer := 8;
-- --    burst_counter_length: integer := 8
--   var:integer := 10;
--  );

  constant state_counter_length: integer := 32;
  constant state_counter_bipol_length: integer := 16;
  constant number_counter_length: integer := 8;
  constant burst_counter_length: integer := 8;

  constant out_sleep: std_logic_vector(3 downto 0):= "0000";
  constant out_pos_prep: std_logic_vector(3 downto 0):= "0010";
  constant out_pos_gen: std_logic_vector(3 downto 0):= "1010";
  constant out_pos_dis: std_logic_vector(3 downto 0):= "0011";
  constant out_neg_prep: std_logic_vector(3 downto 0):= "0001";
  constant out_neg_gen: std_logic_vector(3 downto 0):= "0101";
  constant out_neg_dis: std_logic_vector(3 downto 0):= "0011";
  constant out_ICE: std_logic_vector(3 downto 0):= "0011";



  type state_type is (
      fsm_sleep, --Do nothing here
      fsm_pos_prep, --Charge for pulsing (positive)
      fsm_pos_gen, --Start pulsing (positive)
      fsm_pos_dis, --Discharge pulsing (positive)
      fsm_pause_mono, --Pause after positive pulsing
      fsm_neg_prep, --Charge for pulsing (negative)
      fsm_neg_gen, --Start pulsing (negative)
      fsm_neg_dis, --Discharge pulsing (negative)
      fsm_pause_bipol, --Pause after negative pulsing
      fsm_pause_burst, --Pause between two pulse funcitons
      fsm_ICE --In Case of Emergency state, discharge everything
  );

  --Monopolar Simple------------------------------------------------------------
  type mon_simple_in_type is record
    GEN_START: std_logic;
    pulse_number: std_logic_vector(number_counter_length - 1 downto 0);
    burst_number: std_logic_vector(burst_counter_length - 1 downto 0);

    pulse_pos_gen_duration: std_logic_vector(state_counter_length - 1 downto 0);

    pause_mono_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pause_burst_duration: std_logic_vector(state_counter_length - 1 downto 0);
  end record;

  type mon_simple_out_type is record
    state_out: state_type;
  end record;

  component Monopolar_Simple
    port(
      clk, reset : in std_logic;
      sys_i : in mon_simple_in_type;
      sys_o : out mon_simple_out_type
    );
  end component;
  --Bipolar Simple------------------------------------------------------------
  type bipol_simple_in_type is record
    GEN_START: std_logic;
    pulse_number: std_logic_vector(number_counter_length - 1 downto 0);
    burst_number: std_logic_vector(burst_counter_length - 1 downto 0);

    pulse_pos_gen_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pulse_neg_gen_duration: std_logic_vector(state_counter_length - 1 downto 0);

    pause_mono_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pause_bipol_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pause_burst_duration: std_logic_vector(state_counter_length - 1 downto 0);
  end record;

  type bipol_simple_out_type is record
    state_out: state_type;
  end record;

  component Bipolar_Simple
    port(
      clk, reset : in std_logic;
      sys_i : in bipol_simple_in_type;
      sys_o : out bipol_simple_out_type
    );
  end component;
  --Monopolar Full------------------------------------------------------------
  type mon_full_in_type is record
    GEN_START: std_logic;
    pulse_number: std_logic_vector(number_counter_length - 1 downto 0);
    burst_number: std_logic_vector(burst_counter_length - 1 downto 0);
    pulse_pos_prep_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_pos_gen_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pulse_pos_dis_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pause_mono_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pause_burst_duration: std_logic_vector(state_counter_length - 1 downto 0);
  end record;

  type mon_full_out_type is record
    state_out: state_type;
  end record;

  component Monopolar_Full
    port(
      clk, reset : in std_logic;
      sys_i : in mon_full_in_type;
      sys_o : out mon_full_out_type
    );
  end component;
  --Bipolar Full------------------------------------------------------------
  type bipol_full_in_type is record
    GEN_START: std_logic;
    pulse_number: std_logic_vector(number_counter_length - 1 downto 0);
    burst_number: std_logic_vector(burst_counter_length - 1 downto 0);
    pulse_pos_prep_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_pos_gen_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pulse_pos_dis_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_neg_prep_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_neg_gen_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pulse_neg_dis_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pause_mono_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pause_bipol_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pause_burst_duration: std_logic_vector(state_counter_length - 1 downto 0);
  end record;

  type bipol_full_out_type is record
    state_out: state_type;
  end record;

  component Bipolar_Full
    port(
      clk, reset : in std_logic;
      sys_i : in bipol_full_in_type;
      sys_o : out bipol_full_out_type
    );
  end component;

  --One-shot and lock------------------------------------------------------------
  type latch_full_type is record
    s: std_logic_vector(1 downto 0);
    GEN_START: std_logic;
    pulse_number: std_logic_vector(number_counter_length - 1 downto 0);
    burst_number: std_logic_vector(burst_counter_length - 1 downto 0);
    pulse_pos_prep_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_pos_gen_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pulse_pos_dis_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_neg_prep_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_neg_gen_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pulse_neg_dis_duration: std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pause_mono_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pause_bipol_duration: std_logic_vector(state_counter_length - 1 downto 0);
    pause_burst_duration: std_logic_vector(state_counter_length - 1 downto 0);
  end record;

  component One_Shot_Latch
    port(
      clk, reset : in std_logic;
      sys_i : in latch_full_type;
      gen_mon_simple: out mon_simple_in_type;
      gen_mon_full: out mon_full_in_type;
      gen_bipol_simple: out bipol_simple_in_type;
      gen_bipol_full: out bipol_full_in_type;
      mux_select: out std_logic_vector(1 downto 0)
    );
  end component;
  ------------------------------------------------------------------------------
  --State_MUX
  component State_MUX
    port(
      mon_simple_in: in state_type;
      mon_full_in: in state_type;
      bi_simple_in: in state_type;
      bi_full_in: in state_type;
      s: in std_logic_vector(1 downto 0);
      state_out: out state_type
    );
  end component;
  ------------------------------------------------------------------------------
  --State Decoder
  type decoder_in_type is record
    state_load: state_type;
    ICE: std_logic;
  end record;
  type decoder_out_type is record
    GEN_END_OUT: std_logic;
    GEN_POS_PULSE: std_logic;
    GEN_NEG_PULSE: std_logic;
    MOS_DRIVER_OUT: std_logic_vector(3 downto 0);
  end record;
  component State_Decoder
    port(
      clk, reset : in std_logic;
      sys_i: in decoder_in_type;
      sys_o: out decoder_out_type
    );
  end component;
end package;
