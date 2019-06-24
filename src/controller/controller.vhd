library ieee;
use ieee.std_logic_1164.all;

entity controller is

	port(
		clk	     : in	std_logic;
		input	 : in	std_logic_vector (4 downto 0);
		reset	 : in	std_logic;
        cmp      : in   std_logic;

		opcode : buffer std_logic_vector (4 downto 0);
		
		output               : out	std_logic_vector(1 downto 0);
        pc_switch            : out std_logic;
		pc_incr              : out std_logic;
		pc_ld                : out std_logic;
		ir_load              : out std_logic;
		pilha_ld             : out std_logic;
        register_file_switch : out std_logic_vector (1 downto 0);
		alu_switch           : out std_logic_vector (4 downto 0);
		alu_ra_switch        : out std_logic_vector (2 downto 0);
		alu_rb_switch        : out std_logic_vector (2 downto 0);
		io_switch            : out std_logic_vector (1 downto 0);
		reg_load             : out std_logic;
		reg_reset            : out std_logic;
		D_rd                 : out std_logic;
		D_wr                 : out std_logic
	);

end entity;

architecture controller_arch of controller is

    type state_type is (inicio, busca, decodificacao,
                        noop, load, store, set, swap,
                        move, copy, drop,

                        add, sub, inc, dec, inv, compl,

                        l_shift, r_shift, bit_or, bit_and,
                        bit_xor, bit_set, bit_clear, in_operation, out_operation,

                        compare, logical_and, logical_or, logical_xor, jump_if, jump_else,
                        jump, call, ret
	);
	signal state   : state_type;

begin
    process (clk, reset)
    begin
        if reset = '1' then
            state <= inicio;
        elsif (rising_edge(clk)) then
            case state is
                when inicio =>
                    state <= busca;
                when busca =>
                    pc_incr <= '1';
                when decodificacao =>
                    case opcode is
                        when "00000" =>
                            state <= noop;
                        when "00001" =>
                            state <= load;
                        when "00010" =>
                             state <= store;
                        when "00011" =>
                             state <= set;
                        when "00100" =>
                             state <= swap;
                        when "00101" =>
                            state <= move;
                        when "00110" =>
                            state <= copy;
                        when "00111" =>
                            state <= drop;
                        when "01000" =>
                            state <= add;
                        when "01001" =>
                            state <= sub;
                        when "01010" =>
                            state <= inc;
                        when "01011" =>
                            state <= dec;
                        when "01100" =>
                            state <= inv;
                        when "01101" =>
                            state <= compl;
                        when "01110" =>
                            state <= l_shift;
                        when "01111" =>
                            state <= r_shift;
                        when "10000" =>
                            state <= bit_or;
                        when "10001" =>
                            state <= bit_and;
                        when "10010" =>
                            state <= bit_xor;
                        when "10011" =>
                            state <= bit_set;
                        when "10100" =>
                            state <= bit_clear;
                        when "10101" =>
                            state <= in_operation;
                        when "10110" =>
                            state <= out_operation;
                        when "10111" =>
                            state <= compare;
                        when "11000" =>
                            state <= logical_and;
                        when "11001" =>
                            state <= logical_or;
                        when "11010" =>
                            state <= logical_xor;
                        when "11011" =>
                            state <= jump_if;
                        when "11100" =>
                            state <= jump_else;
                        when "11101" =>
                            state <= jump;
                        when "11110" =>
                            state <= call;
                        when "11111" =>
                            state <= ret;
                        when others => null;
                    end case;
                when others =>
                    state <= busca;
            end case;
        end if;
	end process;

    process (state)
    begin
        case state is
            when inicio        =>
                null;
            when busca         =>
                ir_load <= '1';
                pc_incr <= '1';
            when decodificacao =>
                opcode <= input;
            when noop          =>
                null;
            when load          =>
                D_rd <= '1';
                register_file_switch <= "01";
                reg_load <= '1';
            when store         =>
                D_wr <= '1';
                io_switch  <= "01";
            when set           =>
                register_file_switch <= "10";
                reg_load <= '1';

            when swap          => null; -- TODO
            when move          => null; -- TODO
            when copy          =>
                io_switch <= "11";
                register_file_switch <= "11";
                reg_load <= '1';
            when drop          =>
                reg_reset <= '1';
            when add           =>
                alu_switch <= "01000";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when sub           =>
                alu_switch <= "01001";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when inc           =>
                alu_switch <= "01010";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when dec           =>
                alu_switch <= "01011";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when inv           =>
                alu_switch <= "01100";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when compl         =>
                alu_switch <= "01101";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when l_shift       =>
                alu_switch <= "01110";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when r_shift       =>
                alu_switch <= "01111";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when bit_or        =>
                alu_switch <= "11001";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when bit_and       =>
                alu_switch <= "11000";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when bit_xor       =>
                alu_switch <= "11010";
                io_switch <= "10";
                register_file_switch <= "00";
                reg_load <= '1';
            when bit_set       => null; -- TODO
            when bit_clear     => null; -- TODO
            when in_operation  => null; -- TODO
            when out_operation => null; -- TODO
            when compare       =>
                alu_switch <= "10111";
                io_switch <= "10";
            when logical_and   =>
                alu_switch <= "11011";
                io_switch <= "10";
            when logical_or    =>
                alu_switch <= "11100";
                io_switch <= "10";
            when logical_xor   =>
                alu_switch <= "11101";
                io_switch <= "10";
            when jump_if       =>
                if (cmp = '1') then
                    pc_switch <= '0';
                    pc_ld <= '1';
                end if;
            when jump_else     =>
                if (cmp = '0') then
                    pc_switch <= '0';
                    pc_ld <= '1';
                end if;
            when jump          =>
                pc_switch <= '0';
                pc_ld <= '1';
            when call          =>
                pilha_ld <= '1';
                pc_switch <= '0';
                pc_ld <= '1';
            when ret           =>
                pc_switch <= '1';
                pc_ld <= '1';
		end case;
	end process;
end controller_arch;
