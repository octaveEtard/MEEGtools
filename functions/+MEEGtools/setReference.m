function EEG = setReference(EEG,refLabel)
% Set channel 'refLabel' as reference
%
idxChan = 1:(EEG.nbchan);
EEG = pop_chanedit(EEG, 'setref',{idxChan,refLabel});

% add relevant comments
EEG = MEEGtools.addComments(EEG,sprintf('Channel %s set as reference',refLabel));

end
%
%