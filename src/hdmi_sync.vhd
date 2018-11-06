library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hdmi_sync is
    port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        hdmi_hsync : out STD_LOGIC;
        hdmi_vsync : out STD_LOGIC;
        hdmi_enable : out STD_LOGIC;
        pixel_x : out unsigned(10 downto 0);
        pixel_y : out unsigned(9 downto 0)
    );
end hdmi_sync;

architecture rtl of hdmi_sync is
    -- 640x480 60hz
    constant HRES_LEN : integer := 640; -- usable pixels
    constant HFP_LEN : integer := 16; -- front porch
    constant HSYNC_LEN : integer := 96; -- sync pulse
    constant HBP_LEN : integer := 48; -- back porch
    constant HBLANK_LEN : integer := HFP_LEN + HSYNC_LEN + HBP_LEN;
    constant HTOTAL_LEN : integer := HRES_LEN + HBLANK_LEN;

    constant VRES_LEN : integer := 480; -- usable pixels
    constant VFP_LEN : integer := 11; -- front porch
    constant VSYNC_LEN : integer := 2; -- sync pulse
    constant VBP_LEN : integer := 31; -- back porch
    constant VBLANK_LEN : integer := VFP_LEN + VSYNC_LEN + VBP_LEN;
    constant VTOTAL_LEN : integer := VRES_LEN + VBLANK_LEN;

    -- registers
    signal hcount_reg, hcount_next : unsigned(10 downto 0) := (others=>'0');
    signal vcount_reg, vcount_next : unsigned(9 downto 0) := (others=>'0');

begin

    -- registers
    process (clk, reset)
    begin
        if (reset = '1') then
            hcount_reg <= (others=>'0');
            vcount_reg <= (others=>'0');
        elsif (rising_edge(clk)) then
            hcount_reg <= hcount_next;
            vcount_reg <= vcount_next;
        end if;
    end process;

    -- output pixel coordinate signals
    pixel_x <= hcount_reg when hcount_reg < HRES_LEN else
               (others=>'0');
    pixel_y <= vcount_reg when vcount_reg < VRES_LEN else
               (others=>'0');

    -- video enable
    hdmi_enable <= '1' when (hcount_reg < HRES_LEN) and
                            (vcount_reg < VRES_LEN) else
                   '0';

    -- horizontal sync pulse
    hdmi_hsync <= '0' when (hcount_reg > HRES_LEN + HFP_LEN - 1) and
                           (hcount_reg < HRES_LEN + HFP_LEN + HSYNC_LEN) else
                  '1';

    -- vertical sync pulse
    hdmi_vsync <= '0' when (vcount_reg > VRES_LEN + VFP_LEN - 1) and
                           (vcount_reg < VRES_LEN + VFP_LEN + VSYNC_LEN) else
                  '1';

    -- combinational block
    process (hcount_reg, vcount_reg)
    begin
        -- default values
        vcount_next <= (others => '0');
        hcount_next <= (others => '0');

        -- step counters
        if (hcount_reg = HTOTAL_LEN - 1) then
            hcount_next <= (others =>'0');
            if (vcount_reg = VTOTAL_LEN - 1) then
                vcount_next <= (others =>'0');
            else
                vcount_next <= vcount_reg + 1;
            end if;
        else
            hcount_next <= hcount_reg + 1;
            vcount_next <= vcount_reg;
        end if;
    end process;
end rtl;
