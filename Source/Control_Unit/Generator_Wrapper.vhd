library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.generator.all;



entity Gen_wrapper is
--  generic(
--    state_counter_length: integer := 16;
--    number_counter_length: integer := 8;
--    burst_counter_length: integer := 8
--  );

  port(
    Clk, Reset : in std_logic;
    ICE_in: in std_logic;
    GEN_START: in std_logic;
    bipol_enable: in std_logic;
    pre_post_enable: in std_logic;
    pulse_number: in std_logic_vector(number_counter_length - 1 downto 0);
    burst_number: in std_logic_vector(burst_counter_length - 1 downto 0);

    pause_mono_duration: in std_logic_vector(state_counter_length - 1 downto 0);
    pause_bipol_duration: in std_logic_vector(state_counter_length - 1 downto 0);
    pause_burst_duration: in std_logic_vector(state_counter_length - 1 downto 0);

    pulse_pos_gen_duration: in std_logic_vector(state_counter_length - 1 downto 0);
    pulse_neg_gen_duration: in std_logic_vector(state_counter_length - 1 downto 0);

    pulse_pos_prep_duration: in std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_neg_prep_duration: in std_logic_vector(state_counter_bipol_length - 1 downto 0);

    pulse_pos_dis_duration: in std_logic_vector(state_counter_bipol_length - 1 downto 0);
    pulse_neg_dis_duration: in std_logic_vector(state_counter_bipol_length - 1 downto 0);


    GEN_END_OUT: out std_logic;
    GEN_POS_PULSE: out std_logic;
    GEN_NEG_PULSE: out std_logic;
    MOS_DRIVER_OUT: out std_logic_vector(3 downto 0)
  );
end Gen_wrapper;

architecture rtl of Gen_wrapper is

  signal connect_latch1_gen1: mon_simple_in_type;
  signal connect_latch1_gen2: mon_full_in_type;
  signal connect_latch1_gen3: bipol_simple_in_type;
  signal connect_latch1_gen4: bipol_full_in_type;
  signal connect_gen1_mux1: state_type;
  signal connect_gen2_mux1: state_type;
  signal connect_gen3_mux1: state_type;
  signal connect_gen4_mux1: state_type;
  signal connect_mux1_decoder1: state_type;
  signal sleeping: state_type := fsm_sleep;
--  signal latched_params: latch_full_type;
  signal latched_mux_select: std_logic_vector(1 downto 0);

