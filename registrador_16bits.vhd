library ieee;
use ieee.std_logic_1164.all;

entity registrador_16bits is
    port (
        clock: in std_logic;
        registrador_ld: in std_logic;
		  registrador_clr: in std_logic;
        registrador_in: in std_logic_vector(15 downto 0);
        registrador_out: out std_logic_vector(15 downto 0)
    );
end registrador_16bits;

architecture rtl of registrador_16bits is 
begin
    process(clock, registrador_in, registrador_clr)
    begin
        if(registrador_clr = '1') then
            registrador_out <= x"0000";
        elsif( (rising_edge(clock)) and (registrador_ld = '1') ) then
            registrador_out <= registrador_in;
        end if;
    end process;
end rtl;