function EEG = setReference(EEG,refLabel)
% Set channel 'refLabel' as reference
%
idxChan = 1:(EEG.nbchan);
EEG = pop_chanedit(EEG, 'setref',{idxChan,refLabel});

% add relevant comments
comments = char(...
    '------',...
    datestr(now,'yyyy/mm/dd HH:MM:SS'),...
    sprintf('Channel %s set as reference',refLabel),...
    '------');

EEG.comments = pop_comments(EEG.comments, '', comments, 1);

end