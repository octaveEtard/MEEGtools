function EEG = averageReReference(EEG,excludeChanLabels,keepRef,currentRefLoc)
%
if nargin < 3
    keepRef = false;
end

% indices of channels to exclude
idxExclude = MEEGtools.findIndexChannel({EEG.chanlocs.labels},excludeChanLabels);

if keepRef
    % Computationnally the same as:
    % data = EEG.data; % + exclude unwanted channels
    % % add a channel full of 0 (current ref)
    % data = vertcat(data,zeros(1,size(data,2)));
    % data = data - mean(data,1); % re-reference to average
    currentRefLoc.ref = currentRefLoc.labels;
    
    % this does NOT change the size of EEG.data
    EEG = MEEGtools.addChan(EEG,currentRefLoc);
    EEG = MEEGtools.setReference(EEG,currentRefLoc.labels);
    
    EEG = pop_reref(EEG,[],'exclude',idxExclude,'refloc',currentRefLoc);
    s = ', reference channel added back in data';
else
    % Computationnally the same as:
    % data = EEG.data; % + exclude unwanted channels
    % data = data - mean(data,1); % re-reference to average
    EEG = pop_reref(EEG,[],'exclude',idxExclude);
    s = '';
end

% add relevant comments
comments = char(...
    '------',...
    datestr(now,'yyyy/mm/dd HH:MM:SS'),...
    sprintf('Averaged referenced%s',s),...
    '------');
EEG.comments = pop_comments(EEG.comments, '', comments, 1);

% adding average reference step to name
EEG.filename = addProc('AVR', EEG.filename);

end
%
%