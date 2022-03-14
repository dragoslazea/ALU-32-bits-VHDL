-- Multiplexor 5:1 pentru selectarea rezultatului unitatii logice in functie de operatia efectuata

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_5_to_1_32bits is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           x3 : in STD_LOGIC_VECTOR (31 downto 0);
           x4 : in STD_LOGIC_VECTOR (31 downto 0);
           x5 : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end mux_5_to_1_32bits;

architecture Behavioral of mux_5_to_1_32bits is

begin
    y <= x1 when sel = "0101" else
         x2 when sel = "0110" else
         x3 when sel = "0111" else
         x4 when sel = "1000" else
         x5 when sel = "1001" else
         x"00000000";
end Behavioral;
