LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;
use work.my_package.all;




entity four_way_TLB is
    Port (
		   update_tlb : in bit; -- if 0 update tlb else read from TLB
		   vir_add : in std_logic_vector(15 downto 0);
           write_ppn : in std_logic_vector(3 downto 0);
           physical_add : out std_logic_vector(10 downto 0);
		   tlb_miss : out bit; -- 0 if found , 1 if missed
		   done : inout integer
			   );
end four_way_TLB;


architecture Behavioral of four_way_TLB is
TYPE tlb_four_way_type IS ARRAY (0 TO 11) OF std_logic_vector(13 downto 0);--
signal tlb0 : tlb_four_way_type := (others => (others => '0'));
signal tlb1 : tlb_four_way_type := (others => (others => '0'));
signal tlb2 : tlb_four_way_type := (others => (others => '0'));
signal tlb3 : tlb_four_way_type := (others => (others => '0'));
type int_arr is array(0 to 11) of integer range -500 to 500;
signal counters : int_arr := (others => 0);
signal counter : integer := 0;	  

begin
process(vir_add, update_tlb, write_ppn)
begin
		tlb_miss <= '1';
		if update_tlb = '1' then
			if counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) = 0 then
				tlb0(to_integer(unsigned(vir_add(15 downto 7))) mod 12) <= '1' & vir_add(15 downto 7) & write_ppn;
				counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) <= (counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) + 1) mod 4;
			elsif counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) = 1 then
				tlb1(to_integer(unsigned(vir_add(15 downto 7))) mod 12) <= '1' & vir_add(15 downto 7) & write_ppn;
				counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) <= (counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) + 1) mod 4;
			elsif counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) = 2 then
				tlb2(to_integer(unsigned(vir_add(15 downto 7))) mod 12) <= '1' & vir_add(15 downto 7) & write_ppn;
				counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) <= (counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) + 1) mod 4;
			else
				tlb3(to_integer(unsigned(vir_add(15 downto 7))) mod 12) <= '1' & vir_add(15 downto 7) & write_ppn;
				counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) <= (counters(to_integer(unsigned(vir_add(15 downto 7))) mod 12) + 1) mod 4;
			end if;
		else
			if tlb0(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(13) = '1' and tlb0(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(12 downto 4) = vir_add(15 downto 7) then
				physical_add <= tlb0(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(3 downto 0) & vir_add(6 downto 0);
				tlb_miss <= '0';
			elsif tlb1(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(13) = '1' and tlb1(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(12 downto 4) = vir_add(15 downto 7) then
				physical_add <= tlb1(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(3 downto 0) & vir_add(6 downto 0);
				tlb_miss <= '0';
			elsif tlb2(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(13) = '1' and tlb2(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(12 downto 4) = vir_add(15 downto 7) then
				physical_add <= tlb2(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(3 downto 0) & vir_add(6 downto 0);
				tlb_miss <= '0';
			elsif tlb3(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(13) = '1' and tlb3(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(12 downto 4) = vir_add(15 downto 7) then
				physical_add <= tlb3(to_integer(unsigned(vir_add(15 downto 7))) mod 12)(3 downto 0) & vir_add(6 downto 0);
				tlb_miss <= '0';
			else
				tlb_miss <= '1';
			end if;
		end if;
		done <= (done+1) mod 2;
end process;
end Behavioral;