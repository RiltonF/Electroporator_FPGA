------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Company:
-- Engineer:
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

entity Pulse_Gen is

Generic (
  --times, maybe set externaly later?
  positive_prep_duration: Integer := 10;
  positive_dis_duration: Integer := 10;
  negative_prep_duration: Integer := 10;
  negative_dis_duration: Integer := 10;
  --make sure these values are set correctly
  out_sleep: std_logic_vector(3 downto 0):= "0000";
  out_pos_prep: std_logic_vector(3 downto 0):= "0010";
  out_pos_gen: std_logic_vector(3 downto 0):= "1010";
  out_pos_dis: std_logic_vector(3 downto 0):= "0011";
  out_neg_prep: std_logic_vector(3 downto 0):= "0001";
  out_neg_gen: std_logic_vector(3 downto 0):= "0101";
  out_neg_dis: std_logic_vector(3 downto 0):= "0011";

  bipolar_gen_enable: std_logic :='1'
);

Port (
  clk, resetn : in std_logic;
  GEN_START: in std_logic;
  pulse_number: in std_logic_vector(15 downto 0);
  pulse_pos_duration: in std_logic_vector(15 downto 0);
  pulse_neg_duration: in std_logic_vector(15 downto 0);
  pause_mono_duration: in std_logic_vector(15 downto 0);
  pause_bipol_duration: in std_logic_vector(15 downto 0);
  burst_number: in std_logic_vector(15 downto 0);

  GEN_END_OUT: out std_logic;
  GEN_POS_PULSE: out  std_logic;
  GEN_NEG_PULSE: out  std_logic;
  MOS_DRIVER_OUT: out std_logic_vector(3 downto 0)
);
end Pulse_Gen;

architecture Behavioral of Pulse_Gen is

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
 signal number_counter: std_logic_vector(15 downto 0);
 signal number_done: std_logic := '0';

 -- Pulse duration counter
 signal pulse_pos_prep_count: std_logic_vector(15 downto 0);
 signal pulse_pos_prep_done: std_logic := '0';
 signal pulse_pos_gen_count: std_logic_vector(15 downto 0);
 signal pulse_pos_gen_done: std_logic := '0';
 signal pulse_pos_dis_count: std_logic_vector(15 downto 0);
 signal pulse_pos_dis_done: std_logic := '0';

 signal pulse_neg_prep_count: std_logic_vector(15 downto 0);
 signal pulse_neg_prep_done: std_logic := '0';
 signal pulse_neg_gen_count: std_logic_vector(15 downto 0);
 signal pulse_neg_gen_done: std_logic := '0';
 signal pulse_neg_dis_count: std_logic_vector(15 downto 0);
 signal pulse_neg_dis_done: std_logic := '0';


  -- Pause duration counter
 signal pause_mono_counter: std_logic_vector(15 downto 0);
 signal pause_mono_done: std_logic := '0';
 signal pause_bipol_counter: std_logic_vector(15 downto 0);
 signal pause_bipol_done: std_logic := '0';

