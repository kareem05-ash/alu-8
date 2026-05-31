if {![file exists work]} {
    vlib work
    vmap work work
}

vlog -sv rtl/dut.sv

vsim work.alu8

run 10
quit