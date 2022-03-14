-- Circuit pentru operatia SAU-logic pe 32 de biti

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_or is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end logic_or;

architecture Structural of logic_or is

component or_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

begin

    outerloop: for i in 0 to 31 generate
        or1: or_gate port map (x1 => x1(i), x2 => x2(i), y => y(i));
    end generate outerloop;

end Structural;
