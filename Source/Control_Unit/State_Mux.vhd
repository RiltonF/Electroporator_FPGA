library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.generator.state_type;


entity State_MUX is
  port(
  --input
    mon_simple_in: in state_type;
    mon_full_in: in state_type;
    bi_simple_in: in state_type;
    bi_full_in: in state_type;
    s: in std_logic_vector(1 downto 0);
    --output
    state_out: out state_type
  );
end State_MUX;

architecture rtl of State_MUX is
 
type t_array_mux is array (0 to 3) of state_type;

signal array_mux  : t_array_mux;

begin
  array_mux(0) <= mon_simple_in;
  array_mux(1) <= mon_full_in;
  array_mux(2) <= bi_simple_in;
  array_mux(3) <= bi_full_in;

  state_out <= array_mux(to_integer(unsigned(s)));
end rtl;
