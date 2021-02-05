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
    
    Fs = EEG.srate;
    Fr = filtOpt.resample.Fr;
    Fc = filtOpt.LP.Fc;
    TBW = filtOpt.LP.TBW;
    
    if isfield(filtOpt.LP,'causal') && filtOpt.LP.causal
        x = EEG.data';
        
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
    
    % just to get the parameters used by pop_resample for the comment / log
    passbandRipples = 2e-3;
    [~, p, q, filterOrder] = makeResampleFilterCoeffs(Fs, Fr, Fc, TBW, passbandRipples);
    
    commentLPF = sprintf('Resampled: p=%i, q=%i, Fc=%.2fHz, TBW=%.2fHz, passbandRipples=%.1e, filtOrd=%i%s',p,q,Fc,TBW,passbandRipples,filterOrder,s);
    
elseif filtOpt.LP.do
    
    if isfield(filtOpt.LP,'causal') && filtOpt.LP.causal
        error('implement me!');
    end
    
    Fc = filtOpt.LP.Fc;
    TBW = filtOpt.LP.TBW;
    passbandRipples = filtOpt.LP.passbandRipples;
    
    [filterCoeffs,~,~,filterOrder] = makeResampleFilterCoeffs(EEG.srate, EEG.srate, Fc, TBW, passbandRipples);
    EEG = firfilt(EEG, filterCoeffs);
    %     commentLPF = sprintf('LP: Fc=%.2fHz, TBW=%.2fHz',Fc,TBW);
    commentLPF = sprintf('LP: Fc=%.2fHz, TBW=%.2fHz, passbandRipples=%.1e, filtOrd=%i',Fc,TBW,passbandRipples,filterOrder);
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
        'FILTERING:',...
        commentLPF,...
        commentHPF);
    
    EEG = MEEGtools.addComments(EEG,comments);
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