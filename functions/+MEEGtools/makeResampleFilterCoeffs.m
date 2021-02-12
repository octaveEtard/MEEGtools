function [b, p, q, m] = makeResampleFilterCoeffs(Fs, Fr, Fc, TBW, passbandRipples)
% makeResampleFilterCoeffs Generate the LP filter coefficients used to
% downsample data by EEGLAB

% fc = Fc / (min(Fs,Fr)/2);
% df = TBW / (min(Fs,Fr)/2);
%
% [p, q] = rat(Fr / Fs, 1e-12);
%
% nyq = 1 / max([p q]);
% fc = fc * nyq; % Anti-aliasing filter cutoff frequency
% df = df * nyq; % Anti-aliasing filter transition band width
% m = pop_firwsord('kaiser', 2, df, 0.002); % Anti-aliasing filter kernel
% b = firws(m, fc, windows('kaiser', m + 1, 5)); % Anti-aliasing filter kernel
% b = p * b; % Normalize filter kernel to inserted zeros


% -- code adapted from EEGlab function pop_resample:
[p, q] = rat(Fr / Fs, 1e-12);
% actually here p*Fs normalised at 2, nyq = 1 / max(p, q);
fc = 2*Fc/(p*Fs); % cutoff frequency normalised by nyq
df = 2*TBW / (p*Fs);% transition band width
% see? data is considered to be sampled at 2 ("= p * Fs")
beta = kaiserbeta(passbandRipples);
m = firwsord('kaiser', 2, df, passbandRipples); % Anti-aliasing filter order
b = firws(m, fc, windows('kaiser', m + 1, beta)); % Anti-aliasing filter kernel
b = p * b; % Normalize filter kernel to inserted zeros
% --

end