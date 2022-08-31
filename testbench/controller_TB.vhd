library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use work.my_package.all;

	-- Add your library and packages declaration here ...

entity controller_tb is
end controller_tb;

architecture TB_ARCHITECTURE of controller_tb is
	-- Component declaration of the tested unit
	component controller
	port(
		tlb_version : in INTEGER := 1;
		cache_version : in INTEGER := 1;
		output : out STD_LOGIC_VECTOR(31 downto 0) ;
		indo : out integer
		);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal tlb_version : INTEGER := 1;
	signal cache_version : INTEGER := 1;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal output : STD_LOGIC_VECTOR(31 downto 0);
	signal indo : integer;
	-- Add your code here ...
	
begin

	-- Unit Under Test port map
	UUT : controller
		port map (
			tlb_version => tlb_version,
			cache_version => cache_version,
			output => output,
			indo => indo
		);

	-- Add your stimulus here ...
	process
	begin
		tlb_version <= 1;
		cache_version <= 1;
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_controller of controller_tb is
	for TB_ARCHITECTURE
		for UUT : controller
			use entity work.controller(behaviour);
		end for;
	end for;
end TESTBENCH_FOR_controller;

