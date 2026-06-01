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
    $root/include/alu8_pkg.sv \
    $root/rtl/dut.sv \
    $root/tb/tb_top.sv

# simulation tb unit
vsim -c work.tb_top

run -all

quit -code 0