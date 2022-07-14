library ieee;
use ieee.std_logic_1164.all;


entity comparador is

    generic
    (
        DATA_WIDTH : natural := 16
    );

    port
    (
        a         : in std_logic_vector  ((DATA_WIDTH-1) downto 0); 
        b         : in std_logic_vector  ((DATA_WIDTH-1) downto 0);
        a_gt_b     : out std_logic
    );

end comparador;

architecture rtl of comparador is
begin

    process(a,b)
    begin

        if (a < b) then
            a_gt_b <= '0';
        else
            a_gt_b <= '1';
        end if;

    end process;

end rtl;