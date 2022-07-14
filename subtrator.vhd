library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtrator is

	generic 
	(
	DATA_WIDTH : natural := 16
	);

	port
	(
		a			: in std_logic_vector((DATA_WIDTH-1) downto 0);
		result   : out std_logic_vector((DATA_WIDTH-1) downto 0)
	);
	
end subtrator;
	

architecture comportamental of subtrator is
begin

		process(a)
		begin
			result <= std_logic_vector(unsigned(a)- 1);
		end process;
		
end comportamental;