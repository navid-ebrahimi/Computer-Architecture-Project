library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

use work.my_package.all;

entity pageTable is
	port (
		vpn : in std_logic_vector(8 downto 0);
		update_pageTable : in integer := 0;
		write_ppn_from_RAM : in integer;
		ppn : out std_logic_vector(3 downto 0);
		page_fault : out bit := '0';
		done : inout integer := 0
);
end pageTable;

architecture bhv of pageTable is
signal page_t : page_table := (others => (others => '0'));
begin
	process (vpn, update_pageTable, write_ppn_from_RAM)	
	is
	variable write_ppn : std_logic_vector(3 downto 0);
	variable row : integer;
	begin
		row := to_integer(unsigned(vpn));
		if update_pageTable = 1 then				
			write_ppn := std_logic_vector(to_unsigned(write_ppn_from_RAM, write_ppn'length));
			page_t(row) <= '1' & write_ppn;
        else
			if page_t(row)(4) = '0' then
				page_fault <= '1';
			else
				ppn <= page_t(row)(3 downto 0);
				page_fault <= '0';
			end if;
		end if;
		done <= (done+1) mod 2;
	end process;  
end	bhv;