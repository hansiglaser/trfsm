#!/bin/bash
#
# Start the simulation
#
# Be sure to create a Makefile first and compile all Verilog and VHDL files.
#

if [ $# -ne 1 ] ; then
  echo "Usage: $0 [-cfgreg|-ism|-mux|-tr|-trfsm]"
  exit 1
fi

if [ "$1" = "-cfgreg" ] ; then
  vsim tb_ConfigRegister       -do "do wave-cfgreg.do ; run -all"
elif [ "$1" = "-ism" ] ; then
  vsim tb_InputSwitchingMatrix -do "do wave-ism.do ; run -all"
elif [ "$1" = "-mux" ] ; then
  vsim tb_LargeMux             -do "do wave-mux.do ; run -all"
elif [ "$1" = "-tr" ] ; then
  vsim tb_transitionrow        -do "do wave-tr.do ; run -all"
elif [ "$1" = "-trfsm" ] ; then
  vsim tb_trfsm                -do "do wave-trfsm.do ; run -all"
else
  echo "Error: Invalid parameter $1"
  exit 1;
fi
