-- Poarta SAU pe 1 bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end or_gate;

architecture Flow of or_gate is

begin
    y <= x1 or x2;
end Flow;
