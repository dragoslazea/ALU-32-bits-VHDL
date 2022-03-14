library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port ( next_instr_en : in STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           stop : out STD_LOGIC;
           result_high : out STD_LOGIC_VECTOR (31 downto 0);
           result_low : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR (6 downto 0));
end top_level;

architecture Structural of top_level is

component counter32 is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           en : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component rom256x68 is
    Port ( address : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (67 downto 0));
end component;

component alu32 is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           idop : in STD_LOGIC_VECTOR (3 downto 0);
           start : in STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           stop : out STD_LOGIC;
           flags_word : out STD_LOGIC_VECTOR (6 downto 0);
           y : out STD_LOGIC_VECTOR (63 downto 0));
end component;

signal addr, x1, x2 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal idop : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal instruction : STD_LOGIC_VECTOR (67 downto 0) := (others => '0');
signal result : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');

begin
    
    program_counter : counter32 port map (clk => clk, clr => reset, en => next_instr_en, q => addr);

    instruction_memory : rom256x68 port map (address => addr, data_out => instruction);
    
    x1 <= instruction (67 downto 36);
    x2 <= instruction (35 downto 4);
    idop <= instruction (3 downto 0);
    
    alu : alu32 port map (x1 => x1, x2 => x2, idop => idop, start => start, clk => clk, clr => clr, stop => stop, flags_word => flags, y => result);
    
    result_high <= result (63 downto 32);
    result_low <= result (31 downto 0);

end Structural;
