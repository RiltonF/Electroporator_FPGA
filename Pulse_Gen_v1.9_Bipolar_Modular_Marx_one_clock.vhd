------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company:
-- Engineer: Bob Van Elst
--
-- Create Date: 02/04/2019 03:41:35 PM
-- Design Name:
-- Module Name: Pulse_Gen - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
------------------------------------------------------------------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Pulse_Gen_Burst is

Generic (
  --times, maybe set externaly later?

  --make sure these values are set correctly
  out_sleep: std_logic_vector(3 downto 0):= "0000";
  out_pos_prep: std_logic_vector(3 downto 0):= "0010";
  out_pos_gen: std_logic_vector(3 downto 0):= "1010";
  out_pos_dis: std_logic_vector(3 downto 0):= "0011";
  out_neg_prep: std_logic_vector(3 downto 0):= "0001";
  out_neg_gen: std_logic_vector(3 downto 0):= "0101";
  out_neg_dis: std_logic_vector(3 downto 0):= "0011";

  bipolar_gen_enable: std_logic :='1';
  generator_pre_and_post_states_enable: std_logic :='1';

  pulse_bit_width: Integer := 16;
  number_width: Integer := 8
);

Port (
  clk, resetn : in std_logic;
  GEN_START: in std_logic;
  pulse_number: in std_logic_vector(number_width-1 downto 0);
  burst_number: in std_logic_vector(number_width-1 downto 0);

  positive_prep_duration: in std_logic_vector(pulse_bit_width-1 downto 0);
  positive_dis_duration: in std_logic_vector(pulse_bit_width-1 downto 0);
  negative_prep_duration: in std_logic_vector(pulse_bit_width-1 downto 0);
  negative_dis_duration: in std_logic_vector(pulse_bit_width-1 downto 0);

  pulse_pos_duration: in std_logic_vector(pulse_bit_width-1 downto 0);
  pulse_neg_duration: in std_logic_vector(pulse_bit_width-1 downto 0);
  pause_mono_duration: in std_logic_vector(pulse_bit_width-1 downto 0);
  pause_bipol_duration: in std_logic_vector(pulse_bit_width-1 downto 0);
  pause_burst_duration: in std_logic_vector(pulse_bit_width-1 downto 0);

  GEN_END_OUT: out std_logic;
  GEN_POS_PULSE: out  std_logic;
  GEN_NEG_PULSE: out  std_logic;
  MOS_DRIVER_OUT: out std_logic_vector(3 downto 0)
);
end Pulse_Gen_Burst;

architecture Behavioral of Pulse_Gen_Burst is

-- Pulse Generator state machine
--1: fsm_sleep-> system does nothing.
--2: fsm_pos_prep-> charging the positive generator with duration positive_prep_duration
--3: fsm_pos_gen-> positive pulse generation with duration pulse_pos_duration
--4: fsm_pos_dis-> positive pulse discharge with duration positive_dis_duration
--5: fsm_neg_prep-> charging the positive generator with duration negative_prep_duration
--6: fsm_neg_gen-> negative pulse generation with duration pulse_neg_duration
--7: fsm_neg_dis-> negative pulse discharge with duration negative_dis_duration
--8: fsm_pause_mono-> pause after positive pulse
--9: fsm_pause_bipol-> pause after completion of both pos and neg pulses
--10: fsm_pause_burst-> after number of pulses are complete
 type Gen_states is (fsm_sleep, fsm_pos_prep, fsm_pos_gen, fsm_pos_dis, fsm_neg_prep, fsm_neg_gen, fsm_neg_dis, fsm_pause_mono, fsm_pause_bipol, fsm_pause_burst);
 signal Gen_state, Gen_state_next: Gen_states; -- all part of Gen_states type
 signal Gen_END: std_logic := '0';

  -- Pulse number counter, 1 counts is pos+neg pulse
 signal number_counter: std_logic_vector(number_width-1 downto 0):= (others => '0');
 signal number_done: std_logic := '0';
 signal burst_number_counter: std_logic_vector(number_width-1 downto 0):= (others => '0');
 signal burst_number_done: std_logic := '0';

 -- Pulse duration counter
 signal pulse_pos_prep_count: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pulse_pos_prep_done: std_logic := '0';
 signal pulse_pos_gen_count: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pulse_pos_gen_done: std_logic := '0';
 signal pulse_pos_dis_count: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pulse_pos_dis_done: std_logic := '0';

 signal pulse_neg_prep_count: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pulse_neg_prep_done: std_logic := '0';
 signal pulse_neg_gen_count: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pulse_neg_gen_done: std_logic := '0';
 signal pulse_neg_dis_count: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pulse_neg_dis_done: std_logic := '0';


  -- Pause duration counter
 signal pause_mono_counter: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pause_mono_done: std_logic := '0';
 signal pause_bipol_counter: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pause_bipol_done: std_logic := '0';
 signal pause_burst_counter: std_logic_vector(pulse_bit_width-1 downto 0);
 signal pause_burst_done: std_logic := '0';

