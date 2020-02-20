-- -----------------------------------------------------------------------------
-- 'Generator' Register Component
-- Revision: 65
-- -----------------------------------------------------------------------------
-- Generated on 2019-03-20 at 13:14 (UTC) by airhdl version 2019.02.1
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

use work.Generator_regs_pkg.all;

entity Generator_regs is
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
        pause_duration_strobe : out std_logic; -- Strobe signal for register 'Pause_Duration' (pulsed when the register is written from the bus)
        pause_duration_pause_mono_duration : out std_logic_vector(15 downto 0); -- Value of register 'Pause_Duration', field 'Pause_mono_duration'
        pause_duration_pause_bipol_duration : out std_logic_vector(15 downto 0); -- Value of register 'Pause_Duration', field 'Pause_bipol_duration'
        pause_burst_duration_strobe : out std_logic; -- Strobe signal for register 'Pause_Burst_Duration' (pulsed when the register is written from the bus)
        pause_burst_duration_pause_burst_duration : out std_logic_vector(15 downto 0); -- Value of register 'Pause_Burst_Duration', field 'Pause_burst_duration'
        pulse_gen_duration_strobe : out std_logic; -- Strobe signal for register 'Pulse_gen_duration' (pulsed when the register is written from the bus)
        pulse_gen_duration_pulse_pos_gen : out std_logic_vector(15 downto 0); -- Value of register 'Pulse_gen_duration', field 'Pulse_pos_gen'
        pulse_gen_duration_pulse_neg_gen : out std_logic_vector(15 downto 0); -- Value of register 'Pulse_gen_duration', field 'Pulse_neg_gen'
        pulse_prep_duration_strobe : out std_logic; -- Strobe signal for register 'Pulse_prep_duration' (pulsed when the register is written from the bus)
        pulse_prep_duration_pulse_pos_prep : out std_logic_vector(15 downto 0); -- Value of register 'Pulse_prep_duration', field 'Pulse_pos_prep'
        pulse_prep_duration_pulse_neg_prep : out std_logic_vector(15 downto 0); -- Value of register 'Pulse_prep_duration', field 'Pulse_neg_prep'
        pulse_dis_duration_strobe : out std_logic; -- Strobe signal for register 'Pulse_dis_duration' (pulsed when the register is written from the bus)
        pulse_dis_duration_pulse_pos_dis : out std_logic_vector(15 downto 0); -- Value of register 'Pulse_dis_duration', field 'Pulse_pos_dis'
        pulse_dis_duration_pulse_neg_dis : out std_logic_vector(15 downto 0) -- Value of register 'Pulse_dis_duration', field 'Pulse_neg_dis'
    );
end entity Generator_regs;

