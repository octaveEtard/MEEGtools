function EEG = downsampleBP(EEG,filtOpt,saveOpt)
% downsampleBP Downsample & bandpass EEG data
%
% --- filtOpt ---
% filtOpt.resample.do = bool
% filtOpt.resample.Fr = resampling frequency
%
% filtOpt.LP.do = lowpass the data
% filtOpt.LP.Fc = lowpass cutoff frequency
% filtOpt.LP.TBW = lowpass transition bandwidth
%
% filtOpt.HP.do = highpass the data;
% filtOpt.HP.Fc = highpass cutoff frequency
% filtOpt.HP.TBW = highpass transition bandwidth
% filtOpt.HP.passbandRipples = highpass passband ripples (typically 1e-3)
%
% --- saveOpt ---
% saveOpt.do = save EEG set
% saveOpt.folder = where to save
% EEG.filename will be used as save name for the dataset
%
%
%% LPF with or without downsample
if filtOpt.resample.do
    
    Fr = filtOpt.resample.Fr;
    Fc = filtOpt.LP.Fc;
    TBW = filtOpt.LP.TBW;
    
    
    if isfield(filtOpt.LP,'causal') && filtOpt.LP.causal
        x = EEG.data';
        Fs = EEG.srate;
    end
    
    nyq = Fr / 2;
    EEG = pop_resample(EEG, Fr, Fc/nyq, TBW/nyq);
    
    if isfield(filtOpt.LP,'causal') && filtOpt.LP.causal
        % still do pop_resample before to change all the other fields
        % (not super efficient)
        EEG.data = resampleLPF_causal(x, Fs, Fr, Fc,TBW,true)';
        s = ' with a causal anti-aliasing filter';
    else
        s = '';
    end
    commentLPF = sprintf('Resampled: Fr=%.2fHz, Fc=%.2fHz, TBW=%.2fHz%s',Fr,Fc,TBW,s);

    
elseif filtOpt.LP.do
    
    if isfield(filtOpt.LP,'causal') && filtOpt.LP.causal
        error('implement me!');
    end
    
    Fc = filtOpt.LP.Fc;
    TBW = filtOpt.LP.TBW;
    passbandRipples = filtOpt.LP.passbandRipples;
    
    [filterCoeffs,~,~] = makeResampleFilterCoeffs(EEG.srate, EEG.srate, Fc, TBW, passbandRipples);
    EEG = firfilt(EEG, filterCoeffs);
    commentLPF = sprintf('LP: Fc=%.2fHz, TBW=%.2fHz',Fc,TBW);
    %     commentLPF = ['LP: Fc=', int2str(Fc), 'Hz, TBW=', int2str(TBW), 'Hz'];
else
    commentLPF = [];
end


%% highpass
if filtOpt.HP.do
    Fc = filtOpt.HP.Fc;
    TBW = filtOpt.HP.TBW;
    passbandRipples = filtOpt.HP.passbandRipples;
    
    beta = kaiserbeta(filtOpt.HP.passbandRipples);
    filterOrder = firwsord('kaiser', EEG.srate, TBW, passbandRipples);
    filterCoeffs = firws(filterOrder, Fc / (EEG.srate/2), 'high', windows('kaiser', filterOrder + 1, beta));
    
    if isfield(filtOpt.HP,'causal') && filtOpt.HP.causal
        filterCoeffs = minphaserceps(filterCoeffs);
        EEG = firfiltsplit(EEG, filterCoeffs, 1);
        s = ' (causal)';
    else
        s = '';
        EEG = firfilt(EEG, filterCoeffs);
    end
    
    commentHPF = sprintf('HP%s: Fc=%.2fHz, TBW=%.2fHz, passbandRipples=%.1e, filtOrd=%i',s,Fc,TBW,passbandRipples,filterOrder);
    %     commentHPF = ['HP: Fc=', int2str(Fc), 'Hz, TBW=', int2str(TBW), 'Hz, filtOrd=', int2str(filterOrder)];
else
    commentHPF = [];
end


%% comments
if ~isempty(commentLPF) || ~isempty(commentHPF)
    comments = char(...
        '---------',...
        ['FILTERING: ', datestr(now,'yyyy/mm/dd HH:MM:SS')],...
        commentLPF,...
        commentHPF,...
        '---------');
    EEG.comments = pop_comments(EEG.comments,'',comments,1);
end

%% Adding proc string to the name
proc = makeProcString(filtOpt);
[~,filename,~] = fileparts(EEG.filename);

if ~isempty(proc)
    proc = [proc, '-Fs-', int2str(EEG.srate)];
    
    filename = addProc(proc, filename);
else
    % no filtering / resampling was done
    % not changing the name
end
EEG.filename = filename;

%%
if saveOpt.do
    if ~exist(saveOpt.folder, 'dir')
        mkdir(saveOpt.folder);
    end
    EEG = pop_saveset(EEG, 'filename', [EEG.filename, '.set'], 'filepath', saveOpt.folder);
end
end
%
%