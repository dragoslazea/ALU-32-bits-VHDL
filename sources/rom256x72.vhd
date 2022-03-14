-- Memorie ROM ce contine instructiuni hardcodate (pentru testare)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rom256x68 is
    Port ( address : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (67 downto 0));
end rom256x68;

architecture Behavioral of rom256x68 is

type rom_array is array (0 to 255) of std_logic_vector(67 downto 0);

signal rom: rom_array := (
    x"0000000A_00000010_0",             -- add (10, 16) = 26 = 0000001Ah -bun
    x"00000006_0000000A_0",             -- add (6, 10) = 16 = 00000010h -bun
    x"FFFFFFFA_FFFFFFF0_0",             -- add (-6, -16) = -22 = FFFFFFEAh -bun
    x"7FFFFFFF_6FFFFFFF_0",             -- add (2147483647, 1879048191) = -268435458 = EFFFFFFEh (overflow) -bun
    x"0000000A_00000010_1",             -- sub (10, 16) = -6 = FFFFFFFAh -bun
    x"0000000A_00000012_1",             -- sub (10, 18) = -8 = FFFFFFF8h -bun
    x"80000000_00000002_1",             -- sub (-2147483648, 2) = 2147483646 = 7FFFFFFEh (overflow) -bun
    x"0000000A_00000000_2",             -- inc (10) = 11 = Bh -bun
    x"80000002_00000000_2",             -- inc (-2147483646) = -2147483645 = 80000003h -bun
    x"FFFFFFF8_00000000_3",             -- dec (-8) = -9 = FFFFFFF7h -bun
    x"80000000_00000000_3",             -- dec (-2147483648) = 2147483647 = 7FFFFFFFh ???????????????????????????????????????????????????
    x"0000000A_00000000_4",             -- neg (10) = -10 = FFFFFFF6h -bun
    x"FFFFFFF6_00000000_4",             -- neg (-10) = 10 = 0000000Ah -bun
    x"0000000A_00000009_5",             -- and (10, 9) = 8h -bun
    x"ABC500F1_0A536221_5",             -- and (ABC500F1h, 0A536221h) = 0A410021h -bun
    x"0000000A_00000009_6",             -- or (10, 9) = 11 = Bh -bun
    x"ABC500F1_0A536221_6",             -- and (ABC500F1h, 0A536221h) = ABD762F1h -bun
    x"0000000A_00000000_7",             -- not (10) = -11 = FFFFFFF5h -bun
    x"FFFFFFF5_00000000_7",             -- not (-11) = 10 = 0000000Ah -bun
    x"80000000_00000000_8",             -- rot_left (80000000) = 00000001h -bun
    x"0000000B_00000000_8",             -- rot_left (11) = 22 = 00000016h -bun
    x"00000010_00000000_9",             -- rot_right (16) = 8 = 00000008h -bun
    x"0000000B_00000000_9",             -- rot_right (11) = 80000005h -bun
    x"0000000A_00000006_A",             -- mul (10, 6) = 60 = 0000003Ch -bun
    x"FFFFFFF6_00000006_A",             -- mul (-10, 6) = -60 = FFFFFFC4h -bun 
    x"0000000A_FFFFFFFA_A",             -- mul (10, -6) = -60 = FFFFFFC4h -bun
    x"FFFFFFF6_FFFFFFFA_A",             -- mul (-10, -6) = 60 = 0000003Ch -bun
    x"0000000A_00000000_A",             -- mul (10, 0) = 00000000h -bun
    x"7FFFFFFF_00000003_A",             -- mul(2147483647, 3) = 7FFFFFFDh (overflow) -bun
    x"0000000C_00000006_B",             -- div (12, 6) = 00000000200000000h (c = 2, r = 0) 
    x"0000000C_00000005_B",             -- div (12, 5) = 00000000200000002h (c = 2, r = 2)
    x"FFFFFFF4_00000005_B",             -- div (-12, 5) = FFFFFFFEFFFFFFFEh (c = -2, r = -2)
    x"0000000C_FFFFFFFB_B",             -- div (12, -5) = FFFFFFFE00000002h (c = -2, r = 2)
    x"FFFFFFF4_FFFFFFFB_B",             -- div (-12, -5) = 000000002FFFFFFFEh (c = 2, r = -2)
    x"0000000C_00000000_B",             -- div (12, 0) = 00000000000000000h (division by 0)
    others => x"00000000_00000000_0"    -- no operation
);

begin

    data_out <= rom(conv_integer(address));

end Behavioral;
