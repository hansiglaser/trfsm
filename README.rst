Transition-Based Reconfigurable FSM
===================================

Ever needed a reconfigurable FSM in your FPGA or ASIC design? The
**Transition-Based Reconfigurable FSM** is a reconfigurable logic architecture
which provides exactly that.

.. image:: doc/fsm.png?raw=true
   :width: 600 px
   :alt: Exemplary state diagram of an FSM
   :align: center

Other FSM architectures implement the logic functions which "calculate" the
output signals and the next state from the current state and the input signals.
In contrast, the TR-FSM directly implements the FSM transitions (arrows in the
image above) themselves. The TR-FSM architecture is built as a collection of
reconfigurable transition rows (green boxes in the image below). Each FSM
transition is mapped to one transition row. For more details see Sec.
"Documentation".

.. image:: doc/trfsm.png?raw=true
   :alt: Block Diagram of the TR-FSM Architecture
   :align: center

The TR-FSM is provided as a VHDL design with a number of generics to adjust the
implementation (e.g., number of inputs, width of the state vector, ...). It is
fully verified using testbenches as well as logical equivalence checking with
actually implemented FSMs. Multiple different implementations were included and
successfully used in two ASICs.

The TR-FSM is used by the **Design Methodology for Custom Reconfigurable Logic
Architectures** https://github.com/hansiglaser/chll. This is a design
methodology for the development of complete reconfigurable logic architectures
(not just FSMs). The TR-FSM was developed in the course of this PhD work.

Johann.Glaser@gmx.at


Directory Structure
===================

::

  README.rst                this file
  doc/                      documentation, see Sec. Documentation below
  vhdl/                     VHDL source code of the TR-FSM
  vhdl_packs/               VHDL packages
  tb/                       testbenches
  sim/                      simulation setup for ModelSim/Questa Sim


Documentation
=============

More documentation for this project is stored in ``./doc/``.

- ``arc2010.pdf`` is the initial conference publication [ARC2010] of the TR-FSM
  architecture
- ``trets2011.pdf`` is the following journal publication [TRETS2011] and also
  features the first chip produced with the TR-FSM included
- ``bibliography.bib``: BibTeX file with the scientific publications


Description
===========

The TR-FSM implements a Mealy type FSM, i.e., the output signals depend on the
current state and the input signals. In each state, the input signals are
evaluated and the according state transition is activated to select the next
state and the output value.

Functionality
-------------

As shown in the image above, the TR-FSM is built as a collection of transition
rows (TRs). Each TR implements one transition of the FSM, i.e., one input
pattern as condition, one next state, and one output pattern. The state
selection gates (SSGs) enable only those TRs, which implement transitions
leaving from the current state. In each TR, a subset of the n_I input signals
is selected by the input switching matrix (ISM). The maximum number n_T_m of
observable signals is a characteristic of each TR and is termed "width".
A TR-FSM instance consists of a different number of TRs with different widths.

The subset of inputs is evaluated by the input pattern gate (IPG). If it
matches a given pattern, this transition is active. The IPG can match only a
single pattern or a set of different patterns. Only a single TR can be active
at a time, because in FSMs only a single transition is performed.

The next state registers (NSRs) and the output pattern registers (OPRs) of the
TRs hold the next state and output signal. The values of the active TR are
selected as next state and output, respectively. At the clock edge, the next
state is stored by the state register and becomes the current state.

The configurable elements of a TR-FSM comprise the SSG, ISM, IPG, NSR, and OPR.
In the pre-silicon design phase, the actual implementation of the sizable
TR-FSM cell is specified by the number of input signals, the number of output
signals, the width of the state vector, and the number of TRs of each width.
Typically, TRs with a width of zero to four are implemented. Zero width TRs are
used for sequences of consecutive states.

Since all TRs provide the same functionality (except for the number of observed
input signals), the TR-FSM architecture allows to trade off the total number of
states of an FSM against the number of transitions per state. The TR-FSM
architecture efficiently handles transitions with unobserved input signals.
Further, the mapping of an abstract FSM description to the TR-FSM configuration
is a straight forward process.

Configuration
-------------

The configuration is stored in config registers inside of the TR-FSM. Before its
operation, the TR-FSM is configured using a config bit stream. This bitstream
is generated with the tool **TrfsmGen** (see below).


Usage
=====

