library ieee;
use ieee.std_logic_1164.all;

entity registrador_1bit is
    port (
        clock: in std_logic;
        registrador_ld: in std_logic;
		  registrador_clr: in std_logic;
        registrador_in: in std_logic;
        registrador_out: out std_logic
    );
end registrador_1bit;

architecture rtl of registrador_1bit is 
begin
    process(clock, registrador_in, registrador_clr, registrador_ld)
    begin
        if(registrador_clr = '1') then
            registrador_out <= '0';
        elsif( (rising_edge(clock)) and (registrador_ld = '1') ) then
            registrador_out <= registrador_in;
        end if;
    end process;
end rtl;