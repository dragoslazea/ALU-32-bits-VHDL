library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity division_circuit is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           clr_c_div : in STD_LOGIC;
           ld_d_div : in STD_LOGIC;
           sub_div : in STD_LOGIC;
           ld_i_div : in STD_LOGIC;
           c0 : in STD_LOGIC;
           right_shift_i_div : in STD_LOGIC;
           left_shift_c_div : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (63 downto 0); -- (C << 32) | R
           flags : out STD_LOGIC_VECTOR(6 downto 0);
           dn : out STD_LOGIC);
end division_circuit;

architecture Structural of division_circuit is

component register_n is
    Generic (N : integer := 32);
    Port ( data_in : in STD_LOGIC_VECTOR (n - 1 downto 0);       
           left : in STD_LOGIC;                                  
           right : in STD_LOGIC;                                 
           load : in STD_LOGIC;                                  
           clr : in STD_LOGIC;                                   
           serial_in : in STD_LOGIC;                             
           clk : in STD_LOGIC;                                   
           data_out : out STD_LOGIC_VECTOR (n - 1 downto 0));    
end component;

component adder64 is
    Port ( x1 : in STD_LOGIC_VECTOR (63 downto 0);
           x2 : in STD_LOGIC_VECTOR (63 downto 0);
           sub : in STD_LOGIC;
           cout : out STD_LOGIC;
           y : out STD_LOGIC_VECTOR (63 downto 0));
end component;

component mux_2_to_1_n is
    Generic (n : integer := 32);
    Port ( x1 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x2 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           sel : in STD_LOGIC;       
           y : out STD_LOGIC_VECTOR (n - 1 downto 0));
end component; 

signal dividend : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal sum_out : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal divisor : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal mux_out : STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal ext_x1, ext_x2 : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal c, r : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal cout : STD_LOGIC := '0';
signal carry_flag, aux_carry_flag, overflow_flag, zero_flag, parity_flag, sign_flag, divide_by_zero_flag : STD_LOGIC := '0';

begin

    ext_x1 <= x"00000000" & x1;
    ext_x2 <= x2 & x"00000000";
    
    mux: mux_2_to_1_n generic map (n => 64) port map (x1 => sum_out, x2 => ext_x1, sel => ld_i_div, y => mux_out);

    i_register: register_n generic map (N => 64) port map (data_in => ext_x2, left => '0', right => right_shift_i_div, load => ld_i_div, clr => clr, serial_in => '0', clk => clk, data_out => divisor);

    d_register: register_n generic map (N => 64) port map (data_in => mux_out, left => '0', right => '0', load => ld_d_div, clr => clr, serial_in => '0', clk => clk, data_out => dividend);
    
    c_register: register_n generic map (N => 32) port map (data_in => x"00000000", left => left_shift_c_div, right => '0', load => '0', clr => clr_c_div, serial_in => c0, clk => clk, data_out => c);
    
    adder: adder64 port map (x1 => dividend, x2 => divisor, sub => sub_div, cout => cout, y => sum_out);
    
    dn <= dividend(63);
    
    r <= dividend(31 downto 0);
    
    y <= c & r;
    
    carry_flag <= '0';
    aux_carry_flag <= '0';
    parity_flag <= c(0);
    sign_flag <= c(31);
    overflow_flag <= '0';
    
    divide_by_zero_proc: process (x2)
    begin
        if x2 = x"00000000" then
            divide_by_zero_flag <= '1';
        else
            divide_by_zero_flag <= '0';
        end if;
    end process divide_by_zero_proc;
            
    zero_flag_proc: process (c)
    begin
        if c = x"00000000" then
            zero_flag <= '1';
        else
            zero_flag <= '0';
        end if;
    end process zero_flag_proc;
      
    flags <= sign_flag & overflow_flag & parity_flag & zero_flag & divide_by_zero_flag & aux_carry_flag & carry_flag;

end Structural;
