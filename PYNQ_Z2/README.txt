The ZyBo -> PYNQ Z2 conversion was done as follows:

The Vivado 2016.4 JTAG does not connect to the PYNQ Z2 and you will need to use
a newer Vivado version. We used 2019.1 since it matches the Python Boot Image V2.5.
Make sure the Boot mode jumper are set to JTAG and power is provided via wall outlet
or USB. We contiune to use our C/C++ interface from SDK; under 4 below we also
brief descibe how to you the Python Productivity for Zynq (PYNQ) interface
is intended for.

1) Vivado and vVivado 10 RISC machines:
To update the PIN file use the *xdc and board support packages from:
http://www.tul.com.tw/ProductsPYNQ-Z2.html
(This also has the Python Boot image for the SD card if you like to try.)
Enable PINs for clk, in_port, out_port, and reset in the *.xdc file.
Since we have only 4 std LEDs we use also 2x2 from the 3 color; for the 
6 additional in_port's we use the Arduino pins that can be hardwired to GND or Vcc.
There are no automatic pins assignments in Vivado; if not all pins are assigned to a port 
Vivado will issue an error message and stop compilation.

2) Design the ARM Basic_Computer and IP_SWAP:
The automatic upgrade to Vivado 2019.1 did not work and we redesigned
the basic computer system from scratch. We autoconfiguration  and connection this goes fast.
Make sure that for the IP_SWAP you add to the IP Catalog the User Repository ip_repo for MY_SWAP.
The IP_SWAP is set to 4 bits since we do not have many SW inputs.
Remember for FP operation you need to link the -lm library; use the project 
property to make this addtion.

3) Design of MicroBlaze BC, BC with FPH and BC with HDMI:
The upgrade of the MicroBlaze design to Vivado 2019.1 went smooth; all
IP blocks were updated fine. The old PINs in the *.bd file should be removed
and the new name selected for the axi_GPIO; Remember we only have 2 SWs now.
MicroBlaze does by default has no UART; as for the ZyBo we use a USBUART 
connected to the upper row of Pmod B, see picture PYNQwUART.gif.
The test program needed little to no modification (e.g. banner: ZYBO->PYNQ).
As always generate in SDK first the hello_world or testperiph project and then
replace the code around main and program end with the example code in the top
level directory where you find the *.xpr file.

4) As mentioned we used Vivado version 2019.1 since it match the Python Boot Image V2.5.
Python allows to build MicroBlaze and ARM system Overlays such that all programs
can be comfortable developed using the Jupyter notebooks. A sequence of 3 tutorials 
demonstrade the procedure:
https://discuss.pynq.io/t/tutorial-rebuilding-the-pynq-base-overlay/61
https://discuss.pynq.io/t/tutorial-creating-a-hardware-design-for-pynq/145
https://discuss.pynq.io/t/tutorial-using-a-new-hardware-design-with-pynq-axi-gpio/146

For the ZYNQ_Basic_Computer we built ARM BC overlays for version 2016.4 and 2019.1.
Get three overlay files: *.tcl, *.bit *.hwh; make sure they use the same filename
before you copy the files to the board (you need a Ethernet cable and minimum 8 GB SD card to do this).
File > Export > Export Block Design within Vivado
ARM\ZYNQ_Basic_Computer\ZYNQ_Basic_Computer.runs/impl_1/
ARM\ZYNQ_Basic_Computer\ZYNQ_Basic_Computer.srcs/sources_1/bd/ZYNQ_Basic_Computer/hw_handoff

To copy the three files to the board use Window Explorer:
\\192.168.2.99\xilinx 

To run the Python notebooks in Jupyter you use Chrome browser:
192.168.2.99:9090

The picture RunLED.jpg show a simulation snapshot for a running LED in Python.
A complete Python introduction will have to wait until a 2. edition of the book
is developed.






