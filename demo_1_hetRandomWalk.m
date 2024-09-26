% Demo script to fit AR1 parameters to individual cells 
% CD to the directory of this script

clearvars;
restoredefaultpath;
addpath(genpath(cd));

% Path to Imaris centroid tracking file
filePath = "./Data/088 WT 0,5 T240 1.xls";
[~,fileName] = fileparts(filePath);

% Format tracks in the spreadsheet in a cell array each with the same
% number of spots (cell centroid), each an array of Nt x 4.
% Second dimension of this array runs as follows : (t,x,y,z)
% Nt is number of time steps

tracks = readAndFormatTracks(filePath);

% Find velocities at each time step with finite differences
% vt is a cell array with each cell an array of Nt x 3 

vel = wrapperVel(tracks);

% Fit AR1 
% Cell array with each element a struct of (at,qt), the random walk
% parameters
AR1Fit = wrapperAR1(vel); 

% Save output 
save(sprintf('./Results/AR13D-%s.mat',fileName),'AR1Fit');




function vt = wrapperVel(tracks)
    vt = {}; 
    
    for itrack = 1 : length(tracks)
        
        timett = repmat(tracks{itrack}(:,1),[1 3]);
        trackstt = tracks{itrack}(:,2:4);
        
        % Find velocity with 2nd order centered FD
        vtt = ( trackstt(3:end,:) - trackstt(1:end-2,:) )./ (timett(3:end,:) - timett(1:end-2,:));
        vtt(isnan(vtt(:,1)),:) = [];
        vt{itrack} = vtt;
    end
end

function AR1Fit = wrapperAR1(vt)
    AR1Fit = {}; 
    
    for ivt = 1 : length(vt)
        
        vtt = vt{ivt};
        
        % Fit AR1 model
        [qt,at] = ar1_param_inf_3D(vtt);

        AR1Fit{ivt} = struct();
        AR1Fit{ivt}.at = at;
        AR1Fit{ivt}.qt = qt;

    end
end




