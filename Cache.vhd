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
	clock, reset_n  : in  std_logic;
	writeCache      : in  std_logic;
	address         : in  std_logic_vector(9 downto 0);
	dataIn          : in  std_logic_vector(31 downto 0);
	data            : out std_logic_vector(31 downto 0);
	hit             : out std_logic
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

	component missHitLogic is
	  port (
		tag      : in  std_logic_vector(3 downto 0) ;
		w0       : in  std_logic_vector(4 downto 0) ;
		w1       : in  std_logic_vector(4 downto 0) ;
		hit      : out std_logic;
		w0_valid : out std_logic;
		w1_valid : out std_logic
	  ) ;
	end component ; -- missHitLogic

	component tagValidArray is
	  port (
		clock, reset_n : in  std_logic;
		address        : in  std_logic_vector(5 downto 0) ;
		wren           : in  std_logic;
		invalidate     : in  std_logic;
		wrdata         : in  std_logic_vector(3 downto 0) ;
		data_out       : out std_logic_vector(4 downto 0)
	  ) ;
	end component ; -- tagValidArray

	component dataSelection is
	  port (
		clock : in std_logic;
		data0 : in std_logic_vector(31 downto 0) ;
		data1 : in std_logic_vector(31 downto 0) ;
		w0_valid : in std_logic;
		w1_valid : in std_logic;
		data : out std_logic_vector(31 downto 0);
		selectedWay : out std_logic
	  ) ;
	end component ; -- dataSelection

	component MRUPolicy is
  		port (
			clock      : in  std_logic;
			recentUsed : in  std_logic;
			replace    : out std_logic
  		) ;
	end component ; -- MRUPolicy

	signal wren0, wren1 : std_logic;
	signal w0, w1 : std_logic_vector(4 downto 0) ;
	signal w0_valid, w1_valid : std_logic;
	signal invalidate : std_logic;
	signal data0, data1 : std_logic_vector(31 downto 0) ;
	signal replace, recentUsed : std_logic;
	signal selectedWay : std_logic;
begin

	da0 : dataArray port map (
		clock,
		address(5 downto 0),
		wren0,
		dataIn,
		data0
		);

	da1 : dataArray port map (
		clock,
		address(5 downto 0),
		wren1,
		dataIn,
		data1
		);

	tva0 : tagValidArray port map (
		clock, reset_n,
		address(5 downto 0),
		wren0,
		invalidate,
		address(9 downto 6),
		w0
		);

	tva1 : tagValidArray port map (
		clock, reset_n,
		address(5 downto 0),
		wren1,
		invalidate,
		address(9 downto 6),
		w1
		);

	mhl : missHitLogic port map (
		address(9 downto 6),
		w0,
		w1,
		hit,
		w0_valid,
		w1_valid
		);

	ds : dataSelection port map (
		clock,
		data0,
		data1,
		w0_valid,
		w1_valid,
		data,
		selectedWay
		);

	mru : MRUPolicy port map (
		clock,
		recentUsed,
		replace
		);

	cache_pro : process( clock )
	begin
		if clock = '1' and clock'event then
			if reset_n = '1' then -- Reset

			elsif writeCache = '1' then -- write
				if w0_valid = '0' then
					wren0 <= '1';
					wren1 <= '0';
					recentUsed <= '0';
				elsif w1_valid = '0' then
					wren0 <= '0';
					wren1 <= '1';
					recentUsed <= '1';
				elsif replace = '0' then
					wren0 <= '1';
					wren1 <= '0';
					recentUsed <= '0';
				else
					wren0 <= '1';
					wren1 <= '0';
					recentUsed <= '1';
				end if;	
			else -- Read
				wren0 <= '0';
				wren1 <= '0';
				recentUsed <= selectedWay;
			end if;
		end if;
	end process ; -- cache_pro


end architecture ; -- arch