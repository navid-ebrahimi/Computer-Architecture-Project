library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use work.my_package.all;
entity controller is
	Port (
	tlb_version : in integer := 1;
	cache_version : in integer := 1;
	output : out std_logic_vector(31 downto 0);
	indo : out integer 
	);
end controller;


architecture behaviour of controller is
signal ind : integer := 0;
signal virtual_add : std_logic_vector(15 downto 0);




component Processor	is
    port(index : in integer;         -- Inputs
         vr_add: out std_logic_vector(15 downto 0));       -- Outputs
end component;

component fully_asso_TLB is
	port(
		   update_tlb : in bit; 
		   vir_add : in std_logic_vector(15 downto 0);
           write_ppn : in std_logic_vector(3 downto 0);
           physical_add : out  std_logic_vector(10 downto 0);
		   tlb_miss : out bit;
		   done : inout integer := 0
		   );
end component;
signal update_tlb : bit := '0';
signal tlb_vir_add : std_logic_vector(15 downto 0);
signal tlb_write_ppn : std_logic_vector(3 downto 0);
signal tlb1_phy_add : std_logic_vector(10 downto 0);
signal tlb1_miss : bit;
signal tlb2_phy_add : std_logic_vector(10 downto 0);
signal tlb2_miss : bit;
signal tlb1_done : integer := 0;
signal tlb2_done : integer := 0;
component four_way_TLB is
	port(
	   	   update_tlb : in bit; -- if 0 update tlb else read from TLB
		   vir_add : in std_logic_vector(15 downto 0);
           write_ppn : in std_logic_vector(3 downto 0);
           physical_add : out std_logic_vector(10 downto 0);
		   tlb_miss : out bit;
		   done : inout integer := 0
	);
end component;

component CacheL1 is
	port(
		write : in integer; 
           datain  : in  memory_block;
           addr    : in  STD_LOGIC_VECTOR (10 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0);
		   cache_miss : out bit;
		   done : inout integer := 0
	);
	
end component;
signal cache_write : integer := 0;
signal cache_datain : memory_block;
signal cache_addr : STD_LOGIC_VECTOR (10 downto 0);
signal cache1_dataout : STD_LOGIC_VECTOR (31 downto 0);
signal cache2_dataout : STD_LOGIC_VECTOR (31 downto 0);
signal cache1_miss : bit;
signal cache2_miss : bit;
signal cache1_done : integer := 0;
signal cache2_done : integer := 0;
component CacheL2 is
	port(
		write : in integer; 
           datain  : in  memory_block;
           addr    : in  STD_LOGIC_VECTOR (10 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0);
		   cache_miss : out bit;
		   done : inout integer := 0
	);
	
end component;

component Memory is
	port(
	   w_bit : in bit; 
		ph_add : in std_logic_vector(10 downto 0);
		write_data_from_disk : in page_type;
		read_data : out memory_block;
		written_ppn : out integer;
		done : inout integer := 0
	);
end component;
signal mem_write : bit := '0' ;
signal mem_phy_add : std_logic_Vector(10 downto 0);
signal mem_data_disk : page_type;
signal mem_data : memory_block;
signal mem_ppn_out : integer;
signal mem_done : integer := 0;

component HardDisk is
	port(
		call_hd : in integer;
		s_add : in std_logic_vector(8 downto 0);   
		page : out page_type;
		done : inout integer := 0
	);
end component;
signal hard_call : integer := 0;
signal hard_add : std_logic_vector(8 downto 0);
signal hard_page : page_type;
signal hard_done : integer := 0;

component pageTable is 
	port(
	  	vpn : in std_logic_vector(8 downto 0);
		update_pageTable : in integer := 0;
		write_ppn_from_RAM : in integer;
		ppn : out std_logic_vector(3 downto 0);
		page_fault : out bit := '0';
		done : inout integer := 0
	);
end component;
signal pt_vpn : std_logic_vector(8 downto 0);
signal pt_update : integer := 0;
signal pt_write_ppn : integer;
signal pt_ppn : std_logic_vector(3 downto 0);
signal pt_page_fault : bit;
signal pt_done : integer := 0;






