library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiply_circuit is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           clr_res_mul : in STD_LOGIC;
           ld_res_mul : in STD_LOGIC;
           ld_i_mul : in STD_LOGIC;
           ld_d_mul : in STD_LOGIC;
           right_shift_i_mul : in STD_LOGIC;
           left_shift_d_mul : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (63 downto 0);
           i0 : out STD_LOGIC;
           flags : out STD_LOGIC_VECTOR(6 downto 0));
end multiply_circuit;

architecture Structural of multiply_circuit is

component adder64 is
    Port ( x1 : in STD_LOGIC_VECTOR (63 downto 0);
           x2 : in STD_LOGIC_VECTOR (63 downto 0);
           sub : in STD_LOGIC;
           cout : out STD_LOGIC;
           y : out STD_LOGIC_VECTOR (63 downto 0));
end component;

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

signal res : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal ext_x1 : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal multiplicand : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal multiplier : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal sum : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal cout : STD_LOGIC := '0';
signal carry_flag, aux_carry_flag, overflow_flag, zero_flag, parity_flag, sign_flag, divide_by_zero_flag : STD_LOGIC := '0';

begin

    res_register: register_n generic map (N => 64) port map (data_in => sum, left => '0', right => '0', load => ld_res_mul, clr => clr_res_mul, serial_in => '0', clk => clk, data_out => res);
    
    ext_x1 <= x"00000000" & x1;
    
    d_register: register_n generic map (N => 64) port map (data_in => ext_x1, left => left_shift_d_mul, right => '0', load => ld_d_mul, clr => clr, serial_in => '0', clk => clk, data_out => multiplicand);
    
    i_register: register_n generic map (N => 32) port map (data_in => x2, left => '0', right => right_shift_i_mul, load => ld_i_mul, clr => clr, serial_in => '0', clk => clk, data_out => multiplier);
    
    adder: adder64 port map (x1 => res, x2 => multiplicand, sub => '0', cout => cout, y => sum);
    
    i0 <= multiplier(0);
    
    overflow_flag_proc: process (res)
    begin
        if res(63 downto 32) = x"00000000" then
            overflow_flag <= '0';
        else
            overflow_flag <= '1';
        end if;
    end process overflow_flag_proc;
    
    carry_flag <= '0';
    aux_carry_flag <= '0';
    parity_flag <= res(0);
    sign_flag <= x1(31) xor x2(31);
    divide_by_zero_flag <= '0';
            
    zero_flag_proc: process (res)
    begin
        if res = x"0000000000000000" then
            zero_flag <= '1';
        else
            zero_flag <= '0';
        end if;
    end process zero_flag_proc;
    
    y <= res;
    flags <= sign_flag & overflow_flag & parity_flag & zero_flag & divide_by_zero_flag & aux_carry_flag & carry_flag;

end Structural;
