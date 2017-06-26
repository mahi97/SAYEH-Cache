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
	data    : out std_logic_vector(31 downto 0);
	status  : out std_logic_vector(4 downto 0)
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

signal wren0, wren1 : std_logic;
signal w0, w1 : std_logic_vector(4 downto 0) ;
signal w0_valid, w1_valid : std_logic;
signal reset_n : std_logic;
signal invalidate : std_logic;
begin

da0 : dataArray port map (
	clock,
	address(11 downto 6),
	wren0,
	dataIn,
	data
	);

da1 : dataArray port map (
	clock,
	address(11 downto 6),
	wren1,
	dataIn,
	data
	);

tva0 : tagValidArray port map (
	clock, reset_n,
	address(11 downto 6),
	wren0,
	invalidate,
	address(15 downto 12),
	w0
	);

tva1 : tagValidArray port map (
	clock, reset_n,
	address(11 downto 6),
	wren1,
	invalidate,
	address(15 downto 12),
	w1
	);

mhl : missHitLogic port map (
	address(15 downto 12),
	w0,
	w1,
	hit,
	w0_valid,
	w1_valid
	);




end architecture ; -- arch