This section describes how to include one or more TR-FSM instances in your ASIC
or FPGA design.

Instantiation
-------------

1) include package TRFSMPkg in ``vhdl_packs/trfsm-p.vhd``
2) add one or more instances of the module ``TRFSM``
3) connect the signals appropriately
4) set the generics as required

Signals
-------

- ``Reset_n_i``: active low reset input
- ``Clk_i``: clock input
- ``Input_i``: FSM input signals
- ``Output_o``: FSM output signals
- ``CfgMode_i``, ``CfgClk_i``, ``CfgShift_i``, ``CfgDataIn_i``,
  ``CfgDataOut_o``: configuration interface (see Sec. Configuration Interface)

Generics
--------

- ``InputWidth``: number of input signals, i.e., width of ``Input_i``
- ``OutputWidth``: number of output signals, i.e., width of ``Output_o``
- ``StateWidth``: width of the state vector
- ``NumRows[0-9]``: number of transition rows with a given width

Attention: The IPG in the TRs are implemented as lookup-tables (LUTs).
Therefore the configuration data grows with 2^Width. You most probably don't
need TRs with more than 4 inputs.

Files
-----

For simulation, logical equivalence checking, and synthesis you need all VHDL
files in the directories ``vhdl/`` and ``vhdl_packs/``.

Configuration
-------------

The configuration for TR-FSM instances is generated with the tool **TrfsmGen**.
Please use the release which is included in
https://github.com/hansiglaser/chll (see Build Instructions in README.rst). 
TrfsmGen requires various other sources of this project, therefore it is not
included here.

Currently there are three ways to define the functionality of a TR-FSM, i.e.,
to specify the FSM

 - TrfsmGen script
 - KISS2 format
 - Verilog RTL

The TrfsmGen command ``write_bitstream`` saves the generated bitstream to a
number of different formats, e.g., as VHDL or Verilog vector (e.g., for your
testbenches), C constants (e.g., for your firmware driver), a simple text
format, ... Use the formats which are appropriate in your design.

TrfsmGen Script
~~~~~~~~~~~~~~~
The first way to define the FSM functionality is to use the ``add_state`` and
``add_transition`` commands in a TrfsmGen script. For an example see 
https://github.com/hansiglaser/chll/blob/master/tools/trfsmgen/sensorfsm.tcl.

KISS2 Format
~~~~~~~~~~~~
If you have a dedicated tool to design your FSM, it most probably can export
the FSM functionality in the KISS2 file format [KISS]. Use the ``read_kiss``
command of TrfsmGen to import. For an example see 
https://github.com/hansiglaser/chll/blob/master/tools/trfsmgen/test-s27.tcl.

Verilog RTL
~~~~~~~~~~~
A more elegant way to specify your FSM is as RTL logic design and using a
synthesis tool to generate the configuration data. This can be accomplished in
a two-step process using the synthesis tool **Yosys**
http://www.clifford.at/yosys/ together with TrfsmGen. Currently Yosys only
supports Verilog, but VHDL is available with a proprietary extension.

After synthesis, use the ``fsm`` pass and sub-passes of Yosys to detect and
extract FSMs in the RTL logic design. The FSMs can be stored in KISS2 file
format with ``fsm_export``. Alternatively, you can save the whole logic design
as an ILang file (internal logic netlist format of Yosys). Then read this file
in TrfsmGen with ``read_ilang``. TrfsmGen can also generate wrapper modules for
the TR-FSM for direct instantiation in the logic design. For a (rather
complicated) example see 
`insert-trfsm.tcl <https://github.com/hansiglaser/chll/blob/master/examples/wsn-soc/apps/adt7310/chll/scripts/insert-trfsm.tcl>`_,
`insert-trfsm-read.tcl <https://github.com/hansiglaser/chll/blob/master/examples/wsn-soc/apps/adt7310/chll/scripts/insert-trfsm-read.tcl>`_, and
`insert-trfsm-replace.tcl <https://github.com/hansiglaser/chll/blob/master/examples/wsn-soc/apps/adt7310/chll/scripts/insert-trfsm-replace.tcl>`_.

Configuration Interface
-----------------------

The application of the configuration bit stream to the TR-FSM instances is
fully user defined. You have to provide the appropriate signals from your
design.

