function EEG = addComments(EEG,comments)

% add relevant comments
if iscell(comments)
    comments = ['------';datestr(now,'yyyy/mm/dd HH:MM:SS');comments];
else
    comments = {'------',datestr(now,'yyyy/mm/dd HH:MM:SS'),comments};
end

EEG.comments = pop_comments(EEG.comments, '', comments, 1);

end
%
%