# neede for CI termination errors
onerror {quit -code 1}

# removes old compiled versions
if { [file exists work]} {
    vdel -all -lib work
}

# create work library
vlib work
vmap work work

# compile all sv units
vlog -sv \
    include/alu8_pkg.sv \
    rtl/dut.sv \
    tb/tb_top.sv

# simulation tb unit
vsim -c work.tb_top

run -all

quit -code 0