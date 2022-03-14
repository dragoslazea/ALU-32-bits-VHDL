-- Sumator complet pe 1 bit

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_1bit is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           cin : in STD_LOGIC;
           sum : out STD_LOGIC;
           cout : out STD_LOGIC);
end full_adder_1bit;

architecture Structural of full_adder_1bit is

component and_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component or_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component xor_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

signal s1 : STD_LOGIC := '0';
signal s2 : STD_LOGIC := '0';
signal s3 : STD_LOGIC := '0';

begin

    xor1: xor_gate port map (x1, x2, s1);
    xor2: xor_gate port map (s1, cin, sum);
    and1: and_gate port map (s1, cin, s2);
    and2: and_gate port map (x1, x2, s3);
    or1: or_gate port map (s2, s3, cout);

end Structural;
