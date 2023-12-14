library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.package_coords.all;

entity alu is
    port (
        PRG_CNT : in integer; -- Program counter
        enable : in std_logic;
        OPCODE : in std_logic_vector (2 downto 0); -- Opcode of instruction 
        OPERAND1 : in integer; -- Slope
        PIXELS : out coords;
        done : out std_logic
    );
end entity alu;


architecture rtl of alu is
    type coords is array (0 to 255, 0 to 255) of std_logic;
begin
    opcode_read: process (enable)
        variable result : work.package_coords.coords := (others => (others => '1'));
    begin
        if enable = '1' then
            case OPCODE is
                when "000" => -- positive linear graph, m = operand
                    --for k in 0 to operand1 - 1 loop
                        --result(0,k+0) := '0';
                    --end loop;
                    for i in 1 to 255 loop
                        for j in 1 to 255 loop
                            if j/i = operand1 then
                                for k in 0 to operand1 - 1 loop
                                    if k + j <= 255 then
                                        result(i,k+j) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;
                    end loop;
                when others =>
            end case;
            PIXELS <= result;
            done <= '1';
        end if;
    end process opcode_read;
end architecture rtl;