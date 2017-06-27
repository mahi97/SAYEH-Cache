--------------------------------------------------------------------------------
-- Author:        Mohammad Mahdi Rahimi (mohammadmahdi76@gmail.com)
--
-- Create Date:   26-05-2017
-- Module Name:   missHitLogic.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity missHitLogic is
  port (
	tag      : in  std_logic_vector(3 downto 0) ;
	w0       : in  std_logic_vector(4 downto 0) ;
	w1       : in  std_logic_vector(4 downto 0) ;
	hit      : out std_logic;
	w0_valid : out std_logic;
	w1_valid : out std_logic
  ) ;
end entity ; -- missHitLogic

architecture arch of missHitLogic is

signal valid0 : std_logic;
signal valid1 : std_logic;

begin

	valid0 <= '1' when w0(4) = '1' and tag = w0(3 downto 0) else '0';
	valid1 <= '1' when w1(4) = '1' and tag = w1(3 downto 0) else '0';
	hit    <= '1' when valid0 = '1' or valid1 = '1' else '0';
	w0_valid <= valid0;
	w1_valid <= valid1;
	
end architecture ; -- arch