----------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------


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
Port (
  clk, resetn : in std_logic;
  GEN_START: in std_logic;
  pulse_number: in std_logic_vector(15 downto 0);
  pulse_duration: in std_logic_vector(15 downto 0);
  pause_duration: in std_logic_vector(15 downto 0);
  GEN_END_OUT: out std_logic;
  GEN_PULSE: out  std_logic
);
end Pulse_Gen;

architecture Behavioral of Pulse_Gen is

-- Pulse Generator state machine
 type Gen_states is (stop, pulse, pause);
 signal Gen_state, Gen_state_next: Gen_states; -- all part of Gen_states type
 signal Gen_END: std_logic;

  -- Pulse number counter
 signal number_counter: std_logic_vector(15 downto 0);
 signal number_done: std_logic := '0';

 -- Pulse duration counter
 signal pulse_counter: std_logic_vector(15 downto 0);
 signal pulse_done: std_logic := '0';

  -- Pause duration counter
 signal pause_counter: std_logic_vector(15 downto 0);
 signal pause_done: std_logic := '0';

begin



  --------------------------------------------------------------------------
  GEN_END_OUT <= Gen_END;
  --------------------------------------------------------------------------
  Gen_state_sinchronization: process (clk, resetn, Gen_state_next)
  begin
  	if resetn = '0' then --Reset generator and set current state to stop
  		Gen_state <= stop;
  	elsif rising_edge(clk) then
      if (pulse_duration /= x"0000" AND pulse_number /= x"0000") then --Make sure that none of the input values are zero
		    Gen_state <= Gen_state_next; --Update state for next clock cycle
      end if;
  	end if;
  end process Gen_state_sinchronization;
  --------------------------------------------------------------------------
  Gen_state_input_change: process (clk,Gen_state, GEN_START, pulse_done, pause_done)
  variable stop_var : std_logic_vector(15 downto 0);
  begin
  	case Gen_state is --Regulates the next state
  		when stop =>
  			if GEN_START = '1' then
          if number_done = '1' then --Prevents you from doing another cycle if you forget to remove GEN_START
            Gen_state_next <= stop;
          else
            Gen_state_next <= pulse; --initialize pulse, put prepulse here if needed later
          end if;
  			else --Still no start signal
  				Gen_state_next <= stop;
          number_done <= '0';
  			end if;
  		when pulse =>
  			if pulse_done = '1' then --Reached end of pulse
          stop_var := std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, 16));
          if stop_var = pulse_number OR pause_duration = x"0000" then --Stop if we did all the pulses or if there was no puase value set.
            number_done <= '1';
            Gen_state_next <= stop;
          else
			      Gen_state_next <= pause;
          end if;
  			else --Continue pulsing
  				Gen_state_next <= pulse;
  			end if;
  		when pause =>
  			if pause_done = '1' then --Continue pulsing once the pause is done
  				Gen_state_next <= pulse;
  			else --Pause continues
  				Gen_state_next <= pause;
  			end if;
  		when others => --In case of condition not met any, stop next state
  			Gen_state_next <= stop;
  	end case;
  end process Gen_state_input_change;
  --------------------------------------------------------------------------
  Gen_state_change: process (clk, Gen_state)
  begin
  	case Gen_state is --pulsing here with output GEN_PULSE
  		when stop =>
  			Gen_END <= '1';
  			GEN_PULSE <= '0';
  		when pulse =>
  			Gen_END <= '0';
  			GEN_PULSE <= '1';
  		when pause =>
  			Gen_END <= '0';
  			GEN_PULSE <= '0';
  		when others =>
  			null;
  	end case;
  end process Gen_state_change;
  --------------------------------------------------------------------------
  Pulse_number_counter: process(CLK, Gen_state, pulse_done, number_counter)
  variable number_var: std_logic_vector(15 downto 0);
  begin
  	if Gen_state = stop then
  		number_counter <= (others => '0');
  		-- number_done <= '0';
  	else
  		if rising_edge(clk) AND (pulse_done = '1') then
        number_var := std_logic_vector(to_unsigned(to_integer(unsigned(number_counter)) + 1, 16));
        number_counter <= number_var;
  		end if;
  	end if;
  end process Pulse_number_counter;
  --------------------------------------------------------------------------
  Pulse_duration_counter: process(CLK,Gen_state,pulse_duration)
  variable pulse_var: std_logic_vector(15 downto 0);
  begin
  	case Gen_state is
  		when pulse =>
        if falling_edge(CLK) then
          pulse_var := std_logic_vector(to_unsigned(to_integer(unsigned(pulse_counter)) + 1, 16));
          pulse_counter <= pulse_var;
          if(pulse_var = pulse_duration) then
            pulse_done <= '1';
          end if;
        end if;
  		when others =>
  			pulse_counter <= (others => '0');
  			pulse_done <= '0';
  	end case;
  end process Pulse_duration_counter;
  --------------------------------------------------------------------------
  Pause_duration_counter: process(CLK,Gen_state,pause_duration)
  variable pause_var: std_logic_vector(15 downto 0);
  begin
  	case Gen_state is
  		when pause =>
  			if falling_edge(CLK) then
          pause_var := std_logic_vector(to_unsigned(to_integer(unsigned(pause_counter)) + 1, 16));
          pause_counter <= pause_var;
          if(pause_var = pause_duration) then
            pause_done <= '1';
          end if;
  			end if ;
  		when others =>
  			pause_counter <= (others => '0');
  			pause_done <= '0';
  	end case;
  end process Pause_duration_counter;
end Behavioral;
