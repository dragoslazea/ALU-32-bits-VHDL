-- Poarta SAU-exclusiv pe 1 bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end xor_gate;

architecture Flow of xor_gate is

begin
    y <= x1 xor x2;
end Flow;
