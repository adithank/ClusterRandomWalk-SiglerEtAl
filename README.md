# hetRandomWalk-SiglerEtAl
Cluster identification in random motility parameter space for chemokinesis. 

The analysis is done in two steps:

1) "Time-dependent sequential Bayesian inference of heterogenous 3D random walk" 

Please run "demo_1_hetRandomWalk.m" that takes in a cell centroid file from Imaris output. Replace "readAndFormatTracks.m" with the correct import function for other cases. The script saves AR1 parameter fit for each cell trajectories to the 'Result' folder.

2) "Semi-unsupervised identification of heterogenous sub-populations in migrating T-cells"