library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zero_detector is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC);
end zero_detector;

architecture Behavioral of zero_detector is

begin

    zero <= '1' when x = x"00000000" else '0';
    
end Behavioral;
