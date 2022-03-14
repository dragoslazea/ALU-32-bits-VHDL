-- -- Circuit pentru rotirea logica spre dreapta

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rot_right_circuit is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           right : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (31 downto 0));
end rot_right_circuit;

architecture Structural of rot_right_circuit is

component mux_2_to_1 is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           sel : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component d_flip_flop is
    Port ( D : in STD_LOGIC;
           clk : in STD_LOGIC;
           Q : out STD_LOGIC);
end component;

signal mux_sig : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal q : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";

begin

    outerloop: for i in 0 to 31 generate
        
        innerloop1: if i = 31 generate
            mux: mux_2_to_1 port map (x1 => x(i), x2 => q(0), sel => right, y => mux_sig(i));
            dff: d_flip_flop port map (D => mux_sig(i), clk => clk, Q => q(i));
        end generate innerloop1;
        
        innerloop2: if i < 31 generate
            mux: mux_2_to_1 port map (x1 => x(i), x2 => q(i + 1), sel => right, y => mux_sig(i));
            dff: d_flip_flop port map (D => mux_sig(i), clk => clk, Q => q(i));
        end generate innerloop2;
        
    end generate outerloop;
    
    y <= q;

end Structural;
