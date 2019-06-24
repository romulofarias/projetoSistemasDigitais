library ieee;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;
entity reg8 is
	port
	(
		-- Input ports
		load	: in std_logic;
		reset   : in std_logic;
		clock	: in std_logic;
		input	: in std_logic_vector (7 downto 0);

		-- Output ports
		output	: out std_logic_vector (7 downto 0)
	);
end reg8;


architecture reg8_arch of reg8 is
begin
	process(clock) is 
	begin 
		if (clock'event and rising_edge(clock) and load='1') then
            if (reset='1') then
                output <= (others => '0');
            elsif (load='1') then
                output <= input;
            end if;
		end if;
	end process;
end reg8_arch;

