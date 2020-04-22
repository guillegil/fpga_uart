library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity br_gen_tb is
end br_gen_tb;

architecture testbench of br_gen_tb is

    constant T : time := 20 ns; -- Clock period
    -- constant BIT_TICKS : real := (50000000.0 / 115200.0);
    constant BIT_TIME  : time := 8.68 us;

    signal CLK, SRST, TICK_OUT : std_logic := '0';

    -- Test signals
    signal tick_counter : integer := 0;

begin

DUT:
    entity Work.br_gen
    generic map(
        BAUD_RATE     => 115200,
        CLOCK_FREQ_HZ => 50000000
    )
    port map(
        CLK  => CLK,  -- Input Clock signal at CLOCK_FREQ_HZ frequency
        SRST => SRST, -- Synchronous reset, active high
        TICK_OUT => TICK_OUT -- Tick out, use as "Clock Enable" input
    ); 

    CLK <= not(CLK) after (T/2);

TICK_COUNTER_PROC:
    process
    begin
        wait until rising_edge(CLK);
        if SRST = '1' then
            tick_counter <= 0;
        else
            if TICK_OUT = '1' then
                tick_counter <= tick_counter + 1; 
            end if;
        end if;
    end process;


    process
    begin
        -- Toggle reset
        SRST <= '1';
        wait for (2*T);
        SRST <= '0';     

        -- Check a single bit time.
        wait for BIT_TIME; 
        assert tick_counter = 16
            report "Ticks after a bit time must be 16 and are " & integer'image(tick_counter)
            severity error; 
        
        -- Check the rest of the UART frame (1 start bit + 8 data bits + 1 stop bits)
        wait for (BIT_TIME * 9);
        assert tick_counter = 160 
            report "Ticks after a complete UART frame must be 160 and are " & integer'image(tick_counter)
            severity error;

        
        report "SIMULATION COMPLETED SUCCESSFULLY!" severity failure; 
    end process;

end testbench ; -- testbench