% AvgWithinDataset() - Perform averaging across dimension of current dataset.
%
% Usage:
%   >>
%   EEG=AvgWithinDataset(EEG,AvgChs,AvgADPts,AvgSegEpochs,AvgDimension);
%
% Inputs:
%   EEG                 - EEG dataset.
%   AvgChs              - Channels to include in averaging.
%   AvgADPts            - A/D points to include in averaging.
%   AverageSegEpochs    - Segments to include in averaging.
%   Avg Dimension       - EEG.data dimension across which to perform the averaging
%                           This dimension will be left with length = 1.
%    
% Outputs:
%   EEG     - EEG dataset.
%
% See also: 
%   POP_AvgWithinDataset, EEGLAB 

% Copyright (C) <2006>  <James Desjardins> <Brock University>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function EEG = AvgWithinDataset(EEG,AvgChs,AvgADPts,AvgSegEpochs,AvgDimension);

if nargin < 5
	help AvgWithinDataset;
	return;
end;	


if AvgChs==':';
    AvgChs=1:EEG.nbchan;
else
    AvgChs=str2num(AvgChs);
end

if AvgADPts==':';
    AvgADPts=1:EEG.pnts;
else
    AvgADPts=str2num(AvgADPts);
end

if AvgSegEpochs==':';
    AvgSegEpochs=1:EEG.trials;
else
    AvgSegEpochs=str2num(AvgSegEpochs);
end

AvgDimension=str2num(AvgDimension);
EEG=PurgeNonLockEvent(EEG);

% Perform averaging on current EEG.data.
if length(EEG.data(1,1,:))>=AvgSegEpochs(length(AvgSegEpochs));
    
    EEG.data=mean(EEG.data(AvgChs,AvgADPts,AvgSegEpochs),AvgDimension);
    
    EEG.nbchan=length(AvgChs);
    for i=1:length(AvgChs);
        Tempchanlocs(i).labels=EEG.chanlocs(AvgChs(i)).labels;
    end
    
    EEG.chanlocs=Tempchanlocs;
    
    EEG.pnts=length(AvgADPts);
    EEG.xmax=(EEG.pnts-1)*(1/EEG.srate);
    
    EEG.NTrialsUsed=length(AvgSegEpochs);
    EEG.trials=1;
    if length(EEG.event)>1;
        EEG.event=EEG.event(1);
    end
    if length(EEG.epoch)>1;
        EEG.epoch=EEG.epoch(1);
    end
else
    return
end