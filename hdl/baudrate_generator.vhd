library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- br_gen_inst:
--     entity Work.br_gen
--     generic map(
--         BAUD_RATE     => BAUD_RATE,
--         CLOCK_FREQ_HZ => CLOCK_FREQ_HZ
--     )
--     port map(
--         CLK  => CLK,  -- Input Clock signal at CLOCK_FREQ_HZ frequency
--         SRST => SRST, -- Synchronous reset, active high
--         TICK_OUT => TICK_OUT -- Tick out, use as "Clock Enable" input
--     );

entity br_gen is
    generic(
        BAUD_RATE      : natural := 115200;
        CLOCK_FREQ_HZ  : natural := 50000000
    );
    port (
        CLK         : in std_logic;
        SRST        : in std_logic;
        TICK_OUT    : out std_logic
    );
end br_gen;

architecture rtl of br_gen is

    constant SAMPLES_PER_BIT : natural := 16;
    constant SAMPLES         : natural := (SAMPLES_PER_BIT * BAUD_RATE);
    constant DIV_VALUE       : natural := (CLOCK_FREQ_HZ / SAMPLES);

    signal frc : natural range 0 to DIV_VALUE := 0;
    signal frc_tc : std_logic := '0';

begin

    process
    begin
        wait until rising_edge(CLK);
        if SRST = '1' then
            frc <= 0;
        else
            if frc_tc = '1' then
                frc <= 0;
            else
                frc <= frc + 1;
            end if;
        end if;
    end process;

    frc_tc <= '1' when (frc = DIV_VALUE - 1) else '0';
    
    TICK_OUT <= frc_tc;         

end rtl ; -- rtl