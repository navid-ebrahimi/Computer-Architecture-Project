library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

use work.my_package.all;

	-- Add your library and packages declaration here ...

entity pagetable_tb is
end pagetable_tb;

architecture TB_ARCHITECTURE of pagetable_tb is
	-- Component declaration of the tested unit
	component pagetable
	port(
		vpn : in STD_LOGIC_VECTOR(8 downto 0);
		update_pageTable : in INTEGER;
		write_ppn_from_RAM : in INTEGER;
		ppn : out STD_LOGIC_VECTOR(3 downto 0);
		page_fault : out BIT;
		done : inout INTEGER );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal vpn : STD_LOGIC_VECTOR(8 downto 0);
	signal update_pageTable : INTEGER;
	signal write_ppn_from_RAM : INTEGER;
	signal done : INTEGER;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal ppn : STD_LOGIC_VECTOR(3 downto 0);
	signal page_fault : BIT;

	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : pagetable
		port map (
			vpn => vpn,
			update_pageTable => update_pageTable,
			write_ppn_from_RAM => write_ppn_from_RAM,
			ppn => ppn,
			page_fault => page_fault,
			done => done
		);

	-- Add your stimulus here ...
	process
	begin
		update_pageTable <= 1;
		vpn <= "000000111";
		write_ppn_from_RAM <= 5;
		wait for 50 ns;
		update_pageTable <= 0;
		vpn <= "101010101";
		wait for 50 ns;
		update_pageTable <= 0;
		vpn <= "000000111";
		wait;
	end process;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_pagetable of pagetable_tb is
	for TB_ARCHITECTURE
		for UUT : pagetable
			use entity work.pagetable(bhv);
		end for;
	end for;
end TESTBENCH_FOR_pagetable;

