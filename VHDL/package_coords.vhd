library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


package package_coords is
    
    type coords is array (-255 to 256, -255 to 256) of std_logic;
    
end package package_coords;