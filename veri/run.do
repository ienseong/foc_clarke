# Close the current project (if one is open)
catch {project close}
# Create a new project
project new . jpl_foc_clarke

project compileall

vlog jpl_foc_clarke_tb.sv +acc
vlog ../rtl/jpl_foc_clarke.sv +acc

vsim work.jpl_foc_clarke_tb
do wave.do

radix -decimal  
run 200ns
wave zoom full