library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce is
    Port(
        clk       : in std_logic;
        rst       : in std_logic;
        btn_in    : in std_logic;
        btn_state : out std_logic;
        btn_press : out std_logic;
        btn_long  : out std_logic  -- NEW: Long press output pulse
    );
end debounce;

architecture Behavioral of debounce is
    ----------------------------------------------------------------
    -- Constants
    ----------------------------------------------------------------
    constant C_SHIFT_LEN  : positive := 4;       -- Debounce history
    constant C_MAX        : positive := 200000;  -- 2 ms sampling period
    
    -- NEW: 500 ms at 100 MHz = 50,000,000 clock cycles
    constant C_LONG_PRESS : positive := 50000000; 

    ----------------------------------------------------------------
    -- Internal signals
    ----------------------------------------------------------------
    signal ce_sample : std_logic;
    signal sync0     : std_logic;
    signal sync1     : std_logic;
    signal shift_reg : std_logic_vector(C_SHIFT_LEN-1 downto 0);
    signal debounced : std_logic;
    signal delayed   : std_logic;

    -- NEW: Signals for long press measurement
    signal long_cnt      : integer range 0 to C_LONG_PRESS;
    signal long_detected : std_logic;
    signal long_delayed  : std_logic;

    ----------------------------------------------------------------
    -- Component declaration for clock enable
    ----------------------------------------------------------------
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;

begin
    ----------------------------------------------------------------
    -- Clock enable instance
    ----------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => C_MAX )
        port map (
            clk => clk,
            rst => rst,
            ce  => ce_sample
        );

    ----------------------------------------------------------------
    -- Synchronizer + debounce + long press
    ----------------------------------------------------------------
    p_debounce : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sync0         <= '0';
                sync1         <= '0';
                shift_reg     <= (others => '0');
                debounced     <= '0';
                delayed       <= '0';
                
                -- Reset new signals
                long_cnt      <= 0;
                long_detected <= '0';
                long_delayed  <= '0';

            else
                -- Input synchronizer
                sync1 <= sync0;
                sync0 <= btn_in;

                -- Sample only when enable pulse occurs
                if ce_sample = '1' then
                    shift_reg <= shift_reg(C_SHIFT_LEN-2 downto 0) & sync1;

                    if shift_reg = (shift_reg'range => '1') then
                        debounced <= '1';
                    elsif shift_reg = (shift_reg'range => '0') then
                        debounced <= '0';
                    end if;
                end if;

                -- NEW: Long press counter driven by system clock
                if debounced = '1' then
                    -- Increment until we reach 500 ms
                    if long_cnt < C_LONG_PRESS then
                        long_cnt <= long_cnt + 1;
                        long_detected <= '0';
                    else
                        long_detected <= '1'; -- 500 ms reached!
                    end if;
                else
                    -- Button released, reset the counter
                    long_cnt <= 0;
                    long_detected <= '0';
                end if;

                -- One clock delayed outputs for edge detectors
                delayed      <= debounced;
                long_delayed <= long_detected;
                
            end if;
        end if;
    end process;

    ----------------------------------------------------------------
    -- Outputs
    ----------------------------------------------------------------
    btn_state <= debounced;

    -- One-clock pulse when button is initially pressed
    btn_press <= debounced and not(delayed);

    -- NEW: One-clock pulse when button has been held for exactly 500 ms
    btn_long <= long_detected and not(long_delayed);

end Behavioral;