% pop_AvgWithinDataset() - Average data vectors within a single Dataset.
%
% Usage: 
%   >>  EEG = pop_AvgWithinDataset( EEG, AvgChs, AvgADPts, AvgSegEpochs, AvgDimension );
%
% Inputs:
%   EEG             - input EEG dataset
%   AvgChs          - EEG channel indice to be included in average.
%   AvgADPts        - EEG A/D time points (or fft bins if it is a FFT dataset) to be
%                   include in average.
%   AvgSegEpoch     - EEG segmented data epochs to be included in average.
%   AvgDimension    - Dimension across which to perform average. (this
%                   dimension will be left with length = 1).
%    
% Outputs:
%   EEG  - output dataset
%
% See also:
%   AvgWithinDataset, EEGLAB 

% Copyright (C) <2006>  <James Desjardins> Brock University
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

function [EEG,com]=pop_AvgWithinDataset(EEG,AvgChs,AvgADPts,AvgSegEpochs,AvgDimension);

com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            


% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_AvgWithinDataset;
	return;
end;	



% pop up window
% -------------
if nargin < 5

    results=inputgui( ...
    {[1] [4 2 1] [4 2 1] [4 2 1] [4 2 1]}, ...
    {...
        {'Style', 'text', 'string', 'Enter within dataset averaging parameters.', 'FontWeight', 'bold'}, ...
        {'Style', 'text', 'string', 'Channels to include in average:'}, ...
        {'Style', 'edit', 'tag', 'AvgChsDisp'}, ...
        {'Style', 'pushbutton', 'string', '...', ...
        'callback', 'set(findobj(gcbf, ''tag'', ''AvgChsDisp''), ''string'', int2str(pop_chansel({EEG.chanlocs.labels}, ''withindex'', ''on'')));'}, ...
        {'Style', 'text', 'string', 'Time samples to include in average (Fq bins in the case FFT data):'}, ...
        {'Style', 'edit'}, ...
        {}, ...
        {'Style', 'text', 'string', 'Segments to include in the average:'}, ...
        {'Style', 'edit'}, ...
        {}, ...
        {'Style', 'text', 'string', 'Dimension across which to perform averaging:'}, ...
        {'Style', 'edit'}, ...
        {}, ...
    }, ...
    'pophelp(''pop_EyeReg'');', 'Artifact Correction (Eye regression) -- pop_EyeReg()' ...
    );

    AvgChs  	 = results{1};
    AvgADPts  	 = results{2}; 
    AvgSegEpochs = results{3};
    AvgDimension = results{4};
end

if isempty(AvgChs);
    AvgChs=':';
end
if isempty(AvgADPts);
    AvgADPts=':';
end
if isempty(AvgSegEpochs);
    AvgSegEpochs=':';
end

% call function "AvgWithinDataset".
% ---------------------------------------------------
EEG=AvgWithinDataset(EEG,AvgChs,AvgADPts,AvgSegEpochs,AvgDimension);


% return the string command
% -------------------------
com = sprintf('EEG = pop_AvgWithinDataset( %s, %s, %s, %s, %s );', inputname(1), ... 
    vararg2str(AvgChs), vararg2str(AvgADPts), ... 
    vararg2str(AvgSegEpochs), vararg2str(AvgDimension));


return;
