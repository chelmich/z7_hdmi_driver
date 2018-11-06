# z7_hdmi_driver
This project was created with Vivado 2017.2. It was designed for the Zybo Z7-10 SoC but could also likely be made to work on the Z7-20. The project makes use of the rgb2dvi IP block found in Digilent's [Vivado Library.](https://github.com/Digilent/vivado-library)

## Setup
To download and setup the project run the following commands:
```
git clone https://github.com/chelmich/z7_hdmi_driver
cd z7_hdmi_driver
git submodule update --init --recursive
```
Open Vivado and run the next command in the TCL console, substituting the location you downloaded the project to.
```
source [path to project]/build.tcl
```
This will create and open the project and should allow sythesis it without any additional configuration.

## Design
The file hdmi_sync.vhd contains the code to generate sync, enable and pixel coordinate signals. This is then instantiated within top.vhd which uses the coordinates combined with three switch inputs to produce color gradients. The top module is encapsulated within a design wrapper, connecting it to the IP blocks in the block diagram.

The rgb2dvi IP block requires two clock inputs. One, PixelClk simply ticks once per pixel and can easily be found by multiplying the total number of pixels (including the blanking regions) with the desired refresh rate. For example, 640x480 at 60 Hz produces a pixel clock of 25.175 MHz which we round to 25 MHz. The second clock, SerialClk is used to serialize each 8-bit color channel into 10-bit TMDS. The serializing clock must have a frequency of exactly 5 times the pixel clock. In our example we use 125 MHz. We generate both of these clock signals with a Clocking Wizard IP block.
