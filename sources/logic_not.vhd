-- Circuit pentru operatia NU-logic pe 32 de biti

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_not is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end logic_not;

architecture Structural of logic_not is

component not_gate is
    Port ( x : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

begin

    outerloop: for i in 0 to 31 generate
        not1: not_gate port map (x => x(i), y => y(i));
    end generate outerloop;

end Structural;
