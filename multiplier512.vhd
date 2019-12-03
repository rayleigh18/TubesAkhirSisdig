library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier512 is
	port(
		m, q : in std_logic_vector(7 downto 0);
		res  : out std_logic_vector(7 downto 0)
	);
end multiplier;

		