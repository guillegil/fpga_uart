# RX Port
set_property PACKAGE_PIN Y20 [get_ports RX]
set_property IOSTANDARD LVCMOS33 [get_ports RX]

# Reset port
set_property PACKAGE_PIN E18 [get_ports MRST]
set_property IOSTANDARD LVCMOS33 [get_ports MRST]

# Clock ports
set_property PACKAGE_PIN AD12 [get_ports MCLK_P]
set_property PACKAGE_PIN AD11 [get_ports MCLK_N]

set_property IOSTANDARD LVDS [get_ports MCLK_P]
set_property IOSTANDARD LVDS [get_ports MCLK_N]


# LEDS
set_property PACKAGE_PIN T28 [get_ports {LEDS[0]}]
set_property PACKAGE_PIN V19 [get_ports {LEDS[1]}]
set_property PACKAGE_PIN U30 [get_ports {LEDS[2]}]
set_property PACKAGE_PIN U29 [get_ports {LEDS[3]}]
set_property PACKAGE_PIN V20 [get_ports {LEDS[4]}]
set_property PACKAGE_PIN V26 [get_ports {LEDS[5]}]
set_property PACKAGE_PIN W24 [get_ports {LEDS[6]}]
set_property PACKAGE_PIN W23 [get_ports {LEDS[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LEDS[0]}]