library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

use work.my_package.all;

	-- Add your library and packages declaration here ...

entity memory_tb is
end memory_tb;

architecture TB_ARCHITECTURE of memory_tb is
	-- Component declaration of the tested unit
	component memory
	port(
		w_bit : in BIT;
		ph_add : in STD_LOGIC_VECTOR(10 downto 0);
		write_data_from_disk : in page_type;
		read_data : out memory_block;
		written_ppn : out INTEGER;
		done : inout INTEGER );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal w_bit : BIT;
	signal ph_add : STD_LOGIC_VECTOR(10 downto 0);
	signal write_data_from_disk : page_type;
	signal done : INTEGER;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal read_data : memory_block;
	signal written_ppn : INTEGER;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : memory
		port map (
			w_bit => w_bit,
			ph_add => ph_add,
			write_data_from_disk => write_data_from_disk,
			read_data => read_data,
			written_ppn => written_ppn,
			done => done
		);

	-- Add your stimulus here ...
	process
	begin
		w_bit <= '1';
		write_data_from_disk <= (
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
		wait for 50 ns;
		w_bit <= '0';
		ph_add <= "00001010100";
		
		wait;
		
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_memory of memory_tb is
	for TB_ARCHITECTURE
		for UUT : memory
			use entity work.memory(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_memory;

