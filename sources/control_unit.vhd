-- Unitatea de control pentru unitatea aritmetica si logica

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is

type state_type is (
    start_state,
    load_op_add,
    add_ex,
    load_op_sub,
    sub_ex,
    load_op_inc,
    inc_ex,
    load_op_dec,
    dec_ex,
    load_op_neg,
    neg_ex,
    load_op_and,
    and_ex,
    load_op_or,
    or_ex,
    load_op_not,
    not_ex,
    load_op_rot_left,
    init_rot_left,
    rot_left_ex,
    load_op_rot_right,
    init_rot_right,
    rot_right_ex,
    load_res_alu,
    load_op_mul,
    init_mul,
    test_i01,
    add_mul,
    left_shift_d_mult,
    right_shift_i_mult,
    test_n10,
    load_res_mul,
    load_op_div,
    test_div0,
    init_div,
    sub_div_state,
    test_d_neg,
    left_shift_c1,
    add_div_state,
    left_shift_c0,
    right_shift_i_division,
    test_n20,
    load_res_div,
    stop_state
);


signal state : state_type := start_state;
signal n1 : integer range 0 to 32 := 0;
signal n2 : integer range 0 to 33 := 0;
signal stop_aux : STD_LOGIC := '0';

begin

    next_state: process (clk)
    variable wait_time : integer := 10;
    begin
        if rising_edge(clk) then
            if clr = '1' then
                state <= start_state;
                --stop <= '1';
            else 
                case state is
                    when start_state =>
                        if start = '1' then
                            case idop is
                                when "0000" => state <= load_op_add; res_sel <= "00"; --stop <= '0'; res_sel <= "00";
                                when "0001" => state <= load_op_sub; res_sel <= "00"; --stop <= '0'; res_sel <= "00";
                                when "0010" => state <= load_op_inc; res_sel <= "00"; --stop <= '0'; res_sel <= "00";
                                when "0011" => state <= load_op_dec; res_sel <= "00"; --stop <= '0'; res_sel <= "00";
                                when "0100" => state <= load_op_neg; res_sel <= "00"; --stop <= '0'; res_sel <= "00";
                                when "0101" => state <= load_op_and; res_sel <= "01"; --stop <= '0'; res_sel <= "01";
                                when "0110" => state <= load_op_or; res_sel <= "01"; --stop <= '0'; res_sel <= "01";
                                when "0111" => state <= load_op_not; res_sel <= "01"; --stop <= '0'; res_sel <= "01";
                                when "1000" => state <= load_op_rot_left; res_sel <= "01"; --stop <= '0'; res_sel <= "01";
                                when "1001" => state <= load_op_rot_right; res_sel <= "01"; --stop <= '0'; res_sel <= "01";
                                when "1010" => state <= load_op_mul; res_sel <= "10"; --stop <= '0'; res_sel <= "10";
                                when "1011" => state <= load_op_div; res_sel <= "11"; --stop <= '0'; res_sel <= "11";
                                when others => state <= start_state;
                            end case;
                        else
                            state <= start_state;
                        end if;
                    when load_op_add => state <= add_ex;
                    when add_ex => state <= stop_state; --stop <= '1';
                    when load_res_alu =>
                        state <= stop_state;
                    when load_op_sub => state <= sub_ex;
                    when sub_ex => state <= stop_state; --stop <= '1';
                    when load_op_inc => state <= inc_ex;
                    when inc_ex => state <= stop_state; --stop <= '1';
                    when load_op_dec => state <= dec_ex;
                    when dec_ex => state <= stop_state; --stop <= '1';
                    when load_op_neg => state <= neg_ex;
                    when neg_ex => state <= stop_state; --stop <= '1';
                    when load_op_and => state <= and_ex;
                    when and_ex => state <= stop_state; --stop <= '1';
                    when load_op_or => state <= or_ex;
                    when or_ex => state <= stop_state; --stop <= '1';
                    when load_op_not => state <= not_ex;
                    when not_ex => state <= stop_state; --stop <= '1';
                    when load_op_rot_left => state <= init_rot_left;
                    when init_rot_left => state <= rot_left_ex;
                    when rot_left_ex => state <= load_res_alu;
                    when load_op_rot_right => state <= init_rot_right;
                    when init_rot_right => state <= rot_right_ex;
                    when rot_right_ex => state <= load_res_alu;
                    when load_op_mul => state <= init_mul;
                    when init_mul =>
                        n1 <= 32;
                        state <= test_i01;
                    when test_i01 =>
                        if i0 = '1' then
                            state <= add_mul;
                        else
                            state <= left_shift_d_mult;
                        end if;
                    when add_mul => state <= left_shift_d_mult;
                    when left_shift_d_mult => state <= right_shift_i_mult;
                    when right_shift_i_mult => 
                        n1 <= n1 - 1;
                        state <= test_n10;
                    when test_n10 =>
                        if n1 = 0 then
                            state <= load_res_mul;
                        else 
                            state <= test_i01;
                        end if;
                    when load_res_mul =>
                        state <= stop_state;
                        --stop <= '1';
                    when load_op_div => state <= test_div0;
                    when test_div0 =>
                        if zero = '1' then
                            state <= load_res_div;
                        else
                            state <= init_div;
                        end if;
                    when init_div =>
                        n2 <= 33;
                        state <= sub_div_state;
                    when sub_div_state => 
                        state <= test_d_neg;
                    when test_d_neg =>
                        if dn = '1' then
                            state <= add_div_state;
                        else
                            state <= left_shift_c1;
                        end if;
                    when add_div_state => state <= left_shift_c0;
                    when left_shift_c1 => state <= right_shift_i_division;
                    when left_shift_c0 => state <= right_shift_i_division;
                    when right_shift_i_division =>
                        n2 <= n2 - 1;
                        state <= test_n20;
                    when test_n20 =>
                        if n2 = 0 then
                            state <= load_res_div;
                        else
                            state <= sub_div_state;
                        end if;
                    when load_res_div => 
                        state <= stop_state;
                    when stop_state => state <= start_state; stop_aux <= '1';
                    when others => null;
                end case;
            end if;
        end if;
    end process;
    
    stop <= stop_aux;
    
    control_signals: process(state)
    begin
        -- semnale de control 
        sub <= '0';
        neg <= '0';
        left <= '0';
        right <= '0';
        load_acc <= '0';
        load_res_or_op <= '0';
        load_rop2 <= '0';
        load_op2_or_1 <= '0';
        load_flags <= '0';
           
        -- semnale de control inmultitor    
        clr_res_mul <= '0';
        ld_res_mul <= '0';
        ld_i_mul <= '0';
        ld_d_mul <= '0';
        right_shift_i_mul <= '0';
        left_shift_d_mul <= '0';
               
        -- semnale de control impartitor
        clr_c_div <= '0';
        ld_d_div <= '0';
        sub_div <= '0';
        ld_i_div <= '0';
        c0 <= '0';
        right_shift_i_div <= '0';
        left_shift_c_div <= '0';
        
        case state is
            when load_op_add =>
                load_acc <= '1';
                load_rop2 <= '1';
            when add_ex =>
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when load_res_alu =>
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when load_op_sub =>
                load_acc <= '1';
                load_rop2 <= '1';
            when sub_ex =>
                sub <= '1';
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when load_op_inc =>
                load_acc <= '1';
                load_rop2 <= '1';
                load_op2_or_1 <= '1';
            when inc_ex =>
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when load_op_dec =>
                load_acc <= '1';
                load_rop2 <= '1';
                load_op2_or_1 <= '1';
            when dec_ex =>
                sub <= '1';
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when load_op_neg =>
                load_acc <= '1';
                load_rop2 <= '1';
                load_op2_or_1 <= '1';
            when neg_ex =>
                neg <= '1';
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when load_op_and =>
                load_acc <= '1';
                load_rop2 <= '1';
            when and_ex =>
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when or_ex =>
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when not_ex =>
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when load_op_or =>
                load_acc <= '1';
                load_rop2 <= '1';
            when load_op_not =>
                load_acc <= '1';
            when load_op_rot_left =>
                load_acc <= '1';
            when rot_left_ex =>
                left <= '1';
            when load_op_rot_right =>
                load_acc <= '1';
            when rot_right_ex =>
                right <= '1';
            when load_op_mul =>
                load_acc <= '1';
                load_rop2 <= '1';
            when init_mul =>
                clr_res_mul <= '1';
                ld_d_mul <= '1';
                ld_i_mul <= '1';
            when add_mul =>
                ld_res_mul <= '1';
            when left_shift_d_mult =>
                left_shift_d_mul <= '1';
            when right_shift_i_mult =>
                right_shift_i_mul <= '1';
            when load_res_mul =>
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when load_op_div =>
                load_acc <= '1';
                load_rop2 <= '1';
            when init_div =>
                clr_c_div <= '1';
                ld_d_div <= '1';
                ld_i_div <= '1';
            when sub_div_state =>
                sub_div <= '1';
                ld_d_div <= '1';
            when add_div_state =>
                sub_div <= '0';
                ld_d_div <= '1';
            when left_shift_c0 =>
                c0 <= '0';
                left_shift_c_div <= '1';
            when left_shift_c1 =>
                c0 <= '1';
                left_shift_c_div <= '1';
            when right_shift_i_division =>
                right_shift_i_div <= '1';
            when load_res_div =>
                load_acc <= '1';
                load_res_or_op <= '1';
                load_flags <= '1';
            when others => null;
        end case;    
    end process control_signals;
  
end Behavioral;
