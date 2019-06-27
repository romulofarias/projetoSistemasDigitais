library ieee;
use ieee.std_logic_1164.all;

entity board is
    port (
        clock                : in std_logic;
        reset                : in std_logic;

        io_in               : in std_logic_vector (7 downto 0);

        io_load_in           : in std_logic_vector (3 downto 0);

        io_out0              : out std_logic_vector (7 downto 0);
        io_out1              : out std_logic_vector (7 downto 0);
        io_out2              : out std_logic_vector (7 downto 0);
        io_out3              : out std_logic_vector (7 downto 0)
    );
end entity;

ARCHITECTURE board_arch OF board IS

    COMPONENT datapath
    port (
        clock                : in std_logic;
        reset                : in std_logic;
        pc_switch            : in std_logic;
        pc_incr              : in std_logic;
        pc_ld                : in std_logic;
        ir_load              : in std_logic;
        pilha_ld             : in std_logic;
        register_file_switch : in std_logic_vector (2 downto 0);
        alu_switch           : in std_logic_vector (4 downto 0);
        reg_load             : in std_logic_vector (7 downto 0);
        reg_reset            : in std_logic_vector (7 downto 0);
        D_wr                 : in std_logic;

        io_in0               : in std_logic_vector (7 downto 0);
        io_in1               : in std_logic_vector (7 downto 0);
        io_in2               : in std_logic_vector (7 downto 0);
        io_in3               : in std_logic_vector (7 downto 0);

        io_load_in           : in std_logic_vector (3 downto 0);
        io_load_out          : in std_logic_vector (3 downto 0);

        io_out0              : out std_logic_vector (7 downto 0);
        io_out1              : out std_logic_vector (7 downto 0);
        io_out2              : out std_logic_vector (7 downto 0);
        io_out3              : out std_logic_vector (7 downto 0);
        cmp                  : buffer std_logic;
        instruction          : out std_logic_vector (15 downto 0)
    );
    END COMPONENT datapath;

    COMPONENT controller
        PORT (
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

    END COMPONENT controller;

    SIGNAL pc_switch            : std_logic;
    SIGNAL pc_incr              : std_logic;
    SIGNAL pc_ld                : std_logic;
    SIGNAL ir_load              : std_logic;
    SIGNAL pilha_ld             : std_logic;
    SIGNAL register_file_switch : std_logic_vector (2 downto 0);
    SIGNAL alu_switch           : std_logic_vector (4 downto 0);
    SIGNAL reg_load             : std_logic_vector (7 downto 0);
    SIGNAL reg_reset            : std_logic_vector (7 downto 0);
    SIGNAL D_wr                 : std_logic;
    SIGNAL cmp                  : std_logic;
    SIGNAL instruction          : std_logic_vector (15 downto 0);
    SIGNAL io_load              : std_logic_vector (3 downto 0);

BEGIN
    board_datapath   : datapath    PORT MAP (clock, reset, pc_switch, pc_incr, pc_ld,
                                            ir_load, pilha_ld, register_file_switch,
                                            alu_switch, reg_load, reg_reset, D_wr,
                                            io_in, io_in, io_in, io_in, io_load_in, io_load,
                                            io_out0, io_out1, io_out2, io_out3, cmp, instruction
                                      );
    board_controller : controller  PORT MAP (clock, reset, instruction(15 downto 5),
                                             cmp, pc_switch, pc_incr, pc_ld, ir_load,
                                             pilha_ld, register_file_switch, alu_switch,
                                             reg_load, reg_reset, io_load, D_wr
                                      );
END board_arch;
