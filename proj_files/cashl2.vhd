
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;	
use work.my_package.all;
entity CacheL2 is
    Port (
		   write : in integer; -- if 0 write to cache, else read from cache
           datain  : in  memory_block;
           addr    : in  STD_LOGIC_VECTOR (10 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0);
		   cache_miss : out bit; -- 0 if found , 1 if missed
		   done : inout integer := 0
		   );
end CacheL2;

architecture Behavioral of CacheL2 is
TYPE cashl2_type IS ARRAY (0 TO 15) OF memory_block;
TYPE Tag_type is array (0 to 15) of std_logic_vector(3 downto 0); 
TYPE Valid_type is array(0 to 15) of bit;
signal way0 : cashl2_type := (others => (others => (others => '0'))); 
signal way1 : cashl2_type := (others => (others => (others => '0')));
signal tags0 : Tag_type := (others => (others => '0'));
signal tags1 : Tag_type := (others => (others => '0'));
signal valids0 : Valid_type := (others => '0');	
signal valids1 : Valid_type := (others => '0');
signal tag : std_logic_vector (3 downto 0);					
signal word_offset : integer;
type int_arr is array(0 to 15) of integer range -500 to 500;
signal counters : int_arr := (others => 0) ;
begin
process(addr, write, datain) 
begin 
	if write = 1 then
		if counters(to_integer(unsigned(addr(6 downto 3)))) = 0 then
			way0(to_integer(unsigned(addr(6 downto 3)))) <= datain;
			tags0(to_integer(unsigned(addr(6 downto 3)))) <= addr(10 downto 7);
			valids0(to_integer(unsigned(addr(6 downto 3)))) <= '1';
			counters(to_integer(unsigned(addr(6 downto 3)))) <= (counters(to_integer(unsigned(addr(6 downto 3)))) + 1) mod 2;
		else
			way1(to_integer(unsigned(addr(6 downto 3)))) <= datain;
			tags1(to_integer(unsigned(addr(6 downto 3)))) <= addr(10 downto 7);
			valids1(to_integer(unsigned(addr(6 downto 3)))) <= '1';
			counters(to_integer(unsigned(addr(6 downto 3)))) <= (counters(to_integer(unsigned(addr(6 downto 3)))) + 1) mod 2;
		end if;
	else
		if valids0(to_integer(unsigned(addr(6 downto 3)))) = '1' and tags0(to_integer(unsigned(addr(6 downto 3)))) = addr(10 downto 7) then
			dataout <= way0(to_integer(unsigned(addr(6 downto 3))))(to_integer(unsigned(addr(2 downto 2))));
			cache_miss <= '0';
		elsif valids1(to_integer(unsigned(addr(6 downto 3)))) = '1' and tags1(to_integer(unsigned(addr(6 downto 3)))) = addr(10 downto 7) then
			dataout <= way1(to_integer(unsigned(addr(6 downto 3))))(to_integer(unsigned(addr(2 downto 2))));
			cache_miss <= '0';
		else
			cache_miss <= '1';
		end if;
	end if;
	done <= (done+1) mod 2;
end process;
end Behavioral;

