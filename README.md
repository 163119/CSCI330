# CSCI330
## Summary
This repository includes all necessary source code, screenshots, and documentation for the CSCI-330 program required for the Senior Portfolio for student 163119.

## What the program does
This program simulates a 5 Stage Pipelined Processor Execute stage

## How to compile it
*NOTE:* This program is **not** an application in the general sense.  It is a software representation of a hardware component.  The execute.v is the primary software component and the executeTB.v is a test program to demonstrate it's use.

*NOTE:* These instructions assume standard Linux OS, terminal, Icarus Verilog, and GTKWave are installed.
1. Open Terminal
1. iverilog -o run execute.v executeTB.v
1. vvp run
1. gtkwave test.vcd
