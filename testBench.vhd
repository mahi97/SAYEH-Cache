--------------------------------------------------------------------------------
-- Author:        Mohammad Mahdi Rahimi (mohammadmahdi76@gmail.com)
--
-- Create Date:   26-05-2017
-- Module Name:   Cache.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testBench is
end entity ; -- testBench

architecture arch of testBench is

	component cacheController is
	  port (
		clock, readmem, writemem, reset_n : in std_logic;
		address : in std_logic_vector(15 downto 0);
		databus : inout std_logic_vector(31 downto 0)
	  ) ;
	end component ; -- cacheController

	signal clock, readmem, writemem, reset_n : std_logic := '0';
	signal address : std_logic_vector(15 downto 0) ;
	signal databus : std_logic_vector(31 downto 0) ;

begin

	cc : cacheController port map (
		clock,
		readmem,
		writemem,
		reset_n,
		address,
		databus
		);

	clock <= not (clock) after 5 ns WHEN now < 10000 ns ELSE clock;
	reset_n  <= '1', '0' after 10 ns;
	writemem <= '1', '0' after 100 ns, '1' after 200 ns;
	readmem  <= '0', '1' after 100 ns, '0' after 200 ns;
	
	address <= "0000000000000000", "1111111111111111" after 150 ns;
	databus <= "00000000111111110000000011111111", "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" after 100 ns;


end architecture ; -- arch
