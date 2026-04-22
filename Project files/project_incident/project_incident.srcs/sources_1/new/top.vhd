library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port (
        CLK100MHZ : in  STD_LOGIC;
        CPU_RESETN: in  STD_LOGIC;
        BTNC      : in  STD_LOGIC; -- Střed
        BTNU      : in  STD_LOGIC; -- Nahoru
        BTND      : in  STD_LOGIC; -- Dolů
        BTNL      : in  STD_LOGIC; -- Doleva
        BTNR      : in  STD_LOGIC; -- Doprava
        
        LED16_R, LED16_G, LED16_B : out STD_LOGIC; -- Pravá LED
        LED17_R, LED17_G, LED17_B : out STD_LOGIC  -- Levá LED
    );
end top;

architecture Behavioral of top is
    signal rst : std_logic;

    -- Signály pro tlačítka (press pulzy)
    signal btnc_press : std_logic;
    signal btnu_press : std_logic;
    signal btnd_press : std_logic;
    signal btnl_press, btnl_long : std_logic;
    signal btnr_press, btnr_long : std_logic;

    -- Nastavení pro LED 16 (Pravá LED)
    signal speed16  : unsigned(1 downto 0) := "01";
    signal bright16 : unsigned(1 downto 0) := "11";
    signal en16     : std_logic := '1'; -- Zda je LED zapnutá
    signal pwm16_r, pwm16_g, pwm16_b : std_logic;

    -- Nastavení pro LED 17 (Levá LED)
    signal speed17  : unsigned(1 downto 0) := "01";
    signal bright17 : unsigned(1 downto 0) := "11";
    signal en17     : std_logic := '1'; -- Zda je LED zapnutá
    signal pwm17_r, pwm17_g, pwm17_b : std_logic;

    component debounce is
        Port(
            clk, rst, btn_in : in std_logic;
            btn_state, btn_press, btn_long : out std_logic
        );
    end component;

    component rainbow_pwm is
        Port (
            clk, rst : in STD_LOGIC;
            speed_sel, bright_sel : in unsigned(1 downto 0);
            led_r, led_g, led_b : out STD_LOGIC
        );
    end component;

begin
    -- Hardwarový reset celé desky
    rst <= not CPU_RESETN;

    -- --- DEBOUNCERY TLAČÍTEK ---
    deb_c : debounce port map(clk => CLK100MHZ, rst => rst, btn_in => BTNC, btn_press => btnc_press, btn_long => open, btn_state => open);
    deb_u : debounce port map(clk => CLK100MHZ, rst => rst, btn_in => BTNU, btn_press => btnu_press, btn_long => open, btn_state => open);
    deb_d : debounce port map(clk => CLK100MHZ, rst => rst, btn_in => BTND, btn_press => btnd_press, btn_long => open, btn_state => open);
    deb_l : debounce port map(clk => CLK100MHZ, rst => rst, btn_in => BTNL, btn_press => btnl_press, btn_long => btnl_long, btn_state => open);
    deb_r : debounce port map(clk => CLK100MHZ, rst => rst, btn_in => BTNR, btn_press => btnr_press, btn_long => btnr_long, btn_state => open);

    -- --- LOGIKA PRO PRAVOU LED (LED16, Tlačítka: Doprava, Dolů) ---
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if rst = '1' or btnc_press = '1' then
                speed16 <= "01"; 
                bright16 <= "11";
                en16 <= '1';
            else
                if btnr_press = '1' then speed16 <= speed16 + 1; end if;     -- Doprava = rychlost
                if btnd_press = '1' then bright16 <= bright16 + 1; end if;   -- Dolů = jas
                if btnr_long = '1' then en16 <= not en16; end if;            -- Dlouze Doprava = on/off
            end if;
        end if;
    end process;

    -- --- LOGIKA PRO LEVOU LED (LED17, Tlačítka: Doleva, Nahoru) ---
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if rst = '1' or btnc_press = '1' then
                speed17 <= "01"; 
                bright17 <= "11";
                en17 <= '1';
            else
                if btnl_press = '1' then speed17 <= speed17 + 1; end if;     -- Doleva = rychlost
                if btnu_press = '1' then bright17 <= bright17 + 1; end if;   -- Nahoru = jas
                if btnl_long = '1' then en17 <= not en17; end if;            -- Dlouze Doleva = on/off
            end if;
        end if;
    end process;

    -- --- INSTANCIACE PWM GENERÁTORŮ ---
    rgb16 : rainbow_pwm port map(
        clk => CLK100MHZ, rst => rst, speed_sel => speed16, bright_sel => bright16,
        led_r => pwm16_r, led_g => pwm16_g, led_b => pwm16_b
    );

    rgb17 : rainbow_pwm port map(
        clk => CLK100MHZ, rst => rst, speed_sel => speed17, bright_sel => bright17,
        led_r => pwm17_r, led_g => pwm17_g, led_b => pwm17_b
    );

    -- --- VÝSTUPNÍ MASKA ---
    -- Aplikuje logické AND. Pokud je 'en' nula, na výstup jde tvrdá nula (LED nesvítí).
    LED16_R <= pwm16_r and en16;
    LED16_G <= pwm16_g and en16;
    LED16_B <= pwm16_b and en16;

    LED17_R <= pwm17_r and en17;
    LED17_G <= pwm17_g and en17;
    LED17_B <= pwm17_b and en17;

end Behavioral;








