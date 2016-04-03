#!/bin/bash
#
# Create a Makefile.
#
# This tool uses ModelSim's "vmake" to generate a Makefile. Therefore all
# VHDL files are first compiled by hand to tell ModelSim their order. Then
# the Makefile is generated.
#

VHDL_PATH=../vhdl
TEST_PATH=../tb
PKG_PATH=../vhdl_packs

VCOM_OPTS=""
#VCOM_OPTS="-preserve"
#VCOM_OPTS="+acc -fsmverbose"

VLOG_OPTS=""
#VLOG_OPTS="+acc -fsmverbose"

if ! which vlib > /dev/null ; then
  echo "ERROR: Couldn't find ModelSim executables."
  exit 1
fi

if [ -f Makefile ] ; then
  echo "ERROR: Makefile already exists. Please remove it before calling $0"
  exit 1
fi

# create library work
if [ ! -d work ] ; then
  echo "Creating library 'work'"
  vlib work
  vmap work work
fi

# compile all files
# TR-FSM
vcom ${VCOM_OPTS} -work work -93   $PKG_PATH/trfsmparts-p.vhd
vcom ${VCOM_OPTS} -work work -93   $PKG_PATH/config-p.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/ConfigRegister-e.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/ConfigRegister-rtl-a.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/InputPatternGate-e.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/InputPatternGate-rtl-a.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/InputSwitchingMatrix-e.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/InputSwitchingMatrix-rtl-a.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/LargeMux-e.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/LargeMux-rtl-a.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/StateRegister-e.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/StateRegister-rtl-a.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/StateSelectionGate-e.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/StateSelectionGate-rtl-a.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/TransitionRow-e.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/TransitionRow-struct-a.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/trfsm-e.vhd
vcom ${VCOM_OPTS} -work work -93   $VHDL_PATH/trfsm-struct-a.vhd
vcom ${VCOM_OPTS} -work work -93   $PKG_PATH/trfsm-p.vhd

# testbenches
vcom ${VCOM_OPTS} -work work -2002  $TEST_PATH/tbfuncs-p.vhd
vcom ${VCOM_OPTS} -work work -2002  $TEST_PATH/tb_trfsm-p.vhd
vcom ${VCOM_OPTS} -work work -2002  $TEST_PATH/tb_ConfigRegister-behavior.vhd
vcom ${VCOM_OPTS} -work work -2002  $TEST_PATH/tb_InputSwitchingMatrix-behavior.vhd
vcom ${VCOM_OPTS} -work work -2002  $TEST_PATH/tb_LargeMux-behavior.vhd
vcom ${VCOM_OPTS} -work work -2002  $TEST_PATH/tb_transitionrow-behavior.vhd
vcom ${VCOM_OPTS} -work work -2002  $TEST_PATH/tb_trfsm-behavior.vhd

# create Makefile
echo "Writing Makefile"
vmake -nolinewrap > Makefile
