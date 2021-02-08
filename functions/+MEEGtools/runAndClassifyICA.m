function EEG = runAndClassifyICA(EEG,ICAopt,opt)
%
%

% ------ run ICA -----
[EEG,ICAopt] = MEEGtools.runICA(EEG,ICAopt);


%% ------ run classification -----
if opt.doICLabel
    EEG = iclabel(EEG);
    classification = EEG.etc.ic_classification;
end

% % pop_saveset(EEG,'filename','testICA','filepath','')
% % visual check;
% % plot topoplot
% idx = 1:20;
% pop_topoplot(EEG, 0, idx ,'',[4,5],0,'electrodes','on');
% % print classification
% [~,c]=max(EEG.etc.ic_classification.ICLabel.classifications,[],2);
% c = EEG.etc.ic_classification.ICLabel.classes(c);
% arrayfun(@(i) fprintf('%i %s\n',i,c{i}),idx);
% % inspect some component
% i0 = [14,15];
% pop_prop( EEG, 0, i0, NaN, {'freqrange',[0.5 80] });


%% ------ save ICA results in a standalone file
if opt.save.separateFile.do
    results = [];
    
    results.ICAopt = ICAopt;
    
    results.icainv = EEG.icainv;
    results.icasphere = EEG.icasphere;
    results.icaweights = EEG.icaweights;
    results.icachansind = EEG.icachansind;
    
    results.ranOnFiles = filesWithExt;
    results.ranOnChan = {EEG.chanlocs(:).labels};
    
    if opt.doICLabel
        results.ICLabel = classification;
    end
    
    MEEGtools.save(results,...
        opt.save.separateFile.fileName,...
        opt.save.separateFile.folder);
end


%% ------ save the EEG file
if opt.save.EEGfile.do
    if ~exist(opt.save.EEGfile.folder, 'dir')
        mkdir(opt.save.EEGfile.folder); 
    end
    EEG = pop_saveset(EEG, 'filename', [opt.save.EEGfile.fileName,'.set'], 'filepath',opt.save.EEGfile.folder);
end
end
%
%