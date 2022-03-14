library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench_alu is
end testbench_alu;

architecture Behavioral of testbench_alu is

component top_level is
    Port ( next_instr_en : in STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           stop : out STD_LOGIC;
           result_high : out STD_LOGIC_VECTOR (31 downto 0);
           result_low : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR (6 downto 0));
end component;

signal clk : STD_LOGIC := '0';
signal next_instr_en : STD_LOGIC := '0';
signal clr : STD_LOGIC := '0';
signal reset : STD_LOGIC := '0';

signal start : STD_LOGIC := '0';
signal stop : STD_LOGIC := '0';
signal result_high : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal result_low : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal flags : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');

begin

    clk <= not clk after 1ns;
    clr <= '1', '0' after 5 ns;
    
    dut : top_level
            port map (
                next_instr_en => next_instr_en,
                clk => clk,
                clr => clr, 
                reset => reset,
                start => start,
                stop => stop,
                result_high => result_high,
                result_low => result_low,
                flags => flags
            );
    
    stimulus : process
    begin
        wait until (clr = '0');
        
        start <= '1';
        wait for 2 ns;
        start <= '0';
        wait for 3 us;
        
        for i in 0 to 40 loop
            next_instr_en <= '1';
            wait for 2 ns;
            next_instr_en <= '0';
            start <= '1';
            wait for 2 ns;
            start <= '0';
            wait for 3 us;
        end loop;
        
        wait;
    end process stimulus;

end Behavioral;
