library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use work.package_coords.all;


entity graph_plotter is
    port (
        enable : in std_logic;
        pixel : in coords;
        done : out std_logic
    );
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

    procedure WriteHeader(variable image_width : in integer;
                        variable image_height : in integer;
                        variable header : out header_type) is
    begin
        -- set bmp header values
        header  := (others => character'val(0));
        header(0) := 'B'; -- signature for bmp files
        header(1) := 'M'; -- signature for bmp files
        header(10) := character'val(54);    -- pixel array offset (bytes)
        header(14) := character'val(40);    -- header size (bytes)
        header(18) := character'val(image_width - ((image_height/256-1) * 256) - 1);    -- image width (pixels)
        header(19) := character'val(image_width / 256 - 1);                             -- image width (pixels)
        header(22) := character'val(image_height - ((image_height/256-1) * 256) - 1);   -- image height (pixels)
        header(23) := character'val(image_height / 256 - 1);                            -- image height (pixels)
        header(26) := character'val(1);     -- color planes
        header(28) := character'val(24);    -- bits per pixel
        header(38) := character'val(19);    -- x pixels per meter
        header(39) := character'val(11);    -- x pixels per meter
        header(42) := character'val(19);    -- y pixels per meter
        header(43) := character'val(11);    -- y pixels per meter
    end procedure;
begin
    process (enable)
        type char_file is file of character;
        file out_file : char_file open write_mode is "graph.bmp";
        variable header : header_type := (others => character'val(0));
        variable image_width : integer := 512;
        variable image_height : integer := 512;
        variable row : row_pointer;
        variable image : image_pointer;
    begin
        image := new image_type (-255 to 256);
        
        if enable = '1' then
            -- set pixel color to black or white
            for row_i in -255 to 256 loop
                row := new row_type(-255 to 256);
                for col_i in -255 to 256 loop
                    -- set blue pixel
                    if (row_i = 0 or col_i = 0) and pixel(col_i, row_i) = '1' then -- set 0 lines to red
                        row(col_i).blue := "00000000";
                    elsif pixel(col_i, row_i) = '1' then -- set background to white
                        row(col_i).blue := "11111111";
                    else -- set graph lines to black
                        row(col_i).blue := "00000000";
                    end if;
                    
                    -- set red pixel
                    if (row_i = 0 or col_i = 0) and pixel(col_i, row_i) = '1' then -- set 0 lines to red
                        row(col_i).red := "11111111";
                    elsif pixel(col_i, row_i) = '1' then -- set background to white
                        row(col_i).red := "11111111";
                    else -- set graph lines to black
                        row(col_i).red := "00000000";
                    end if;

                    -- set green pixel
                    if (row_i = 0 or col_i = 0) and pixel(col_i, row_i) = '1' then -- set 0 lines to red
                        row(col_i).green := "00000000";
                    elsif pixel(col_i, row_i) = '1' then -- set background to white
                        row(col_i).green := "11111111";
                    else -- set graph lines to black
                        row(col_i).green := "00000000";
                    end if;
                end loop;
                image(row_i) := row;
            end loop;
            
            
            WriteHeader(image_width, image_height, header);
            for i in header_type'range loop
                write(out_file, header(i));
            end loop;
            
            -- write pixel colors
            for row_i in -255 to 256 loop
                row := image(row_i);
                for col_i in -255 to 256 loop
                    write(out_file, character'val(to_integer(unsigned(row(col_i).blue)))); -- Write blue pixel
                    write(out_file, character'val(to_integer(unsigned(row(col_i).green)))); -- Write green pixel
                    write(out_file, character'val(to_integer(unsigned(row(col_i).red)))); -- Write red pixel
                end loop;
                deallocate(row);
            end loop;

            file_close(out_file);

            done <= '1';
            report "done";
        end if;
    end process;
    
end architecture rtl;