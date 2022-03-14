-- Poarta SI pe un bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end and_gate;

architecture Flow of and_gate is

begin
    y <= x1 and x2;
end Flow;