The configuration in the TR-FSM is stored in one continuous shift register. To
apply the configuration or to exchange an existing configuration, set
``CfgMode_i`` to ``'1'``. This enable configuration mode. Additionally, all
internal configuration signals are set to ``'0'`` to avoid glitches and
undesired behavior during configuration. If you have multiple related instances
of the TR-FSM, it is best to tie all ``CfgMode_i`` inputs together.

For each individual TR-FSM instance, set the ``CfgShift_i`` to ``'1'`` and
supply the config data to ``CfgDataIn_i``, one bit per ``CfgClk_i`` cycle, LSB
first. If desired, the previous configuration can be captured at
``CfgDataOut_o``. When all bits for the instance were supplied, set
``CfgShift_i`` to ``'0'`` and proceed with the next instance. After all
instances are configured, set ``CfgMode_i`` back to ``'0'``. This immediately
activates the new configuration.

There are two options regarding ``CfgClk_i``:

- using the system clock 
- using a gated clock

When using the permanently running system clock, ``CfgClk_i`` can be tied to
``Clk_i``. In this case, set ``CfgClkGating`` in ``vhdl_packs/config-p.vhd`` to
``false``.

The preferred option is to use a dedicated gated configuration clock. This
avoids high switching activity and thus current consumption in a possibly large
section of the clock tree for the config registers. Set ``CfgClkGating`` in
``vhdl_packs/config-p.vhd`` to ``true``. Note that in this case ``CfgShift_i``
is not evaluated and can be tied to constant ``'0'`` or ``'1'``. It is
important that only the ``CfgClk_i`` of the currently configured TR-FSM
instance is enabled. All others must be disabled. You have to provide the exact
number of bits and thus clock cycles as stored in the config register.

For an example of a configuration interface as a OpenMSP430 CPU peripheral see
https://github.com/hansiglaser/chll/blob/master/examples/wsn-soc/units/cfgintf/vhdl/cfgintf.vhd.

Verification
------------

The individual building blocks of the TR-FSM are verified in ``./sim/`` using
ModelSim or Questa Sim. Execute ``./make.sh`` to compile the VHDL sources and
then run ``./sim.sh [-cfgreg|-ism|-mux|-tr|-trfsm]`` to simulate the individual
blocks.

To verify your logic design which contains TR-FSM instances, include the
sources as mentioned in Sec. Files. You can either simulate the configuration
process or you can directly apply the configuration data before the start of
the simulation. Use the format ``modelsim`` of the ``write_bitstream`` command
in TrfsmGen to save the configuration as ModelSim/Questa Sim ``force`` commands.

It is also possible to use logical equivalence checking to compare your logic
design with Verilog RTL descriptions of the FSMs to your design with TR-FSM
instances. Here you have to apply the configuration data as constraints or
constants. Use the format ``lec`` for Cadence Conformal LEC and ``formality``
for Synopsys Formality. Additionally, the state vector encoding will most
probably be different between the RTL design and the TR-FSMs. Use
``write_encoding`` to generate FSM encoding information files. Unfortunately
only LEC supports the specification of encodings of FSMs in hierarchical
module, therefore Formality is not supported here.


Licence
=======

The TR-FSM is distributed under the terms of the GNU LGPL 2 or later. You can
freely use the design files and scripts in your (commercial) chip designs. If
you improve the design files or the scripts, you have to provide their source
code. This however doesn't affect the other parts of your chip design.


TODO
====
- example designs
- image of timing diagram for configuration interface


References
==========
[ARC2010]
  Johann Glaser, Markus Damm, Jan Haase, and Christoph Grimm. A Dedicated
  Reconfigurable Architecture for Finite State Machines. In *Reconfigurable
  Computing: Architectures, Tools and Applications, 6th International
  Symposium, ARC 2010*, volume LNCS 5992 of Lecture Notes on Computer Science,
  pages 122--133, Bangkok, Thailand, March 2010. Springer Berlin Heidelberg.

[TRETS2011]
  Johann Glaser, Markus Damm, Jan Haase, and Christoph Grimm. TR-FSM:
  Transition-based Reconfigurable Finite State Machine. *ACM Transactions on
  Reconfigurable Technology and Systems (TRETS)*, 4(3):23:1--23:14, August
  2011.

[KISS]
  University of California Berkeley: Berkeley Logic Interchange Format (BLIF).
  February 22, 2005
