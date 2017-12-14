# AJIVE_Project
This repository provides the AJIVE software in Matlab and all related Matlab scripts to reproduce the results in the paper 
**Angle-basied Joint And Individual Variation Explained** Feng et.al. (2017). 

The folder, *AJIVECode*, contains the scripts to implement AJIVE algorithm, which should been added to search path to run the AJIVE software. The script *AJIVEtest.m* provides unit testing for the AJIVE software. The folder  *DataExample* contains the input toy dataset, TCGA dataset and motarlity dataset in the paper. The folders *TCGA* and *Motarlity* contain the scripts to reproduce the corresponding figures for these two dataset in the paper. In order to utilize these scripts, the [*Marron’s Matlab Softwares*](http://marron.web.unc.edu/sample-page/marrons-matlab-software/) need to been installed.


Please run the script *AJIVEdemo.m* for illustration the use of AJIVE algorithm on the toy example. This toy example has two data blocks, X (100 × 100) and Y (10000 × 100), with patterns corresponding to joint and individual structures. The data has been simulated so expected row means are 0. Each column of these matrices is regarded as a common data object and each row is considered as one feature.  This toy example has one joint component, one individual X component, and two individual Y components. 