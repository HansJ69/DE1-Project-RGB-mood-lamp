library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debounce is
end tb_debounce;

architecture Behavioral of tb_debounce is

    component debounce
        Port(
            clk       : in  std_logic;
            rst       : in  std_logic;
            btn_in    : in  std_logic;
            btn_state : out std_logic;
            btn_press : out std_logic;
            btn_long  : out std_logic
        );
    end component;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal btn_in    : std_logic := '0';
    signal btn_state : std_logic;
    signal btn_press : std_logic;
    signal btn_long  : std_logic;

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin
    uut: debounce port map (
        clk => clk, rst => rst, btn_in => btn_in,
        btn_state => btn_state, btn_press => btn_press, btn_long => btn_long
    );

    clk_process : process
    begin
        clk <= '0'; wait for CLK_PERIOD / 2;
        clk <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_proc: process
    begin
        -- 1. Reset modulu
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 1 ms;

        -- 2. Simulace mechanických zákmitů (Bouncing) při stisku
        btn_in <= '1'; wait for 50 ns;
        btn_in <= '0'; wait for 100 ns;
        btn_in <= '1'; wait for 20 ns;
        btn_in <= '0'; wait for 80 ns;
        -- Nyní se tlačítko ustálí a drží se (krátký stisk)
        btn_in <= '1';
        wait for 15 ms; -- Debounce logika by zde měla vygenerovat btn_press
        
        -- Uvolnění tlačítka se zákmity
        btn_in <= '0'; wait for 60 ns;
        btn_in <= '1'; wait for 30 ns;
        btn_in <= '0';
        wait for 10 ms;

        -- 3. Dlouhý stisk (Long Press > 500 ms)
        btn_in <= '1';
        wait for 510 ms; -- Po 500 ms musí vystřelit btn_long
        btn_in <= '0';
        wait for 10 ms;

        assert false report "tb_debounce dokonceno" severity failure;
    end process;

end Behavioral;