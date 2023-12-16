library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.package_coords.all;

entity alu is
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
end entity alu;


architecture rtl of alu is
begin
    opcode_read: process (enable)
        variable result : coords := (others => (others => '1')); -- saved pixels
        variable offset : integer := 0; -- offset for drawing graph
        variable temp_operand, temp_operand_2 : integer; -- for some operand calculations
    begin
        if enable = '1' then
            case OPCODE is
                when "000" => -- linear graph, m = operand1, b = operand2, y = mx + b
                    --set offset
                    if operand1 mod 2 = 0 then
                        offset := 1;
                    end if;

                    if operand1 >= 0 then -- positive linear graph, m = operand1
                        -- set pixels on x = 0
                        for k in 0 to operand1/2 loop
                            if k + operand2 <= 256 then
                                result(0, k + operand2) := '0';
                            end if;
                        end loop;

                        for k in 0 to operand1/2 - offset loop
                            if -k + operand2 - 1 >= -255 then
                                result(-1, -k + operand2 - 1) := '0';
                            end if;
                        end loop;

                        -- set pixels
                        for i in -255 to -1 loop
                            for j in 0 downto -255 - operand2 loop
                                if j/i = operand1 then
                                    for k in 0 to operand1/2 loop
                                        if j + k + operand2 <= 256 then
                                            result(i, j + k + operand2) := '0';
                                        end if;
                                    end loop;
                                    for k in 0 to operand1/2 - offset loop
                                        if i - 1 >= -255 and j - k + operand2 - 1 >= -255 and j - k + operand2 - 1 <= 256 then
                                            result(i-1, j - k + operand2 - 1) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        for i in 1 to 256 loop
                            for j in 0 to 256 - operand2 loop
                                if j/i = operand1 then
                                    for k in 0 to operand1/2 loop
                                        if j + k + operand2 <= 256 then
                                            result(i, j + k + operand2) := '0';
                                        end if;
                                    end loop;
                                    for k in 0 to operand1/2 - offset loop
                                        if i - 1 >= -255 and j - k + operand2 - 1 >= -255 and j - k + operand2 - 1 <= 256 then
                                            result(i - 1, j - k + operand2 - 1) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;


                    else -- negative linear graph, m = operand
                        -- set pixels on x = 0
                        for k in 0 downto operand1/2 loop
                            if k + operand2 <= 256 then
                                result(0, k + operand2) := '0';
                            end if;
                        end loop;
                            
                        for k in 0 downto operand1/2 - offset loop
                            if -k + operand2 + 1 >= -255 then
                                result(-1, -k + operand2 + 1) := '0';
                            end if;
                        end loop;

                        -- set pixels
                        for i in -255 to -1 loop
                            for j in 0 to 256 - operand2 loop
                                if j/i = operand1 then
                                    for k in 0 downto operand1/2 loop
                                        if j + k + operand2 <= 256 then
                                            result(i, j + k + operand2) := '0';
                                        end if;
                                    end loop;
                                    for k in 0 downto operand1/2 + offset loop
                                        if i - 1 >= -255 and j - k + operand2 + 1 >= -255 and j - k + operand2 + 1 <= 256 then
                                            result(i-1, j - k + operand2 + 1) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        for i in 1 to 256 loop
                            for j in 0 downto -255 - operand2 loop
                                if j/i = operand1 then
                                    for k in 0 downto operand1/2 loop
                                        if j + k + operand2 <= 256 then
                                            result(i, j + k + operand2) := '0';
                                        end if;
                                    end loop;
                                    for k in 0 downto operand1/2 + offset loop
                                        if i - 1 >= -255 and j - k + operand2 + 1 >= -255 and j - k + operand2 + 1 <= 256 then
                                            result(i - 1, j - k + operand2 + 1) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;
                    end if;


                when "001" => -- linear graph, m = 1/operand1, b = operand2, y = mx + b
                    --set offset
                    if operand1 mod 2 = 0 then
                        offset := 1;
                    end if;

                    if operand1 >= 0 then -- positive linear graph, m = 1/operand
                        -- set pixels on x = 0
                        for k in 0 to operand1/2 - offset loop
                            if operand2 + 1 <= 256 and operand2 + 1 >= -255 then
                                result(k + 1, operand2 + 1) := '0';
                            end if;
                        end loop;

                        for k in 0 to operand1/2 loop
                            result(-k, operand2) := '0';
                        end loop;

                        -- set pixels
                        for j in -255 - operand2 to -1 loop
                            for i in 0 downto -255 loop
                                if i/j = operand1 then
                                    for k in 0 to operand1/2 - offset loop
                                        if i + k + 1 <= 256 and j + operand2 + 1 >= -255 and j + operand2 + 1 <= 256 then
                                            result(i + k + 1, j + operand2 + 1) := '0';
                                        end if;
                                    end loop;
                                    for k in 0 to operand1/2 loop
                                        if i - k >= -255 and j + operand2 >= -255 and j + operand2 <= 256 then
                                            result(i - k, j + operand2) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        for j in 1 to 256 - operand2 loop
                            for i in 0 to 256 loop
                                if i/j = operand1 then
                                    for k in 0 to operand1/2 - offset loop
                                        if i + k + 1 <= 256 and j + operand2 + 1 >= -255 and j + operand2 + 1 <= 256 then
                                            result(i + k + 1, j + operand2 + 1) := '0';
                                        end if;
                                    end loop;
                                    for k in 0 to operand1/2 loop
                                        if i - k >= -255 and j + operand2 >= -255 and j + operand2 <= 256 then
                                            result(i - k, j + operand2) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;


                    else -- negative linear graph, m = 1/operand1, b = operand2, y = mx + b
                        -- set pixels on x = 0
                        for k in 0 downto operand1/2 - offset loop
                            if operand2 + 1 <= 256 and operand2 + 1 >= -255 then
                                result(k - 1, operand2 + 1) := '0';
                            end if;
                        end loop;

                        for k in 0 downto operand1/2 loop
                            result(-k, operand2) := '0';
                        end loop;

                        -- set pixels
                        for j in -255 - operand2 to -1 loop
                            for i in 0 to 256 loop
                                if i/j = operand1 then
                                    for k in 0 downto operand1/2 - offset loop
                                        if i + k - 1 <= 256 and i + k - 1 >= -255 and j + operand2 + 1 >= -255 and j + operand2 + 1 <= 256 then
                                            result(i + k - 1, j + operand2 + 1) := '0';
                                        end if;
                                    end loop;
                                    for k in 0 downto operand1/2 loop
                                        if i - k <= 256 and j + operand2 >= -255 and j + operand2 <= 256 then
                                            result(i - k, j + operand2) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        for j in 1 to 256 - operand2 loop
                            for i in 0 downto -255 loop
                                if i/j = operand1 then
                                    for k in 0 downto operand1/2 - offset loop
                                        if i + k - 1 <= 256 and i + k - 1 >= -255 and j + operand2 + 1 >= -255 and j + operand2 + 1 <= 256 then
                                            result(i + k - 1, j + operand2 + 1) := '0';
                                        end if;
                                    end loop;
                                    for k in 0 downto operand1/2 loop
                                        if i - k <= 256 and j + operand2 >= -255 and j + operand2 <= 256 then
                                            result(i - k, j + operand2) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;
                    end if;


                when "010" => -- absolute graph, m = operand1, b = operand2 , y = |mx| + b
                    -- set m to always be positive
                    if operand1 < 0 then
                        temp_operand := -operand1;
                    else
                        temp_operand := operand1;
                    end if;

                    --set offset
                    if temp_operand mod 2 = 0 then
                        offset := 1;
                    end if;

                    -- set pixels on x = 0
                    for k in 0 to temp_operand/2 loop
                        if k + operand2 <= 256 and -k + operand2 >= -255 then
                            result(0, k + operand2) := '0';
                        end if;
                    end loop;

                    -- set pixels (mirrored)
                    for i in 1 to 256 loop
                        for j in 0 to 256 - operand2 loop
                            if j/i = temp_operand then
                                for k in 0 to temp_operand/2 loop
                                    if j + k + operand2 <= 256 then
                                        result(i, j + k + operand2) := '0';
                                        if -i >= -255 then
                                            result(-i, j + k + operand2) := '0';
                                        end if;
                                    end if;
                                end loop;
                                for k in 0 to temp_operand/2 - offset loop
                                    if i - 1 >= -255 and j - k + operand2 - 1 >= -255 and j - k + operand2 - 1 <= 256 then
                                        result(i - 1, j - k + operand2 - 1) := '0';
                                        if -(i - 1) >= -255 then
                                            result(-(i - 1), j - k + operand2 - 1) := '0';
                                        end if;
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;
                    end loop;

                
                when "011" => -- absolute graph, m = 1/operand1, b = operand2 , y = |mx| + b
                    -- set m to always be positive
                    if operand1 < 0 then
                        temp_operand := -operand1;
                    else
                        temp_operand := operand1;
                    end if;

                    -- set pixels on x = 0
                    for k in 0 to temp_operand/2 - offset loop
                        if operand2 + 1 <= 256 and operand2 + 1 >= -255 then
                            result(k + 1, operand2 + 1) := '0';
                            if -(k + 1) >= -255 then
                                result(-(k + 1), operand2 + 1) := '0';
                            end if;
                        end if;
                    end loop;

                    -- set pixels (mirrored)
                    for j in 1 to 256 - operand2 loop
                        for i in 0 to 256 loop
                            if i/j = temp_operand then
                                for k in 0 to temp_operand/2 - offset loop
                                    if i + k + 1 <= 256 and j + operand2 + 1 >= -255 and j + operand2 + 1 <= 256 then
                                        result(i + k + 1, j + operand2 + 1) := '0';
                                        if -(i + k + 1) >= -255 then
                                            result(-(i + k + 1), j + operand2 + 1) := '0';
                                        end if;
                                    end if;
                                end loop;
                                for k in 0 to temp_operand/2 loop
                                    if i - k >= -255 and j + operand2 >= -255 and j + operand2 <= 256 then
                                        result(i - k, j + operand2) := '0';
                                        if -(i - k) >= -255 then
                                            result(-(i - k), j + operand2) := '0';
                                        end if;
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;
                    end loop;


                when "100" => -- quadratic graph, a = operand1, b = operand2, c = operand3 , y = a(x-b)^2 + c
                    -- set pixels on x = 0
                    result(operand2, operand3) := '0';
                    temp_operand := operand3;
                    
                    if operand1 >= 0 then -- positive graph
                        -- set pixels (mirrored)
                        for i in 1 to 256 loop
                            for j in -255 to 256 loop
                                if j = operand1 * i * i + operand3 then
                                    for k in 0 to j - temp_operand - 1 loop
                                        if j - k <= 256 and i + operand2 <= 256 then
                                            temp_operand := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                        if j - k <= 256 and -i + operand2 >= -255 then
                                            temp_operand := j;
                                            result(-i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        -- set remaining pixels (mirrored)
                        for i in 1 to 256 loop
                            if temp_operand = operand1 * i * i + operand3 then
                                for k in 1 to 256 - temp_operand loop
                                    if i + operand2 + 1 <= 256 and temp_operand + k <= 256 then
                                        result(i + operand2 + 1, temp_operand + k) := '0';
                                    end if;
                                    if -i + operand2 - 1 >= -255 and temp_operand + k <= 256 then
                                        result(-i + operand2 - 1, temp_operand + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;


                    else -- negative graph
                        -- set pixels (mirrored)
                        for i in 1 to 256 loop
                            for j in -255 to 256 loop
                                if j = operand1 * i * i + operand3 then
                                    for k in 0 downto j - temp_operand + 1 loop
                                        if j - k >= -255 and i + operand2 <= 256 then
                                            temp_operand := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                        if j - k >= -255 and -i + operand2 >= -255 then
                                            temp_operand := j;
                                            result(-i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        -- set remaining pixels (mirrored)
                        for i in 1 to 256 loop
                            if temp_operand = operand1 * i * i + operand3 then
                                for k in -1 downto -255 - temp_operand loop
                                    if i + operand2 + 1 <= 256 and temp_operand + k >= -255 then
                                        result(i + operand2 + 1, temp_operand + k) := '0';
                                    end if;
                                    if -i + operand2 - 1 >= -255 and temp_operand + k >= -255 then
                                        result(-i + operand2 - 1, temp_operand + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;
                    end if;


                when "101" => -- quadratic graph, a = 1/operand1, b = operand2, c = operand3 , y = a(x-b)^2 + c
                    --set offset
                    if operand1 mod 2 = 0 then
                        offset := 1;
                    end if;

                    -- set pixels on x = 0
                    for k in 0 to operand1 / 2 - offset loop
                        result(operand2 + k, operand3) := '0';
                        result(operand2 - k, operand3) := '0';
                    end loop;
                    for k in 0 downto operand1 / 2 + offset loop
                        result(operand2 + k, operand3) := '0';
                        result(operand2 - k, operand3) := '0';
                    end loop;
                    temp_operand := operand3;
                    
                    if operand1 >= 0 then -- positive graph
                        -- set pixels (mirrored)
                        for i in 1 to 256 loop
                            for j in -255 to 256 loop
                                if j = i * i / operand1 + operand3 then
                                    for k in 0 to j - temp_operand - 1 loop
                                        if j - k <= 256 and i + operand2 <= 256 then
                                            temp_operand := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                        if j - k <= 256 and -i + operand2 >= -255 then
                                            temp_operand := j;
                                            result(-i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        -- set remaining pixels (mirrored)
                        for i in 1 to 256 loop
                            if temp_operand =  i * i / operand1 + operand3 then
                                for k in 1 to 256 - temp_operand loop
                                    if i + operand2 + 1 <= 256 and temp_operand + k <= 256 then
                                        result(i + operand2 + 1, temp_operand + k) := '0';
                                    end if;
                                    if -i + operand2 - 1 >= -255 and temp_operand + k <= 256 then
                                        result(-i + operand2 - 1, temp_operand + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;


                    else -- negative graph
                        -- set pixels (mirrored)
                        for i in 1 to 256 loop
                            for j in -255 to 256 loop
                                if j = i * i / operand1 + operand3 then
                                    for k in 0 downto j - temp_operand + 1 loop
                                        if j - k >= -255 and i + operand2 <= 256 then
                                            temp_operand := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                        if j - k >= -255 and -i + operand2 >= -255 then
                                            temp_operand := j;
                                            result(-i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        -- set remaining pixels (mirrored)
                        for i in 1 to 256 loop
                            if temp_operand = i * i / operand1 + operand3 then
                                for k in -1 downto -255 - temp_operand loop
                                    if i + operand2 + 1 <= 256 and temp_operand + k >= -255 then
                                        result(i + operand2 + 1, temp_operand + k) := '0';
                                    end if;
                                    if -i + operand2 - 1 >= -255 and temp_operand + k >= -255 then
                                        result(-i + operand2 - 1, temp_operand + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;
                    end if;


                when "110" => -- cubic graph, a = operand1, b = operand2, c = operand3 , y = a(x-b)^3 + c
                    -- set pixels on x = 0
                    result(operand2, operand3) := '0';
                    temp_operand := operand3;
                    temp_operand_2 := operand3;
                    
                    if operand1 >= 0 then -- positive graph
                        -- set pixels
                        for i in -1 downto -255 + operand2 loop
                            for j in -255 to operand3 - 1 loop
                                if j = operand1 * i * i * i + operand3 then
                                    for k in 0 downto j - temp_operand_2 + 1 loop
                                        if j - k >= -255 and i + operand2 >= -255 then
                                            temp_operand_2 := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        for i in 1 to 256 + operand2 loop
                            for j in operand3 + 1 to 256 loop
                                if j = operand1 * i * i * i + operand3 then
                                    for k in 0 to j - temp_operand - 1 loop
                                        if j - k <= 256 and i + operand2 <= 256 then
                                            temp_operand := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        -- set remaining pixels (mirrored)
                        for i in -1 downto -255 + operand2 loop
                            if temp_operand_2 = operand1 * i * i * i + operand3 then
                                for k in -1 downto -255 - temp_operand_2 loop
                                    if temp_operand_2 + k >= -255 and i + operand2 - 1 >= -255 then
                                        result(i + operand2 - 1, temp_operand_2 + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;

                        for i in 1 to 256 + operand2 loop
                            if temp_operand = operand1 * i * i * i + operand3 then
                                for k in 1 to 256 - temp_operand loop
                                    if temp_operand + k <= 256 and i + operand2 + 1 <= 256 then
                                        result(i + operand2 + 1, temp_operand + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;


                    else -- negative graph
                        -- set pixels
                        for i in -1 downto -255 + operand2 loop
                            for j in operand3 + 1 to 256 loop
                                if j = operand1 * i * i * i + operand3 then
                                    for k in 0 to j - temp_operand_2 - 1 loop
                                        if j - k >= -255 and i + operand2 >= -255 then
                                            temp_operand_2 := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        for i in 1 to 256 + operand2 loop
                            for j in -255 to operand3 - 1 loop
                                if j = operand1 * i * i * i + operand3 then
                                    for k in 0 downto j - temp_operand + 1 loop
                                        if j - k <= 256 and i + operand2 <= 256 then
                                            temp_operand := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        -- set remaining pixels (mirrored)
                        for i in -1 downto -255 + operand2 loop
                            if temp_operand_2 = operand1 * i * i * i + operand3 then
                                for k in 1 to 256 - temp_operand_2 loop
                                    if temp_operand_2 + k <= 256 and i + operand2 - 1 <= 256 then
                                        result(i + operand2 - 1, temp_operand_2 + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;

                        for i in 1 to 256 + operand2 loop
                            if temp_operand = operand1 * i * i * i + operand3 then
                                for k in -1 downto -255 - temp_operand loop
                                    if temp_operand + k >= -255 and i + operand2 + 1 >= -255 then
                                        result(i + operand2 + 1, temp_operand + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;
                    end if;


                when "111" => -- cubic graph, a = 1/operand1, b = operand2, c = operand3 , y = a(x-b)^3 + c
                    --set offset
                    if operand1 mod 2 = 0 then
                        offset := 1;
                    end if;

                    -- set pixels on x = 0
                    for k in 0 to operand1 / 3 - offset loop
                        result(operand2 + k, operand3) := '0';
                        result(operand2 - k, operand3) := '0';
                    end loop;
                    for k in 0 downto operand1 / 3 + offset loop
                        result(operand2 + k, operand3) := '0';
                        result(operand2 - k, operand3) := '0';
                    end loop;
                    temp_operand := operand3;
                    temp_operand_2 := operand3;
                    
                    if operand1 >= 0 then -- positive graph
                        -- set pixels
                        for i in -1 downto -255 + operand2 loop
                            for j in -255 to operand3 - 1 loop
                                if j = i * i * i / operand1 + operand3 then
                                    for k in 0 downto j - temp_operand_2 + 1 loop
                                        if j - k >= -255 and i + operand2 >= -255 then
                                            temp_operand_2 := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        for i in 1 to 256 + operand2 loop
                            for j in operand3 + 1 to 256 loop
                                if j = i * i * i / operand1 + operand3 then
                                    for k in 0 to j - temp_operand - 1 loop
                                        if j - k <= 256 and i + operand2 <= 256 then
                                            temp_operand := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        -- set remaining pixels (mirrored)
                        for i in -1 downto -255 + operand2 loop
                            if temp_operand_2 = i * i * i / operand1 + operand3 then
                                for k in -1 downto -255 - temp_operand_2 loop
                                    if temp_operand_2 + k >= -255 and i + operand2 - 1 >= -255 then
                                        result(i + operand2 - 1, temp_operand_2 + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;

                        for i in 1 to 256 + operand2 loop
                            if temp_operand = i * i * i / operand1 + operand3 then
                                for k in 1 to 256 - temp_operand loop
                                    if temp_operand + k <= 256 and i + operand2 + 1 <= 256 then
                                        result(i + operand2 + 1, temp_operand + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;


                    else -- negative graph
                        -- set pixels
                        for i in -1 downto -255 + operand2 loop
                            for j in operand3 + 1 to 256 loop
                                if j = i * i * i / operand1 + operand3 then
                                    for k in 0 to j - temp_operand_2 - 1 loop
                                        if j - k >= -255 and i + operand2 >= -255 then
                                            temp_operand_2 := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        for i in 1 to 256 + operand2 loop
                            for j in -255 to operand3 - 1 loop
                                if j = i * i * i / operand1 + operand3 then
                                    for k in 0 downto j - temp_operand + 1 loop
                                        if j - k <= 256 and i + operand2 <= 256 then
                                            temp_operand := j;
                                            result(i + operand2, j - k) := '0';
                                        end if;
                                    end loop;
                                    exit;
                                end if;
                            end loop;
                        end loop;

                        -- set remaining pixels (mirrored)
                        for i in -1 downto -255 + operand2 loop
                            if temp_operand_2 = i * i * i / operand1 + operand3 then
                                for k in 1 to 256 - temp_operand_2 loop
                                    if temp_operand_2 + k <= 256 and i + operand2 - 1 <= 256 then
                                        result(i + operand2 - 1, temp_operand_2 + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;

                        for i in 1 to 256 + operand2 loop
                            if temp_operand = i * i * i / operand1 + operand3 then
                                for k in -1 downto -255 - temp_operand loop
                                    if temp_operand + k >= -255 and i + operand2 + 1 >= -255 then
                                        result(i + operand2 + 1, temp_operand + k) := '0';
                                    end if;
                                end loop;
                                exit;
                            end if;
                        end loop;
                    end if;


                when others =>
            end case;
            PIXELS <= result;
            done <= '1';
        end if;
    end process opcode_read;
end architecture rtl;