begin
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  GEN_END_OUT <= Gen_END;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Gen_state_sinchronization: process (clk, resetn, Gen_state_next)
  begin
  	if resetn = '0' then --Reset generator and set current state to fsm_sleep
  		Gen_state <= fsm_sleep;
  	elsif rising_edge(clk) then
      if (unsigned(pause_mono_duration) /= 0 AND unsigned(pause_bipol_duration) /= 0 AND unsigned(pulse_number) /= 0) then --Make sure that none of the input values are zero ToDo
        Gen_state <= Gen_state_next; --Update state for next clock cycle
      end if;
  	end if;
  end process Gen_state_sinchronization;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Gen_state_input_change: process (clk,Gen_state, GEN_START, pulse_pos_prep_done, pulse_pos_gen_done,
   pulse_pos_dis_done, pulse_neg_prep_done, pulse_neg_gen_done, pulse_neg_dis_done, pause_mono_done,
   pause_bipol_done, number_counter, number_done, pulse_number, pause_burst_done, burst_number_counter, burst_number)
  variable fsm_sleep_var : std_logic_vector(number_width-1 downto 0);
  begin
    case Gen_state is --Regulates the next state
      when fsm_sleep =>
        if GEN_START = '1' then
          if number_done = '1' then --Prevents you from doing another cycle if you forget to remove GEN_START
            Gen_state_next <= fsm_sleep;
          else
            if generator_pre_and_post_states_enable = '1' then
              Gen_state_next <= fsm_pos_prep; --with prepulses
            else
              Gen_state_next <= fsm_pos_gen; --without prepulse
            end if;
          end if;
        else --Still no start signal
          Gen_state_next <= fsm_sleep;
          number_done <= '0';
        end if;
      when fsm_pos_prep =>
        if pulse_pos_prep_done = '1' then --check if positive pulse is charged
          Gen_state_next <= fsm_pos_gen;
        else
          Gen_state_next <= fsm_pos_prep;
        end if;
      when fsm_pos_gen =>
        if pulse_pos_gen_done = '1' then
          if generator_pre_and_post_states_enable = '1' then --if we have no postpulses, go straight to pause
            Gen_state_next <= fsm_pos_dis;
          else
            Gen_state_next <= fsm_pause_mono;
          end if;
        else
          Gen_state_next <= fsm_pos_gen;
        end if;
      when fsm_pos_dis =>
        if pulse_pos_dis_done = '1' then
          if bipolar_gen_enable = '0' then --check if it's mono
            if generator_pre_and_post_states_enable = '0' then
              fsm_sleep_var := std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, number_width)); --we need to increment this when there are no pre/post pulses because the counter increments at rising clock and we want to go stright to sleep after the pulses are done
            else
              fsm_sleep_var := number_counter;
            end if;
            if fsm_sleep_var >= pulse_number then --fsm_sleep if we did all the pulses or if there was no puase value set.
              number_done <= '1';
              Gen_state_next <= fsm_sleep; --go stright to sleep when finished with all the mono pulses in mono mode.
            else
              number_done <= '0';
              Gen_state_next <= fsm_pause_mono;
            end if;
          else
            Gen_state_next <= fsm_pause_mono;
          end if;
        else
          Gen_state_next <= fsm_pos_dis;
        end if;
      when fsm_pause_mono =>
        if pause_mono_done = '1' then
          if bipolar_gen_enable = '1' then --if we have a bipolar generator
            if generator_pre_and_post_states_enable = '1' then
              Gen_state_next <= fsm_neg_prep;
            else
              Gen_state_next <= fsm_neg_gen;
            end if;
          else --if we have monopolar generator go back to pulse prep
            if generator_pre_and_post_states_enable = '1' then
              Gen_state_next <= fsm_pos_prep;
            else
              Gen_state_next <= fsm_pos_gen;
            end if;
          end if;
        else
          Gen_state_next <= fsm_pause_mono;
        end if;
      when fsm_neg_prep =>
        if pulse_neg_prep_done = '1' then
          Gen_state_next <= fsm_neg_gen;
        else
          Gen_state_next <= fsm_neg_prep;
        end if;
      when fsm_neg_gen =>
        if pulse_neg_gen_done = '1' then
          if generator_pre_and_post_states_enable = '1' then
            Gen_state_next <= fsm_neg_dis;
          else
            fsm_sleep_var := std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, number_width));
            if fsm_sleep_var >= pulse_number then --fsm_sleep if we did all the pulses or if there was no puase value set.
              number_done <= '1';
              Gen_state_next <= fsm_sleep; --go stright to sleep when finished with all the mono pulses in mono mode. ToDo:add burst mode here!!!
            else
              number_done <= '0';
              Gen_state_next <= fsm_pause_bipol; --go to final pause
            end if;
          end if;
        else
          Gen_state_next <= fsm_neg_gen;
        end if;
      when fsm_neg_dis =>
        if pulse_neg_dis_done = '1' then
          if generator_pre_and_post_states_enable = '0' then
            fsm_sleep_var := std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, number_width));
          else
            fsm_sleep_var := number_counter;
          end if;
          if fsm_sleep_var >= pulse_number  then --fsm_sleep if we did all the pulses or if there was no puase value set.
            number_done <= '1';
            Gen_state_next <= fsm_pause_burst; --ToDo:add burst mode here!!!
          else
            number_done <= '0';
            Gen_state_next <= fsm_pause_bipol; --go to final pause
          end if;
        else
          Gen_state_next <= fsm_neg_dis;
        end if;
      when fsm_pause_bipol =>
        if pause_bipol_done = '1' then
          if generator_pre_and_post_states_enable = '1' then
            Gen_state_next <= fsm_pos_prep;
          else
            Gen_state_next <= fsm_pos_gen;
          end if;
        else
          Gen_state_next <= fsm_pause_bipol;
        end if;
      when fsm_pause_burst =>
        if pause_burst_done = '1' then
          if std_logic_vector(to_unsigned(to_integer(unsigned(burst_number_counter)) + 1, number_width)) >= burst_number then
            burst_number_done <= '1';
            Gen_state_next <= fsm_sleep;--here
          else
            burst_number_done <= '0';
            Gen_state_next <= fsm_pos_prep;
          end if;
        else
          Gen_state_next <= fsm_pause_burst;
        end if;
      when others => --In case of condition not met any, fsm_sleep next state
        Gen_state_next <= fsm_sleep;
    end case;
  end process Gen_state_input_change;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Gen_state_change: process (clk, Gen_state)
  begin
    case Gen_state is --pulsing here with output GEN_PULSE
      when fsm_sleep =>
        Gen_END <= '1';
        GEN_POS_PULSE <= '0';
        GEN_NEG_PULSE <= '0';
        MOS_DRIVER_OUT <= out_sleep;
      when fsm_pos_prep =>
        Gen_END <= '0';
        GEN_POS_PULSE <= '0';
        GEN_NEG_PULSE <= '0';
        MOS_DRIVER_OUT <= out_pos_prep;
      when fsm_pos_gen =>
        Gen_END <= '0';
        GEN_POS_PULSE <= '1';
        GEN_NEG_PULSE <= '0';
        MOS_DRIVER_OUT <= out_pos_gen;
      when fsm_pos_dis =>
        Gen_END <= '0';
        GEN_POS_PULSE <= '0';
        GEN_NEG_PULSE <= '0';
        MOS_DRIVER_OUT <= out_pos_dis;
      when fsm_neg_prep =>
        Gen_END <= '0';
        GEN_POS_PULSE <= '0';
        GEN_NEG_PULSE <= '0';
        MOS_DRIVER_OUT <= out_neg_prep;
      when fsm_neg_gen =>
        Gen_END <= '0';
        GEN_POS_PULSE <= '0';
        GEN_NEG_PULSE <= '1';
        MOS_DRIVER_OUT <= out_neg_gen;
      when fsm_neg_dis =>
        Gen_END <= '0';
        GEN_POS_PULSE <= '0';
        GEN_NEG_PULSE <= '0';
        MOS_DRIVER_OUT <= out_neg_dis;
      when fsm_pause_mono | fsm_pause_bipol | fsm_pause_burst =>
        Gen_END <= '0';
        GEN_POS_PULSE <= '0';
        GEN_NEG_PULSE <= '0';
        MOS_DRIVER_OUT <= out_sleep;
      when others =>
        Gen_END <= '1';
        GEN_POS_PULSE <= '0';
        GEN_NEG_PULSE <= '0';
        MOS_DRIVER_OUT <= out_sleep;
    end case;
  end process Gen_state_change;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pulse_number_counter: process(CLK, Gen_state, pulse_pos_gen_done, pulse_neg_gen_done, number_counter)
  variable increment_var: std_logic;
  begin
    case Gen_state is
      when fsm_sleep | fsm_pause_burst =>
        number_counter <= (others => '0');
      when fsm_neg_dis => -------------------------herere
        if bipolar_gen_enable = '1' AND pulse_neg_gen_done = '1' then --set incrementaiton trigger based on bipolar status, maybe issue here??
          number_counter <= std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, number_width));
        end if;
      -- when others =>
      --   if bipolar_gen_enable = '1' then --set incrementaiton trigger based on bipolar status, maybe issue here??
      --     increment_var := pulse_neg_gen_done;
      --   else
      --     increment_var := pulse_pos_gen_done;
      --   end if;
      --   if rising_edge(clk) AND increment_var = '1' then
      --     number_counter <= std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, number_width));
      --   end if;
      when others =>
        null;
    end case;
  end process Pulse_number_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pulse_burst_number_counter: process(CLK, Gen_state, burst_number_counter, pause_burst_done)
  begin
    case Gen_state is
      when fsm_sleep =>
        burst_number_counter <= (others => '0');
      when others =>
      if rising_edge(clk) AND pause_burst_done = '1' then
        burst_number_counter <= std_logic_vector(to_unsigned(to_integer(unsigned(burst_number_counter)) + 1, number_width));
      end if;
    end case;
  end process Pulse_burst_number_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pos_prep_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_pos_prep =>
        if falling_edge(CLK) then
          pulse_pos_prep_count <= std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_prep_count)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_prep_count)) + 1, pulse_bit_width)) >= positive_prep_duration then
            pulse_pos_prep_done <= '1';
          end if;
        end if;
      when others =>
        pulse_pos_prep_count <= (others => '0');
        pulse_pos_prep_done <= '0';
    end case;
  end process Pos_prep_duration_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pos_gen_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_pos_gen =>
        if falling_edge(CLK) then
          pulse_pos_gen_count <= std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_gen_count)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_gen_count)) + 1, pulse_bit_width)) >= pulse_pos_duration then
            pulse_pos_gen_done <= '1';
          end if;
        end if;
      when others =>
        pulse_pos_gen_count <= (others => '0');
        pulse_pos_gen_done <= '0';
    end case;
  end process Pos_gen_duration_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pos_dis_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_pos_dis =>
        if falling_edge(CLK) then
          pulse_pos_dis_count <= std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_dis_count)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_dis_count)) + 1, pulse_bit_width)) >=  positive_dis_duration then
            pulse_pos_dis_done <= '1';
          end if;
        end if;
      when others =>
        pulse_pos_dis_count <= (others => '0');
        pulse_pos_dis_done <= '0';
    end case;
  end process Pos_dis_duration_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Neg_prep_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_neg_prep =>
        if falling_edge(CLK) then
          pulse_neg_prep_count <= std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_prep_count)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_prep_count)) + 1, pulse_bit_width)) >=  negative_prep_duration then
            pulse_neg_prep_done <= '1';
          end if;
        end if;
      when others =>
        pulse_neg_prep_count <= (others => '0');
        pulse_neg_prep_done <= '0';
    end case;
  end process Neg_prep_duration_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Neg_gen_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_neg_gen =>
        if falling_edge(CLK) then
          pulse_neg_gen_count <= std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_gen_count)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_gen_count)) + 1, pulse_bit_width)) >= pulse_neg_duration then
            pulse_neg_gen_done <= '1';
          end if;
        end if;
      when others =>
        pulse_neg_gen_count <= (others => '0');
        pulse_neg_gen_done <= '0';
    end case;
  end process Neg_gen_duration_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Neg_dis_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_neg_dis =>
        if falling_edge(CLK) then
          pulse_neg_dis_count <= std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_dis_count)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_dis_count)) + 1, pulse_bit_width)) >=  negative_dis_duration then
            pulse_neg_dis_done <= '1';
          end if;
        end if;
      when others =>
        pulse_neg_dis_count <= (others => '0');
        pulse_neg_dis_done <= '0';
    end case;
  end process Neg_dis_duration_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pause_mono_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_pause_mono =>
        if falling_edge(CLK) then
          pause_mono_counter <= std_logic_vector(to_unsigned(to_integer(unsigned(pause_mono_counter)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pause_mono_counter)) + 1, pulse_bit_width)) >= pause_mono_duration then
            pause_mono_done <= '1';
          end if;
        end if ;
      when others =>
        pause_mono_counter <= (others => '0');
        pause_mono_done <= '0';
      end case;
  end process Pause_mono_duration_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pause_bipol_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_pause_bipol =>
        if falling_edge(CLK) then
          pause_bipol_counter <= std_logic_vector(to_unsigned(to_integer(unsigned(pause_bipol_counter)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pause_bipol_counter)) + 1, pulse_bit_width)) >= pause_bipol_duration then
            pause_bipol_done <= '1';
          end if;
        end if ;
      when others =>
        pause_bipol_counter <= (others => '0');
        pause_bipol_done <= '0';
    end case;
  end process Pause_bipol_duration_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pause_burst_duration_counter: process(CLK,Gen_state)
  begin
    case Gen_state is
      when fsm_pause_burst =>
        if falling_edge(CLK) then
          pause_burst_counter <= std_logic_vector(to_unsigned(to_integer(unsigned(pause_burst_counter)) + 1, pulse_bit_width));
          if std_logic_vector(to_unsigned(to_integer(unsigned(pause_burst_counter)) + 1, pulse_bit_width)) >= pause_burst_duration then
            pause_burst_done <= '1';
          end if;
        end if ;
      when others =>
        pause_burst_counter <= (others => '0');
        pause_burst_done <= '0';
    end case;
  end process Pause_burst_duration_counter;
end Behavioral;
