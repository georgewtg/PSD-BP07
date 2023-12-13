library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;


entity graph_plotter is
end entity graph_plotter;


architecture rtl of graph_plotter is
    type header_type is array (0 to 53) of character; -- file header

    type pixel_type is record -- split pixel type to rgb
        red : std_logic_vector (7 downto 0);
        green : std_logic_vector (7 downto 0);
        blue : std_logic_vector (7 downto 0);
    end record;

    type row_type is array (integer range <>) of pixel_type;
    type row_pointer is access row_type;
    type image_type is array (integer range <>) of row_pointer;
    type image_pointer is access image_type;
begin
    
    process
        type char_file is file of character;
        file out_file : char_file open write_mode is "graph.bmp";
        variable header : header_type := (others => character'val(0));
        variable image_width : integer;
        variable image_height : integer;
        variable row : row_pointer;
        variable image : image_pointer;
    begin
        image_width := 20;
        image_height := 20;
        image := new image_type (0 to image_height - 1);
        
        -- set pixel color to black or white
        for row_i in 0 to image_height - 1 loop
            row := new row_type(0 to image_width - 1);
            for col_i in 0 to image_width - 1 loop
                if (row_i + col_i) mod 2 = 0 then
                    row(col_i).blue := "11111111";
                else
                    row(col_i).blue := "00000000";
                end if;
                
                if (row_i + col_i) mod 2 = 0 then
                    row(col_i).red := "11111111";
                else
                    row(col_i).red := "00000000";
                end if;

                if (row_i + col_i) mod 2 = 0 then
                    row(col_i).green := "11111111";
                else
                    row(col_i).green := "00000000";
                end if;
            end loop;
            image(row_i) := row;
        end loop;
        
        -- set bmp header values
        header(0) := 'B';
        header(1) := 'M';
        header(10) := character'val(54);
        header(14) := character'val(40);
        header(18) := character'val(image_width);
        header(22) := character'val(image_height);
        header(26) := character'val(1);
        header(28) := character'val(24);
        header(38) := character'val(19);
        header(39) := character'val(11);
        header(42) := character'val(19);
        header(43) := character'val(11);
        for i in header_type'range loop
            write(out_file, header(i));
        end loop;
        
        -- write pixel colors
        for row_i in 0 to image_height - 1 loop
            row := image(row_i);
            for col_i in 0 to image_width - 1 loop
                write(out_file, character'val(to_integer(unsigned(row(col_i).blue)))); -- Write blue pixel
                write(out_file, character'val(to_integer(unsigned(row(col_i).green)))); -- Write green pixel
                write(out_file, character'val(to_integer(unsigned(row(col_i).red)))); -- Write red pixel
            end loop;
            deallocate(row);
        end loop;

        file_close(out_file);

        report "done";
        wait;
    end process;
    
end architecture rtl;