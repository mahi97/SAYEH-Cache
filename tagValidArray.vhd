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



begin



end architecture ; -- arch