architecture RTL of Generator_regs is

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
    signal s_pause_duration_strobe_r : std_logic;
    signal s_reg_pause_duration_pause_mono_duration_r : std_logic_vector(15 downto 0);
    signal s_reg_pause_duration_pause_bipol_duration_r : std_logic_vector(15 downto 0);
    signal s_pause_burst_duration_strobe_r : std_logic;
    signal s_reg_pause_burst_duration_pause_burst_duration_r : std_logic_vector(15 downto 0);
    signal s_pulse_gen_duration_strobe_r : std_logic;
    signal s_reg_pulse_gen_duration_pulse_pos_gen_r : std_logic_vector(15 downto 0);
    signal s_reg_pulse_gen_duration_pulse_neg_gen_r : std_logic_vector(15 downto 0);
    signal s_pulse_prep_duration_strobe_r : std_logic;
    signal s_reg_pulse_prep_duration_pulse_pos_prep_r : std_logic_vector(15 downto 0);
    signal s_reg_pulse_prep_duration_pulse_neg_prep_r : std_logic_vector(15 downto 0);
    signal s_pulse_dis_duration_strobe_r : std_logic;
    signal s_reg_pulse_dis_duration_pulse_pos_dis_r : std_logic_vector(15 downto 0);
    signal s_reg_pulse_dis_duration_pulse_neg_dis_r : std_logic_vector(15 downto 0);

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
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pause_Duration' at address offset 0x4 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pause_duration_pause_mono_duration_r;
                        v_rdata_r(31 downto 16) := s_reg_pause_duration_pause_bipol_duration_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pause_Burst_Duration' at address offset 0x8 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_BURST_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pause_burst_duration_pause_burst_duration_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_gen_duration' at address offset 0xC 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_GEN_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pulse_gen_duration_pulse_pos_gen_r;
                        v_rdata_r(31 downto 16) := s_reg_pulse_gen_duration_pulse_neg_gen_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_prep_duration' at address offset 0x10 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_PREP_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pulse_prep_duration_pulse_pos_prep_r;
                        v_rdata_r(31 downto 16) := s_reg_pulse_prep_duration_pulse_neg_prep_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Pulse_dis_duration' at address offset 0x14 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + PULSE_DIS_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pulse_dis_duration_pulse_pos_dis_r;
                        v_rdata_r(31 downto 16) := s_reg_pulse_dis_duration_pulse_neg_dis_r;
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
            s_reg_setup_bipolar_gen_enable_r <= std_logic_vector'("0");
            s_reg_setup_generator_pre_and_post_enable_r <= std_logic_vector'("0");
            s_reg_setup_pulse_number_r <= std_logic_vector'("00000000");
            s_reg_setup_burst_number_r <= std_logic_vector'("00000000");
            s_reg_setup_gen_start_r <= std_logic_vector'("0");
            s_pause_duration_strobe_r <= '0';
            s_reg_pause_duration_pause_mono_duration_r <= std_logic_vector'("0000000000000000");
            s_reg_pause_duration_pause_bipol_duration_r <= std_logic_vector'("0000000000000000");
            s_pause_burst_duration_strobe_r <= '0';
            s_reg_pause_burst_duration_pause_burst_duration_r <= std_logic_vector'("0000000000000000");
            s_pulse_gen_duration_strobe_r <= '0';
            s_reg_pulse_gen_duration_pulse_pos_gen_r <= std_logic_vector'("0000000000000000");
            s_reg_pulse_gen_duration_pulse_neg_gen_r <= std_logic_vector'("0000000000000000");
            s_pulse_prep_duration_strobe_r <= '0';
            s_reg_pulse_prep_duration_pulse_pos_prep_r <= std_logic_vector'("0000000000000000");
            s_reg_pulse_prep_duration_pulse_neg_prep_r <= std_logic_vector'("0000000000000000");
            s_pulse_dis_duration_strobe_r <= '0';
            s_reg_pulse_dis_duration_pulse_pos_dis_r <= std_logic_vector'("0000000000000000");
            s_reg_pulse_dis_duration_pulse_neg_dis_r <= std_logic_vector'("0000000000000000");

        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_awready_r <= '0';
            s_axi_wready_r  <= '0';
            s_setup_strobe_r <= '0';
            s_pause_duration_strobe_r <= '0';
            s_pause_burst_duration_strobe_r <= '0';
            s_pulse_gen_duration_strobe_r <= '0';
            s_pulse_prep_duration_strobe_r <= '0';
            s_pulse_dis_duration_strobe_r <= '0';

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
                    end if;
                    -- register 'Pause_Duration' at address offset 0x4
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pause_duration_strobe_r <= '1';
                        -- field 'Pause_mono_duration':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(0) <= s_axi_wdata_reg_r(0); -- Pause_mono_duration(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(1) <= s_axi_wdata_reg_r(1); -- Pause_mono_duration(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(2) <= s_axi_wdata_reg_r(2); -- Pause_mono_duration(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(3) <= s_axi_wdata_reg_r(3); -- Pause_mono_duration(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(4) <= s_axi_wdata_reg_r(4); -- Pause_mono_duration(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(5) <= s_axi_wdata_reg_r(5); -- Pause_mono_duration(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(6) <= s_axi_wdata_reg_r(6); -- Pause_mono_duration(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(7) <= s_axi_wdata_reg_r(7); -- Pause_mono_duration(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(8) <= s_axi_wdata_reg_r(8); -- Pause_mono_duration(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(9) <= s_axi_wdata_reg_r(9); -- Pause_mono_duration(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(10) <= s_axi_wdata_reg_r(10); -- Pause_mono_duration(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(11) <= s_axi_wdata_reg_r(11); -- Pause_mono_duration(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(12) <= s_axi_wdata_reg_r(12); -- Pause_mono_duration(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(13) <= s_axi_wdata_reg_r(13); -- Pause_mono_duration(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(14) <= s_axi_wdata_reg_r(14); -- Pause_mono_duration(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_duration_pause_mono_duration_r(15) <= s_axi_wdata_reg_r(15); -- Pause_mono_duration(15)
                        end if;
                        -- field 'Pause_bipol_duration':
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(0) <= s_axi_wdata_reg_r(16); -- Pause_bipol_duration(0)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(1) <= s_axi_wdata_reg_r(17); -- Pause_bipol_duration(1)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(2) <= s_axi_wdata_reg_r(18); -- Pause_bipol_duration(2)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(3) <= s_axi_wdata_reg_r(19); -- Pause_bipol_duration(3)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(4) <= s_axi_wdata_reg_r(20); -- Pause_bipol_duration(4)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(5) <= s_axi_wdata_reg_r(21); -- Pause_bipol_duration(5)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(6) <= s_axi_wdata_reg_r(22); -- Pause_bipol_duration(6)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(7) <= s_axi_wdata_reg_r(23); -- Pause_bipol_duration(7)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(8) <= s_axi_wdata_reg_r(24); -- Pause_bipol_duration(8)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(9) <= s_axi_wdata_reg_r(25); -- Pause_bipol_duration(9)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(10) <= s_axi_wdata_reg_r(26); -- Pause_bipol_duration(10)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(11) <= s_axi_wdata_reg_r(27); -- Pause_bipol_duration(11)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(12) <= s_axi_wdata_reg_r(28); -- Pause_bipol_duration(12)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(13) <= s_axi_wdata_reg_r(29); -- Pause_bipol_duration(13)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(14) <= s_axi_wdata_reg_r(30); -- Pause_bipol_duration(14)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pause_duration_pause_bipol_duration_r(15) <= s_axi_wdata_reg_r(31); -- Pause_bipol_duration(15)
                        end if;
                    end if;
                    -- register 'Pause_Burst_Duration' at address offset 0x8
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PAUSE_BURST_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pause_burst_duration_strobe_r <= '1';
                        -- field 'Pause_burst_duration':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(0) <= s_axi_wdata_reg_r(0); -- Pause_burst_duration(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(1) <= s_axi_wdata_reg_r(1); -- Pause_burst_duration(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(2) <= s_axi_wdata_reg_r(2); -- Pause_burst_duration(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(3) <= s_axi_wdata_reg_r(3); -- Pause_burst_duration(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(4) <= s_axi_wdata_reg_r(4); -- Pause_burst_duration(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(5) <= s_axi_wdata_reg_r(5); -- Pause_burst_duration(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(6) <= s_axi_wdata_reg_r(6); -- Pause_burst_duration(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(7) <= s_axi_wdata_reg_r(7); -- Pause_burst_duration(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(8) <= s_axi_wdata_reg_r(8); -- Pause_burst_duration(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(9) <= s_axi_wdata_reg_r(9); -- Pause_burst_duration(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(10) <= s_axi_wdata_reg_r(10); -- Pause_burst_duration(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(11) <= s_axi_wdata_reg_r(11); -- Pause_burst_duration(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(12) <= s_axi_wdata_reg_r(12); -- Pause_burst_duration(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(13) <= s_axi_wdata_reg_r(13); -- Pause_burst_duration(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(14) <= s_axi_wdata_reg_r(14); -- Pause_burst_duration(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pause_burst_duration_pause_burst_duration_r(15) <= s_axi_wdata_reg_r(15); -- Pause_burst_duration(15)
                        end if;
                    end if;
                    -- register 'Pulse_gen_duration' at address offset 0xC
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_GEN_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_gen_duration_strobe_r <= '1';
                        -- field 'Pulse_pos_gen':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(0) <= s_axi_wdata_reg_r(0); -- Pulse_pos_gen(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(1) <= s_axi_wdata_reg_r(1); -- Pulse_pos_gen(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(2) <= s_axi_wdata_reg_r(2); -- Pulse_pos_gen(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(3) <= s_axi_wdata_reg_r(3); -- Pulse_pos_gen(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(4) <= s_axi_wdata_reg_r(4); -- Pulse_pos_gen(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(5) <= s_axi_wdata_reg_r(5); -- Pulse_pos_gen(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(6) <= s_axi_wdata_reg_r(6); -- Pulse_pos_gen(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(7) <= s_axi_wdata_reg_r(7); -- Pulse_pos_gen(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(8) <= s_axi_wdata_reg_r(8); -- Pulse_pos_gen(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(9) <= s_axi_wdata_reg_r(9); -- Pulse_pos_gen(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(10) <= s_axi_wdata_reg_r(10); -- Pulse_pos_gen(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(11) <= s_axi_wdata_reg_r(11); -- Pulse_pos_gen(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(12) <= s_axi_wdata_reg_r(12); -- Pulse_pos_gen(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(13) <= s_axi_wdata_reg_r(13); -- Pulse_pos_gen(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(14) <= s_axi_wdata_reg_r(14); -- Pulse_pos_gen(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_gen_duration_pulse_pos_gen_r(15) <= s_axi_wdata_reg_r(15); -- Pulse_pos_gen(15)
                        end if;
                        -- field 'Pulse_neg_gen':
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(0) <= s_axi_wdata_reg_r(16); -- Pulse_neg_gen(0)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(1) <= s_axi_wdata_reg_r(17); -- Pulse_neg_gen(1)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(2) <= s_axi_wdata_reg_r(18); -- Pulse_neg_gen(2)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(3) <= s_axi_wdata_reg_r(19); -- Pulse_neg_gen(3)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(4) <= s_axi_wdata_reg_r(20); -- Pulse_neg_gen(4)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(5) <= s_axi_wdata_reg_r(21); -- Pulse_neg_gen(5)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(6) <= s_axi_wdata_reg_r(22); -- Pulse_neg_gen(6)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(7) <= s_axi_wdata_reg_r(23); -- Pulse_neg_gen(7)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(8) <= s_axi_wdata_reg_r(24); -- Pulse_neg_gen(8)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(9) <= s_axi_wdata_reg_r(25); -- Pulse_neg_gen(9)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(10) <= s_axi_wdata_reg_r(26); -- Pulse_neg_gen(10)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(11) <= s_axi_wdata_reg_r(27); -- Pulse_neg_gen(11)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(12) <= s_axi_wdata_reg_r(28); -- Pulse_neg_gen(12)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(13) <= s_axi_wdata_reg_r(29); -- Pulse_neg_gen(13)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(14) <= s_axi_wdata_reg_r(30); -- Pulse_neg_gen(14)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_gen_duration_pulse_neg_gen_r(15) <= s_axi_wdata_reg_r(31); -- Pulse_neg_gen(15)
                        end if;
                    end if;
                    -- register 'Pulse_prep_duration' at address offset 0x10
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_PREP_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_prep_duration_strobe_r <= '1';
                        -- field 'Pulse_pos_prep':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(0) <= s_axi_wdata_reg_r(0); -- Pulse_pos_prep(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(1) <= s_axi_wdata_reg_r(1); -- Pulse_pos_prep(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(2) <= s_axi_wdata_reg_r(2); -- Pulse_pos_prep(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(3) <= s_axi_wdata_reg_r(3); -- Pulse_pos_prep(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(4) <= s_axi_wdata_reg_r(4); -- Pulse_pos_prep(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(5) <= s_axi_wdata_reg_r(5); -- Pulse_pos_prep(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(6) <= s_axi_wdata_reg_r(6); -- Pulse_pos_prep(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(7) <= s_axi_wdata_reg_r(7); -- Pulse_pos_prep(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(8) <= s_axi_wdata_reg_r(8); -- Pulse_pos_prep(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(9) <= s_axi_wdata_reg_r(9); -- Pulse_pos_prep(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(10) <= s_axi_wdata_reg_r(10); -- Pulse_pos_prep(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(11) <= s_axi_wdata_reg_r(11); -- Pulse_pos_prep(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(12) <= s_axi_wdata_reg_r(12); -- Pulse_pos_prep(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(13) <= s_axi_wdata_reg_r(13); -- Pulse_pos_prep(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(14) <= s_axi_wdata_reg_r(14); -- Pulse_pos_prep(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_prep_duration_pulse_pos_prep_r(15) <= s_axi_wdata_reg_r(15); -- Pulse_pos_prep(15)
                        end if;
                        -- field 'Pulse_neg_prep':
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(0) <= s_axi_wdata_reg_r(16); -- Pulse_neg_prep(0)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(1) <= s_axi_wdata_reg_r(17); -- Pulse_neg_prep(1)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(2) <= s_axi_wdata_reg_r(18); -- Pulse_neg_prep(2)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(3) <= s_axi_wdata_reg_r(19); -- Pulse_neg_prep(3)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(4) <= s_axi_wdata_reg_r(20); -- Pulse_neg_prep(4)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(5) <= s_axi_wdata_reg_r(21); -- Pulse_neg_prep(5)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(6) <= s_axi_wdata_reg_r(22); -- Pulse_neg_prep(6)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(7) <= s_axi_wdata_reg_r(23); -- Pulse_neg_prep(7)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(8) <= s_axi_wdata_reg_r(24); -- Pulse_neg_prep(8)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(9) <= s_axi_wdata_reg_r(25); -- Pulse_neg_prep(9)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(10) <= s_axi_wdata_reg_r(26); -- Pulse_neg_prep(10)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(11) <= s_axi_wdata_reg_r(27); -- Pulse_neg_prep(11)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(12) <= s_axi_wdata_reg_r(28); -- Pulse_neg_prep(12)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(13) <= s_axi_wdata_reg_r(29); -- Pulse_neg_prep(13)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(14) <= s_axi_wdata_reg_r(30); -- Pulse_neg_prep(14)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_prep_duration_pulse_neg_prep_r(15) <= s_axi_wdata_reg_r(31); -- Pulse_neg_prep(15)
                        end if;
                    end if;
                    -- register 'Pulse_dis_duration' at address offset 0x14
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + PULSE_DIS_DURATION_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pulse_dis_duration_strobe_r <= '1';
                        -- field 'Pulse_pos_dis':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(0) <= s_axi_wdata_reg_r(0); -- Pulse_pos_dis(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(1) <= s_axi_wdata_reg_r(1); -- Pulse_pos_dis(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(2) <= s_axi_wdata_reg_r(2); -- Pulse_pos_dis(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(3) <= s_axi_wdata_reg_r(3); -- Pulse_pos_dis(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(4) <= s_axi_wdata_reg_r(4); -- Pulse_pos_dis(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(5) <= s_axi_wdata_reg_r(5); -- Pulse_pos_dis(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(6) <= s_axi_wdata_reg_r(6); -- Pulse_pos_dis(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(7) <= s_axi_wdata_reg_r(7); -- Pulse_pos_dis(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(8) <= s_axi_wdata_reg_r(8); -- Pulse_pos_dis(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(9) <= s_axi_wdata_reg_r(9); -- Pulse_pos_dis(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(10) <= s_axi_wdata_reg_r(10); -- Pulse_pos_dis(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(11) <= s_axi_wdata_reg_r(11); -- Pulse_pos_dis(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(12) <= s_axi_wdata_reg_r(12); -- Pulse_pos_dis(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(13) <= s_axi_wdata_reg_r(13); -- Pulse_pos_dis(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(14) <= s_axi_wdata_reg_r(14); -- Pulse_pos_dis(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pulse_dis_duration_pulse_pos_dis_r(15) <= s_axi_wdata_reg_r(15); -- Pulse_pos_dis(15)
                        end if;
                        -- field 'Pulse_neg_dis':
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(0) <= s_axi_wdata_reg_r(16); -- Pulse_neg_dis(0)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(1) <= s_axi_wdata_reg_r(17); -- Pulse_neg_dis(1)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(2) <= s_axi_wdata_reg_r(18); -- Pulse_neg_dis(2)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(3) <= s_axi_wdata_reg_r(19); -- Pulse_neg_dis(3)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(4) <= s_axi_wdata_reg_r(20); -- Pulse_neg_dis(4)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(5) <= s_axi_wdata_reg_r(21); -- Pulse_neg_dis(5)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(6) <= s_axi_wdata_reg_r(22); -- Pulse_neg_dis(6)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(7) <= s_axi_wdata_reg_r(23); -- Pulse_neg_dis(7)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(8) <= s_axi_wdata_reg_r(24); -- Pulse_neg_dis(8)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(9) <= s_axi_wdata_reg_r(25); -- Pulse_neg_dis(9)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(10) <= s_axi_wdata_reg_r(26); -- Pulse_neg_dis(10)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(11) <= s_axi_wdata_reg_r(27); -- Pulse_neg_dis(11)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(12) <= s_axi_wdata_reg_r(28); -- Pulse_neg_dis(12)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(13) <= s_axi_wdata_reg_r(29); -- Pulse_neg_dis(13)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(14) <= s_axi_wdata_reg_r(30); -- Pulse_neg_dis(14)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pulse_dis_duration_pulse_neg_dis_r(15) <= s_axi_wdata_reg_r(31); -- Pulse_neg_dis(15)
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
    pause_duration_strobe <= s_pause_duration_strobe_r;
    pause_duration_pause_mono_duration <= s_reg_pause_duration_pause_mono_duration_r;
    pause_duration_pause_bipol_duration <= s_reg_pause_duration_pause_bipol_duration_r;
    pause_burst_duration_strobe <= s_pause_burst_duration_strobe_r;
    pause_burst_duration_pause_burst_duration <= s_reg_pause_burst_duration_pause_burst_duration_r;
    pulse_gen_duration_strobe <= s_pulse_gen_duration_strobe_r;
    pulse_gen_duration_pulse_pos_gen <= s_reg_pulse_gen_duration_pulse_pos_gen_r;
    pulse_gen_duration_pulse_neg_gen <= s_reg_pulse_gen_duration_pulse_neg_gen_r;
    pulse_prep_duration_strobe <= s_pulse_prep_duration_strobe_r;
    pulse_prep_duration_pulse_pos_prep <= s_reg_pulse_prep_duration_pulse_pos_prep_r;
    pulse_prep_duration_pulse_neg_prep <= s_reg_pulse_prep_duration_pulse_neg_prep_r;
    pulse_dis_duration_strobe <= s_pulse_dis_duration_strobe_r;
    pulse_dis_duration_pulse_pos_dis <= s_reg_pulse_dis_duration_pulse_pos_dis_r;
    pulse_dis_duration_pulse_neg_dis <= s_reg_pulse_dis_duration_pulse_neg_dis_r;

end architecture RTL;
