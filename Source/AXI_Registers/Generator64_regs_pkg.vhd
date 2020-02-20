-- -----------------------------------------------------------------------------
-- 'Generator64' Register Definitions
-- Revision: 25
-- -----------------------------------------------------------------------------
-- Generated on 2019-11-18 at 10:00 (UTC) by airhdl version 2019.09.1
-- -----------------------------------------------------------------------------
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
-- POSSIBILITY OF SUCH DAMAGE.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Generator64_regs_pkg is

    -- Type definitions
    type slv1_array_t is array(natural range <>) of std_logic_vector(0 downto 0);
    type slv2_array_t is array(natural range <>) of std_logic_vector(1 downto 0);
    type slv3_array_t is array(natural range <>) of std_logic_vector(2 downto 0);
    type slv4_array_t is array(natural range <>) of std_logic_vector(3 downto 0);
    type slv5_array_t is array(natural range <>) of std_logic_vector(4 downto 0);
    type slv6_array_t is array(natural range <>) of std_logic_vector(5 downto 0);
    type slv7_array_t is array(natural range <>) of std_logic_vector(6 downto 0);
    type slv8_array_t is array(natural range <>) of std_logic_vector(7 downto 0);
    type slv9_array_t is array(natural range <>) of std_logic_vector(8 downto 0);
    type slv10_array_t is array(natural range <>) of std_logic_vector(9 downto 0);
    type slv11_array_t is array(natural range <>) of std_logic_vector(10 downto 0);
    type slv12_array_t is array(natural range <>) of std_logic_vector(11 downto 0);
    type slv13_array_t is array(natural range <>) of std_logic_vector(12 downto 0);
    type slv14_array_t is array(natural range <>) of std_logic_vector(13 downto 0);
    type slv15_array_t is array(natural range <>) of std_logic_vector(14 downto 0);
    type slv16_array_t is array(natural range <>) of std_logic_vector(15 downto 0);
    type slv17_array_t is array(natural range <>) of std_logic_vector(16 downto 0);
    type slv18_array_t is array(natural range <>) of std_logic_vector(17 downto 0);
    type slv19_array_t is array(natural range <>) of std_logic_vector(18 downto 0);
    type slv20_array_t is array(natural range <>) of std_logic_vector(19 downto 0);
    type slv21_array_t is array(natural range <>) of std_logic_vector(20 downto 0);
    type slv22_array_t is array(natural range <>) of std_logic_vector(21 downto 0);
    type slv23_array_t is array(natural range <>) of std_logic_vector(22 downto 0);
    type slv24_array_t is array(natural range <>) of std_logic_vector(23 downto 0);
    type slv25_array_t is array(natural range <>) of std_logic_vector(24 downto 0);
    type slv26_array_t is array(natural range <>) of std_logic_vector(25 downto 0);
    type slv27_array_t is array(natural range <>) of std_logic_vector(26 downto 0);
    type slv28_array_t is array(natural range <>) of std_logic_vector(27 downto 0);
    type slv29_array_t is array(natural range <>) of std_logic_vector(28 downto 0);
    type slv30_array_t is array(natural range <>) of std_logic_vector(29 downto 0);
    type slv31_array_t is array(natural range <>) of std_logic_vector(30 downto 0);
    type slv32_array_t is array(natural range <>) of std_logic_vector(31 downto 0);


    -- Revision number of the 'Generator64' register map
    constant GENERATOR64_REVISION : natural := 25;

    -- Default base address of the 'Generator64' register map 
    constant GENERATOR64_DEFAULT_BASEADDR : unsigned(31 downto 0) := unsigned'(x"40000000");
    
    -- Register 'SETUP'
    constant SETUP_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000000"); -- address offset of the 'SETUP' register
    constant SETUP_BIPOLAR_GEN_ENABLE_BIT_OFFSET : natural := 0; -- bit offset of the 'Bipolar_gen_enable' field
    constant SETUP_BIPOLAR_GEN_ENABLE_BIT_WIDTH : natural := 1; -- bit width of the 'Bipolar_gen_enable' field
    constant SETUP_BIPOLAR_GEN_ENABLE_RESET : std_logic_vector(0 downto 0) := std_logic_vector'("0"); -- reset value of the 'Bipolar_gen_enable' field
    constant SETUP_GENERATOR_PRE_AND_POST_ENABLE_BIT_OFFSET : natural := 1; -- bit offset of the 'Generator_pre_and_post_enable' field
    constant SETUP_GENERATOR_PRE_AND_POST_ENABLE_BIT_WIDTH : natural := 1; -- bit width of the 'Generator_pre_and_post_enable' field
    constant SETUP_GENERATOR_PRE_AND_POST_ENABLE_RESET : std_logic_vector(1 downto 1) := std_logic_vector'("0"); -- reset value of the 'Generator_pre_and_post_enable' field
    constant SETUP_PULSE_NUMBER_BIT_OFFSET : natural := 2; -- bit offset of the 'Pulse_Number' field
    constant SETUP_PULSE_NUMBER_BIT_WIDTH : natural := 8; -- bit width of the 'Pulse_Number' field
    constant SETUP_PULSE_NUMBER_RESET : std_logic_vector(9 downto 2) := std_logic_vector'("00000000"); -- reset value of the 'Pulse_Number' field
    constant SETUP_BURST_NUMBER_BIT_OFFSET : natural := 10; -- bit offset of the 'Burst_number' field
    constant SETUP_BURST_NUMBER_BIT_WIDTH : natural := 8; -- bit width of the 'Burst_number' field
    constant SETUP_BURST_NUMBER_RESET : std_logic_vector(17 downto 10) := std_logic_vector'("00000000"); -- reset value of the 'Burst_number' field
    constant SETUP_GEN_START_BIT_OFFSET : natural := 18; -- bit offset of the 'GEN_START' field
    constant SETUP_GEN_START_BIT_WIDTH : natural := 1; -- bit width of the 'GEN_START' field
    constant SETUP_GEN_START_RESET : std_logic_vector(18 downto 18) := std_logic_vector'("0"); -- reset value of the 'GEN_START' field
    constant SETUP_ICE_TRIGGERED_BIT_OFFSET : natural := 19; -- bit offset of the 'ICE_TRIGGERED' field
    constant SETUP_ICE_TRIGGERED_BIT_WIDTH : natural := 1; -- bit width of the 'ICE_TRIGGERED' field
    constant SETUP_ICE_TRIGGERED_RESET : std_logic_vector(19 downto 19) := std_logic_vector'("0"); -- reset value of the 'ICE_TRIGGERED' field
    
    -- Register 'Pause_mono_duration'
    constant PAUSE_MONO_DURATION_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000004"); -- address offset of the 'Pause_mono_duration' register
    constant PAUSE_MONO_DURATION_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PAUSE_MONO_DURATION_VALUE_BIT_WIDTH : natural := 32; -- bit width of the 'value' field
    constant PAUSE_MONO_DURATION_VALUE_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000000"); -- reset value of the 'value' field
    
    -- Register 'Pause_bipol_duration'
    constant PAUSE_BIPOL_DURATION_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000008"); -- address offset of the 'Pause_bipol_duration' register
    constant PAUSE_BIPOL_DURATION_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PAUSE_BIPOL_DURATION_VALUE_BIT_WIDTH : natural := 32; -- bit width of the 'value' field
    constant PAUSE_BIPOL_DURATION_VALUE_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000000"); -- reset value of the 'value' field
    
    -- Register 'Pause_burst_duration'
    constant PAUSE_BURST_DURATION_OFFSET : unsigned(31 downto 0) := unsigned'(x"0000000C"); -- address offset of the 'Pause_burst_duration' register
    constant PAUSE_BURST_DURATION_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PAUSE_BURST_DURATION_VALUE_BIT_WIDTH : natural := 32; -- bit width of the 'value' field
    constant PAUSE_BURST_DURATION_VALUE_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000000"); -- reset value of the 'value' field
    
    -- Register 'Pulse_pos_gen'
    constant PULSE_POS_GEN_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000010"); -- address offset of the 'Pulse_pos_gen' register
    constant PULSE_POS_GEN_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PULSE_POS_GEN_VALUE_BIT_WIDTH : natural := 32; -- bit width of the 'value' field
    constant PULSE_POS_GEN_VALUE_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000000"); -- reset value of the 'value' field
    
    -- Register 'Pulse_neg_gen'
    constant PULSE_NEG_GEN_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000014"); -- address offset of the 'Pulse_neg_gen' register
    constant PULSE_NEG_GEN_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PULSE_NEG_GEN_VALUE_BIT_WIDTH : natural := 32; -- bit width of the 'value' field
    constant PULSE_NEG_GEN_VALUE_RESET : std_logic_vector(31 downto 0) := std_logic_vector'("00000000000000000000000000000000"); -- reset value of the 'value' field
    
    -- Register 'Pulse_pos_prep'
    constant PULSE_POS_PREP_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000018"); -- address offset of the 'Pulse_pos_prep' register
    constant PULSE_POS_PREP_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PULSE_POS_PREP_VALUE_BIT_WIDTH : natural := 16; -- bit width of the 'value' field
    constant PULSE_POS_PREP_VALUE_RESET : std_logic_vector(15 downto 0) := std_logic_vector'("0000000000000000"); -- reset value of the 'value' field
    
    -- Register 'Pulse_neg_prep'
    constant PULSE_NEG_PREP_OFFSET : unsigned(31 downto 0) := unsigned'(x"0000001C"); -- address offset of the 'Pulse_neg_prep' register
    constant PULSE_NEG_PREP_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PULSE_NEG_PREP_VALUE_BIT_WIDTH : natural := 16; -- bit width of the 'value' field
    constant PULSE_NEG_PREP_VALUE_RESET : std_logic_vector(15 downto 0) := std_logic_vector'("0000000000000000"); -- reset value of the 'value' field
    
    -- Register 'Pulse_pos_dis'
    constant PULSE_POS_DIS_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000020"); -- address offset of the 'Pulse_pos_dis' register
    constant PULSE_POS_DIS_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PULSE_POS_DIS_VALUE_BIT_WIDTH : natural := 16; -- bit width of the 'value' field
    constant PULSE_POS_DIS_VALUE_RESET : std_logic_vector(15 downto 0) := std_logic_vector'("0000000000000000"); -- reset value of the 'value' field
    
    -- Register 'Pulse_neg_dis'
    constant PULSE_NEG_DIS_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000024"); -- address offset of the 'Pulse_neg_dis' register
    constant PULSE_NEG_DIS_VALUE_BIT_OFFSET : natural := 0; -- bit offset of the 'value' field
    constant PULSE_NEG_DIS_VALUE_BIT_WIDTH : natural := 16; -- bit width of the 'value' field
    constant PULSE_NEG_DIS_VALUE_RESET : std_logic_vector(15 downto 0) := std_logic_vector'("0000000000000000"); -- reset value of the 'value' field

end Generator64_regs_pkg;
