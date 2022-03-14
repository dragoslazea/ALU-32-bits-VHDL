library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4_to_1_n is
    Generic (n : integer := 32);
    Port ( x1 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x2 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x3 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x4 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           y : out STD_LOGIC_VECTOR (n - 1 downto 0));
end mux_4_to_1_n;

architecture Behavioral of mux_4_to_1_n is

begin

    y <= x1 when sel = "00" else
         x2 when sel = "01" else
         x3 when sel = "10" else
         x4 when sel = "11" else
         (others => '0');

end Behavioral;
