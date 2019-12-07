library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity input512 is
	port(
        clk     : in std_logic;
		enable  : in std_logic;
		sw      : in std_logic_vector(7 downto 0);
        butt    : in std_logic_vector(1 downto 0); --butt 1 for end, butt0 for geser
		outToTop: out std_logic_vector(511 downto 0)
	);
end input512;

architecture inp of input512 is
    type inputStateL is (mInput, mGeser);
    signal inputState : inputStateL := mInput;
    signal place : integer := 0;
    signal placeUp : integer := 7;
    signal state : std_logic := '0';
    signal ans   : std_logic_vector(511 downto 0) := (others => '0');
    signal geser : std_logic := '0';
    signal endInpSignal: std_logic := '1';
    signal rclk : std_logic;

    component CLOCKDIV is
        port(
            CLK     : IN STD_LOGIC;
            DIVOUT  : buffer STD_LOGIC;
            div     : in integer
        );
    end component;

begin
    real_clock : CLOCKDIV port map(
			CLK    => clk,
			DIVOUT => rclk,
			div	   => 1250000
		);
    process(clk, butt(0), rclk)
    begin
        if (rising_edge(rclk)) then
            if (enable = '0' ) then
                inputState <= mInput;
                place   <= 0;
                placeUp <= 7;
            elsif (butt(0) = '0') then
                case inputState is
                    when mInput =>
                        if (butt(0) = '0') then
                            inputState <= mGeser;
                            geser  <= '1';
                        end if;
                    when mGeser =>
                        if (geser  = '0') then
                            inputState <= mInput;
                        else 
                            ans(placeUp downto place) <= sw(7 downto 0);
                            geser <= '0';
                            place <= place + 8;
                            placeUp <= placeUp + 8;
                        end if;
                end case;
            elsif (butt(1) = '0') then
                endInp <= '1';
            end if;

            outToTop <= ans;
        end if;
    end process;
end inp;

