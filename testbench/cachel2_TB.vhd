LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;	
use work.my_package.all;

	-- Add your library and packages declaration here ...

entity cachel2_tb is
end cachel2_tb;

architecture TB_ARCHITECTURE of cachel2_tb is
	-- Component declaration of the tested unit
	component cachel2
	port(
		write : in INTEGER;
		datain : in memory_block;
		addr : in STD_LOGIC_VECTOR(10 downto 0);
		dataout : out STD_LOGIC_VECTOR(31 downto 0);
		cache_miss : out BIT;
		done : inout INTEGER );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal write : INTEGER;
	signal datain : memory_block;
	signal addr : STD_LOGIC_VECTOR(10 downto 0);
	signal done : INTEGER;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal dataout : STD_LOGIC_VECTOR(31 downto 0);
	signal cache_miss : BIT;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : cachel2
		port map (
			write => write,
			datain => datain,
			addr => addr,
			dataout => dataout,
			cache_miss => cache_miss,
			done => done
		);

	-- Add your stimulus here ...
	process
	begin
		write <= 1;
		datain <= ( "10011111010011001011100111000110", "00111010101101010100000010101100" );
		addr <= "11010000100";
		wait for 50 ns;
		write <= 0;
		addr <= "11010000100";
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_cachel2 of cachel2_tb is
	for TB_ARCHITECTURE
		for UUT : cachel2
			use entity work.cachel2(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_cachel2;

