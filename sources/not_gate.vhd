-- Poarta NU pe un bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity not_gate is
    Port ( x : in STD_LOGIC;
           y : out STD_LOGIC);
end not_gate;

architecture Flow of not_gate is

begin
    y <= not x;
end Flow;
