--------------------------------------------------------------------------------
-- Author:        Mohammad Mahdi Rahimi (mohammadmahdi76@gmail.com)
--
-- Create Date:   26-05-2017
-- Module Name:   dataArray.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dataArray is
  port (
	clock   : in  std_logic;
	address : in  std_logic_vector(5 downto 0);
	wren    : in  std_logic;
	wrdata  : in  std_logic_vector(31 downto 0);
	data    : out std_logic_vector(31 downto 0)
  ) ;
end entity ; -- dataArray

architecture arch of dataArray is
	type dataArr is array (0 to 63) of std_logic_vector (31 downto 0);
begin

	dataArr_pro : process( clock )
		variable da : dataArr := (others => (others => '0'));
		variable ad : integer;
	begin
		if clock = '1' and clock'event then

			ad := to_integer(unsigned(address));

			if wren = '1' then -- Write
				da(ad) := wrdata;
			else -- Read
				data <= da(ad);
			end if;

		end if;
	end process ; -- dataArr_pro

end architecture ; -- arch