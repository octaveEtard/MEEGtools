function varargout = printArgs(format,varargin)

n = numel(varargin);

for iArg = 1:n
    if isnumeric(varargin{iArg})
        varargin{iArg} = sprintf(format,varargin{iArg});
    end
end

varargout = varargin;

end
%
%