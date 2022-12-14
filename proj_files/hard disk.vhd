library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all; 

use work.my_package.all;


------------------------------------ HardDisk design ---------------------------------------------------------------- 
------- size of RAM = 512 words.
------- size of Page Table = 80 words (we have 2^9 pages, every row has 4 bit for ppn and 1 bit for valid => (4+1)*(2^9)bit = 80 words).
------- size of remaining blocks = 512 - 80 = 432words
------- size of every block = 432/32 = 13  (size of page = 32 words)
entity HardDisk is 	
	port (
		call_hd : in integer;
		s_add : in std_logic_vector(8 downto 0);   -- referes to OS Fault Handler
		page : out page_type; -- every data size is 4B = 32 bit => every page has 32 data
		done : inout integer := 0
	);
end HardDisk;	  

architecture behavioral of HardDisk is
begin  
	process (call_hd)
	is	
		type all_page is array (0 to 0) of page_type;
		variable data : page_type := (
		("10011111010011001011100111000110", "10001011001001110001011101100100"), 
		("11111000110011011011011001101110", "00111101001100000101011110101001"), 
		("11111111000001010010011101100010", "11101110000010000101001111110100"), 
		("01101111110011001000100110011111", "10111010110101000001111101111101"), 
		("00111110001100110011000100100000", "01000000010001111010111011100001"), 
		("00101111100100001010111110111011", "10000111110101011001110001100110"), 
		("11001001000001001010011001001000", "11111110100000101000001001100000"), 
		("01011011010111010011001001000001", "10110101101001000100111111001111"), 
		("10111100010101000111000011010110", "11010110011101010101111010110010"), 
		("10100010011011100011000011111000", "01101011111110011110101011000001"), 
		("00010110100011011101101110010111", "11011101000011111011111100101010"), 
		("11110000100000110111001001000101", "00000001101001110110110110000011"), 
		("00100111001001101000111110100000", "11111001100111111011101111011010"), 
		("11101000011001000001100000111011", "00111010110011001101111110100001"), 
		("11010100011001100000011001110001", "00111101011101100010111110110101"), 
		("11011000000010111001110001111101", "00111010101101010100000010101100")
										
										);
										
										
							
	begin
		done <= (done+1) mod 2;				
		page <= data;
	end process;
end	behavioral;
-----------------------------------------------------------------------------------------------------------------------
