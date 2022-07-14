LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity mux is
port (

            a       : in std_logic_vector (3 downto 0);
            b       : in std_logic_vector (3 downto 0);
            enable  : in std_logic;
            saida   : out std_logic_vector(3 downto 0)

        );
end mux;


architecture behaviour of mux is
begin

    process(enable, a, b)
    begin
        if(enable = '0') then
            saida <= a;
        else
            saida <= b;
        end if;
    end process;

end behaviour;