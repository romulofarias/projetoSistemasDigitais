library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
generic
(
	constant N: natural := 1 --numero de bits deslocados
);


port
(
	-- Input ports
    A, B    : in signed(7 downto 0);
	ALU_SEL	: in std_logic_vector(4 downto 0);
    compare_sel : in std_logic_vector(2 downto 0);
		
	-- Output ports
	ALU_OUT	: out signed (7 downto 0);
	carryout	: out std_logic; --Flag carryout;
	alu_flags: buffer std_logic := '0'
);
end alu;


architecture behavioral of alu is

shared variable alu_result : signed(7 downto 0);
shared variable tmp : signed(8 downto 0);

function compare(A: signed(7 downto 0);
                    B: signed(7 downto 0);
                    operation: std_logic_vector(2 downto 0)) return std_logic is
    variable comp : std_logic;
begin
    comp := '0';
    case (operation) is
        when "000" => --A=B
            if (A=B) then
            comp := '1';
            end if;
        when "001" => --A>B
            if (A>B) then
            comp := '1';
            end if;
        when "010" => --A<B
            if (A<B) then
            comp := '1';
            end if;
        when "011" => --A>=B
            if (A>=B) then
            comp := '1';
            end if;
        when "100" => --A<=B
            if (A<=B) then
            comp := '1';
            end if;
        when "101" => --A/=B
            if (A/=B) then
            comp := '1';
            end if;
        when others => null;
    end case;
    return comp;
end function;

begin
process(A, B, ALU_SEL, compare_sel)
begin
	case (ALU_SEL) is
	when "01000" => --add
		alu_result := A + B;
	when "01001" => --sub
		alu_result := A - B;
	when "01010" => --inc
		alu_result := A + 1;
	when "01011" => --dec
		alu_result := A - 1;
	when "01100" => --inv
		alu_result := not A;
	when "01101" => --compl
		alu_result := (not A) + 1;
	when "01110" => --shift_left
		alu_result := A sll N;
	when "01111" => --shift_right
		alu_result := A srl N;
	when "11000" => --and
		alu_result := A and B;
	when "11001" => --or
		alu_result := A or B;
	when "11010" => --xor
		alu_result := A xor B;
	when "10111" => --compare
		alu_flags <= compare(A, B, compare_sel);
    when "11011" => -- logic AND
		alu_flags <= alu_flags AND compare(A, B, compare_sel);
    when "11100" => -- logic OR
		alu_flags <= alu_flags OR compare(A, B, compare_sel);
    when "11101" => -- logic XOR
		alu_flags <= alu_flags XOR compare(A, B, compare_sel);
	when others =>
		alu_result := x"00";
	end case;
    ALU_OUT <= ALU_result;
    tmp := A + B;
    carryout <= tmp(8); --Carryout flag
end process;

end behavioral;
