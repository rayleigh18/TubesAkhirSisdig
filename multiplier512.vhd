library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier512 is
	port(
		m, q : in std_logic_vector(7 downto 0);
		startIn,clk  : in std_logic;
		endOut        : out std_logic;
		res  : out std_logic_vector(15 downto 0)
	);
end multiplier;

architecture i/o of multiplier512 is
	signal endSignal  : std_logic := 0;
	signal startSignal: std_logic := 0;
	signal carry      : std_logic := 0;
	signal A          : std_logic_vector(7 downto 0) := (others => '0');
	signal count      : integer := 8;

	component 
begin
	process(startIn, endSignal)
	begin
		if startIn = '1' and endSignal = '0' then
			startSignal = '1';
		end if;
		if endSignal = '1' then
			startSignal = '0';
		end if;
	end process;

	process(startSignal, r_clk)
		if rising_edge(r_clk) then
	end if;

end i/o;