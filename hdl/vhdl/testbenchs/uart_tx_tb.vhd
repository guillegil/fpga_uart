library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity uart_tx_tb is
end uart_tx_tb;

architecture testbench of uart_tx_tb is

    constant BAUD_RATE : natural := 115200;
    constant CLOCK_FREQ_HZ : natural := 50000000; -- 50 MHz

    constant CLOCK_T   : time := 20 ns;     -- Clock period
    constant BIT_TIME  : time := 8.68 us; -- Bit time for a baudrate of 115200

    constant START_BIT : std_logic := '0';
    constant STOP_BIT  : std_logic := '1';

    signal TICK_OUT : std_logic := '0';

    signal CLK, SRST, TICK, EN, TX, DATA_SENT : std_logic := '0';
    signal DATA_IN : std_logic_vector(7 downto 0) := (others => '0');

    -- Test signals -- 
    type data_t is array(0 to 7) of std_logic_vector(7 downto 0);
    constant data_to_send : data_t := (
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

BAUDRATE_GEN:
    entity Work.br_gen
    generic map(
        BAUD_RATE     => BAUD_RATE,
        CLOCK_FREQ_HZ => CLOCK_FREQ_HZ
    )
    port map(
        CLK  => CLK,            -- Input Clock signal at CLOCK_FREQ_HZ frequency
        SRST => SRST,           -- Synchronous reset, active high
        TICK_OUT => TICK_OUT    -- Tick out, use as "Clock Enable" input
    );

    TICK <= TICK_OUT;

DUT:
    entity Work.uart_tx
    port map(
        CLK       => CLK,       -- Clock port
        SRST      => SRST,      -- Synchronous reset (active high)
        TICK      => TICK,      -- Tick signal from baudrate generator
        EN        => EN,        -- Send Enable signal (when high starts transmitting DATA_IN)
        DATA_IN   => DATA_IN,   -- Data to send
        TX        => TX,        -- UART TX port
        DATA_SENT => DATA_SENT  -- "Dara sent" port (inform that a new data has been transmitted)
    ) ;


    CLK <= not CLK after (CLOCK_T/2);

    process
    begin
        -- Reset stim
        SRST <= '1';
        wait for 2*CLOCK_T;
        SRST <= '0';


        for data_idx in 0 to 7 loop     -- Send multiple data
            DATA_IN <= data_to_send(data_idx);
            wait for CLOCK_T;
            EN <= '1';

            wait for (BIT_TIME/2);
            assert TX = START_BIT
            report "Incorrect value for start bit"
            severity failure;

            EN <= '0';

            for bit_idx in 0 to 7 loop
                wait for (BIT_TIME);
                assert TX = data_to_send(data_idx)(bit_idx)
                report "Data sent does not math with test bit written"
                severity failure;
            end loop;

            wait for (BIT_TIME);
            assert TX = STOP_BIT
            report "Incorrect value for stop bit"
            severity failure;

            wait for (BIT_TIME/2);

        end loop;

        report "SIMULATION COMPLETED SUCCESSFULLY!"
        severity failure;
    end process;

end testbench ; -- testbench