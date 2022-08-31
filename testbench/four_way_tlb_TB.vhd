LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;
use work.my_package.all;


	-- Add your library and packages declaration here ...

entity test_four_way_tlb_tb is
end test_four_way_tlb_tb;

architecture TB_ARCHITECTURE of test_four_way_tlb_tb is
	-- Component declaration of the tested unit
	component four_way_tlb
	port(
		update_tlb : in BIT;
		vir_add : in STD_LOGIC_VECTOR(15 downto 0);
		write_ppn : in STD_LOGIC_VECTOR(3 downto 0);
		physical_add : out STD_LOGIC_VECTOR(10 downto 0);
		tlb_miss : out BIT;
		done : inout INTEGER
		 );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
		signal CLK : std_logic := '0';
		signal update_tlb : BIT;
	signal vir_add : STD_LOGIC_VECTOR(15 downto 0);
	signal write_ppn : STD_LOGIC_VECTOR(3 downto 0);
	signal done : INTEGER;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal physical_add : STD_LOGIC_VECTOR(10 downto 0);
	signal tlb_miss : BIT;
  	constant CLK_period : time := 10 ns;


	-- Add your code here ...

begin

	-- Unit Under Test port map
	UUT : four_way_tlb
	port map (
			update_tlb => update_tlb,
			vir_add => vir_add,
			write_ppn => write_ppn,
			physical_add => physical_add,
			tlb_miss => tlb_miss,
			done => done
		);
	CLK_process :process
	   begin
	        CLK <= '0';
	        wait for CLK_period/2;
	        CLK <= '1';
	        wait for CLK_period/2;
	   end process;

	process
	begin
		update_tlb <= '1';
		vir_add <= "0000111101010100";
		write_ppn <= "1010";
		wait for 50 ns;
		update_tlb <= '1';
		vir_add <= "0000100101010100";
		write_ppn <= "1000";
		wait for 50 ns;
		update_tlb <= '0';
		vir_add <= "0000111101010100";
		wait;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_four_way_tlb of test_four_way_tlb_tb is
	for TB_ARCHITECTURE
		for UUT : four_way_tlb
			use entity work.four_way_tlb(behavioral);
		end for;
	end for;
end TESTBENCH_FOR_four_way_tlb;

