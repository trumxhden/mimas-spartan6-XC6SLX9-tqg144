# mimas-spartan6-XC6SLX9-tqg144

This repository contains compressed project files for the Mimas FPGA Spartan 6 XC6SLX9-TQG144

Projects are composed using Xilinx ISE Design Suite 14.7.

To rebuild the modules:
- Unzip the compressed file of a project into a separated folder
- Open "ISE Design Suite" (ISE Project Navigator) and locate "*.xise" file to open the project
- Click "Process" -> "Implement Top Module" to synthesize and implement the design. Shortcut Alt+P+I can be used
- In Process panel, double-click on "Generate Programming File", to generate binary file that can be downloaded to the FPGA. Make sure the option "Create Binary Configuration File"
is checked in "Process Properties" (right-click on "Generate Programming File")

To download the new module on board, use the script mimasconfig.py