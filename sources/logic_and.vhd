-- Circuit pentru operatia SI-logic pe 32 de biti

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_and is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end logic_and;

architecture Structural of logic_and is

component and_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

begin

    outerloop: for i in 0 to 31 generate
        and1: and_gate port map (x1 => x1(i), x2 => x2(i), y => y(i));
    end generate outerloop;

end Structural;
