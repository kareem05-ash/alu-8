onerror {quit -code 1}

set repo    [file normalize [pwd]]
set sim_dir [file normalize [file join $repo sim]]

if {[file exists $sim_dir/work]} {
    vdel -lib $sim_dir/work -all
}
vlib $sim_dir/work
vmap work $sim_dir/work

vlog -sv \
    $repo/include/alu8_pkg.sv \
    $repo/rtl/dut.sv \
    $repo/tb/tb_top.sv

vsim -c work.tb_top -do "run -all; quit -code 0"