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
    constant HFP_LEN : integer := 16; -- front porch
    constant HSYNC_LEN : integer := 96; -- sync pulse
    constant HBP_LEN : integer := 48; -- back porch
    constant HRES_LEN : integer := 640; -- usable pixels
    constant HBLANK_LEN : integer := HFP_LEN + HSYNC_LEN + HBP_LEN;
    constant HTOTAL_LEN : integer := HBLANK_LEN + HRES_LEN;

    constant VFP_LEN : integer := 11; -- front porch
    constant VSYNC_LEN : integer := 2; -- sync pulse
    constant VBP_LEN : integer := 31; -- back porch
    constant VRES_LEN : integer := 480; -- usable pixels
    constant VBLANK_LEN : integer := VFP_LEN + VSYNC_LEN + VBP_LEN;
    constant VTOTAL_LEN : integer := VBLANK_LEN + VRES_LEN;

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
    pixel_x <= hcount_reg - HBLANK_LEN when hcount_reg >= HBLANK_LEN
               else (others=>'0');
    pixel_y <= vcount_reg - VBLANK_LEN when vcount_reg >= VBLANK_LEN
               else (others=>'0');

    -- combinational block
    process (hcount_reg, vcount_reg)
    begin
        -- default values
        hdmi_enable <= '0';
        hdmi_hsync <= '1';
        hdmi_vsync <= '1';

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

        -- vertical video enable
        if (vcount_reg > VFP_LEN + VSYNC_LEN + VBP_LEN - 1) then
            -- horzontal video enable
            if (hcount_reg > HFP_LEN + HSYNC_LEN + HBP_LEN - 1) then
                hdmi_enable <= '1';
            end if;

            -- horizontal sync pulse
            if (hcount_reg > HFP_LEN - 1) and (hcount_reg < HFP_LEN + HSYNC_LEN) then
                hdmi_hsync <= '0';
            end if;
        end if;

        -- vertical sync pulse
        if (vcount_reg > VFP_LEN - 1) and (vcount_reg < VFP_LEN + VSYNC_LEN) then
            hdmi_vsync <= '0';
        end if;
    end process;
end rtl;
