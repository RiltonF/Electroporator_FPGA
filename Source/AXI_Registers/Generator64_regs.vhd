-- -----------------------------------------------------------------------------
-- 'Generator64' Register Component
-- Revision: 25
-- -----------------------------------------------------------------------------
-- Generated on 2019-11-18 at 10:01 (UTC) by airhdl version 2019.09.1
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

use work.Generator64_regs_pkg.all;

entity Generator64_regs is
    generic(
        AXI_ADDR_WIDTH : integer := 32;  -- width of the AXI address bus
        BASEADDR : std_logic_vector(31 downto 0) := x"40000000" -- the register file's system base address		
    );
    port(
        -- Clock and Reset
        axi_aclk    : in  std_logic;
        axi_aresetn : in  std_logic;
        -- AXI Write Address Channel
        s_axi_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_awprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
        s_axi_awvalid : in  std_logic;
        s_axi_awready : out std_logic;
        -- AXI Write Data Channel
        s_axi_wdata   : in  std_logic_vector(31 downto 0);
        s_axi_wstrb   : in  std_logic_vector(3 downto 0);
        s_axi_wvalid  : in  std_logic;
        s_axi_wready  : out std_logic;
        -- AXI Read Address Channel
        s_axi_araddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_arprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
        s_axi_arvalid : in  std_logic;
        s_axi_arready : out std_logic;
        -- AXI Read Data Channel
        s_axi_rdata   : out std_logic_vector(31 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in  std_logic;
        -- AXI Write Response Channel
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in  std_logic;
        -- User Ports
        setup_strobe : out std_logic; -- Strobe signal for register 'SETUP' (pulsed when the register is written from the bus)
        setup_bipolar_gen_enable : out std_logic_vector(0 downto 0); -- Value of register 'SETUP', field 'Bipolar_gen_enable'
        setup_generator_pre_and_post_enable : out std_logic_vector(0 downto 0); -- Value of register 'SETUP', field 'Generator_pre_and_post_enable'
        setup_pulse_number : out std_logic_vector(7 downto 0); -- Value of register 'SETUP', field 'Pulse_Number'
        setup_burst_number : out std_logic_vector(7 downto 0); -- Value of register 'SETUP', field 'Burst_number'
        setup_gen_start : out std_logic_vector(0 downto 0); -- Value of register 'SETUP', field 'GEN_START'
        setup_ice_triggered : out std_logic_vector(0 downto 0); -- Value of register 'SETUP', field 'ICE_TRIGGERED'
        pause_mono_duration_strobe : out std_logic; -- Strobe signal for register 'Pause_mono_duration' (pulsed when the register is written from the bus)
        pause_mono_duration_value : out std_logic_vector(31 downto 0); -- Value of register 'Pause_mono_duration', field 'value'
        pause_bipol_duration_strobe : out std_logic; -- Strobe signal for register 'Pause_bipol_duration' (pulsed when the register is written from the bus)
        pause_bipol_duration_value : out std_logic_vector(31 downto 0); -- Value of register 'Pause_bipol_duration', field 'value'
        pause_burst_duration_strobe : out std_logic; -- Strobe signal for register 'Pause_burst_duration' (pulsed when the register is written from the bus)
        pause_burst_duration_value : out std_logic_vector(31 downto 0); -- Value of register 'Pause_burst_duration', field 'value'
        pulse_pos_gen_strobe : out std_logic; -- Strobe signal for register 'Pulse_pos_gen' (pulsed when the register is written from the bus)
        pulse_pos_gen_value : out std_logic_vector(31 downto 0); -- Value of register 'Pulse_pos_gen', field 'value'
        pulse_neg_gen_strobe : out std_logic; -- Strobe signal for register 'Pulse_neg_gen' (pulsed when the register is written from the bus)
        pulse_neg_gen_value : out std_logic_vector(31 downto 0); -- Value of register 'Pulse_neg_gen', field 'value'
        pulse_pos_prep_strobe : out std_logic; -- Strobe signal for register 'Pulse_pos_prep' (pulsed when the register is written from the bus)
        pulse_pos_prep_value : out std_logic_vector(15 downto 0); -- Value of register 'Pulse_pos_prep', field 'value'
        pulse_neg_prep_strobe : out std_logic; -- Strobe signal for register 'Pulse_neg_prep' (pulsed when the register is written from the bus)
        pulse_neg_prep_value : out std_logic_vector(15 downto 0); -- Value of register 'Pulse_neg_prep', field 'value'
        pulse_pos_dis_strobe : out std_logic; -- Strobe signal for register 'Pulse_pos_dis' (pulsed when the register is written from the bus)
        pulse_pos_dis_value : out std_logic_vector(15 downto 0); -- Value of register 'Pulse_pos_dis', field 'value'
        pulse_neg_dis_strobe : out std_logic; -- Strobe signal for register 'Pulse_neg_dis' (pulsed when the register is written from the bus)
        pulse_neg_dis_value : out std_logic_vector(15 downto 0) -- Value of register 'Pulse_neg_dis', field 'value'
    );
end entity Generator64_regs;

architecture RTL of Generator64_regs is

    -- Constants
    constant AXI_OKAY           : std_logic_vector(1 downto 0) := "00";
    constant AXI_DECERR         : std_logic_vector(1 downto 0) := "11";

    -- Registered signals
    signal s_axi_awready_r    : std_logic;
    signal s_axi_wready_r     : std_logic;
    signal s_axi_awaddr_reg_r : unsigned(s_axi_awaddr'range);
    signal s_axi_bvalid_r     : std_logic;
    signal s_axi_bresp_r      : std_logic_vector(s_axi_bresp'range);
    signal s_axi_arready_r    : std_logic;
    signal s_axi_araddr_reg_r : unsigned(s_axi_araddr'range);
    signal s_axi_rvalid_r     : std_logic;
    signal s_axi_rresp_r      : std_logic_vector(s_axi_rresp'range);
    signal s_axi_wdata_reg_r  : std_logic_vector(s_axi_wdata'range);
    signal s_axi_wstrb_reg_r  : std_logic_vector(s_axi_wstrb'range);
    signal s_axi_rdata_r      : std_logic_vector(s_axi_rdata'range);
    
    -- User-defined registers
    signal s_setup_strobe_r : std_logic;
    signal s_reg_setup_bipolar_gen_enable_r : std_logic_vector(0 downto 0);
    signal s_reg_setup_generator_pre_and_post_enable_r : std_logic_vector(0 downto 0);
    signal s_reg_setup_pulse_number_r : std_logic_vector(7 downto 0);
    signal s_reg_setup_burst_number_r : std_logic_vector(7 downto 0);
    signal s_reg_setup_gen_start_r : std_logic_vector(0 downto 0);
    signal s_reg_setup_ice_triggered_r : std_logic_vector(0 downto 0);
    signal s_pause_mono_duration_strobe_r : std_logic;
    signal s_reg_pause_mono_duration_value_r : std_logic_vector(31 downto 0);
    signal s_pause_bipol_duration_strobe_r : std_logic;
    signal s_reg_pause_bipol_duration_value_r : std_logic_vector(31 downto 0);
    signal s_pause_burst_duration_strobe_r : std_logic;
    signal s_reg_pause_burst_duration_value_r : std_logic_vector(31 downto 0);
    signal s_pulse_pos_gen_strobe_r : std_logic;
    signal s_reg_pulse_pos_gen_value_r : std_logic_vector(31 downto 0);
    signal s_pulse_neg_gen_strobe_r : std_logic;
    signal s_reg_pulse_neg_gen_value_r : std_logic_vector(31 downto 0);
    signal s_pulse_pos_prep_strobe_r : std_logic;
    signal s_reg_pulse_pos_prep_value_r : std_logic_vector(15 downto 0);
    signal s_pulse_neg_prep_strobe_r : std_logic;
    signal s_reg_pulse_neg_prep_value_r : std_logic_vector(15 downto 0);
    signal s_pulse_pos_dis_strobe_r : std_logic;
    signal s_reg_pulse_pos_dis_value_r : std_logic_vector(15 downto 0);
    signal s_pulse_neg_dis_strobe_r : std_logic;
    signal s_reg_pulse_neg_dis_value_r : std_logic_vector(15 downto 0);

begin

    ----------------------------------------------------------------------------
    -- Inputs
    --

    ----------------------------------------------------------------------------
    -- Read-transaction FSM
    --    
    read_fsm : process(axi_aclk, axi_aresetn) is
        constant MEM_WAIT_COUNT : natural := 2;
        type t_state is (IDLE, READ_REGISTER, WAIT_MEMORY_RDATA, READ_RESPONSE, DONE);
        -- registered state variables
        variable v_state_r          : t_state;
        variable v_rdata_r          : std_logic_vector(31 downto 0);
        variable v_rresp_r          : std_logic_vector(s_axi_rresp'range);
        variable v_mem_wait_count_r : natural range 0 to MEM_WAIT_COUNT - 1;
        -- combinatorial helper variables
        variable v_addr_hit : boolean;
        variable v_mem_addr : unsigned(AXI_ADDR_WIDTH-1 downto 0);
    begin
        if axi_aresetn = '0' then
            v_state_r          := IDLE;
            v_rdata_r          := (others => '0');
            v_rresp_r          := (others => '0');
            v_mem_wait_count_r := 0;
            s_axi_arready_r    <= '0';
            s_axi_rvalid_r     <= '0';
            s_axi_rresp_r      <= (others => '0');
            s_axi_araddr_reg_r <= (others => '0');
            s_axi_rdata_r      <= (others => '0');
 
        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_arready_r <= '0';

            case v_state_r is

                -- Wait for the start of a read transaction, which is 
                -- initiated by the assertion of ARVALID
                when IDLE =>
                    v_mem_wait_count_r := 0;
                    --
                    if s_axi_arvalid = '1' then
                        s_axi_araddr_reg_r <= unsigned(s_axi_araddr); -- save the read address
                        s_axi_arready_r    <= '1'; -- acknowledge the read-address
                        v_state_r          := READ_REGISTER;
                    end if;

                -- Read from the actual storage element
                when READ_REGISTER =>
                    -- defaults:
                    v_addr_hit := false;
                    v_rdata_r  := (others => '0');
                    
                    -- register 'SETUP' at address offset 0x0 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + SETUP_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(0 downto 0) := s_reg_setup_bipolar_gen_enable_r;
                        v_rdata_r(1 downto 1) := s_reg_setup_generator_pre_and_post_enable_r;
                        v_rdata_r(9 downto 2) := s_reg_setup_pulse_number_r;
                        v_rdata_r(17 downto 10) := s_reg_setup_burst_number_r;
                        v_rdata_r(18 downto 18) := s_reg_setup_gen_start_r;
                        v_rdata_r(19 downto 19) := s_reg_setup_ice_triggered_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pause_mono_duration' at address offset 0x4 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_MONO_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(31 downto 0) := s_reg_pause_mono_duration_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pause_bipol_duration' at address offset 0x8 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_BIPOL_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(31 downto 0) := s_reg_pause_bipol_duration_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pause_burst_duration' at address offset 0xC 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_BURST_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(31 downto 0) := s_reg_pause_burst_duration_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_pos_gen' at address offset 0x10 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_POS_GEN_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(31 downto 0) := s_reg_pulse_pos_gen_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_neg_gen' at address offset 0x14 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_NEG_GEN_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(31 downto 0) := s_reg_pulse_neg_gen_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_pos_prep' at address offset 0x18 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_POS_PREP_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pulse_pos_prep_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_neg_prep' at address offset 0x1C 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_NEG_PREP_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pulse_neg_prep_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_pos_dis' at address offset 0x20 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_POS_DIS_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pulse_pos_dis_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_neg_dis' at address offset 0x24 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_NEG_DIS_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pulse_neg_dis_value_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    --
                    if v_addr_hit then
                        v_rresp_r := AXI_OKAY;
                    else
                        v_rresp_r := AXI_DECERR;
                        -- pragma translate_off
                        report "ARADDR decode error" severity warning;
                        -- pragma translate_on
                        v_state_r := READ_RESPONSE;
                    end if;

                -- Wait for memory read data
                when WAIT_MEMORY_RDATA =>
                    if v_mem_wait_count_r = MEM_WAIT_COUNT-1 then
                        v_state_r      := READ_RESPONSE;
                    else
                        v_mem_wait_count_r := v_mem_wait_count_r + 1;
                    end if;

                -- Generate read response
                when READ_RESPONSE =>
                    s_axi_rvalid_r <= '1';
                    s_axi_rresp_r  <= v_rresp_r;
                    s_axi_rdata_r  <= v_rdata_r;
                    --
                    v_state_r      := DONE;

                -- Write transaction completed, wait for master RREADY to proceed
                when DONE =>
                    if s_axi_rready = '1' then
                        s_axi_rvalid_r <= '0';
                        s_axi_rdata_r   <= (others => '0');
                        v_state_r      := IDLE;
                    end if;
            end case;
        end if;
    end process read_fsm;

    ----------------------------------------------------------------------------
    -- Write-transaction FSM
    --    
    write_fsm : process(axi_aclk, axi_aresetn) is
        type t_state is (IDLE, ADDR_FIRST, DATA_FIRST, UPDATE_REGISTER, DONE);
        variable v_state_r  : t_state;
        variable v_addr_hit : boolean;
        variable v_mem_addr : unsigned(AXI_ADDR_WIDTH-1 downto 0);
    begin
        if axi_aresetn = '0' then
            v_state_r          := IDLE;
            s_axi_awready_r    <= '0';
            s_axi_wready_r     <= '0';
            s_axi_awaddr_reg_r <= (others => '0');
            s_axi_wdata_reg_r  <= (others => '0');
            s_axi_wstrb_reg_r  <= (others => '0');
            s_axi_bvalid_r     <= '0';
            s_axi_bresp_r      <= (others => '0');
            --            
            s_setup_strobe_r <= '0';
            s_reg_setup_bipolar_gen_enable_r <= SETUP_BIPOLAR_GEN_ENABLE_RESET;
            s_reg_setup_generator_pre_and_post_enable_r <= SETUP_GENERATOR_PRE_AND_POST_ENABLE_RESET;
            s_reg_setup_pulse_number_r <= SETUP_PULSE_NUMBER_RESET;
            s_reg_setup_burst_number_r <= SETUP_BURST_NUMBER_RESET;
            s_reg_setup_gen_start_r <= SETUP_GEN_START_RESET;
            s_reg_setup_ice_triggered_r <= SETUP_ICE_TRIGGERED_RESET;
            s_pause_mono_duration_strobe_r <= '0';
            s_reg_pause_mono_duration_value_r <= PAUSE_MONO_DURATION_VALUE_RESET;
            s_pause_bipol_duration_strobe_r <= '0';
            s_reg_pause_bipol_duration_value_r <= PAUSE_BIPOL_DURATION_VALUE_RESET;
            s_pause_burst_duration_strobe_r <= '0';
            s_reg_pause_burst_duration_value_r <= PAUSE_BURST_DURATION_VALUE_RESET;
            s_pulse_pos_gen_strobe_r <= '0';
            s_reg_pulse_pos_gen_value_r <= PULSE_POS_GEN_VALUE_RESET;
            s_pulse_neg_gen_strobe_r <= '0';
            s_reg_pulse_neg_gen_value_r <= PULSE_NEG_GEN_VALUE_RESET;
            s_pulse_pos_prep_strobe_r <= '0';
            s_reg_pulse_pos_prep_value_r <= PULSE_POS_PREP_VALUE_RESET;
            s_pulse_neg_prep_strobe_r <= '0';
            s_reg_pulse_neg_prep_value_r <= PULSE_NEG_PREP_VALUE_RESET;
            s_pulse_pos_dis_strobe_r <= '0';
            s_reg_pulse_pos_dis_value_r <= PULSE_POS_DIS_VALUE_RESET;
            s_pulse_neg_dis_strobe_r <= '0';
            s_reg_pulse_neg_dis_value_r <= PULSE_NEG_DIS_VALUE_RESET;

        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_awready_r <= '0';
            s_axi_wready_r  <= '0';
            s_setup_strobe_r <= '0';
            s_pause_mono_duration_strobe_r <= '0';
            s_pause_bipol_duration_strobe_r <= '0';
            s_pause_burst_duration_strobe_r <= '0';
            s_pulse_pos_gen_strobe_r <= '0';
            s_pulse_neg_gen_strobe_r <= '0';
            s_pulse_pos_prep_strobe_r <= '0';
            s_pulse_neg_prep_strobe_r <= '0';
            s_pulse_pos_dis_strobe_r <= '0';
            s_pulse_neg_dis_strobe_r <= '0';

            case v_state_r is

                -- Wait for the start of a write transaction, which may be 
                -- initiated by either of the following conditions:
                --   * assertion of both AWVALID and WVALID
                --   * assertion of AWVALID
                --   * assertion of WVALID
                when IDLE =>
                    if s_axi_awvalid = '1' and s_axi_wvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        s_axi_wdata_reg_r  <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r  <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r     <= '1'; -- acknowledge the write-data
                        v_state_r          := UPDATE_REGISTER;
                    elsif s_axi_awvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        v_state_r          := ADDR_FIRST;
                    elsif s_axi_wvalid = '1' then
                        s_axi_wdata_reg_r <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r    <= '1'; -- acknowledge the write-data
                        v_state_r         := DATA_FIRST;
                    end if;

                -- Address-first write transaction: wait for the write-data
                when ADDR_FIRST =>
                    if s_axi_wvalid = '1' then
                        s_axi_wdata_reg_r <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r    <= '1'; -- acknowledge the write-data
                        v_state_r         := UPDATE_REGISTER;
                    end if;

                -- Data-first write transaction: wait for the write-address
                when DATA_FIRST =>
                    if s_axi_awvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        v_state_r          := UPDATE_REGISTER;
                    end if;

                -- Update the actual storage element
                when UPDATE_REGISTER =>
                    s_axi_bresp_r               <= AXI_OKAY; -- default value, may be overriden in case of decode error
                    s_axi_bvalid_r              <= '1';
                    --
                    v_addr_hit := false;
                    -- register 'SETUP' at address offset 0x0
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + SETUP_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_setup_strobe_r <= '1';
                        -- field 'Bipolar_gen_enable':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_setup_bipolar_gen_enable_r(0) <= s_axi_wdata_reg_r(0); -- Bipolar_gen_enable(0)
                        end if;
                        -- field 'Generator_pre_and_post_enable':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_setup_generator_pre_and_post_enable_r(0) <= s_axi_wdata_reg_r(1); -- Generator_pre_and_post_enable(0)
                        end if;
                        -- field 'Pulse_Number':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_setup_pulse_number_r(0) <= s_axi_wdata_reg_r(2); -- Pulse_Number(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_setup_pulse_number_r(1) <= s_axi_wdata_reg_r(3); -- Pulse_Number(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_setup_pulse_number_r(2) <= s_axi_wdata_reg_r(4); -- Pulse_Number(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_setup_pulse_number_r(3) <= s_axi_wdata_reg_r(5); -- Pulse_Number(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_setup_pulse_number_r(4) <= s_axi_wdata_reg_r(6); -- Pulse_Number(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_setup_pulse_number_r(5) <= s_axi_wdata_reg_r(7); -- Pulse_Number(5)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_setup_pulse_number_r(6) <= s_axi_wdata_reg_r(8); -- Pulse_Number(6)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_setup_pulse_number_r(7) <= s_axi_wdata_reg_r(9); -- Pulse_Number(7)
                        end if;
                        -- field 'Burst_number':
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_setup_burst_number_r(0) <= s_axi_wdata_reg_r(10); -- Burst_number(0)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_setup_burst_number_r(1) <= s_axi_wdata_reg_r(11); -- Burst_number(1)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_setup_burst_number_r(2) <= s_axi_wdata_reg_r(12); -- Burst_number(2)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_setup_burst_number_r(3) <= s_axi_wdata_reg_r(13); -- Burst_number(3)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_setup_burst_number_r(4) <= s_axi_wdata_reg_r(14); -- Burst_number(4)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_setup_burst_number_r(5) <= s_axi_wdata_reg_r(15); -- Burst_number(5)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_setup_burst_number_r(6) <= s_axi_wdata_reg_r(16); -- Burst_number(6)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_setup_burst_number_r(7) <= s_axi_wdata_reg_r(17); -- Burst_number(7)
                        end if;
                        -- field 'GEN_START':
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_setup_gen_start_r(0) <= s_axi_wdata_reg_r(18); -- GEN_START(0)
                        end if;
                        -- field 'ICE_TRIGGERED':
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_setup_ice_triggered_r(0) <= s_axi_wdata_reg_r(19); -- ICE_TRIGGERED(0)
                        end if;
                    end if;
                    -- register 'Pause_mono_duration' at address offset 0x4
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_MONO_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pause_mono_duration_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_mono_duration_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_mono_duration_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_mono_duration_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_mono_duration_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_mono_duration_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_mono_duration_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_mono_duration_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_mono_duration_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_mono_duration_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_mono_duration_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_mono_duration_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_mono_duration_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_mono_duration_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_mono_duration_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_mono_duration_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_mono_duration_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_mono_duration_value_r(16) <= s_axi_wdata_reg_r(16); -- value(16)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_mono_duration_value_r(17) <= s_axi_wdata_reg_r(17); -- value(17)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_mono_duration_value_r(18) <= s_axi_wdata_reg_r(18); -- value(18)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_mono_duration_value_r(19) <= s_axi_wdata_reg_r(19); -- value(19)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_mono_duration_value_r(20) <= s_axi_wdata_reg_r(20); -- value(20)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_mono_duration_value_r(21) <= s_axi_wdata_reg_r(21); -- value(21)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_mono_duration_value_r(22) <= s_axi_wdata_reg_r(22); -- value(22)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_mono_duration_value_r(23) <= s_axi_wdata_reg_r(23); -- value(23)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_mono_duration_value_r(24) <= s_axi_wdata_reg_r(24); -- value(24)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_mono_duration_value_r(25) <= s_axi_wdata_reg_r(25); -- value(25)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_mono_duration_value_r(26) <= s_axi_wdata_reg_r(26); -- value(26)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_mono_duration_value_r(27) <= s_axi_wdata_reg_r(27); -- value(27)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_mono_duration_value_r(28) <= s_axi_wdata_reg_r(28); -- value(28)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_mono_duration_value_r(29) <= s_axi_wdata_reg_r(29); -- value(29)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_mono_duration_value_r(30) <= s_axi_wdata_reg_r(30); -- value(30)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_mono_duration_value_r(31) <= s_axi_wdata_reg_r(31); -- value(31)
                        end if;
                    end if;
                    -- register 'Pause_bipol_duration' at address offset 0x8
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_BIPOL_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pause_bipol_duration_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_bipol_duration_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_bipol_duration_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_bipol_duration_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_bipol_duration_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_bipol_duration_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_bipol_duration_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_bipol_duration_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_bipol_duration_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_bipol_duration_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_bipol_duration_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_bipol_duration_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_bipol_duration_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_bipol_duration_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_bipol_duration_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_bipol_duration_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_bipol_duration_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_bipol_duration_value_r(16) <= s_axi_wdata_reg_r(16); -- value(16)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_bipol_duration_value_r(17) <= s_axi_wdata_reg_r(17); -- value(17)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_bipol_duration_value_r(18) <= s_axi_wdata_reg_r(18); -- value(18)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_bipol_duration_value_r(19) <= s_axi_wdata_reg_r(19); -- value(19)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_bipol_duration_value_r(20) <= s_axi_wdata_reg_r(20); -- value(20)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_bipol_duration_value_r(21) <= s_axi_wdata_reg_r(21); -- value(21)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_bipol_duration_value_r(22) <= s_axi_wdata_reg_r(22); -- value(22)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_bipol_duration_value_r(23) <= s_axi_wdata_reg_r(23); -- value(23)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_bipol_duration_value_r(24) <= s_axi_wdata_reg_r(24); -- value(24)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_bipol_duration_value_r(25) <= s_axi_wdata_reg_r(25); -- value(25)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_bipol_duration_value_r(26) <= s_axi_wdata_reg_r(26); -- value(26)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_bipol_duration_value_r(27) <= s_axi_wdata_reg_r(27); -- value(27)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_bipol_duration_value_r(28) <= s_axi_wdata_reg_r(28); -- value(28)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_bipol_duration_value_r(29) <= s_axi_wdata_reg_r(29); -- value(29)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_bipol_duration_value_r(30) <= s_axi_wdata_reg_r(30); -- value(30)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_bipol_duration_value_r(31) <= s_axi_wdata_reg_r(31); -- value(31)
                        end if;
                    end if;
                    -- register 'Pause_burst_duration' at address offset 0xC
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_BURST_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pause_burst_duration_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_burst_duration_value_r(16) <= s_axi_wdata_reg_r(16); -- value(16)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_burst_duration_value_r(17) <= s_axi_wdata_reg_r(17); -- value(17)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_burst_duration_value_r(18) <= s_axi_wdata_reg_r(18); -- value(18)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_burst_duration_value_r(19) <= s_axi_wdata_reg_r(19); -- value(19)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_burst_duration_value_r(20) <= s_axi_wdata_reg_r(20); -- value(20)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_burst_duration_value_r(21) <= s_axi_wdata_reg_r(21); -- value(21)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_burst_duration_value_r(22) <= s_axi_wdata_reg_r(22); -- value(22)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_burst_duration_value_r(23) <= s_axi_wdata_reg_r(23); -- value(23)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_burst_duration_value_r(24) <= s_axi_wdata_reg_r(24); -- value(24)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_burst_duration_value_r(25) <= s_axi_wdata_reg_r(25); -- value(25)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_burst_duration_value_r(26) <= s_axi_wdata_reg_r(26); -- value(26)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_burst_duration_value_r(27) <= s_axi_wdata_reg_r(27); -- value(27)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_burst_duration_value_r(28) <= s_axi_wdata_reg_r(28); -- value(28)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_burst_duration_value_r(29) <= s_axi_wdata_reg_r(29); -- value(29)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_burst_duration_value_r(30) <= s_axi_wdata_reg_r(30); -- value(30)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_burst_duration_value_r(31) <= s_axi_wdata_reg_r(31); -- value(31)
                        end if;
                    end if;
                    -- register 'Pulse_pos_gen' at address offset 0x10
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_POS_GEN_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_pos_gen_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_gen_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_gen_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_gen_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_gen_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_gen_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_gen_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_gen_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_gen_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_gen_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_gen_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_gen_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_gen_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_gen_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_gen_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_gen_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_gen_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_pos_gen_value_r(16) <= s_axi_wdata_reg_r(16); -- value(16)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_pos_gen_value_r(17) <= s_axi_wdata_reg_r(17); -- value(17)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_pos_gen_value_r(18) <= s_axi_wdata_reg_r(18); -- value(18)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_pos_gen_value_r(19) <= s_axi_wdata_reg_r(19); -- value(19)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_pos_gen_value_r(20) <= s_axi_wdata_reg_r(20); -- value(20)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_pos_gen_value_r(21) <= s_axi_wdata_reg_r(21); -- value(21)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_pos_gen_value_r(22) <= s_axi_wdata_reg_r(22); -- value(22)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_pos_gen_value_r(23) <= s_axi_wdata_reg_r(23); -- value(23)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_pos_gen_value_r(24) <= s_axi_wdata_reg_r(24); -- value(24)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_pos_gen_value_r(25) <= s_axi_wdata_reg_r(25); -- value(25)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_pos_gen_value_r(26) <= s_axi_wdata_reg_r(26); -- value(26)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_pos_gen_value_r(27) <= s_axi_wdata_reg_r(27); -- value(27)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_pos_gen_value_r(28) <= s_axi_wdata_reg_r(28); -- value(28)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_pos_gen_value_r(29) <= s_axi_wdata_reg_r(29); -- value(29)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_pos_gen_value_r(30) <= s_axi_wdata_reg_r(30); -- value(30)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_pos_gen_value_r(31) <= s_axi_wdata_reg_r(31); -- value(31)
                        end if;
                    end if;
                    -- register 'Pulse_neg_gen' at address offset 0x14
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_NEG_GEN_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_neg_gen_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_gen_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_gen_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_gen_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_gen_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_gen_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_gen_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_gen_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_gen_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_gen_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_gen_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_gen_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_gen_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_gen_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_gen_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_gen_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_gen_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_neg_gen_value_r(16) <= s_axi_wdata_reg_r(16); -- value(16)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_neg_gen_value_r(17) <= s_axi_wdata_reg_r(17); -- value(17)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_neg_gen_value_r(18) <= s_axi_wdata_reg_r(18); -- value(18)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_neg_gen_value_r(19) <= s_axi_wdata_reg_r(19); -- value(19)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_neg_gen_value_r(20) <= s_axi_wdata_reg_r(20); -- value(20)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_neg_gen_value_r(21) <= s_axi_wdata_reg_r(21); -- value(21)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_neg_gen_value_r(22) <= s_axi_wdata_reg_r(22); -- value(22)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_neg_gen_value_r(23) <= s_axi_wdata_reg_r(23); -- value(23)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_neg_gen_value_r(24) <= s_axi_wdata_reg_r(24); -- value(24)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_neg_gen_value_r(25) <= s_axi_wdata_reg_r(25); -- value(25)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_neg_gen_value_r(26) <= s_axi_wdata_reg_r(26); -- value(26)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_neg_gen_value_r(27) <= s_axi_wdata_reg_r(27); -- value(27)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_neg_gen_value_r(28) <= s_axi_wdata_reg_r(28); -- value(28)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_neg_gen_value_r(29) <= s_axi_wdata_reg_r(29); -- value(29)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_neg_gen_value_r(30) <= s_axi_wdata_reg_r(30); -- value(30)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_neg_gen_value_r(31) <= s_axi_wdata_reg_r(31); -- value(31)
                        end if;
                    end if;
                    -- register 'Pulse_pos_prep' at address offset 0x18
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_POS_PREP_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_pos_prep_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_prep_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_prep_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_prep_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_prep_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_prep_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_prep_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_prep_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_prep_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_prep_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_prep_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_prep_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_prep_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_prep_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_prep_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_prep_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_prep_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                    end if;
                    -- register 'Pulse_neg_prep' at address offset 0x1C
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_NEG_PREP_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_neg_prep_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_prep_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_prep_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_prep_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_prep_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_prep_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_prep_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_prep_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_prep_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_prep_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_prep_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_prep_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_prep_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_prep_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_prep_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_prep_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_prep_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                    end if;
                    -- register 'Pulse_pos_dis' at address offset 0x20
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_POS_DIS_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_pos_dis_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_dis_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_dis_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_dis_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_dis_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_dis_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_dis_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_dis_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_pos_dis_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_dis_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_dis_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_dis_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_dis_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_dis_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_dis_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_dis_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_pos_dis_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                    end if;
                    -- register 'Pulse_neg_dis' at address offset 0x24
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_NEG_DIS_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_neg_dis_strobe_r <= '1';
                        -- field 'value':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_dis_value_r(0) <= s_axi_wdata_reg_r(0); -- value(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_dis_value_r(1) <= s_axi_wdata_reg_r(1); -- value(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_dis_value_r(2) <= s_axi_wdata_reg_r(2); -- value(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_dis_value_r(3) <= s_axi_wdata_reg_r(3); -- value(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_dis_value_r(4) <= s_axi_wdata_reg_r(4); -- value(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_dis_value_r(5) <= s_axi_wdata_reg_r(5); -- value(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_dis_value_r(6) <= s_axi_wdata_reg_r(6); -- value(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_neg_dis_value_r(7) <= s_axi_wdata_reg_r(7); -- value(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_dis_value_r(8) <= s_axi_wdata_reg_r(8); -- value(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_dis_value_r(9) <= s_axi_wdata_reg_r(9); -- value(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_dis_value_r(10) <= s_axi_wdata_reg_r(10); -- value(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_dis_value_r(11) <= s_axi_wdata_reg_r(11); -- value(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_dis_value_r(12) <= s_axi_wdata_reg_r(12); -- value(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_dis_value_r(13) <= s_axi_wdata_reg_r(13); -- value(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_dis_value_r(14) <= s_axi_wdata_reg_r(14); -- value(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_neg_dis_value_r(15) <= s_axi_wdata_reg_r(15); -- value(15)
                        end if;
                    end if;
                    --
                    if not v_addr_hit then
                        s_axi_bresp_r <= AXI_DECERR;
                        -- pragma translate_off
                        report "AWADDR decode error" severity warning;
                        -- pragma translate_on
                    end if;
                    --
                    v_state_r := DONE;

                -- Write transaction completed, wait for master BREADY to proceed
                when DONE =>
                    if s_axi_bready = '1' then
                        s_axi_bvalid_r <= '0';
                        v_state_r      := IDLE;
                    end if;

            end case;


        end if;
    end process write_fsm;

    ----------------------------------------------------------------------------
    -- Outputs
    --
    s_axi_awready <= s_axi_awready_r;
    s_axi_wready  <= s_axi_wready_r;
    s_axi_bvalid  <= s_axi_bvalid_r;
    s_axi_bresp   <= s_axi_bresp_r;
    s_axi_arready <= s_axi_arready_r;
    s_axi_rvalid  <= s_axi_rvalid_r;
    s_axi_rresp   <= s_axi_rresp_r;
    s_axi_rdata   <= s_axi_rdata_r;

    setup_strobe <= s_setup_strobe_r;
    setup_bipolar_gen_enable <= s_reg_setup_bipolar_gen_enable_r;
    setup_generator_pre_and_post_enable <= s_reg_setup_generator_pre_and_post_enable_r;
    setup_pulse_number <= s_reg_setup_pulse_number_r;
    setup_burst_number <= s_reg_setup_burst_number_r;
    setup_gen_start <= s_reg_setup_gen_start_r;
    setup_ice_triggered <= s_reg_setup_ice_triggered_r;
    pause_mono_duration_strobe <= s_pause_mono_duration_strobe_r;
    pause_mono_duration_value <= s_reg_pause_mono_duration_value_r;
    pause_bipol_duration_strobe <= s_pause_bipol_duration_strobe_r;
    pause_bipol_duration_value <= s_reg_pause_bipol_duration_value_r;
    pause_burst_duration_strobe <= s_pause_burst_duration_strobe_r;
    pause_burst_duration_value <= s_reg_pause_burst_duration_value_r;
    pulse_pos_gen_strobe <= s_pulse_pos_gen_strobe_r;
    pulse_pos_gen_value <= s_reg_pulse_pos_gen_value_r;
    pulse_neg_gen_strobe <= s_pulse_neg_gen_strobe_r;
    pulse_neg_gen_value <= s_reg_pulse_neg_gen_value_r;
    pulse_pos_prep_strobe <= s_pulse_pos_prep_strobe_r;
    pulse_pos_prep_value <= s_reg_pulse_pos_prep_value_r;
    pulse_neg_prep_strobe <= s_pulse_neg_prep_strobe_r;
    pulse_neg_prep_value <= s_reg_pulse_neg_prep_value_r;
    pulse_pos_dis_strobe <= s_pulse_pos_dis_strobe_r;
    pulse_pos_dis_value <= s_reg_pulse_pos_dis_value_r;
    pulse_neg_dis_strobe <= s_pulse_neg_dis_strobe_r;
    pulse_neg_dis_value <= s_reg_pulse_neg_dis_value_r;

end architecture RTL;
