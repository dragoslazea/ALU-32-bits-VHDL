library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity zero_extend is
    Port ( data_in : in STD_LOGIC_VECTOR (31 downto 0);
           extended_data : out STD_LOGIC_VECTOR (63 downto 0));
end zero_extend;

architecture Behavioral of zero_extend is

begin

    extended_data <= x"00000000" & data_in;

end Behavioral;
