function [out,outDir] = runICAinFolder(EEG,ICAopt)

outDir = fullfile(ICAopt.tmpdir,sprintf('%s_%i',datestr(now,'yyyymmdd_HHMMSS'),randi(999)));

if ~exist(outDir, 'dir')
    mkdir(outDir);
end

pwd_ = pwd();
cd(outDir);

switch ICAopt.type
    
    case 'AMICA'
        [~,~,out] = runamica15(data,'outdir',outDir,ICAopt.algParams{:});
        
    case 'binica'
        out = pop_runica(EEG, 'icatype', 'binica', 'extended',1,ICAopt.algParams{:});
end

%  and coming back to original folder
cd (pwd_);
end
%
%
