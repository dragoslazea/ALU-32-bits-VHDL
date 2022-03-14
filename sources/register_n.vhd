library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity register_n is
    Generic (N : integer := 32);
    Port ( data_in : in STD_LOGIC_VECTOR (n - 1 downto 0);       -- intrari paralele
           left : in STD_LOGIC;                                  -- shift left enable
           right : in STD_LOGIC;                                 -- shift right enable
           load : in STD_LOGIC;                                  -- load enable
           clr : in STD_LOGIC;                                   -- reset
           serial_in : in STD_LOGIC;                             -- intrare seriala
           clk : in STD_LOGIC;                                   -- semnal de ceas
           data_out : out STD_LOGIC_VECTOR (n - 1 downto 0));    -- iesiri de date
end register_n;

architecture Behavioral of register_n is

signal temp : STD_LOGIC_VECTOR (n - 1 downto 0) := (others => '0');

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if clr = '1' then
                temp <= (others => '0');
            elsif load = '1' then
                temp <= data_in;
            elsif left = '1' then
                temp <= temp(n - 2 downto 0) & serial_in;
            elsif right = '1' then
                temp <= serial_in & temp(n - 1 downto 1);
            end if;
        end if;
    end process;

    data_out <= temp;

end Behavioral;
