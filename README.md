# jpl-adc-scaling

## Overview

 
This module processes the output from an Clarke transform : compute Clarke tranform to to determine two orthogonal alpha, beta from three current phase a,b,c according to the following equations:

`o_ialpha = i_ia`
`o_ibeta  = (i_ia + 2*i_ib)/sqrt(3)

## Documentation

For details of the module, see the [specification](https://github-fn.jpl.nasa.gov/jpl-fpga-ip-incubator-fn/jpl_foc_clarke/blob/master/docs/FPGA_DesignSpec_Clarke_Transform.doc
).


## Unit Test

For instructions on how to run the unit test, see the [README]((https://github-fn.jpl.nasa.gov/jpl-fpga-ip-incubator-fn/jpl_foc_clarke/blob/master/README.md).






