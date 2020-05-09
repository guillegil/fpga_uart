library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- UART_RX_Inst:
--     entity Work.uart_rx
--     port map(
--         CLK  => CLK,    -- Clock port
--         SRST => SRST,   -- Synchronous reset (active high)
--         TICK => TICK,   -- Tick signal from baudrate generator
--         RX   => RX,     -- UART RX port
--         DATA_OUT => DATA_OUT,   -- Data received from rx line
--         DATA_REC => DATA_REC    -- "Dara received" port (inform of a new data)
--     );


entity uart_rx is
  port (
    CLK         : in std_logic;
    SRST        : in std_logic;
    TICK        : in std_logic;
    RX          : in std_logic;
    DATA_OUT    : out std_logic_vector(7 downto 0);
    DATA_REC    : out std_logic
  ) ;
end uart_rx;

architecture rtl of uart_rx is
    
    type states is (IDLE, START_BIT, DATA, STOP_BIT);
    signal current_state, next_state : states := IDLE;

    signal tick_count, tick_count_next : unsigned(3 downto 0) := (others => '0');
    signal data_count, data_count_next : unsigned(3 downto 0) := (others => '0');
    signal data_buffer, data_buffer_next : std_logic_vector(7 downto 0) := (others => '0');

    signal data_received : std_logic := '0';

begin

state_register : 
    process 
    begin
        wait until rising_edge(CLK);
        if SRST = '1' then
            current_state <= IDLE;
        else
            current_state <= next_state;

            tick_count <= tick_count_next;
            data_count <= data_count_next;
            data_buffer <= data_buffer_next;
        end if;
    end process ; -- state_register

next_state_logic :
    process(current_state, tick_count, data_count, RX, TICK)
    begin
        next_state <= current_state;
        tick_count_next <= tick_count;
        data_count_next <= data_count;
        data_buffer_next <= data_buffer;
        data_received <= '0';

        case current_state is
            when IDLE =>
                tick_count_next <= (others => '0');
                if RX = '0' then
                    next_state <= START_BIT;
                end if;
            when START_BIT =>
                data_count_next <= (others => '0');
                if TICK = '1' then
                    if tick_count = 7 then
                        tick_count_next <= (others => '0');
                        data_buffer_next <= (others => '0');
                        next_state <= DATA;
                    else
                        tick_count_next <= tick_count + 1;
                    end if;
                end if;
            when DATA => 
                if TICK = '1' then
                    if tick_count = 15 then
                        tick_count_next <= (others => '0');
                        data_buffer_next <= RX & data_buffer(7 downto 1);

                        if data_count = 7 then
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
                        tick_count_next <= (others => '0');
                        next_state <= IDLE;
                        if RX = '1' then
                            data_received <= '1';
                        end if;
                    else
                        tick_count_next <= tick_count + 1;
                    end if;
                end if;
            when others =>
                next_state <= current_state;
                tick_count_next <= tick_count;
                data_count_next <= data_count;
                data_buffer_next <= data_buffer;
                data_received <= '0';
        end case;
    end process;

    DATA_OUT <= data_buffer;
    DATA_REC <= data_received;

end rtl ; -- rtl