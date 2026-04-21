library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rainbow_pwm is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        speed_sel  : in  unsigned(1 downto 0); -- Výběr ze 4 rychlostí
        bright_sel : in  unsigned(1 downto 0); -- Výběr ze 4 úrovní jasu
        led_r      : out STD_LOGIC;
        led_g      : out STD_LOGIC;
        led_b      : out STD_LOGIC
    );
end rainbow_pwm;

architecture Behavioral of rainbow_pwm is
    -- Signály pro řízení rychlosti (Tick generátor)
    signal tick_cnt    : integer := 0;
    signal speed_limit : integer := 500000;
    signal tick        : std_logic := '0';

    -- Stav a hodnota pro výpočet RGB duhy
    signal state     : integer range 0 to 5 := 0;
    signal color_cnt : unsigned(7 downto 0) := (others => '0');

    -- Surové RGB hodnoty (0 až 255)
    signal r_raw, g_raw, b_raw : unsigned(7 downto 0) := (others => '0');
    -- RGB hodnoty upravené o jas
    signal r_adj, g_adj, b_adj : unsigned(7 downto 0) := (others => '0');
    
    -- PWM čítač
    signal pwm_cnt : unsigned(7 downto 0) := (others => '0');

begin
    -- 1. Výběr rychlosti (kolik hodinových taktů trvá jeden posun barvy)
    process(speed_sel)
    begin
        case speed_sel is
            when "11" => speed_limit <= 50000;   -- Nejvyšší rychlost (cca 0.7s na cyklus)
            when "10" => speed_limit <= 150000;  -- Rychlá (cca 2s na cyklus)
            when "01" => speed_limit <= 500000;  -- Střední (cca 7.5s na cyklus)
            when others => speed_limit <= 1000000; -- Pomalá (cca 15s na cyklus)
        end case;
    end process;

    -- 2. Tick generátor pro posun barev
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                tick_cnt <= 0;
                tick <= '0';
            else
                if tick_cnt >= speed_limit then
                    tick_cnt <= 0;
                    tick <= '1';
                else
                    tick_cnt <= tick_cnt + 1;
                    tick <= '0';
                end if;
            end if;
        end if;
    end process;

    -- 3. Stavový automat pro RGB duhu (6 fází přechodů)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= 0;
                color_cnt <= (others => '0');
            elsif tick = '1' then
                if color_cnt = 255 then
                    color_cnt <= (others => '0');
                    if state = 5 then
                        state <= 0;
                    else
                        state <= state + 1;
                    end if;
                else
                    color_cnt <= color_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    -- Mapování fází na konkrétní míchání barev
    process(state, color_cnt)
    begin
        case state is
            when 0 => r_raw <= "11111111";   g_raw <= color_cnt;     b_raw <= "00000000";
            when 1 => r_raw <= not color_cnt;g_raw <= "11111111";   b_raw <= "00000000";
            when 2 => r_raw <= "00000000";   g_raw <= "11111111";   b_raw <= color_cnt;
            when 3 => r_raw <= "00000000";   g_raw <= not color_cnt;b_raw <= "11111111";
            when 4 => r_raw <= color_cnt;    g_raw <= "00000000";   b_raw <= "11111111";
            when 5 => r_raw <= "11111111";   g_raw <= "00000000";   b_raw <= not color_cnt;
            when others => r_raw <= "00000000"; g_raw <= "00000000"; b_raw <= "00000000";
        end case;
    end process;

    -- 4. Aplikace Jasu (Hardwarový bitový posun pro 100%, 50%, 25%, 12.5%)
    process(bright_sel, r_raw, g_raw, b_raw)
    begin
        case bright_sel is
            when "11" => r_adj <= r_raw; g_adj <= g_raw; b_adj <= b_raw; -- 100 %
            when "10" => r_adj <= "0" & r_raw(7 downto 1); g_adj <= "0" & g_raw(7 downto 1); b_adj <= "0" & b_raw(7 downto 1); -- 50 %
            when "01" => r_adj <= "00" & r_raw(7 downto 2); g_adj <= "00" & g_raw(7 downto 2); b_adj <= "00" & b_raw(7 downto 2); -- 25 %
            when others => r_adj <= "000" & r_raw(7 downto 3); g_adj <= "000" & g_raw(7 downto 3); b_adj <= "000" & b_raw(7 downto 3); -- 12.5 %
        end case;
    end process;

    -- 5. PWM Generátor
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pwm_cnt <= (others => '0');
            else
                pwm_cnt <= pwm_cnt + 1;
            end if;
            
            if r_adj > pwm_cnt then led_r <= '1'; else led_r <= '0'; end if;
            if g_adj > pwm_cnt then led_g <= '1'; else led_g <= '0'; end if;
            if b_adj > pwm_cnt then led_b <= '1'; else led_b <= '0'; end if;
        end if;
    end process;

end Behavioral;