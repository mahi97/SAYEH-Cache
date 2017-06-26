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



begin



end architecture ; -- arch