library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity top_level_vhd is
    port(
        clk  : in std_logic;
        sw   : in std_logic_vector(7 downto 0);
        butt : in std_logic_vector(1 downto 0)
    );
end top_level_vhd;

architecture tubes of top_level_vhd is

component  multiplier512 is
	port(
		m, q : in std_logic_vector(511 downto 0);
		startIn,clk  : in std_logic;
		endOut        : out std_logic;
		res  : out std_logic_vector(1023 downto 0);
		aOut, qOut : out std_logic_vector(511 downto 0)
	);
end component;

component input512 is
	port(
        clk     : in std_logic;
		enable  : in std_logic;
		sw      : in std_logic_vector(7 downto 0);
        butt    : in std_logic_vector(1 downto 0); --butt 1 for end, butt0 for geser
		outToTop: out std_logic_vector(511 downto 0)
	);
end component;

signal enableM, enableQ : std_logic := '0';
signal m,q :std_logic_vector(511 downto 0);
signal startIn, endOut : std_logic := '0';
signal res : std_logic_vector(1023 downto 0);

begin
	mSignal : input512 port map(
		clk => clk,
		enable => enableM,
		sw => sw,
		butt => butt,
		outToTop => m
	);
	qSignal : input512 port map(
		clk => clk,
		enable => enableQ,
		sw => sw,
		butt => butt,
		outToTop => q
	);

	mult : multiplier512 port map(
		m => m,
		q => q,
		startIn => startIn,
		clk => clk,
		endOut => endOut,
		res => res
	);

end tubes;
