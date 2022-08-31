library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;


package my_package is
	type memory_block is array (0 to 1) of std_logic_vector(31 downto 0);		
	type page_type is array (0 to 15) of memory_block;
	type RAM is array (0 to 12) of page_type;
	type page_table is array(0 to 511) of std_logic_vector(4 downto 0);

end my_package;


