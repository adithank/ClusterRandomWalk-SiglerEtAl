function tracks = readAndFormatTracks(file)

    % Read only the 'Position' tab
    sheet = sheetnames(file);
    pos = readtable(file, 'Sheet',"Position",'variableNamesRange',2);
    
    % Frames to seconds calibration 
    dt = 30; %s 
    
    % Tracks/cells ID
    trackIDs = unique(pos.TrackID);

    tracks = {};

    % Min and max time 
    tMin = min(pos.Time(:)); tMax = max(pos.Time(:)); % Frames
    
    % Convert all tracks to have the same length( with NaNs )
    for itrack = 1 : length(trackIDs)
        
        ttNew = [tMin:1:tMax];
        xxNew = nan(1,tMax-tMin+1); yyNew = nan(1,tMax-tMin+1); zzNew = nan(1,tMax-tMin+1);

        xx = pos.PositionX(pos.TrackID == trackIDs(itrack));
        yy = pos.PositionY(pos.TrackID == trackIDs(itrack));
        zz = pos.PositionZ(pos.TrackID == trackIDs(itrack));
        tt = (pos.Time(pos.TrackID == trackIDs(itrack))); % Frames

        % Catch duplicates
        [~,unqInds] = unique(tt,'stable');
        if length(unqInds) ~= length(tt)
            dupInds = setdiff([1:length(tt)],unqInds);
            tt(dupInds) = []; xx(dupInds) = []; yy(dupInds) = []; zz(dupInds) = [];
        end

        inds = ismember(ttNew,tt);
                   
        try  
            xxNew(inds) = xx; yyNew(inds) = yy; zzNew(inds) = zz;
        catch
            keyboard;
        end

    
        ttNew = (ttNew-1) * dt/60; % min

        try
            tracks{itrack} = [ttNew(:) xxNew(:) yyNew(:) zzNew(:)];  
        catch e
            disp(e.message);
        end

    end

end
        