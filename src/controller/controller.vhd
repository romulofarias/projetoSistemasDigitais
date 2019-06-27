library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port (
        clk         : in std_logic;
        reset       : in std_logic;
        instruction : in std_logic_vector (10 downto 0);
        cmp         : buffer std_logic;

        pc_switch            : out std_logic;
        pc_incr              : out std_logic;
        pc_ld                : out std_logic;
        ir_load              : out std_logic;
        pilha_ld             : out std_logic;
        register_file_switch : out std_logic_vector (2 downto 0);
        alu_switch           : out std_logic_vector (4 downto 0);
        reg_load             : out std_logic_vector (7 downto 0);
        reg_reset            : out std_logic_vector (7 downto 0);
        io_load              : out std_logic_vector (3 downto 0);
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

function reg_load_vector(reg: std_logic_vector(2 downto 0)
                    ) return std_logic_vector is
    variable load : std_logic_vector(7 downto 0);
begin
    load := "00000000";
    case (reg) is
        when "000" =>
            load := (0 => '1', others => '0');
        when "001" =>
            load := (1 => '1', others => '0');
        when "010" =>
            load := (2 => '1', others => '0');
        when "011" =>
            load := (3 => '1', others => '0');
        when "100" =>
            load := (4 => '1', others => '0');
        when "101" =>
            load := (5 => '1', others => '0');
        when "110" =>
            load := (6 => '1', others => '0');
        when "111" =>
            load := (7 => '1', others => '0');
        when others => null;
    end case;
    return load;
end function;

function io_load_vector(reg: std_logic_vector(1 downto 0)
                    ) return std_logic_vector is
    variable load : std_logic_vector(3 downto 0);
begin
    load := "0000";
    case (reg) is
        when "00" =>
            load := (0 => '1', others => '0');
        when "01" =>
            load := (1 => '1', others => '0');
        when "10" =>
            load := (2 => '1', others => '0');
        when "11" =>
            load := (3 => '1', others => '0');
        when others => null;
    end case;
    return load;
end function;

alias opcode is instruction(10 downto 6);
alias reg1   is instruction(5 downto 3);
alias reg2   is instruction(2 downto 0);
alias io_reg is instruction(2 downto 1);

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
                null;
            when noop          =>
                null;
            when load          =>
                register_file_switch <= "001";
                reg_load <= reg_load_vector(reg1);
            when store         =>
                D_wr <= '1';
            when set           =>
                register_file_switch <= "010";
                reg_load <= reg_load_vector(reg1);
            when swap          =>
                alu_switch <= "11110";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when move          =>
                register_file_switch <= "011";
                reg_load <= reg_load_vector(reg1);
                reg_reset <= reg_load_vector(reg2);
            when copy          =>
                register_file_switch <= "011";
                reg_load <= reg_load_vector(reg1);
            when drop          =>
                reg_reset <= reg_load_vector(reg1);
            when add           =>
                alu_switch <= "01000";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when sub           =>
                alu_switch <= "01001";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when inc           =>
                alu_switch <= "01010";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when dec           =>
                alu_switch <= "01011";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when inv           =>
                alu_switch <= "01100";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when compl         =>
                alu_switch <= "01101";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when l_shift       =>
                alu_switch <= "01110";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when r_shift       =>
                alu_switch <= "01111";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when bit_or        =>
                alu_switch <= "11001";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when bit_and       =>
                alu_switch <= "11000";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when bit_xor       =>
                alu_switch <= "11010";
                register_file_switch <= "000";
                reg_load <= reg_load_vector(reg1);
            when bit_set       => null; -- TODO
            when bit_clear     => null; -- TODO
            when in_operation  =>
                reg_load <= reg_load_vector(reg1);
                register_file_switch <= "100";
            when out_operation => null;
                io_load <= io_load_vector(io_reg);
            when compare       =>
                alu_switch <= "10111";
            when logical_and   =>
                alu_switch <= "11011";
            when logical_or    =>
                alu_switch <= "11100";
            when logical_xor   =>
                alu_switch <= "11101";
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
