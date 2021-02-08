function EEG = interpolateMissingChannels(EEG,chanLocs)

% interpolate removed / missing channels
missing = MEEGtools.missingChannels(EEG,chanLocs);
nMissing = numel(missing);

if 0 < nMissing
    EEG = pop_interp(EEG,chanLocs,'spherical');
    s = sprintf(' %s',missing{:});
    comments = sprintf('Interpolate (spherical) %i missing channels%s',nMissing,s);
    EEG = MEEGtools.addComments(EEG,comments);
end
end
%
%