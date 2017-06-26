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
	dataIn  : in  std_logic_vector(31 downto 0);
	data    : out std_logic_vector(31 downto 0);
	hit     : out std_logic
  ) ;
end entity ; -- Cache

architecture arch of Cache is

component dataArray is
  port (
	clock   : in  std_logic;
	address : in  std_logic_vector(5 downto 0);
	wren    : in  std_logic;
	wrdata  : in  std_logic_vector(31 downto 0);
	data    : out std_logic_vector(31 downto 0)
  ) ;
end component ; -- dataArray


signal wren1, wren2 : std_logic;
begin

da1 : dataArray port map (
	clock,
	address(11 downto 6),
	wren1,
	dataIn,
	data
	);

da2 : dataArray port map (
	clock,
	address(11 downto 6),
	wren2,
	dataIn,
	data
	);




end architecture ; -- arch