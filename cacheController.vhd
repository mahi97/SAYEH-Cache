--------------------------------------------------------------------------------
-- Author:        Mohammad Mahdi Rahimi (mohammadmahdi76@gmail.com)
--
-- Create Date:   26-05-2017
-- Module Name:   CacheController.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cacheController is
  port (
	clock, readmem, writemem : in std_logic;
	address : in std_logic_vector(15 downto 0);
	databus : inout std_logic_vector(31 downto 0)
  ) ;
end entity ; -- cacheController

architecture arch of cacheController is

component memory is
	port (clk, readmem, writemem : in std_logic;
		addressbus: in std_logic_vector (15 downto 0);
		databus : inout std_logic_vector (31 downto 0);
		memdataready : out std_logic);
end component;

component Cache is
  port (
	clock   : in  std_logic;
	address : in  std_logic_vector(9 downto 0);
	dataIn  : in  std_logic_vector(31 downto 0);
	data    : out std_logic_vector(31 downto 0);
	hit     : out std_logic
  ) ;
end component ; -- Cache


signal cache_data_out : std_logic_vector(31 downto 0) ;
signal dataIn : std_logic_vector(31 downto 0) ;
signal mem_data : std_logic_vector(31 downto 0) ;
signal memdataready : std_logic;
signal hit : std_logic;
begin

c : Cache port map (
	clock,
	address(15 downto 6),
	dataIn,
	cache_data_out,
	hit
	);

m : memory port map (
	clock, readmem, writemem,
	address,
	mem_data,
	memdataready
	);

controller : process( clock )
begin
	if clock = '1' and clock'event then
		if readmem = '1' then
			if hit = '1' then 
				databus <= cache_data_out;
			else
				if memdataready = '1' then
					databus <= mem_data;
					dataIn <= mem_data;
				end if;
			end if;
		else -- write
			if hit = '1' then 
				dataIn <= databus;
			else
				mem_data <= databus;
				dataIn <= databus;
			end if;
		end if;
		
	end if;
end process ; -- controller


end architecture ; -- arch