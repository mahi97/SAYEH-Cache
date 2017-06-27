--------------------------------------------------------------------------------
-- Author:        Mohammad Mahdi Rahimi (mohammadmahdi76@gmail.com)
--
-- Create Date:   26-05-2017
-- Module Name:   MRUPolicy.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MRUPolicy is
  port (
	clock      : in  std_logic;
	recentUsed : in  std_logic;
	replace    : out std_logic
  ) ;
end entity ; -- MRUPolicy

architecture arch of MRUPolicy is
begin
	mru_process : process( clock )
	begin
		if clock = '1' and clock'event then
			if recentUsed = '1' then
				replace <= '0';
			else
				replace <= '1';
			end if;
		end if;
	end process ; -- mru_process


end architecture ; -- arch