-- Bistabil de tip D

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flip_flop is
    Port ( D : in STD_LOGIC;
           clk : in STD_LOGIC;
           Q : out STD_LOGIC);
end d_flip_flop;

architecture Behavioral of d_flip_flop is

begin

    process (clk)
    begin
        if rising_edge(clk) then
            Q <= D;
        end if;
    end process;

end Behavioral;
