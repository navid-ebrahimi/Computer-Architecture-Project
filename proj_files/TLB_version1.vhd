LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;
use work.my_package.all;




entity fully_asso_TLB is
    Port (
		   update_tlb : in bit; -- if 1 update tlb else read from TLB
		   vir_add : in std_logic_vector(15 downto 0);
           write_ppn : in std_logic_vector(3 downto 0);
           physical_add : out  std_logic_vector(10 downto 0);
		   tlb_miss : out bit; -- 0 if found , 1 if missed
		   done : inout integer := 0
		   );
end fully_asso_TLB;


architecture Behavioral of fully_asso_TLB is
TYPE tlb_type IS ARRAY (0 TO 47) OF std_logic_vector(13 downto 0); 
signal tlb : tlb_type := (others => (others => '0'));
signal counter : integer := 0 ;	  
begin
process(vir_add, update_tlb, write_ppn) 
begin
		tlb_miss <= '1';
		if update_tlb = '1' then
			tlb(counter) <= '1' & vir_add(15 downto 7) & write_ppn;
			counter <= (counter + 1) mod 48;
		else
			for i in 0 to 47 loop
				if tlb(i)(13) = '1' and tlb(i)(12 downto 4) = vir_add(15 downto 7) then
					physical_add <= tlb(i)(3 downto 0) & vir_add(6 downto 0);
					tlb_miss <= '0';
					exit;
				end if;	
			end loop;
		end if;
		done <= (done+1) mod 2;
end process;   
end Behavioral;