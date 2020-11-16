function [valid,cst,lin] = checkChannels(data,chanLabels,doPrint)
%
% Performs basic sanity checks on the data:
%   - constant channels (in particular, zero channels)
%   - linear channels
%
% Input:
%   - data: nPnts x nChan matrix
%   - chanLabels: cell array  of channel labels (nChan elements; optional:
%     default = []; if provided only used for display if doPrint == true)
%   - doPrint: print results in console (optional: default = false)
%

if nargin < 3
    doPrint = false;
end
if nargin < 2
    chanLabels = [];
end

% (exactly) constant channels
cst = all(data == data(1,:),1);

% (exactly) linear channels
dVal = diff(data,1);
lin = all( dVal == dVal(1,:),1);
lin(cst) = false; % excluding constant

valid = ~(cst|lin);
    
if doPrint
    nChan = size(data,2);

    val = nan(nChan,1);
    val(cst) = data(1,cst);
    val(lin) = dVal(lin);
    
    d = [num2cell((1:nChan)'),...
        chanLabels(:),...
        num2cell(valid'),...
        num2cell(cst'),...
        num2cell(lin'),...
        num2cell(val)];
    d = d';
    m = int2str(max(cellfun(@length,chanLabels)));
    
    fprintf('idx\t   label\tvalid\tcst\tlinear\tval\n')
    fprintf(['%3i\t%',m,'s\t%i\t%i\t%i\t%.1e\n'],d{:});
end
end
%
%