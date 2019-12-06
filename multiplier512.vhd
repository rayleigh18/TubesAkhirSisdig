library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity multiplier512 is
	port(
		m, q : in std_logic_vector(7 downto 0);
		startIn,clk  : in std_logic;
		endOut        : out std_logic;
		res  : out std_logic_vector(15 downto 0);
		aOut, qOut : out std_logic_vector(7 downto 0)
	);
end multiplier512;

architecture io of multiplier512 is
	type typeState is (init,check, add, shift,keluar);
	signal p_state,n_state      : typeState := init;
	signal endSignal  : std_logic := '0';
	signal startSignal: std_logic := '0';
	signal carry      : std_logic := '0';
	signal qSig       : std_logic_vector(7 downto 0);
	signal aSig       : std_logic_vector(7 downto 0) := (others => '0');
	signal buff       : std_logic_vector(8 downto 0) := (others => '0');
	signal count      : integer := 8;
	signal r_clk      : std_logic;
	signal shiftSignal: std_logic;
	signal addSignal  : std_logic;

	--component 
begin
	process(p_state, clk, count, shiftSignal)
	begin
		if (rising_edge(clk)) then
			case p_state is
				when check =>
					if (count > 0) then 
						if (qSig(0) = '1') then
							p_state <= add; 
							addSignal <= '1';
						else
							p_state <= shift;
							shiftSignal <= '1';
						end if;
						count <= count - 1;
					else
						p_state <= keluar;
					end if;
				when add =>
					if addSignal = '1' then
						buff <= ('0' & m) + ('0' & aSig);
						addSignal <= '0';
					else 
						carry<= buff(8);
						aSig <= buff(7 downto 0);
						p_state <= shift;
						shiftSignal <= '1';
					end if;
				when shift =>
					if (shiftSignal = '1') then
						qSig <= '0' & qSig(7 downto 1);
						qSig(7) <= aSig(0);
						aSig <= '0' & aSig(7 downto 1);
						aSig(7) <= carry;
						carry <= '0';
						shiftSignal <= '0';
					else
						p_state <= check;
						shiftSignal <= '0';
					end if;
				when init =>
					qSig <= q;
					p_state <= check;
					endOut <= '0';
					--all initiation procedure put here
				when keluar =>
					endOut <= '1';
					p_state <= keluar;
					res <= aSig & qSig; 
			end case;
			aOut <= aSig;
			qOut <= qSig;
		end if;
	end process;

end io;