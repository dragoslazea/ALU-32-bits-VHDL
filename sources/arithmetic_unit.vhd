-- Unitatea aritmetica (+, -, inc, dec, neg)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity arithmetic_unit is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           sub : in STD_LOGIC;
           neg : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR(6 downto 0));
end arithmetic_unit;

architecture Structural of arithmetic_unit is

component full_adder_1bit is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           cin : in STD_LOGIC;
           sum : out STD_LOGIC;
           cout : out STD_LOGIC);
end component;

component not_gate is
    Port ( x : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component mux_2_to_1 is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           sel : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component and3_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           x3 : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

component or_gate is
    Port ( x1 : in STD_LOGIC;
           x2 : in STD_LOGIC;
           y : out STD_LOGIC);
end component;

signal carry : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal inv2 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal mux2 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal inv1 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal mux1 : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal overflow_plus : STD_LOGIC := '0';
signal overflow_minus : STD_LOGIC := '0';
signal borrow : STD_LOGIC := '0';
signal ov_plus1 : STD_LOGIC := '0';
signal ov_plus2 : STD_LOGIC := '0';
signal ov_minus1 : STD_LOGIC := '0';
signal ov_minus2 : STD_LOGIC := '0';
signal result : STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
signal not_res31 : STD_LOGIC := '0';
signal carry_flag, aux_carry_flag, overflow_flag, ovf, zero_flag, parity_flag, sign_flag, divide_by_zero_flag : STD_LOGIC := '0';

begin

    outerloop: for i in 0 to 31 generate
        
        innerloop1: if i = 0 generate
            sum: full_adder_1bit port map (x1 => mux1(i), x2 => mux2(i), cin => sub, sum => result(i), cout => carry(i));
            not2: not_gate port map (x => x2(i), y => inv2(i));
            mux_sub: mux_2_to_1 port map (x1 => x2(i), x2 => inv2(i), sel => sub, y => mux2(i)); 
            not1: not_gate port map (x => x1(i), y => inv1(i));
            mux_neg: mux_2_to_1 port map (x1 => x1(i), x2 => inv1(i), sel => neg, y => mux1(i));
        end generate innerloop1;
        
        innerloop2: if i > 0 generate
            sum: full_adder_1bit port map (x1 => mux1(i), x2 => mux2(i), cin => carry(i - 1), sum => result(i), cout => carry(i));
            not2: not_gate port map (x => x2(i), y => inv2(i));
            mux_sub: mux_2_to_1 port map (x1 => x2(i), x2 => inv2(i), sel => sub, y => mux2(i)); 
            not1: not_gate port map (x => x1(i), y => inv1(i));
            mux_neg: mux_2_to_1 port map (x1 => x1(i), x2 => inv1(i), sel => neg, y => mux1(i));
        end generate innerloop2;
        
    end generate outerloop;
    
    borrow_flag_proc: process(x1, x2)
    begin
        if signed(x2) > signed(x1) then
            borrow <= '1';
        else
            borrow <= '0';
        end if;
    end process;
    
    carry_flag <= carry(31) when sub = '0' else borrow;
    aux_carry_flag <= carry(3);
    parity_flag <= result(0);
    sign_flag <= result(31);
    divide_by_zero_flag <= '0';
    
    zero_flag_proc: process (result)
    begin
        if result = x"00000000" then
            zero_flag <= '1';
        else
            zero_flag <= '0';
        end if;
    end process zero_flag_proc;
    
    overflow_plus <= (x1(31) and x2(31) and (not result(31))) or ((not x1(31)) and (not x2(31)) and result(31));
    overflow_minus <= (x1(31) and (not x2(31)) and (not result(31))) or ((not x1(31)) and x2(31) and result (31));
    ovf <= overflow_plus when sub = '0' else overflow_minus;
    overflow_flag <= '0' when neg = '1' else ovf;

    flags <= sign_flag & overflow_flag & parity_flag & zero_flag & divide_by_zero_flag & aux_carry_flag & carry_flag;
    y <= result;

end Structural;
