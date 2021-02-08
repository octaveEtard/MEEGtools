function missing = missingChannels(EEG,chanLocs)
%
% Return channel labels that are in chanLocs but not in EEG

missing = findIndexFullStringInCellArray({EEG.chanlocs.labels},{chanLocs.labels});
missing = cellfun(@isempty,missing);
missing = {chanLocs(missing).labels};

end
%
%