begin
  latch1: One_Shot_Latch
    port map (
      --inputs
      clk => Clk,
      reset => Reset,
      sys_i.s(1) => bipol_enable,
      sys_i.s(0) => pre_post_enable,
      sys_i.GEN_START => GEN_START,
      sys_i.pulse_number => pulse_number,
      sys_i.burst_number => burst_number,
      sys_i.pulse_pos_prep_duration => pulse_pos_prep_duration,
      sys_i.pulse_pos_gen_duration => pulse_pos_gen_duration,
      sys_i.pulse_pos_dis_duration => pulse_pos_dis_duration,
      sys_i.pulse_neg_prep_duration => pulse_neg_prep_duration,
      sys_i.pulse_neg_gen_duration => pulse_neg_gen_duration,
      sys_i.pulse_neg_dis_duration => pulse_neg_dis_duration,
      sys_i.pause_mono_duration => pause_mono_duration,
      sys_i.pause_bipol_duration => pause_bipol_duration,
      sys_i.pause_burst_duration => pause_burst_duration,
      --putputs
      gen_mon_simple => connect_latch1_gen1,
      gen_mon_full => connect_latch1_gen2,
      gen_bipol_simple => connect_latch1_gen3,
      gen_bipol_full => connect_latch1_gen4,
      mux_select => latched_mux_select
    );

  gen1: Monopolar_Simple
    port map (
      --inputs
      clk => Clk,
      reset => Reset,
      sys_i => connect_latch1_gen1,
--      sys_i.GEN_START => latched_params.GEN_START,
--      sys_i.pulse_number => latched_params.pulse_number,
--      sys_i.burst_number => latched_params.burst_number,
--      sys_i.pulse_pos_gen_duration => latched_params.pulse_pos_gen_duration,
--      sys_i.pause_mono_duration => latched_params.pause_mono_duration,
--      sys_i.pause_burst_duration => latched_params.pause_burst_duration,
      --outputs
      sys_o.state_out => connect_gen1_mux1
    );
  gen2: Monopolar_Full
    port map (
      --inputs
      clk => Clk,
      reset => Reset,
      sys_i => connect_latch1_gen2,
--      sys_i.GEN_START => latched_params.GEN_START,
--      sys_i.pulse_number => latched_params.pulse_number,
--      sys_i.burst_number => latched_params.burst_number,
--      sys_i.pulse_pos_prep_duration => latched_params.pulse_pos_prep_duration,
--      sys_i.pulse_pos_gen_duration => latched_params.pulse_pos_gen_duration,
--      sys_i.pulse_pos_dis_duration => latched_params.pulse_pos_dis_duration,
--      sys_i.pause_mono_duration => latched_params.pause_mono_duration,
--      sys_i.pause_burst_duration => latched_params.pause_burst_duration,
      --outputs
      sys_o.state_out => connect_gen2_mux1
    );
  gen3: Bipolar_Simple
    port map (
      --inputs
      clk => Clk,
      reset => Reset,
      sys_i => connect_latch1_gen3,
--      sys_i.GEN_START => latched_params.GEN_START,
--      sys_i.pulse_number => latched_params.pulse_number,
--      sys_i.burst_number => latched_params.burst_number,
--      sys_i.pulse_pos_gen_duration => latched_params.pulse_pos_gen_duration,
--      sys_i.pulse_neg_gen_duration => latched_params.pulse_neg_gen_duration,
--      sys_i.pause_mono_duration => latched_params.pause_mono_duration,
--      sys_i.pause_bipol_duration => latched_params.pause_bipol_duration,
--      sys_i.pause_burst_duration => latched_params.pause_burst_duration,
      --outputs
      sys_o.state_out => connect_gen3_mux1
    );
  gen4: Bipolar_Full
    port map (
      --inputs
      clk => Clk,
      reset => Reset,      
      sys_i => connect_latch1_gen4,
--      sys_i.GEN_START => latched_params.GEN_START,
--      sys_i.pulse_number => latched_params.pulse_number,
--      sys_i.burst_number => latched_params.burst_number,
--      sys_i.pulse_pos_prep_duration => latched_params.pulse_pos_prep_duration,
--      sys_i.pulse_pos_gen_duration => latched_params.pulse_pos_gen_duration,
--      sys_i.pulse_pos_dis_duration => latched_params.pulse_pos_dis_duration,
--      sys_i.pulse_neg_prep_duration => latched_params.pulse_neg_prep_duration,
--      sys_i.pulse_neg_gen_duration => latched_params.pulse_neg_gen_duration,
--      sys_i.pulse_neg_dis_duration => latched_params.pulse_neg_dis_duration,
--      sys_i.pause_mono_duration => latched_params.pause_mono_duration,
--      sys_i.pause_bipol_duration => latched_params.pause_bipol_duration,
--      sys_i.pause_burst_duration => latched_params.pause_burst_duration,
      --outputs
      sys_o.state_out => connect_gen4_mux1
    );
  mux1: State_MUX
    port map(
      --inputs
      mon_simple_in => connect_gen1_mux1,
      mon_full_in => connect_gen2_mux1,
      bi_simple_in => connect_gen3_mux1,
      bi_full_in => connect_gen4_mux1,
      s => latched_mux_select,
      --outputs
      state_out => connect_mux1_decoder1
    );

  decoder1: State_Decoder
    port map(
      --inputs
      clk => Clk,
      reset => Reset,
      sys_i.state_load => connect_mux1_decoder1,
      sys_i.ICE => ICE_in,
      --outputs
      sys_o.GEN_END_OUT => GEN_END_OUT,
      sys_o.GEN_POS_PULSE => GEN_POS_PULSE,
      sys_o.GEN_NEG_PULSE => GEN_NEG_PULSE,
      sys_o.MOS_DRIVER_OUT => MOS_DRIVER_OUT
    );

end rtl;
