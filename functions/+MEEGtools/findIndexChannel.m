function idx = findIndexChannel(labels,chanName)
if iscell(chanName)
    idx = cellfun(@(s) find(strcmp(labels,s)),chanName);
else
    idx = find(strcmp(labels,chanName));
end
end
%
%