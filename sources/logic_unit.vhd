-- Unitatea logica (and, or, not, left rotate, right rotate)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logic_unit is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           idop : in STD_LOGIC_VECTOR (3 downto 0);
           left : in STD_LOGIC;
           right : in STD_LOGIC;
           clk : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR(6 downto 0));
end logic_unit;

architecture Structural of logic_unit is

component logic_and is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component logic_or is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component logic_not is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component rot_left_circuit is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           left : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component rot_right_circuit is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           right : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux_5_to_1_32bits is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           x3 : in STD_LOGIC_VECTOR (31 downto 0);
           x4 : in STD_LOGIC_VECTOR (31 downto 0);
           x5 : in STD_LOGIC_VECTOR (31 downto 0);
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           y : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal y_and : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal y_or : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal y_not : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal y_left : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal y_right : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal result : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal carry_flag, aux_carry_flag, overflow_flag, zero_flag, parity_flag, sign_flag, divide_by_zero_flag : STD_LOGIC := '0';

begin
    and_circuit: logic_and port map (x1 => x1, x2 => x2, y => y_and);
    or_circuit: logic_or port map (x1 => x1, x2 => x2, y => y_or);
    not_circuit: logic_not port map (x => x1, y => y_not);
    left_circuit: rot_left_circuit port map (x => x1, clk => clk, left => left, y => y_left);
    right_circuit: rot_right_circuit port map (x => x1, clk => clk, right => right, y => y_right);
    mux: mux_5_to_1_32bits port map (x1 => y_and, x2 => y_or, x3 => y_not, x4 => y_left, x5 => y_right, sel => idop, y => result);
    
    carry_flag <= '0';
    aux_carry_flag <= '0';
    parity_flag <= result(0);
    sign_flag <= result(31);
    divide_by_zero_flag <= '0';
    overflow_flag <= '0';
        
    zero_flag_proc: process (result)
    begin
        if result = x"00000000" then
            zero_flag <= '1';
        else
            zero_flag <= '0';
        end if;
    end process zero_flag_proc;
    
    y <= result;
    flags <= sign_flag & overflow_flag & parity_flag & zero_flag & divide_by_zero_flag & aux_carry_flag & carry_flag;
    
end Structural;
