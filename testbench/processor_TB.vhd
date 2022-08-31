library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity processor_tb is
end processor_tb;

architecture TB_ARCHITECTURE of processor_tb is
	-- Component declaration of the tested unit
	component processor
	port(
		index : in INTEGER := 0;
		vr_add : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal index : INTEGER := 0;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal vr_add : STD_LOGIC_VECTOR(15 downto 0);

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : processor
		port map (
			index => index,
			vr_add => vr_add
		);

	-- Add your stimulus here ...
	process	
	begin
		index <= 0;
		wait for 50 ns;
		index <= 1;
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_processor of processor_tb is
	for TB_ARCHITECTURE
		for UUT : processor
			use entity work.processor(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_processor;

