function newName = addProc(proc,name)
% addProc Add 'proc' after the old proc string, and before the
% basename, with '-' in between
%
% Example: addProc('LP-15-Fs-40', 'PREP-octave_clean_1.set') will return
% 'PREP-LP-15-Fs-40-octave_clean_1.set'
%
% Based on the convention that proc string have '-', but basename do not.

if isempty(name)
    newName = proc;
    return;
end
if isempty(proc)
    newName = name;
    return;
end

[oldProc,Fs,baseName] = getProcAndBaseName(name);
split = strsplit(proc,'Fs');

% sampling rate specified in proc
if length(split) > 1
    FsInProc = true;
else
    FsInProc = false;
end

[oldFilt,oldProcBefore,oldProcAfter] = getFilter(oldProc);
[newFilt,newProcBefore,newProcAfter] = getFilter(proc);

mergedFilt = mergeFilt(oldFilt,newFilt);
mergedFilt = makeProcString(mergedFilt);

if oldFilt.HP.do || oldFilt.LP.do
    toJoin = [oldProcBefore,mergedFilt];
    if ~isempty(oldProcAfter)
        toJoin = [toJoin,'-',oldProcAfter];
    end
    toJoin = [toJoin,'-',newProcBefore];
    if ~isempty(newProcAfter)
        toJoin = [toJoin,'-',newProcAfter];
    end
else
    if ~isempty(newProcBefore) && ~isempty(mergedFilt)
        toJoin = [newProcBefore,mergedFilt];
    elseif ~isempty(newProcBefore)
        toJoin = newProcBefore;
    else
        toJoin = mergedFilt;
    end
    if ~isempty(oldProcBefore)
        toJoin = [oldProcBefore,'-',toJoin];
    end
    if ~isempty(newProcAfter)
        toJoin = [toJoin,'-',newProcAfter];
    end
end

if ~FsInProc && ~isempty(Fs)
    toJoin = [toJoin,['-Fs-',int2str(Fs)]];
end

newName = [toJoin,'-',baseName];

end


function [filt,procBefore,procAfter] = getFilter(proc)

filt.LP.do = false;
filt.HP.do = false;
procBefore = proc;
procAfter = '';

split = strsplit(proc,'LP-');
if length(split) > 1
    filt.LP.do = true;
    after = strsplit(split{2},'-');
    procBefore = split{1};
    % +0.5 and TBW arbitrary for compatibility with makeProcString
    filt.LP.Fc = str2double(after{1})+0.5;
    filt.LP.TBW = 1;
    procAfter = strjoin(after(2:end),'-');
end

split = strsplit(proc,'HP-');
if length(split) > 1
    filt.HP.do = true;
    after = strsplit(split{2},'-');
    procBefore = split{1};
    % -0.5 and TBW arbitrary for compatibility with makeProcString
    filt.HP.Fc = str2double(after{1})-0.5;
    filt.HP.TBW = 1;
    procAfter = strjoin(after(2:end),'-');
end

if ~filt.LP.do && ~filt.HP.do
    split = strsplit(proc,'BP-');
    if length(split) > 1
        filt.LP.do = true;
        filt.HP.do = true;
        after = strsplit(split{2},'-');
        procBefore = split{1};
        % -0.5 and TBW arbitrary for compatibility with makeProcString
        filt.HP.Fc = str2double(after{1})-0.5;
        filt.HP.TBW = 1;
        
        % +0.5 and TBW arbitrary for compatibility with makeProcString
        filt.LP.Fc = str2double(after{2})+0.5;
        filt.LP.TBW = 1;
        
        procAfter = strjoin(after(3:end),'-');
    end
    
end
end

function mergedFilt = mergeFilt(oldFilt,newFilt)

mergedFilt.HP.do = oldFilt.HP.do | newFilt.HP.do;
mergedFilt.LP.do = oldFilt.LP.do | newFilt.LP.do;

if mergedFilt.HP.do
    mergedFilt.HP.Fc = opExist(oldFilt.HP,newFilt.HP,@max);
    mergedFilt.HP.TBW = 1;
end
if mergedFilt.LP.do
    mergedFilt.LP.Fc = opExist(oldFilt.LP,newFilt.LP,@min);
    mergedFilt.LP.TBW = 1;
end
end

function m = opExist(oldFilt,newFilt,opHandle)
if isfield(oldFilt,'Fc') && isfield(newFilt,'Fc')
    m = opHandle(oldFilt.Fc,newFilt.Fc);
elseif isfield(oldFilt,'Fc')
    m = opHandle(oldFilt.Fc);
else
    m = newFilt.Fc;
end
end

