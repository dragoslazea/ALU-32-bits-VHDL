library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity complement_circuit is
    Generic (n : integer := 32);
    Port ( x : in STD_LOGIC_VECTOR (n - 1 downto 0);       
           y : out STD_LOGIC_VECTOR (n - 1 downto 0));
end complement_circuit;

architecture Behavioral of complement_circuit is

signal temp_x :  STD_LOGIC_VECTOR (n - 1 downto 0) := (others => '0');

begin

    process (x)
    begin
        for i in 0 to n - 1 loop
            temp_x(i) <= not x(i);
        end loop;
    end process;
    
    y <= temp_x + 1;
    
end Behavioral;
