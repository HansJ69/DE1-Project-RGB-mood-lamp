library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_rainbow_pwm is
end tb_rainbow_pwm;

architecture Behavioral of tb_rainbow_pwm is

    component rainbow_pwm
        Port (
            clk        : in  STD_LOGIC;
            rst        : in  STD_LOGIC;
            speed_sel  : in  unsigned(1 downto 0);
            bright_sel : in  unsigned(1 downto 0);
            led_r, led_g, led_b : out STD_LOGIC
        );
    end component;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal speed_sel  : unsigned(1 downto 0) := "00";
    signal bright_sel : unsigned(1 downto 0) := "11";
    signal led_r, led_g, led_b : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin
    uut: rainbow_pwm port map (
        clk => clk, rst => rst,
        speed_sel => speed_sel, bright_sel => bright_sel,
        led_r => led_r, led_g => led_g, led_b => led_b
    );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_proc: process
    begin
        -- Reset
        rst <= '1';
        wait for 100 ns;
        rst <= '0';

        -- Výchozí stav: Nejvyšší rychlost, 100% jas
        speed_sel <= "11";
        bright_sel <= "11";
        wait for 50 us; -- Necháme PWM chvíli běžet

        -- Změna jasu na 50%
        bright_sel <= "10";
        wait for 50 us;

        -- Změna jasu na 25% a snížení rychlosti
        bright_sel <= "01";
        speed_sel <= "01";
        wait for 50 us;

        assert false report "tb_rainbow_pwm dokonceno" severity failure;
    end process;

end Behavioral;