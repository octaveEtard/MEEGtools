function EEG = addComments(EEG,comments)

% add relevant comments
comments = char(...
    '------',...
    datestr(now,'yyyy/mm/dd HH:MM:SS'),...
    comments);

EEG.comments = pop_comments(EEG.comments, '', comments, 1);

end
%
%