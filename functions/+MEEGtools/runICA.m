function [EEG,ICAopt] = runICA(EEG,ICAopt)

switch ICAopt.type
    
    case 'AMICA'
        
        % ------number of PCs to keep ------
        if strcmp(ICAopt.rank,'full')
            r = rank(EEG.data);
        elseif strcmp(opt.rank,'var')
            % with % or variance
            s = svd(EEG.data).^2;
            r = find(cumsum(s)/sum(s) >= opt.keepVar,1);
        end
        
        iPCAkeep = find( strcmp('pcakeep',ICAopt.algParams) );
        
        if isempty(iPCAkeep)
            PCAkeep = [];
        else
            PCAkeep = ICAopt.algParams{iPCAkeep+1};
        end
        
        if isempty(PCAkeep) || PCAkeep <= 0
            PCAkeep = r;
        elseif PCAkeep > r
            warning('pcaKeep = %i, but data rank = %i. Changing pcaKeep to %i',PCAkeep,r,r);
            PCAkeep = r;
        end
        
        if isempty(iPCAkeep)
            ICAopt.algParams = [ICAopt.algParams,'pcakeep',PCAkeep];
        else
            ICAopt.algParams{iPCAkeep+1} = PCAkeep;
        end
        
        % ------ run AMICA ------
        % run in folder because AMICA leaves some files behind
        [mods,outDir] = MEEGtools.runICAinFolder(EEG,ICAopt);
        
        % ------ check AMICA result ------
        [nanProduced,iter,cancelled] = checkAMICAout(outDir);
        
        if cancelled
            warning('AMICA cancelled (iteration %i)',iter);
        elseif nanProduced
            warning('NaN produced after %i iterations',iter);
            % elseif iter ~= maxIter
            %     warning('AMICA stopped early (%i / %i iterations)',iter,maxIter);
        end
        
        % add results in EEG
        EEG.icaweights = mods.W;
        EEG.icasphere = mods.S(1:PCAkeep,:);
        EEG.icachansind = 1:EEG.nbchan;
        
        EEG = eeg_checkset(EEG);
        
    case 'binica'
        % run in folder because binica leaves some files behind
        EEG = MEEGtools.runICAinFolder(EEG,ICAopt);
        
    case 'runica'
        EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,ICAopt.algParams{:});
end
end
%
%