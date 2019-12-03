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
	type typeState is (init,check, add, shift,keluar, do_nothing);
	signal p_state,n_state      : typeState : init;
	signal endSignal  : std_logic := 0;
	signal startSignal: std_logic := 0;
	signal carry      : std_logic := 0;
	signal qSig       : std_logic_vector(7 downto 0);
	signal aSig       : std_logic_vector(7 downto 0) := (others => '0');
	signal buff       : std_logic_vector(8 downto 0) := (others => '0');
	signal count      : integer := 8;
	signal r_clk      : std_logic;
	signal shiftSignal: std_logic;

	--component 
begin
	process(p_state)
	begin
		if (rising_edge(r_clk)) then
			case p_state is
				when check =>
					if (count > 0) then 
						if (qSig(0) = '1') then
							p_state <= add; 
						else
							p_state <= shift;
						end if;
						count <= count - 1;
					else
						p_state <= keluar;
					end if;
				when add =>
					buff <= ('0'& m) + ('0' & qSig);
					carry<= buff(8);
					qSig <= buff(7 downto 0);
					p_state <= shift;
				when shift =>
					if (shiftSignal = '1') then
						--add Shifting Procedure, using component, use 4 clockCycle, shiftSignal will be Output
					else
						p_state <= check;
						shiftSignal = '0';
					end if;
				when init =>
					qSig <= q;
					p_state <= check;
					--all initiation procedure put here
				when keluar =>
					endOut <= '1';
					p_state <= keluar;
			end case;
		end if;
	end process;

end i/o;