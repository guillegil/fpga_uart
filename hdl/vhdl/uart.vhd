library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- UART_Inst:
--   entity Work.uart
--   generic map(
--     BAUD_RATE      => BAUD_RATE,
--     CLOCK_FREQ_HZ  => CLOCK_FREQ_HZ
--   )
--   port map(
--     CLK       => CLK,
--     SRST      => SRST,
--     SE        => SE,
--     DATA_IN   => DATA_IN,
--     RX        => RX,
--     TX        => TX,
--     DATA_REC  => DATA_REC,
--     DS        => DS,
--     DR        => DR
--   ) ;

-- constant BAUD_RATE      : natural := 115200;
-- constant CLOCK_FREQ_HZ  : natural := 50000000;

-- signal CLK, SRST, SE, RX, TX, DS, DR : std_logic := '0';
-- signal DATA_IN, DATA_REC : std_logic_vector(7 downto 0) := (others => '0');

entity uart is
  generic (
    BAUD_RATE      : natural := 115200;
    CLOCK_FREQ_HZ  : natural := 50000000
  );
  port (
    CLK       : in std_logic;
    SRST      : in std_logic;
    SE        : in std_logic; -- Send enable
    DATA_IN   : in std_logic_vector(7 downto 0);
    RX        : in std_logic;
    TX        : out std_logic;
    DATA_REC  : out std_logic_vector(7 downto 0);
    DS        : out std_logic;  -- Data sent
    DR        : out std_logic   -- Data received
  ) ;
end uart;

architecture rtl of uart is

    signal baudrate_gen_tick : std_logic := '0';

begin

BAUDRATE_GENERATOR:
    entity Work.br_gen
    generic map(BAUD_RATE => BAUD_RATE, CLOCK_FREQ_HZ => CLOCK_FREQ_HZ)
    port map(CLK  => CLK, SRST => SRST, TICK_OUT => baudrate_gen_tick);

UART_TX:
    entity Work.uart_tx
    port map(
        CLK       => CLK,       
        SRST      => SRST,     
        TICK      => baudrate_gen_tick,     
        EN        => SE,       
        DATA_IN   => DATA_IN,   
        TX        => TX,        
        DATA_SENT => DS  
    ) ;

UART_RX:
    entity Work.uart_rx
    port map(
        CLK      => CLK,    
        SRST     => SRST,   
        TICK     => baudrate_gen_tick,   
        RX       => RX,     
        DATA_OUT => DATA_REC,   
        DATA_REC => DR    
    );

end rtl ; -- rtl