# AJIVE_Project

This repository provides the AJIVE software in Matlab and all related Matlab scripts to reproduce the results in the paper 
**Angle-basied Joint And Individual Variation Explained** (Feng et.al., 2017). 

## Organization

The folder, *AJIVECode*, contains the scripts to implement AJIVE algorithm, which should been added to search path to run the AJIVE software. The script *AJIVEtest.m* provides unit testing for the AJIVE software. The folder  *DataExample* contains the input toy dataset, TCGA dataset and motarlity dataset in the paper. The folders *TCGA* and *Motarlity* contain the scripts to reproduce the corresponding figures for these two dataset in the paper. In order to utilize these scripts, the [*Marron’s Matlab Softwares*](http://marron.web.unc.edu/sample-page/marrons-matlab-software/) need to been installed.

## Toy Example

Please run the script *AJIVEdemo.m* for illustration the use of AJIVE algorithm on the toy example. This toy example has two data blocks, X (100 × 100) and Y (10000 × 100), with patterns corresponding to joint and individual structures. The data has been simulated so expected row means are 0. Each column of these matrices is regarded as a common data object and each row is considered as one feature.  This toy example has one joint component, one individual X component, and two individual Y components. 

## Example of Application 1: TCGA data set

The script *TCGA/TCGA_AJIVE_Analysis.m* shows the AJIVE analysis on the TCGA data set. TCGA provides prototypical data sets for the application of AJIVE. Here we study the 616 breast cancer tumor samples from Ciriello et al. (2015), which had a common measurement set. For each tumor sample, there are measurements of 16615 gene expression features (GE), 24174 copy number variations features (CN), 187 reverse phase protein array features (RPPA) and 18256 mutation features (Mut). Two joint components are identified in the Step 2 of AJIVE algorithm, while the second joint component are dropped in the third step. The scores of them are visualized in this script.

## Example of Application 2: Mortality data set

The script *Mortality/Mortality_AJIVE_Analysis* shows the AJIVE analysis on the Mortality data set. THis data set is from the Human Mortality Database, which consists of both Spanish males and females. For each gender data block, there is a matrix of mortality, defined as the number of people who died divided by the total, for a given age group and year. Because mortality varies by several orders of magnitude, the log10 mortality is studied here. Each row represents an age group from 0 to 95, and each column represents a year between 1908 and 2002. In order to associate the historical events with the variations of mortality, columns, i.e., mortality as a function of age, are considered as the common set of data objects of each gender block. The two data blocks have been mean centered before applying AJIVE algorithm. Two joint components are identified by AJIVE alorightm. The block specific loading plots and score plots of each joint and individual components can be generated from this script.