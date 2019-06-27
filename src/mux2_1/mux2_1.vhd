library ieee;

use ieee.std_logic_1164.all;

entity mux2_1 is
	port
	(
		-- Input ports
		e0, e1 : in std_logic_vector(10 downto 0);
		switch : in std_logic;

		-- Output ports
		y : out std_logic_vector(10 downto 0)
	);
end mux2_1;


architecture arch_mux2_1 of mux2_1 is
begin
	WITH switch SELECT
	  y <=              e0 WHEN '0',
                        e1 WHEN '1',
           (others => '0') WHEN others
	  ;
end arch_mux2_1;