begin
	proc : Processor Port Map (index => ind, vr_add => virtual_add);
	
	tlbv1 : fully_asso_TLB Port Map ( update_tlb => update_tlb, vir_add => tlb_vir_add, 
	write_ppn => tlb_write_ppn, physical_add => tlb1_phy_add, tlb_miss => tlb1_miss, done => tlb1_done);
	
	tlbv2 : four_way_TLB Port Map ( update_tlb => update_tlb, vir_add => tlb_vir_add, 
	write_ppn => tlb_write_ppn, physical_add => tlb2_phy_add, tlb_miss => tlb2_miss, done => tlb2_done);
	
	cachev1 : CacheL1 Port Map (
			write => cache_write, 
           datain => cache_datain,
           addr => cache_addr,
           dataout => cache1_dataout,
		   cache_miss => cache1_miss,
		   done => cache1_done
		   );
	cachev2 : CacheL2 Port Map (
			write => cache_write, 
           datain => cache_datain,
           addr => cache_addr,
           dataout => cache2_dataout,
		   cache_miss => cache2_miss,
		   done => cache2_done
		   );
		   
	page_table : pageTable Port Map (
		vpn => pt_vpn,
		update_pageTable => pt_update,
		write_ppn_from_RAM => pt_write_ppn,
		ppn	=> pt_ppn,
		page_fault => pt_page_fault,
		done => pt_done
	);
	
	main_memory : Memory Port Map (
	  	w_bit => mem_write,
		ph_add => mem_phy_add,
		write_data_from_disk => mem_data_disk,
		read_data => mem_data,
		written_ppn => mem_ppn_out,
		done => mem_done
	);
	
	hard_disk : HardDisk Port Map (
		call_hd => hard_call,
		s_add => hard_add ,
		page => hard_page ,
		done => hard_done
	);
	
	
	
	process
	begin
		indo <= ind;
		update_tlb <= '0';
		tlb_vir_add <= virtual_add;
		if tlb_version = 1 then
			wait on tlb1_done;
			if tlb1_miss = '0' then
				cache_write <= 0;
				cache_addr <= tlb1_phy_add;
				if cache_version = 1 then
					wait on cache1_done;
					if cache1_miss = '1' then		
						mem_write <= '0';
						mem_phy_add <= tlb1_phy_add;
						wait on mem_done;
						cache_write <= 1;
						cache_datain <= mem_data;
						cache_addr <= tlb1_phy_add;
						wait on cache1_done;
						cache_write <= 0;
						cache_addr <= tlb1_phy_add;
						wait on cache1_done;
						output <= cache1_dataout;
					else						 
						output <= cache1_dataout;
					end if;
					
				else
					wait on cache2_done;
					if cache2_miss = '1' then		
						mem_write <= '0';
						mem_phy_add <= tlb1_phy_add;
						wait on mem_done;
						cache_write <= 1;
						cache_datain <= mem_data;
						cache_addr <= tlb1_phy_add;
						wait on cache2_done;
						cache_write <= 0;
						cache_addr <= tlb1_phy_add;
						wait on cache2_done;
						output <= cache2_dataout;
					else						 
						output <= cache2_dataout;
					end if;
				end if;
			else
				pt_update <= 0;
				pt_vpn <= virtual_add(15 downto 7);
				wait on pt_done;
				if pt_page_fault = '0' then
					update_tlb <= '1';
					tlb_vir_add <= virtual_add;
					tlb_write_ppn <= pt_ppn;
					wait on tlb1_done;
					if cache_version = 1 then
						wait on cache1_done;
						if cache1_miss = '1' then		
							mem_write <= '0';
							mem_phy_add <= tlb1_phy_add;
							wait on mem_done;
							cache_write <= 1;
							cache_datain <= mem_data;
							cache_addr <= tlb1_phy_add;
							wait on cache1_done;
							cache_write <= 0;
							cache_addr <= tlb1_phy_add;
							wait on cache1_done;
							output <= cache1_dataout;
						else						 
							output <= cache1_dataout;
						end if;
					
					else
						wait on cache2_done;
						if cache2_miss = '1' then		
							mem_write <= '0';
							mem_phy_add <= tlb1_phy_add;
							wait on mem_done;
							cache_write <= 1;
							cache_datain <= mem_data;
							cache_addr <= tlb1_phy_add;
							wait on cache2_done;
							cache_write <= 0;
							cache_addr <= tlb1_phy_add;
							wait on cache2_done;
							output <= cache2_dataout;
						else						 
							output <= cache2_dataout;
						end if;
					end if;
					
				else
					hard_call <= (hard_call+1) mod 2;
					wait on hard_done;		   
					mem_write <= '1';
					mem_data_disk <= hard_page;
					wait on mem_done;
					pt_update <= 1;
					pt_write_ppn <= mem_ppn_out;
					pt_vpn <= virtual_add(15 downto 7);
					wait on pt_done;
					update_tlb <= '1';
					tlb_write_ppn <= std_logic_vector(to_unsigned(mem_ppn_out, tlb_write_ppn'length));
					wait on tlb1_done;
					cache_write <= 1;
					cache_datain <= mem_data;
					cache_addr <= std_logic_vector(to_unsigned(mem_ppn_out, 4)) & virtual_add(6 downto 0);
					if cache_version = 1 then
						wait on cache1_done;
						cache_write <= 0;
						wait on cache1_done;
						output <= cache1_dataout;
					else
						wait on cache2_done;
						cache_write <= 0;
						wait on cache2_done;
						output <= cache2_dataout;
					end if;
						
				end if;
			
				end if;
				
				
			else
				wait on tlb2_done;
			if tlb2_miss = '0' then
				cache_write <= 0;
				cache_addr <= tlb2_phy_add;
				if cache_version = 1 then
					wait on cache1_done;
					if cache1_miss = '1' then		
						mem_write <= '0';
						mem_phy_add <= tlb2_phy_add;
						wait on mem_done;
						cache_write <= 1;
						cache_datain <= mem_data;
						cache_addr <= tlb2_phy_add;
						wait on cache1_done;
						cache_write <= 0;
						cache_addr <= tlb2_phy_add;
						wait on cache1_done;
						output <= cache1_dataout;
					else						 
						output <= cache1_dataout;
					end if;
					
				else
					wait on cache2_done;
					if cache2_miss = '1' then		
						mem_write <= '0';
						mem_phy_add <= tlb2_phy_add;
						wait on mem_done;
						cache_write <= 1;
						cache_datain <= mem_data;
						cache_addr <= tlb2_phy_add;
						wait on cache2_done;
						cache_write <= 0;
						cache_addr <= tlb2_phy_add;
						wait on cache2_done;
						output <= cache2_dataout;
					else						 
						output <= cache2_dataout;
					end if;
				end if;
			else
				pt_update <= 0;
				pt_vpn <= virtual_add(15 downto 7);
				wait on pt_done;
				if pt_page_fault = '0' then
					update_tlb <= '1';
					tlb_vir_add <= virtual_add;
					tlb_write_ppn <= pt_ppn;
					wait on tlb2_done;
					if cache_version = 1 then
						wait on cache1_done;
						if cache1_miss = '1' then		
							mem_write <= '0';
							mem_phy_add <= tlb2_phy_add;
							wait on mem_done;
							cache_write <= 1;
							cache_datain <= mem_data;
							cache_addr <= tlb2_phy_add;
							wait on cache1_done;
							cache_write <= 0;
							cache_addr <= tlb2_phy_add;
							wait on cache1_done;
							output <= cache1_dataout;
						else						 
							output <= cache1_dataout;
						end if;
					
					else
						wait on cache2_done;
						if cache2_miss = '1' then		
							mem_write <= '0';
							mem_phy_add <= tlb2_phy_add;
							wait on mem_done;
							cache_write <= 1;
							cache_datain <= mem_data;
							cache_addr <= tlb2_phy_add;
							wait on cache2_done;
							cache_write <= 0;
							cache_addr <= tlb2_phy_add;
							wait on cache2_done;
							output <= cache2_dataout;
						else						 
							output <= cache2_dataout;
						end if;
					end if;
					
				else
					hard_call <= (hard_call+1) mod 2;
					wait on hard_done;		   
					mem_write <= '1';
					mem_data_disk <= hard_page;
					wait on mem_done;
					pt_update <= 1;
					pt_write_ppn <= mem_ppn_out;
					pt_vpn <= virtual_add(15 downto 7);
					wait on pt_done;
					update_tlb <= '1';
					tlb_write_ppn <= std_logic_vector(to_unsigned(mem_ppn_out, tlb_write_ppn'length));
					wait on tlb2_done;
					cache_write <= 1;
					cache_datain <= mem_data;
					cache_addr <= std_logic_vector(to_unsigned(mem_ppn_out, 4)) & virtual_add(6 downto 0);
					if cache_version = 1 then
						wait on cache1_done;
						cache_write <= 0;
						wait on cache1_done;
						output <= cache1_dataout;
					else
						wait on cache2_done;
						cache_write <= 0;
						wait on cache2_done;
						output <= cache2_dataout;
					end if;
						
				end if;
			
				end if;	
		
			end if;	
	ind <= (ind + 1) mod 20;	
	wait on virtual_add;	
	end process;


end behaviour;