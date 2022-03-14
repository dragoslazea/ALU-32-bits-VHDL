library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity counter32 is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           en : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (31 downto 0));
end counter32;

architecture Behavioral of counter32 is

signal temp : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";

begin

    process (clk, clr)
    begin
        if clr = '1' then 
            temp <= x"00000000";
        else
            if rising_edge(clk) then
                if en = '1' then
                    temp <= temp + 1;
                end if;
            end if;
        end if;
    end process;
    
    q <= temp;

end Behavioral;
