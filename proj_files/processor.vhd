library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;



------------------------------------ Proccessor design ----------------------------------------------------
entity Processor is 
	port (
	index : in integer := 0;
	vr_add : out std_logic_vector(15 downto 0)
	);
end Processor;	  


architecture behavioral of Processor is
begin  
	process (index)
	is	
	type virtual_address is array (0 to 19) of std_logic_vector(15 downto 0);
		variable v_addrs : virtual_address := (
		"1100100111010000", 
		"1010111111000010", 
		"0101111000100100", 
		"1010110100010100", 
		"1010001100011011", 
		"1011010100011111", 
		"0101111110000001", 
		"1111010101001100", 
		"0010111110101110", 
		"1110110001011001", 
		"0000011001011011", 
		"0001111111010011", 
		"1101101111010011", 
		"0000110011001001", 
		"1001101000111010", 
		"0011000000001110", 
		"0000001100101001", 
		"1111101101110100", 
		"0100010110110011", 
		"0010011011000010"
		);
	begin
		vr_add <= v_addrs(index);				   
	end process;
end	behavioral;
----------------------------------------------------------------------------------------------------------