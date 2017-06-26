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



begin



end architecture ; -- arch