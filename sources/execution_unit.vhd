library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity execution_unit is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           res_sel : in STD_LOGIC_VECTOR (1 downto 0);
           idop : in STD_LOGIC_VECTOR (3 downto 0);
           sub : in STD_LOGIC;
           neg : in STD_LOGIC;
           left : in STD_LOGIC;
           right : in STD_LOGIC;
           -- semnale de control pentru fsm_ctrl inmultitor
           clr_res_mul : in STD_LOGIC;
           ld_res_mul : in STD_LOGIC;
           ld_i_mul : in STD_LOGIC;
           ld_d_mul : in STD_LOGIC;
           right_shift_i_mul : in STD_LOGIC;
           left_shift_d_mul : in STD_LOGIC;
           -- semnale de control pentru fsm_ctrl impartitor
           clr_c_div : in STD_LOGIC;
           ld_d_div : in STD_LOGIC;
           sub_div : in STD_LOGIC;
           ld_i_div : in STD_LOGIC;
           c0 : in STD_LOGIC;
           right_shift_i_div : in STD_LOGIC;
           left_shift_c_div : in STD_LOGIC;
           dn : out STD_LOGIC;
           i0 : out STD_LOGIC;
           flags : out STD_LOGIC_VECTOR(6 downto 0);
           y : out STD_LOGIC_VECTOR (63 downto 0));
end execution_unit;

architecture Structural of execution_unit is

component arithmetic_unit is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           sub : in STD_LOGIC;
           neg : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component logic_unit is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           idop : in STD_LOGIC_VECTOR (3 downto 0);
           left : in STD_LOGIC;
           right : in STD_LOGIC;
           clk : in STD_LOGIC;
           y : out STD_LOGIC_VECTOR (31 downto 0);
           flags : out STD_LOGIC_VECTOR(6 downto 0));
end component;

component multiply_circuit is
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
end component;

component division_circuit is
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
end component;

component mux_4_to_1_n is
    Generic (n : integer := 32);
    Port ( x1 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x2 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x3 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x4 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           y : out STD_LOGIC_VECTOR (n - 1 downto 0));
end component;

component mux_2_to_1_n is
    Generic (n : integer := 32);
    Port ( x1 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x2 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           sel : in STD_LOGIC;       
           y : out STD_LOGIC_VECTOR (n - 1 downto 0));
end component;

component complement_circuit is
    Generic (n : integer := 32);
    Port ( x : in STD_LOGIC_VECTOR (n - 1 downto 0);       
           y : out STD_LOGIC_VECTOR (n - 1 downto 0));
end component;

component sign_extend is
    Generic ( initial_size : integer := 32;
              extended_size : integer := 64);
    Port ( data_in : in STD_LOGIC_VECTOR (initial_size - 1 downto 0);
           extended_data : out STD_LOGIC_VECTOR (extended_size - 1 downto 0));
end component;

component zero_extend is
    Port ( data_in : in STD_LOGIC_VECTOR (31 downto 0);
           extended_data : out STD_LOGIC_VECTOR (63 downto 0));
end component;

signal au_out32, lu_out32, div_out32, neg_div_out32, final_div_out32, pos_q32, neg_q32, final_q32, pos_r32, neg_r32, final_r32 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal au_out64, lu_out64, div_out64, final_div64, mul_out64, neg_mul_out64, final_mul64 : STD_LOGIC_VECTOR (63 downto 0) := (others => '0'); 
signal au_flags, lu_flags, mul_flags, div_flags : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
signal neg_x1, neg_x2, abs_x1, abs_x2 : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal product_quotient_sign, remainder_sign : STD_LOGIC := '0';

begin

    au : arithmetic_unit port map (x1 => x1, x2 => x2, sub => sub, neg => neg, y => au_out32, flags => au_flags);
    
    lu : logic_unit port map (x1 => x1, x2 => x2, idop => idop, left => left, right => right, clk => clk, y => lu_out32, flags => lu_flags);
    
    mult : multiply_circuit port map (clk => clk, clr => clr, x1 => abs_x1, x2 => abs_x2, clr_res_mul => clr_res_mul, ld_res_mul => ld_res_mul, ld_i_mul => ld_i_mul, ld_d_mul => ld_d_mul, right_shift_i_mul => right_shift_i_mul, left_shift_d_mul => left_shift_d_mul, y => mul_out64, i0 => i0, flags => mul_flags);

    division : division_circuit port map (clk => clk, clr => clr, x1 => abs_x1, x2 => abs_x2, clr_c_div => clr_c_div, ld_d_div => ld_d_div, sub_div => sub_div, ld_i_div => ld_i_div, c0 => c0, right_shift_i_div => right_shift_i_div, left_shift_c_div => left_shift_c_div, y => div_out64, flags => div_flags, dn => dn);

    ccx1 : complement_circuit generic map (n => 32) port map (x => x1, y => neg_x1);
    
    ccx2 : complement_circuit generic map (n => 32) port map (x => x2, y => neg_x2);
    
    mux_x1 : mux_2_to_1_n generic map (n => 32) port map (x1 => x1, x2 => neg_x1, sel => x1(31), y => abs_x1);
    
    mux_x2 : mux_2_to_1_n generic map (n => 32) port map (x1 => x2, x2 => neg_x2, sel => x2(31), y => abs_x2);
    
    product_quotient_sign <= x1(31) xor x2(31);
    
    ccprod : complement_circuit generic map (n => 64) port map (x => mul_out64, y => neg_mul_out64);
    
    mux_prod : mux_2_to_1_n generic map (n => 64) port map (x1 => mul_out64, x2 => neg_mul_out64, sel => product_quotient_sign, y => final_mul64);
    
    --ccquot : complement_circuit generic map (n => 32) port map (x => div_out32, y => neg_div_out32);
    
    ext_au : sign_extend generic map (initial_size => 32, extended_size => 64) port map (data_in => au_out32, extended_data => au_out64);
    
    --ext_au : zero_extend port map (data_in => au_out32, extended_data => au_out64);
    
    ext_lu : zero_extend port map (data_in => lu_out32, extended_data => lu_out64);
    
    pos_q32 <= div_out64(63 downto 32);
    
    ccq : complement_circuit generic map (n => 32) port map (x => div_out64(63 downto 32), y => neg_q32);
    
    mux_quot : mux_2_to_1_n generic map (n => 32) port map (x1 => pos_q32, x2 => neg_q32, sel => product_quotient_sign, y => final_q32);
    
    pos_r32 <= div_out64(31 downto 0);
    
    remainder_sign <= x1(31);
    
    ccr : complement_circuit generic map (n => 32) port map (x => div_out64(31 downto 0), y => neg_r32);
    
    mux_r : mux_2_to_1_n generic map (n => 32) port map (x1 => pos_r32, x2 => neg_r32, sel => remainder_sign, y => final_r32);
    
    final_div64 <= final_q32 & final_r32;
    
    mux_res : mux_4_to_1_n generic map (n => 64) port map (x1 => au_out64, x2 => lu_out64, x3 => final_mul64, x4 => final_div64, sel => res_sel, y => y);
    
    mux_flags : mux_4_to_1_n generic map (n => 7) port map (x1 => au_flags, x2 => lu_flags, x3 => mul_flags, x4 => div_flags, sel => res_sel, y => flags);

end Structural;
