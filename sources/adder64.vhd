-- Sumator scazator pe 64 de biti

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder64 is
    Port ( x1 : in STD_LOGIC_VECTOR (63 downto 0);
           x2 : in STD_LOGIC_VECTOR (63 downto 0);
           sub : in STD_LOGIC;
           cout : out STD_LOGIC;
           y : out STD_LOGIC_VECTOR (63 downto 0));
end adder64;

architecture Structural of adder64 is

component full_adder_1bit is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           cin : in STD_LOGIC;
           sum : out STD_LOGIC;
           cout : out STD_LOGIC);
end component;

component mux_2_to_1 is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           sel : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component not_gate is
    Port ( x : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

signal carry : STD_LOGIC_VECTOR (63 downto 0) := x"0000000000000000";
signal inv : STD_LOGIC_VECTOR (63 downto 0) := x"0000000000000000";
signal mux : STD_LOGIC_VECTOR (63 downto 0) := x"0000000000000000";
signal result : STD_LOGIC_VECTOR (63 downto 0) := x"0000000000000000";

begin
    
    outerloop: for i in 0 to 63 generate
        
        innerloop1: if i = 0 generate
            sum: full_adder_1bit port map (x1 => x1(i), x2 => mux(i), cin => sub, sum => result(i), cout => carry(i));
            not2: not_gate port map (x => x2(i), y => inv(i));
            mux_sub: mux_2_to_1 port map (x1 => x2(i), x2 => inv(i), sel => sub, y => mux(i)); 
        end generate innerloop1;
        
        innerloop2: if i > 0 generate
            sum: full_adder_1bit port map (x1 => x1(i), x2 => mux(i), cin => carry(i - 1), sum => result(i), cout => carry(i));
            not2: not_gate port map (x => x2(i), y => inv(i));
            mux_sub: mux_2_to_1 port map (x1 => x2(i), x2 => inv(i), sel => sub, y => mux(i));
        end generate innerloop2;
        
    end generate outerloop;
    
    cout <= carry(63);
    y <= result;

end Structural;
