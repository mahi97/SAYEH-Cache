--------------------------------------------------------------------------------
-- Author:        Mohammad Mahdi Rahimi (mohammadmahdi76@gmail.com)
--
-- Create Date:   26-05-2017
-- Module Name:   Cache.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cache is
  port (
	clock   : in  std_logic;
	address : in  std_logic_vector(15 downto 0);
	data    : out std_logic_vector(31 downto 0);
	hit     : out std_logic
  ) ;
end entity ; -- Cache

architecture arch of Cache is

begin



end architecture ; -- arch