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



end architecture ; -- arch