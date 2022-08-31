library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

use work.my_package.all;
entity Memory is
	port (
		w_bit : in bit; -- if equals to 0 => read from memmory and write in CACH else write from hard disk in memory
		ph_add : in std_logic_vector(10 downto 0);
		write_data_from_disk : in page_type;
		read_data : out memory_block;
		written_ppn : out integer;
		done : inout integer := 0
	);
end Memory;

architecture behavioral of Memory is
signal data : RAM := (others => (others => (others => (others =>'0'))));
signal counter : integer := 0;
signal blk : memory_block;
begin
	process (ph_add, w_bit, write_data_from_disk)	
	is 
		variable ppn : std_logic_vector(3 downto 0) := ph_add(10 downto 7);  
		variable page : page_type;		
		variable block_offset : integer;
		variable ph : std_logic_vector(10 downto 0) := ph_add;
	begin
		if w_bit = '1' then
			data(counter) <= write_data_from_disk;
			ppn := std_logic_vector(to_unsigned(counter, ppn'length));
			written_ppn <= counter ;	    
            counter <= (counter + 1) mod 13;
        end if;
		page := data(to_integer(unsigned(ppn)));
		block_offset := to_integer(unsigned(ph(5 downto 2)));
		blk <= page(block_offset);	
		done <= (done+1) mod 2;
	end process;  
	read_data <= blk;
end	behavioral;


--------------------------------------------------------------------------------------------------------------------------------------------