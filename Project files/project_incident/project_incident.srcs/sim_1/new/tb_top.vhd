library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is

    component top
        Port (
            CLK100MHZ : in  STD_LOGIC;
            CPU_RESETN: in  STD_LOGIC;
            BTNC      : in  STD_LOGIC;
            BTNU      : in  STD_LOGIC;
            BTND      : in  STD_LOGIC;
            BTNL      : in  STD_LOGIC;
            BTNR      : in  STD_LOGIC;
            LED16_R, LED16_G, LED16_B : out STD_LOGIC;
            LED17_R, LED17_G, LED17_B : out STD_LOGIC
        );
    end component;

    -- Vstupní signály
    signal CLK100MHZ  : std_logic := '0';
    signal CPU_RESETN : std_logic := '1';
    signal BTNC, BTNU, BTND, BTNL, BTNR : std_logic := '0';
    
    -- Výstupní signály
    signal LED16_R, LED16_G, LED16_B : std_logic;
    signal LED17_R, LED17_G, LED17_B : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: top port map (
        CLK100MHZ => CLK100MHZ, CPU_RESETN => CPU_RESETN,
        BTNC => BTNC, BTNU => BTNU, BTND => BTND, BTNL => BTNL, BTNR => BTNR,
        LED16_R => LED16_R, LED16_G => LED16_G, LED16_B => LED16_B,
        LED17_R => LED17_R, LED17_G => LED17_G, LED17_B => LED17_B
    );

    clk_process : process
    begin
        CLK100MHZ <= '0'; wait for CLK_PERIOD / 2;
        CLK100MHZ <= '1'; wait for CLK_PERIOD / 2;
    end process;

    stim_proc: process
    begin
        -- 1. Hardwarový Reset celé desky (CPU_RESETN je aktivní v 0)
        CPU_RESETN <= '0';
        wait for 100 ns;
        CPU_RESETN <= '1';
        wait for 2 ms;

        -- 2. Změna rychlosti levé LED17 (Tlačítko Doleva - krátký stisk)
        BTNL <= '1';
        wait for 15 ms; 
        BTNL <= '0';
        wait for 5 ms;

        -- 3. Změna jasu levé LED17 (Tlačítko Nahoru - krátký stisk)
        BTNU <= '1';
        wait for 15 ms; 
        BTNU <= '0';
        wait for 5 ms;

        -- 4. Vypnutí pravé LED16 (Tlačítko Doprava - dlouhý stisk > 500 ms)
        BTNR <= '1';
        wait for 510 ms; 
        BTNR <= '0';
        wait for 5 ms;

        -- 5. Návrat do výchozího stavu pomocí prostředního tlačítka (BTNC)
        BTNC <= '1';
        wait for 15 ms;
        BTNC <= '0';
        wait for 5 ms;

        wait for 1000 ms;

        assert false report "tb_top dokonceno: Vsechny integracni cesty otestovany." severity failure;
    end process;

end Behavioral;




  

