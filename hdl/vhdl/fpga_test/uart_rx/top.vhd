library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
  port (
    MCLK_P  : in std_logic;
    MCLK_N  : in std_logic;  
    MRST    : in std_logic;
    RX      : in std_logic;
    LEDS    : out std_logic_vector(7 downto 0)
  ) ;
end top;

architecture rtl of top is

    constant BAUD_RATE     : natural := 115200;
    constant CLOCK_FREQ_HZ : natural := 50000000; -- 50 MHz

    signal clk, srst: std_logic := '0';
    signal tick_out : std_logic := '0';
    
    -- MMCM signals
    signal locked : std_logic := '0';

begin

MMCM:
    entity Work.mmcm
    port map(clk_in1_p => MCLK_P, clk_in1_n => MCLK_N, reset => MRST, clk => clk, locked => locked);

    srst <= not locked; -- Reset keeps high while mmcm is not locked; 

BAUD_RATE_GENERATOR:
    entity Work.br_gen
    generic map(BAUD_RATE => BAUD_RATE, CLOCK_FREQ_HZ => CLOCK_FREQ_HZ)
    port map(CLK  => clk, SRST => srst, TICK_OUT => tick_out);

UART_RX:
    entity Work.uart_rx
    port map(CLK  => clk, SRST => srst, TICK => tick_out, RX => RX, DATA_OUT => LEDS, DATA_REC => open);


end rtl ; -- rtl