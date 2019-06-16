# Recovering-hidden-components-in-multimodal-data
MATLAB implementation of the synthetic fetal ECG heart rate detection example in "Recovering Hidden Components in Multimodal Data with Composite Diffusion Operators", T. Shnitzer, M. Ben-Chen, L. Guibas, R. Talmon and H.T. Wu, submitted to SIAM Journal on Mathematics of Data Science (SIMODS).

This implementation constructs the simulated ta-ECG signals composed of the maternal and the fetal ECG components, and applies the operators A and S to the data.
The code creates Figure 4, Figure 5 and Figure 6 from the paper.

Execute:
>> main.m

Remark: In order to reduce the running time, we use the MATLAB function "eigs" (main.m: lines 99 and 103) instead of "eig". This may lead to plots which are slightly different than the ones in the paper. The exact plots that appear in the paper can be obtained by replacing "eigs" with "eig" (leads to a significant increase in running time).
