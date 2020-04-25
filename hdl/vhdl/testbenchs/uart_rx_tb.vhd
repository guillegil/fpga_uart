library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity uart_rx_tb is
end uart_rx_tb;


architecture testbench of uart_rx_tb is

    constant BAUD_RATE     : natural := 115200;
    constant CLOCK_FREQ_HZ : natural := 50000000; -- 50 MHz

    constant START_BIT     : std_logic := '0';
    constant STOP_BIT      : std_logic := '1';

    constant T : time := 20 ns; -- Clock period
    constant BIT_TIME  : time := 8.68 us; -- Bit time for a baudrate of 115200

    -- DUT Signals --
    signal CLK, SRST, TICK, RX, DATA_REC : std_logic := '0';
    signal DATA_OUT : std_logic_vector(7 downto 0) := (others => '0');

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

    signal data : std_logic_vector(7 downto 0);


begin

BAUD_RATE_GENERATOR:
    entity Work.br_gen
    generic map(
        BAUD_RATE     => 115200,
        CLOCK_FREQ_HZ => 50000000
    )
    port map(
        CLK  => CLK,            -- Input Clock signal at CLOCK_FREQ_HZ frequency
        SRST => SRST,           -- Synchronous reset, active high
        TICK_OUT => TICK        -- Tick out, use as "Clock Enable" input
    ); 

DUT: -- UART Receiver
    entity Work.uart_rx
    port map(
        CLK  => CLK,    -- Clock port
        SRST => SRST,   -- Synchronous reset (active high)
        TICK => TICK,   -- Tick signal from baudrate generator
        RX   => RX,     -- UART RX port
        DATA_OUT => DATA_OUT,   -- Data received from rx line
        DATA_REC => DATA_REC    -- "Dara received" port (inform of a new data)
    );

    CLK <= not(CLK) after (T/2);


    process
    begin
        RX <= '1'; -- IDLE state of RX

        -- Reset system
        SRST <= '1';
        wait for 2*T;
        SRST <= '0';


        for data_idx in 0 to 7 loop     -- Send multiple data
            data <= data_to_send(data_idx);

            RX <= START_BIT;
            wait for BIT_TIME;

            for bit_idx in 0 to 7 loop
                RX <= data(bit_idx);
                wait for BIT_TIME;
            end loop;

            RX <= STOP_BIT;
            wait for BIT_TIME;

            assert DATA_OUT = data
            report "Data received: " & integer'image(to_integer(unsigned(DATA_OUT))) & 
            " not match with the data sent: " & integer'image(to_integer(unsigned(data)))
            severity failure;
        end loop;

        report "SIMULATION COMPLETED SUCCESSFULLY!"
        severity failure;
    end process;

end testbench ; -- testbench