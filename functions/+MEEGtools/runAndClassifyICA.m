function EEG = runAndClassifyICA(EEG,ICAopt,opt)
%
%

% ------ run ICA -----
[EEG,ICAopt] = MEEGtools.runICA(EEG,ICAopt);


%% ------ run classification -----
if opt.doICLabel
    EEG = iclabel(EEG);
    classification = EEG.etc.ic_classification;
    EEG = MEEGtools.addComments(EEG,'ICs classified with ICLabel');
end

pop_saveset(EEG,'filename','testICA','filepath','')

% % visual check;
% idx = 1:20;
% spec_opt = {'freqrange',[0.5 80] };
% erp_opt = {};
% [com] = pop_viewprops( EEG, 0, idx, spec_opt, erp_opt, 1, 'ICLabel');
% % inspect a component
% i0 = 1;
% pop_prop_extended(EEG, 0, i0, NaN, spec_opt, erp_opt, 1, 'ICLabel')


% %% ------ save ICA results in a standalone file
% if opt.save.separateFile.do
%     results = [];
%      
%     results.ICAopt = ICAopt;
%     
%     results.icainv = EEG.icainv;
%     results.icasphere = EEG.icasphere;
%     results.icaweights = EEG.icaweights;
%     results.icachansind = EEG.icachansind;
%     
%     results.ranOnFiles = filesWithExt;
%     results.ranOnChan = {EEG.chanlocs(:).labels};
%     
%     if opt.doICLabel
%         results.ICLabel = classification;
%     end
%     
%     MEEGtools.save(results,...
%         opt.save.separateFile.fileName,...
%         opt.save.separateFile.folder);
% end
% 
% 
% %% ------ save the EEG file
% if opt.save.EEGfile.do
%     if ~exist(opt.save.EEGfile.folder, 'dir')
%         mkdir(opt.save.EEGfile.folder); 
%     end
%     EEG = pop_saveset(EEG, 'filename', [opt.save.EEGfile.fileName,'.set'], 'filepath',opt.save.EEGfile.folder);
% end
end
%
%