--------------------------------------------------------------------------------
-- Author:        Mohammad Mahdi Rahimi (mohammadmahdi76@gmail.com)
--
-- Create Date:   26-05-2017
-- Module Name:   tagValidArray.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tagValidArray is
  port (
	clock, reset_n : in  std_logic;
	address        : in  std_logic_vector(5 downto 0) ;
	wren           : in  std_logic;
	invalidate     : in  std_logic;
	wrdata         : in  std_logic_vector(3 downto 0) ;
	data_out       : out std_logic_vector(4 downto 0)
  ) ;
end entity ; -- tagValidArray

architecture arch of tagValidArray is

	type tvarr is array (0 to 63) of std_logic_vector (4 downto 0);

begin

	tagValid_pro : process( clock, reset_n )
		variable tv : tvarr := (others => (others => '0'));
		variable ad : integer;
	begin
		if clock = '1' and clock'event then 
			
			ad := to_integer(unsigned(address));

			if reset_n = '1' then
				tv := (others => (others => '0'));
			end if;

			if wren = '1' then -- Write
				tv(ad) := not invalidate & wrdata;
			else -- Read
				data_out <= tv(ad);
			end if;

		end if;
	end process ; -- tagValid_pro

end architecture ; -- arch