%
function proc = makeFiltString(opt)
if opt.HP.do
    lcf = opt.HP.Fc + opt.HP.TBW/2;
    if floor(lcf) == lcf
        lcf = sprintf('%.0f', lcf);
    else
        lcf = sprintf('%.1f', lcf);
    end
end

if opt.LP.do
    hcf = opt.LP.Fc - opt.LP.TBW/2;
    if floor(hcf) == hcf
        hcf = sprintf('%.0f', hcf);
    else
        hcf = sprintf('%.1f', hcf);
    end
end

proc = '';
if opt.HP.do && opt.LP.do
    
    if isfield(opt.LP,'causal') && opt.LP.causal && ...
            isfield(opt.HP,'causal') && opt.HP.causal
        proc = sprintf('cBP-%s-%s', lcf, hcf);
        
    elseif isfield(opt.LP,'anticausal') && opt.LP.anticausal && ...
            isfield(opt.HP,'anticausal') && opt.HP.anticausal
        proc = sprintf('acBP-%s-%s', lcf, hcf);
        
    elseif (~isfield(opt.LP,'causal') || ~opt.LP.causal) && ...
            isfield(opt.HP,'causal') && opt.HP.causal
        proc = sprintf('cHLP-%s-%s', lcf, hcf);
        
    elseif isfield(opt.LP,'causal') && opt.LP.causal && ...
            (~isfield(opt.HP,'causal') || ~opt.HP.causal)
        proc = sprintf('HcLP-%s-%s', lcf, hcf);
        
    else
        proc = sprintf('BP-%s-%s', lcf, hcf);
    end
    
elseif opt.LP.do
    if isfield(opt.LP,'causal') && opt.LP.causal
        proc = sprintf('cLP-%s', hcf);
    elseif isfield(opt.LP,'anticausal') && opt.LP.anticausal
        proc = sprintf('acLP-%s', hcf);
    else
        proc = sprintf('LP-%s', hcf);
    end
    
elseif opt.HP.do
    if isfield(opt.HP,'causal') && opt.HP.causal
        proc = sprintf('cHP-%s', lcf);
    else
        proc = sprintf('HP-%s', lcf);
    end
end
end
%
%