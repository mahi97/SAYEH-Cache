--------------------------------------------------------------------------------
-- Author:        Mohammad Mahdi Rahimi (mohammadmahdi76@gmail.com)
--
-- Create Date:   26-05-2017
-- Module Name:   dataSelection.vhd
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dataSelection is
  port (
		clock : in std_logic;
		data0 : in std_logic_vector(31 downto 0) ;
		data1 : in std_logic_vector(31 downto 0) ;
		w0_valid : in std_logic;
		w1_valid : in std_logic;
		data : out std_logic_vector(31 downto 0);
		selectedWay : out std_logic
	  ) ;
end entity ; -- dataSelection

architecture arch of dataSelection is
begin
	dataselection_pro : process( clock )
	begin
		if w0_valid = '1' then
			data <= data0;
			selectedWay <= '0';
		elsif w1_valid  = '1' then
			data <= data1;
			selectedWay <= '1';
		end if;
	end process ; -- dataselection_pro

end architecture ; -- arch