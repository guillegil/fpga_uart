library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Testbench signals

    -- signal CLK, SRST, TICK, EN, TX, DATA_SENT : std_logic := '0';
    -- signal DATA_IN : std_logic_vector(7 downto 0) := (others => '0');


-- UART_TX_Inst:
--     entity Work.uart_tx
--     port map(
--         CLK       => CLK,       -- Clock port
--         SRST      => SRST,      -- Synchronous reset (active high)
--         TICK      => TICK,      -- Tick signal from baudrate generator
--         EN        => EN,        -- Send Enable signal (when high starts transmitting DATA_IN)
--         DATA_IN   => DATA_IN,   -- Data to send
--         TX        => TX,        -- UART TX port
--         DATA_SENT => DATA_SENT  -- "Dara sent" port (inform that a new data has been transmitted)
--     ) ;


entity uart_tx is
  port (
    CLK       : in std_logic;
    SRST      : in std_logic;
    TICK      : in std_logic;
    EN        : in std_logic;
    DATA_IN   : in std_logic_vector(7 downto 0);
    TX        : out std_logic;
    DATA_SENT : out std_logic
  ) ;
end uart_tx;


architecture rtl of uart_tx is

    type states is (IDLE, START_BIT, DATA, STOP_BIT);
    signal current_state, next_state : states := IDLE;

    signal data_reg, data_next : std_logic_vector(7 downto 0) := (others => '0');

    signal tick_count, tick_count_next : natural range 0 to 15 := 0;
    signal data_count, data_count_next : natural range 0 to 7 := 0;

begin

    -- State register
    process
    begin
        wait until rising_edge(CLK);
        if SRST = '1' then
            current_state <= IDLE;
        else
            current_state <= next_state;

            data_reg <= data_next;
            tick_count <= tick_count_next;
            data_count <= data_count_next;
        end if;
    end process;

    -- Next state logic
    process(current_state, TICK, EN, tick_count, data_count)
    begin
        next_state <= current_state;
        data_next <= data_reg;
        tick_count_next <= tick_count;
        data_count_next <= data_count;

        DATA_SENT <= '0';

        case current_state is
        when IDLE =>
            data_next <= DATA_IN;
            if EN = '1' then
                next_state <= START_BIT;
            end if;
        when START_BIT =>
            data_count_next <= 0;
            if TICK = '1' then
                if tick_count = 15 then
                    tick_count_next <= 0;
                    next_state <= DATA;
                else
                    tick_count_next <= tick_count + 1;
                end if;
            end if;
        when DATA =>
            if TICK = '1' then
                if tick_count = 15 then
                    tick_count_next <= 0;
                    data_next <= '0' & data_reg(7 downto 1);

                    if data_count = 7 then
                        data_count_next <= 0;
                        next_state <= STOP_BIT;
                    else
                        data_count_next <= data_count + 1;
                    end if;
                else
                    tick_count_next <= tick_count + 1;
                end if;
            end if;
        when STOP_BIT =>
            if TICK = '1' then
                if tick_count = 15 then
                    tick_count_next <= 0;
                    next_state <= IDLE;
                    DATA_SENT <= '1';
                else
                    tick_count_next <= tick_count + 1;
                end if;
            end if;
        when others =>
            DATA_SENT <= '0';
            next_state <= current_state;
            data_next <= data_reg;
            tick_count_next <= tick_count;
            data_count_next <= data_count;
        end case;
    end process;

    with current_state select TX <=
        '0'         when START_BIT,
        data_reg(0) when DATA,
        '1'         when others;

end rtl ; -- rtl