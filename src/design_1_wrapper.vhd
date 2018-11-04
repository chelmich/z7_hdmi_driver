library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity design_1_wrapper is
    port (
        --hdmi_blue : in STD_LOGIC_VECTOR ( 7 downto 0 );
        --hdmi_clock : out STD_LOGIC;
        --hdmi_enable : in STD_LOGIC;
        --hdmi_green : in STD_LOGIC_VECTOR ( 7 downto 0 );
        --hdmi_hsync : in STD_LOGIC;
        hdmi_out_clk_n : out STD_LOGIC;
        hdmi_out_clk_p : out STD_LOGIC;
        hdmi_out_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
        hdmi_out_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
        --hdmi_red : in STD_LOGIC_VECTOR ( 7 downto 0 );
        --hdmi_vsync : in STD_LOGIC;
        sys_clock : in STD_LOGIC;
        reset : in STD_LOGIC;
        sw_r, sw_g, sw_b : in STD_LOGIC
    );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
    component design_1 is
        port (
            hdmi_out_clk_p : out STD_LOGIC;
            hdmi_out_clk_n : out STD_LOGIC;
            hdmi_out_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
            hdmi_out_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
            hdmi_clock : out STD_LOGIC;
            sys_clock : in STD_LOGIC;
            hdmi_green : in STD_LOGIC_VECTOR ( 7 downto 0 );
            hdmi_blue : in STD_LOGIC_VECTOR ( 7 downto 0 );
            hdmi_red : in STD_LOGIC_VECTOR ( 7 downto 0 );
            hdmi_hsync : in STD_LOGIC;
            hdmi_vsync : in STD_LOGIC;
            hdmi_enable : in STD_LOGIC
        );
    end component design_1;

    component top is
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
    end component top;

    signal hdmi_clock : STD_LOGIC;

    signal hdmi_red : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal hdmi_green : STD_LOGIC_VECTOR ( 7 downto 0 );
    signal hdmi_blue : STD_LOGIC_VECTOR ( 7 downto 0 );

    signal hdmi_hsync : STD_LOGIC;
    signal hdmi_vsync : STD_LOGIC;
    signal hdmi_enable : STD_LOGIC;

begin

    design_1_i: component design_1
    port map (
        hdmi_blue(7 downto 0) => hdmi_blue(7 downto 0),
        hdmi_clock => hdmi_clock,
        hdmi_enable => hdmi_enable,
        hdmi_green(7 downto 0) => hdmi_green(7 downto 0),
        hdmi_hsync => hdmi_hsync,
        hdmi_out_clk_n => hdmi_out_clk_n,
        hdmi_out_clk_p => hdmi_out_clk_p,
        hdmi_out_data_n(2 downto 0) => hdmi_out_data_n(2 downto 0),
        hdmi_out_data_p(2 downto 0) => hdmi_out_data_p(2 downto 0),
        hdmi_red(7 downto 0) => hdmi_red(7 downto 0),
        hdmi_vsync => hdmi_vsync,
        sys_clock => sys_clock
    );

    top_i: component top
    port map (
        clk => hdmi_clock,
        reset => reset,
        hdmi_red => hdmi_red,
        hdmi_green => hdmi_green,
        hdmi_blue => hdmi_blue,
        hdmi_hsync => hdmi_hsync,
        hdmi_vsync => hdmi_vsync,
        hdmi_enable => hdmi_enable,
        sw_r => sw_r,
        sw_g => sw_g,
        sw_b => sw_b
    );
end STRUCTURE;
