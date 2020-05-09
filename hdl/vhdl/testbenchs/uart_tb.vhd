library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tb is
end uart_tb;

architecture testbech of uart_tb is

    constant BAUD_RATE      : natural := 115200;
    constant CLOCK_FREQ_HZ  : natural := 50000000;

    constant BIT_TIME_FOR_115200 : time := 8.68 us; -- Bit time for a baudrate of 115200



    constant CLOCK_T   : time := 20 ns;     -- Clock period
    constant BIT_TIME  : time := BIT_TIME_FOR_115200;

    constant START_BIT : std_logic := '0';
    constant STOP_BIT  : std_logic := '1';

    signal CLK, SRST, SE, RX, TX, DS, DR : std_logic := '0';
    signal DATA_IN, DATA_REC : std_logic_vector(7 downto 0) := (others => '0');

    type test_vector_t is array(0 to 7) of std_logic_vector(7 downto 0);
    constant test_vector : test_vector_t := (
        x"12",
        x"98",
        x"00",
        x"FF", 
        x"33",
        x"C0",
        x"A7",
        x"EF"
    );

begin

DUT:
  entity Work.uart
  generic map(
    BAUD_RATE      => BAUD_RATE,
    CLOCK_FREQ_HZ  => CLOCK_FREQ_HZ
  )
  port map(
    CLK       => CLK,
    SRST      => SRST,
    SE        => SE,
    DATA_IN   => DATA_IN,
    RX        => RX,
    TX        => TX,
    DATA_REC  => DATA_REC,
    DS        => DS,
    DR        => DR
  ) ;

    CLK <= not(CLK) after (CLOCK_T/2);

    RX <= TX;  -- Simulate physical connection between two devices

    process
    begin
        SRST <= '1';
        wait for (CLOCK_T * 2);
        SRST <= '0';
        
        for idx in 0 to 7 loop
            DATA_IN <= test_vector(idx);
            SE <= '1';
            wait for (CLOCK_T * 2);
            SE <= '0';
            
            wait for (BIT_TIME * 10);
            
        end loop;

        SE <= '0';
        
        report "SIMULATION COMPLETED SUCCESSFULLY!"
        severity failure;
    end process;


    process
    begin
        wait until rising_edge(CLK);
        if DR = '1' then
            assert DATA_IN = DATA_REC
            report "Data received does not match with data sent"
            severity failure;
        end if;
    end process;

end testbech ; 