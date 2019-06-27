library ieee;

use ieee.std_logic_1164.all;

use ieee.numeric_std.all;

entity IR is
port
(
	-- Input ports
	program_data : in std_logic_vector (15 downto 0);
	clk          : in std_logic;
	load         : in std_logic;

	-- Output ports
    program_statement : out std_logic_vector (15 downto 0)
);
end IR;


architecture arch_IR of IR is
begin
	process (clk)
	begin
		if (clk'event and rising_edge(clk) and load='1') then
			program_statement <= program_data;	
		end if;
	end process;
end arch_IR;
