# hetRandomWalk-SiglerEtAl
Cluster identification in random motility parameter space for chemokinesis. 

The analysis is done in two steps:

1) "Time-dependent sequential Bayesian inference of heterogenous 3D random walk"  (demo_1)

Please run "demo_1_hetRandomWalk.m" that takes in a cell centroid file from Imaris output. Replace "readAndFormatTracks.m" with the correct import function for other cases. The script saves AR1 parameter fit for each cell trajectories to the 'Result' folder.

2) "Semi-unsupervised identification of heterogenous sub-populations in migrating T-cells" (demo_2)

Once the step 1 output is saved from all the cells to be included in the clustering, run "demo_2_clustering.m". This scripts reads output of all cells from step 1 and performs K-means clustering. Change K-value as required using mean silhouette score.
