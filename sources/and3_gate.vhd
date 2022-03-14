-- Poarta SI cu 3 intrari pe un bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and3_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           x3 : in STD_LOGIC;
           y : out STD_LOGIC);
end and3_gate;

architecture Flow of and3_gate is

component and_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

signal y1 : STD_LOGIC := '0';

begin
    and1: and_gate port map (x1 => x1, x2 => x2, y => y1);
    and2: and_gate port map (x1 => y1, x2 => x3, y => y);
end Flow;
