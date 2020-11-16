function [M,idx,outputChanOrder] = reorderMatrix(M,inputChanOrder,outputChanOrder,dim)
%
% LM.example.reorderMatrix
% Part of the Linear Model (LM) package.
% Author: Octave Etard
%
% reorder matrix M from original order given by inputChanOrder
% to outputChanOrder
%

if isempty(M)
    return;
end

assert(size(M,dim) == numel(inputChanOrder),'Input channel order does not match data size');

idx = findIndexFullStringInCellArray(inputChanOrder,outputChanOrder);
usedChan = ~cellfun(@isempty,idx);
if any(~usedChan)
    warning('Not all requested output channels found in input!');
end
outputChanOrder = outputChanOrder(usedChan);
idx = [idx{:}];


% make dimension of interest first
nbDims = ndims(M);

if dim ~= 1
    dimPerm = [dim,1:(dim-1),(dim+1):nbDims];
    M = permute(M,dimPerm);
end

% reorder
M = reshape(M(idx,:),size(M));

% restore original order
if dim ~= 1
    dimPerm = [2:dim,1,(dim+1):nbDims];
    M = permute(M,dimPerm);
end
end
%
%