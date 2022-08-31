
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;
use work.my_package.all;
entity CacheL1 is
    Port (
		   write : in integer; -- if 0 read data from cache else write data to cache
           datain  : in  memory_block;
           addr    : in  STD_LOGIC_VECTOR (10 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0);
		   cache_miss : out bit; -- 0 if found , 1 if missed
		   done : inout integer := 0
		   );
end CacheL1;

architecture Behavioral of CacheL1 is
TYPE cashl1_type IS ARRAY (0 TO 31) OF memory_block;
TYPE Tag_type is array (0 to 31) of std_logic_vector(2 downto 0);
TYPE Valid_type is array(0 to 31) of bit;
signal cashl11 : cashl1_type := (others => (others => (others => '0')));
signal tags : Tag_type := (others => (others => '0'));
signal valids : Valid_type := (others => '0');
signal cash_addr : integer;

signal tag : std_logic_vector(2 downto 0);
signal word_offset : integer;
begin					  
word_offset <= to_integer(unsigned(addr(2 downto 2)));
process(addr, write, datain) 
begin
		if write = 1 then 
			cashl11(to_integer(unsigned(addr(7 downto 3)))) <= datain;
			tags(to_integer(unsigned(addr(7 downto 3)))) <= addr(10 downto 8);
			valids(to_integer(unsigned(addr(7 downto 3)))) <= '1';
		else
			if valids(to_integer(unsigned(addr(7 downto 3)))) = '1' and tags(to_integer(unsigned(addr(7 downto 3)))) = addr(10 downto 8) then
				dataout <= cashl11(to_integer(unsigned(addr(7 downto 3))))(word_offset);
				cache_miss <= '0';
			else
				cache_miss <= '1';
			end if;
		end if;
		done <= (done+1) mod 2;
end process;
end Behavioral;

