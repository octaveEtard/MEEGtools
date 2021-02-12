function EEG = rejectICs(EEG,rok,thresholds)
%
% Reject ICs classified by ICLabel.
%
% 'thresholds' should be a 7 x 2 matrix containing the mininum / maximum
% probabilities in each category to flag a component.
%
% If rok == 'reject', flagged ICs will be rejected
% If rok == 'keep', flagged ICs will be kept (reject all others).
%
% Input order for thresholds:
% 'Brain' 'Muscle' 'Eye' 'Heart' 'Line Noise' 'Channel Noise' 'Other'
%
% thresholds values are not inclusive (<).
%
% Examples:
% % reject any component classified as any of 'Muscle' 'Eye' 'Heart'
% % 'Line Noise' 'Channel Noise' with 0.8 < proba < 1
% % rok = 'reject';
% % thresholds = [0 0; 0.8 1; 0.8 1; 0.8 1; 0.8 1; 0.8 1; 0 0];
%
% % keep only components classified as 'Brain' with 0.8 < proba < 1
% % rok = 'keep';
% % thresholds = [0 0.8; 0 0; 0 0; 0 0; 0 0; 0 0; 0 0];
%
% % reject component classified as 'Brain' with 0 < proba < 0.2
% % rok = 'reject';
% % threshold = [0 0.2;0 0; 0 0; 0 0; 0 0; 0 0; 0 0];
%

assert( all(size(thresholds) == [7,2]) );
% sanity check: making sure this order is indeed used
order = {'Brain','Muscle','Eye','Heart','Line Noise','Channel Noise','Other'};
idx = findIndexFullStringInCellArray(EEG.etc.ic_classification.ICLabel.classes,order);
idx = [idx{:}];
thresholds = thresholds(idx,:);

% this function uses non inclusive thresholds
EEG = pop_icflag(EEG, thresholds);
if strcmp(rok,'keep')
    % inverting to keep ICs flagged by pop_icflag
    EEG.reject.gcompreject = ~EEG.reject.gcompreject;
elseif ~strcmp(rok,'reject')
    error('Unknown keyword');
end

rej = EEG.reject.gcompreject;

% removing flagged components
setName = EEG.setname;
EEG = pop_subcomp( EEG, [], false, false);

% add comments
s = cell(9,1);
s{1} = sprintf('Reject %i ICs. Criterion: %s:',sum(rej),rok);
s(2:8) = arrayfun(@(i) sprintf('%s %.1f %.1f',order{i},thresholds(i,1),thresholds(i,2)),(1:7)','UniformOutput',false);
s_ = sprintf(' %i',find(rej));
s{9} = sprintf('IC rejected: %s',s_);

EEG = MEEGtools.addComments(EEG,s);
EEG.setname = [setName,'-ICr'];
end
%
%