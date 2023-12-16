library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.package_coords.all;


entity controller is
    port (
        CLK : in std_logic := '0';
        ENABLE : in std_logic := '0';
        instruction : in std_logic_vector (2 downto 0);
        A : in integer := 1; -- constant A
        B : in integer := 0; -- constant B
        C : in integer := 0  -- constant C
    );
end entity controller;


architecture rtl of controller is
    component alu is
        port (
            PRG_CNT : in integer; -- Program counter
            enable : in std_logic;
            OPCODE : in std_logic_vector (2 downto 0); -- Opcode of instruction 
            OPERAND1 : in integer; -- constant A
            OPERAND2 : in integer; -- constant B
            OPERAND3 : in integer; -- constant C
            PIXELS : out coords;
            done : out std_logic
        );
    end component alu;

    component graph_plotter is
        port (
            enable : in std_logic;
            pixel : in coords;
            done : out std_logic
        );
    end component graph_plotter;

    signal opcode : std_logic_vector (2 downto 0);
    signal en_alu, en_graph : std_logic := '0';
    signal data : coords;
    signal operand1 : integer;
    signal operand2 : integer;
    signal operand3 : integer;
    signal ex_done, write_done : std_logic;

    type state_type is (IDLE, FETCH, DECODE, EXECUTE, WRITE, COMPLETE);
    signal state : state_type := IDLE;
    signal PRG_CNT : integer := 0;
begin
    alu_0 : alu port map (PRG_CNT, en_alu, opcode, operand1, operand2, operand3, data, ex_done);
    graph_plotter_0 : graph_plotter port map (en_graph, data, write_done);

    data_flow: process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when IDLE =>
                    if enable = '1' then
                        state <= FETCH;
                    end if;
                when FETCH =>
                    PRG_CNT <= PRG_CNT + 1;
                    if PRG_CNT = 1 then
                        state <= DECODE;
                    end if;
                when DECODE =>
                    opcode <= instruction;
                    PRG_CNT <= PRG_CNT + 1;
                    if PRG_CNT = 2 then
                        state <= EXECUTE;
                    end if;
                when EXECUTE =>
                    operand1 <= A;
                    operand2 <= B;
                    operand3 <= C;
                    en_alu <= '1';

                    if ex_done = '1' then
                        PRG_CNT <= PRG_CNT + 1;
                    end if;

                    if PRG_CNT = 3 then
                        state <= WRITE;
                    end if;
                when WRITE =>
                    en_graph <= '1';

                    if write_done = '1' then
                        PRG_CNT <= PRG_CNT + 1;
                    end if;
                    
                    if PRG_CNT = 4 then
                        state <= COMPLETE;
                    end if;
                when COMPLETE =>
                    report "complete";
            end case;
        end if;
    end process data_flow;
end architecture rtl;