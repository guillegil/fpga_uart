library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is
  port (
    MCLK_P      : in std_logic;
    MCLK_N      : in std_logic;
    SEND        : in std_logic;
    DATA_IN     : in std_logic_vector(7 downto 0);
    DATA_OUT    : out std_logic_vector(7 downto 0);
    TX          : out std_logic;
    RX          : in std_logic
  ) ;
end top;

architecture test_uart of top is

    constant BAUD_RATE      : natural := 115200;
    constant CLOCK_FREQ_HZ  : natural := 50000000;

    signal clk, locked, srst : std_logic := '0';

    signal se_reg : std_logic_vector(1 downto 0) := (others => '0');
    signal se : std_logic := '0';
begin

MMCM:
    entity Work.mmcm
    port map(clk_in1_p => MCLK_P, clk_in1_n => MCLK_N, reset => '0', clk => clk, locked => locked);

    srst <= not locked; -- Reset keeps high while mmcm is not locked; 


    se_reg <= SEND & se_reg(1) when rising_edge(clk);
    se <= not se_reg(0) and se_reg(1);

UART:
  entity Work.uart
  generic map(
    BAUD_RATE      => BAUD_RATE,
    CLOCK_FREQ_HZ  => CLOCK_FREQ_HZ
  )
  port map(
    CLK       => clk,
    SRST      => srst,
    SE        => se,
    DATA_IN   => DATA_IN,
    RX        => RX,
    TX        => TX,
    DATA_REC  => DATA_OUT,
    DS        => open,
    DR        => open
  ) ;


end test_uart ; 