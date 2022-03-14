library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2_to_1_n is
    Generic (n : integer := 32);
    Port ( x1 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x2 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           sel : in STD_LOGIC;       
           y : out STD_LOGIC_VECTOR (n - 1 downto 0));
end mux_2_to_1_n;

architecture Behavioral of mux_2_to_1_n is

begin

    y <= x1 when sel = '0' else x2;

end Behavioral;
