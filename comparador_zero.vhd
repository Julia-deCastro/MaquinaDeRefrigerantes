library ieee;
use ieee.std_logic_1164.all;


entity comparador_zero is

    generic
    (
        DATA_WIDTH : natural := 5
    );

    port
    (
        a         : in std_logic_vector  ((DATA_WIDTH-1) downto 0); 
        a_eq_0    : out std_logic
    );

end comparador_zero;

architecture rtl of comparador_zero is
begin

    process(a)
    begin
        if(a > "00000") then
            a_eq_0 <= '1';
        else 
            a_eq_0 <= '0';

        end if;

    end process;

end rtl;