library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench is
end entity testbench;

architecture rtl of testbench is
    component controller is
        port (
            CLK : in std_logic;
            ENABLE : in std_logic;
            instruction : in std_logic_vector (2 downto 0);
            A : in integer; -- constant A
            B : in integer; -- constant B
            C : in integer  -- constant C
        );
    end component controller;

    signal a,b,c : integer := 0;
    signal ins : std_logic_vector (2 downto 0) := (others => '0');
    signal enable : std_logic := '0';
    signal clk : std_logic := '0';
begin
    DUT : controller
        port map (CLK => clk , ENABLE => enable, instruction => ins, A => a, B => b, C => c);

        CLK_PROCESS: process
        begin
            while now < 100 ps loop
                clk <= not clk;
                wait for 5 ps;
            end loop;
            wait;
        end process;
    
        STIMULUS_PROCESS: process
        begin
            wait for 15 ps; -- Wait for initial conditions
    
            -- Apply stimulus here, for example:
            enable <= '1';
            ins <= "001"; -- Replace with your desired instruction
            A <= 5; -- Replace with your desired value for A
            B <= 10; -- Replace with your desired value for B
            C <= 0;  -- Replace with your desired value for C
    
            wait for 80 ps;
    
            enable <= '0'; -- Deassert ENABLE to stop the simulation
            wait;
        end process;
end architecture rtl;