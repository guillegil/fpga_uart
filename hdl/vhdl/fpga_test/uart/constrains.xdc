# TX/RX Port
set_property PACKAGE_PIN Y20 [get_ports RX]
set_property PACKAGE_PIN Y23 [get_ports TX]

set_property IOSTANDARD LVCMOS33 [get_ports RX]
set_property IOSTANDARD LVCMOS33 [get_ports TX]

# Reset port
#set_property PACKAGE_PIN E18 [get_ports MRST]
#set_property IOSTANDARD LVCMOS33 [get_ports MRST]

# Clock ports
set_property PACKAGE_PIN AD12 [get_ports MCLK_P]
set_property PACKAGE_PIN AD11 [get_ports MCLK_N]

set_property IOSTANDARD LVDS [get_ports MCLK_P]
set_property IOSTANDARD LVDS [get_ports MCLK_N]


# Data In ports 
set_property PACKAGE_PIN G19 [get_ports {DATA_IN[0]}]
set_property PACKAGE_PIN G25 [get_ports {DATA_IN[1]}]
set_property PACKAGE_PIN H24 [get_ports {DATA_IN[2]}]
set_property PACKAGE_PIN K19 [get_ports {DATA_IN[3]}]
set_property PACKAGE_PIN N19 [get_ports {DATA_IN[4]}]
set_property PACKAGE_PIN P19 [get_ports {DATA_IN[5]}]
set_property PACKAGE_PIN P26 [get_ports {DATA_IN[6]}]
set_property PACKAGE_PIN P27 [get_ports {DATA_IN[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IN[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IN[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IN[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IN[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_IN[0]}]

set_property PACKAGE_PIN E18 [get_ports SEND]
set_property IOSTANDARD LVCMOS33 [get_ports SEND]

# LEDS
set_property PACKAGE_PIN T28 [get_ports {DATA_OUT[0]}]
set_property PACKAGE_PIN V19 [get_ports {DATA_OUT[1]}]
set_property PACKAGE_PIN U30 [get_ports {DATA_OUT[2]}]
set_property PACKAGE_PIN U29 [get_ports {DATA_OUT[3]}]
set_property PACKAGE_PIN V20 [get_ports {DATA_OUT[4]}]
set_property PACKAGE_PIN V26 [get_ports {DATA_OUT[5]}]
set_property PACKAGE_PIN W24 [get_ports {DATA_OUT[6]}]
set_property PACKAGE_PIN W23 [get_ports {DATA_OUT[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {DATA_OUT[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_OUT[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_OUT[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_OUT[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_OUT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_OUT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_OUT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {DATA_OUT[0]}]