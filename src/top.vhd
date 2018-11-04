library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        hdmi_red : out STD_LOGIC_VECTOR ( 7 downto 0 );
        hdmi_green : out STD_LOGIC_VECTOR ( 7 downto 0 );
        hdmi_blue : out STD_LOGIC_VECTOR ( 7 downto 0 );
        hdmi_hsync : out STD_LOGIC;
        hdmi_vsync : out STD_LOGIC;
        hdmi_enable : out STD_LOGIC;
        sw_r, sw_g, sw_b : in STD_LOGIC
    );
end top;

architecture rtl of top is
    component hdmi_sync is
        port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            hdmi_hsync : out STD_LOGIC;
            hdmi_vsync : out STD_LOGIC;
            hdmi_enable : out STD_LOGIC;
            pixel_x : out unsigned(10 downto 0);
            pixel_y : out unsigned(9 downto 0)
        );
    end component;

    signal pixel_x : unsigned(10 downto 0);
    signal pixel_y : unsigned(9 downto 0);

begin

    hdmi_sync_i: component hdmi_sync
    port map (
        clk => clk,
        reset => reset,
        hdmi_hsync => hdmi_hsync,
        hdmi_vsync => hdmi_vsync,
        hdmi_enable => hdmi_enable,
        pixel_x => pixel_x,
        pixel_y => pixel_y
    );

    hdmi_red <= std_logic_vector(resize(pixel_x, 8)) when sw_r = '1'
                else (others => '0');
    hdmi_green <= std_logic_vector(resize(pixel_y, 8)) when sw_g = '1'
                  else (others => '0');
    hdmi_blue <= "01100110" when sw_b = '1'
                 else (others => '0');
end rtl;