begin
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  GEN_END_OUT <= Gen_END;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Gen_state_sinchronization: process (clk, resetn, Gen_state_next)
  begin
  	if resetn = '0' then --Reset generator and set current state to fsm_sleep
  		Gen_state <= fsm_sleep;
  	elsif rising_edge(clk) then
      if (pulse_pos_duration /= x"0000" AND pulse_neg_duration /= x"0000" AND pulse_number /= x"0000") then --Make sure that none of the input values are zero ToDo
		    Gen_state <= Gen_state_next; --Update state for next clock cycle
      end if;
  	end if;
  end process Gen_state_sinchronization;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Gen_state_input_change: process (clk,Gen_state, GEN_START, pulse_pos_prep_done, pulse_pos_gen_done, pulse_pos_dis_done, pulse_neg_prep_done, pulse_neg_gen_done, pulse_neg_dis_done, pause_mono_done, pause_bipol_done)
  variable fsm_sleep_var : std_logic_vector(15 downto 0);
  begin
  	case Gen_state is --Regulates the next state
  		when fsm_sleep =>
  			if GEN_START = '1' then
          if number_done = '1' then --Prevents you from doing another cycle if you forget to remove GEN_START
            Gen_state_next <= fsm_sleep;
          else
            Gen_state_next <= fsm_pos_prep; --initialize pulse, put prepulse here if needed later
          end if;
  			else --Still no start signal
  				Gen_state_next <= fsm_sleep;
          number_done <= '0';
  			end if;
      when fsm_pos_prep =>
        if pulse_pos_prep_done = '1' then
          Gen_state_next <= fsm_pos_gen;
        else
          Gen_state_next <= fsm_pos_prep;
        end if;
      when fsm_pos_gen =>
        if pulse_pos_gen_done = '1' then
          Gen_state_next <= fsm_pos_dis;
        else
          Gen_state_next <= fsm_pos_gen;
        end if;
      when fsm_pos_dis =>
        if pulse_pos_dis_done = '1' then
          if bipolar_gen_enable = '0' then --check if it's mono
            fsm_sleep_var := std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, 16));
            if fsm_sleep_var = pulse_number OR pause_mono_duration = x"0000" then --fsm_sleep if we did all the pulses or if there was no puase value set.
              number_done <= '1';
              Gen_state_next <= fsm_sleep; --go stright to sleep when finished with all the mono pulses in mono mode.
            else
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
            Gen_state_next <= fsm_neg_prep;
          else --if we have monopolar generator go back to pulse prep
            Gen_state_next <= fsm_pos_prep;
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
          Gen_state_next <= fsm_neg_dis;
        else
          Gen_state_next <= fsm_neg_gen;
        end if;
      when fsm_neg_dis =>
        if pulse_neg_dis_done = '1' then
          fsm_sleep_var := std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, 16));
          if fsm_sleep_var = pulse_number OR pause_bipol_duration = x"0000" then --fsm_sleep if we did all the pulses or if there was no puase value set.
            number_done <= '1';
            Gen_state_next <= fsm_sleep; --go stright to sleep when finished with all the mono pulses in mono mode. ToDo:add burst mode here!!!
          else
            Gen_state_next <= fsm_pause_bipol; --go to final pause
          end if;
        else
          Gen_state_next <= fsm_neg_dis;
        end if;
      when fsm_pause_bipol =>
        if pause_bipol_done = '1' then
          -- Gen_state_next <= fsm_pause_burst;--todo:burst mode here!!
          Gen_state_next <= fsm_pos_prep;
        else
          Gen_state_next <= fsm_pause_bipol;
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
  			null;
  	end case;
  end process Gen_state_change;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pulse_number_counter: process(CLK, Gen_state, pulse_pos_gen_done, pulse_neg_gen_done, number_counter)
  variable number_var: std_logic_vector(15 downto 0);
  variable increment_var: std_logic;
  begin
  	if Gen_state = fsm_sleep then
  		number_counter <= (others => '0');
  	else
      if bipolar_gen_enable = '1' then --set incrementaiton trigger based on bipolar status, maybe issue here??
        increment_var := pulse_neg_gen_done;
      else
        increment_var := pulse_pos_gen_done;
      end if;
  		if rising_edge(clk) AND increment_var = '1' then
        number_var := std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, 16));
        number_counter <= number_var;
  		end if;
  	end if;
  end process Pulse_number_counter;
  ----------------------------------------------------------------------------------------------------------------------------------------------------
  Pos_prep_duration_counter: process(CLK,Gen_state)
  variable pulse_var: std_logic_vector(15 downto 0);
  begin
  	case Gen_state is
  		when fsm_pos_prep =>
        if falling_edge(CLK) then
          pulse_var := std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_prep_count)) + 1, 16));
          pulse_pos_prep_count <= pulse_var;
          if(pulse_var =  std_logic_vector(to_unsigned(positive_prep_duration, 16))) then
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
  variable pulse_var: std_logic_vector(15 downto 0);
  begin
  	case Gen_state is
  		when fsm_pos_gen =>
        if falling_edge(CLK) then
          pulse_var := std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_gen_count)) + 1, 16));
          pulse_pos_gen_count <= pulse_var;
          if pulse_var = pulse_pos_duration then
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
  variable pulse_var: std_logic_vector(15 downto 0);
  begin
  	case Gen_state is
  		when fsm_pos_dis =>
        if falling_edge(CLK) then
          pulse_var := std_logic_vector(to_unsigned(to_integer(unsigned(pulse_pos_dis_count)) + 1, 16));
          pulse_pos_dis_count <= pulse_var;
          if(pulse_var =  std_logic_vector(to_unsigned(positive_dis_duration, 16))) then
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
  variable pulse_var: std_logic_vector(15 downto 0);
  begin
    case Gen_state is
      when fsm_neg_prep =>
        if falling_edge(CLK) then
          pulse_var := std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_prep_count)) + 1, 16));
          pulse_neg_prep_count <= pulse_var;
          if(pulse_var =  std_logic_vector(to_unsigned(negative_prep_duration, 16))) then
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
  variable pulse_var: std_logic_vector(15 downto 0);
  begin
    case Gen_state is
      when fsm_neg_gen =>
        if falling_edge(CLK) then
          pulse_var := std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_gen_count)) + 1, 16));
          pulse_neg_gen_count <= pulse_var;
          if pulse_var = pulse_neg_duration then
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
  variable pulse_var: std_logic_vector(15 downto 0);
  begin
    case Gen_state is
      when fsm_neg_dis =>
        if falling_edge(CLK) then
          pulse_var := std_logic_vector(to_unsigned(to_integer(unsigned(pulse_neg_dis_count)) + 1, 16));
          pulse_neg_dis_count <= pulse_var;
          if(pulse_var =  std_logic_vector(to_unsigned(negative_dis_duration, 16))) then
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
  variable pause_var: std_logic_vector(15 downto 0);
  begin
  	case Gen_state is
  		when fsm_pause_mono =>
  			if falling_edge(CLK) then
          pause_var := std_logic_vector(to_unsigned(to_integer(unsigned(pause_mono_counter)) + 1, 16));
          pause_mono_counter <= pause_var;
          if(pause_var = pause_mono_duration) then
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
  variable pause_var: std_logic_vector(15 downto 0);
  begin
    case Gen_state is
      when fsm_pause_bipol =>
        if falling_edge(CLK) then
          pause_var := std_logic_vector(to_unsigned(to_integer(unsigned(pause_bipol_counter)) + 1, 16));
          pause_bipol_counter <= pause_var;
          if(pause_var = pause_bipol_duration) then
            pause_bipol_done <= '1';
          end if;
        end if ;
      when others =>
        pause_bipol_counter <= (others => '0');
        pause_bipol_done <= '0';
    end case;
  end process Pause_bipol_duration_counter;
end Behavioral;
