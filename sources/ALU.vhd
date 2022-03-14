library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu32 is
    Port ( x1 : in STD_LOGIC_VECTOR (31 downto 0);
           x2 : in STD_LOGIC_VECTOR (31 downto 0);
           idop : in STD_LOGIC_VECTOR (3 downto 0);
           start : in STD_LOGIC;
           clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           stop : out STD_LOGIC;
           flags_word : out STD_LOGIC_VECTOR (6 downto 0);
           y : out STD_LOGIC_VECTOR (63 downto 0));
end alu32;

architecture Structural of alu32 is

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

component control_unit is
    Port ( idop : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           start : in STD_LOGIC;
           clr : in STD_LOGIC;
           clr_div : in STD_LOGIC;
           clr_mul : in STD_LOGIC;
           i0 : in STD_LOGIC; -- pentru inmultire (inmultitor(0))
           dn : in STD_LOGIC; -- pentru impartite (deimpartit(31))
           zero : in STD_LOGIC;
           -- semnale de control pentru operatii logoce si aritmetice
           sub : out STD_LOGIC;
           neg : out STD_LOGIC;
           left : out STD_LOGIC;
           right : out STD_LOGIC;
           load_acc : out STD_LOGIC;
           load_res_or_op : out STD_LOGIC;
           load_rop2 : out STD_LOGIC;
           load_op2_or_1 : out STD_LOGIC;
           load_flags : out STD_LOGIC;
           stop : out STD_LOGIC;
           -- semnale de control pentru fsm_ctrl inmultitor
           clr_res_mul : out STD_LOGIC;
           ld_res_mul : out STD_LOGIC;
           ld_i_mul : out STD_LOGIC;
           ld_d_mul : out STD_LOGIC;
           right_shift_i_mul : out STD_LOGIC;
           left_shift_d_mul : out STD_LOGIC;
           -- semnale de control pentru fsm_ctrl impartitor
           clr_c_div : out STD_LOGIC;
           ld_d_div : out STD_LOGIC;
           sub_div : out STD_LOGIC;
           ld_i_div : out STD_LOGIC;
           c0 : out STD_LOGIC;
           right_shift_i_div : out STD_LOGIC;
           left_shift_c_div : out STD_LOGIC;
           res_sel : out STD_LOGIC_VECTOR (1 downto 0));
end component;

component execution_unit is
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
end component;

component mux_2_to_1_n is
    Generic (n : integer := 32);
    Port ( x1 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           x2 : in STD_LOGIC_VECTOR (n - 1 downto 0);
           sel : in STD_LOGIC;       
           y : out STD_LOGIC_VECTOR (n - 1 downto 0));
end component;

component sign_extend is
    Generic ( initial_size : integer := 32;
              extended_size : integer := 64);
    Port ( data_in : in STD_LOGIC_VECTOR (initial_size - 1 downto 0);
           extended_data : out STD_LOGIC_VECTOR (extended_size - 1 downto 0));
end component;

component zero_detector is
    Port ( x : in STD_LOGIC_VECTOR (31 downto 0);
           zero : out STD_LOGIC);
end component;

-- control signals arithmetic and logic operations
signal sub, neg, left, right, load_acc, load_res_or_op, load_rop2, load_op2_or_1, load_flags : STD_LOGIC := '0';

-- control signals multiplication
signal clr_res_mul, ld_res_mul, ld_i_mul, ld_d_mul, right_shift_i_mul, left_shift_d_mul, i0 : STD_LOGIC := '0';

-- control signals division
signal clr_c_div, ld_d_div, sub_div, ld_i_div, c0, right_shift_i_div, left_shift_c_div, dn, zero : STD_LOGIC := '0';

-- control signal for result selection
signal res_sel : STD_LOGIC_VECTOR (1 downto 0) := "00";

-- flags
signal flags : STD_LOGIC_VECTOR (6 downto 0) := "0000000";

-- result
signal eu_res : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');

-- extended first operand
signal ext_x1 : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');

-- accumulator register in/out
signal acc_in, acc_out : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');

-- register for second operand in/out
signal reg_op2_in, reg_op2_out : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');

begin

    cu: control_unit port map
        (
            idop => idop,
            clk => clk,
            start => start,
            clr => clr,
            clr_div => '0',
            clr_mul => '0',
            i0 => i0,
            dn => dn,
            zero => zero,
            sub => sub,
            neg => neg,
            left => left,
            right => right,
            load_acc => load_acc,
            load_res_or_op => load_res_or_op,
            load_rop2 => load_rop2,
            load_op2_or_1 => load_op2_or_1,
            load_flags => load_flags,
            stop => stop,
            clr_res_mul => clr_res_mul,
            ld_res_mul => ld_res_mul,
            ld_i_mul => ld_i_mul,
            ld_d_mul => ld_d_mul, 
            right_shift_i_mul => right_shift_i_mul,
            left_shift_d_mul => left_shift_d_mul,
            clr_c_div => clr_c_div,
            ld_d_div => ld_d_div,
            sub_div => sub_div,
            ld_i_div => ld_i_div,
            c0 => c0,
            right_shift_i_div => right_shift_i_div,
            left_shift_c_div => left_shift_c_div,
            res_sel => res_sel
        );
    
    eu: execution_unit port map
        (
            x1 => acc_out (31 downto 0),
            x2 => reg_op2_out,
            clk => clk,
            clr => clr,
            res_sel => res_sel,
            idop => idop,
            sub => sub,
            neg => neg,
            left => left,
            right => right,
            clr_res_mul => clr_res_mul,
            ld_res_mul => ld_res_mul,
            ld_i_mul => ld_i_mul,
            ld_d_mul => ld_d_mul,
            right_shift_i_mul => right_shift_i_mul,
            left_shift_d_mul => left_shift_d_mul,
            clr_c_div => clr_c_div,
            ld_d_div => ld_d_div,
            sub_div => sub_div,
            ld_i_div => ld_i_div,
            c0 => c0,
            right_shift_i_div => right_shift_i_div,
            left_shift_c_div => left_shift_c_div,
            dn => dn,
            i0 => i0,
            flags => flags,
            y => eu_res
        );

    ext_unit_x1: sign_extend generic map (initial_size => 32, extended_size => 64) port map (data_in => x1, extended_data => ext_x1);

    mux_acc: mux_2_to_1_n generic map (n => 64) port map (x1 => ext_x1, x2 => eu_res, sel => load_res_or_op, y => acc_in);
    
    acc_reg: register_n generic map (N => 64) port map (data_in => acc_in, left => '0', right => '0', load => load_acc, clr => clr, serial_in => '0', clk => clk, data_out => acc_out);
    
    mux_op2: mux_2_to_1_n generic map (n => 32) port map (x1 => x2, x2 => x"00000001", sel => load_op2_or_1, y => reg_op2_in); 
    
    reg_op2: register_n generic map (N => 32) port map (data_in => reg_op2_in, left => '0', right => '0', load => load_rop2, clr => clr, serial_in => '0', clk => clk, data_out => reg_op2_out);
    
    status_register: register_n generic map (N => 7) port map (data_in => flags, left => '0', right => '0', load => load_flags, clr => clr, serial_in => '0', clk => clk, data_out => flags_word);

    zero_det: zero_detector port map (x => reg_op2_out, zero => zero);

    y <= acc_out;

end Structural;
